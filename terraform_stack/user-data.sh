#!/bin/bash
set -xe

# === Define variables from Terraform ===
DB_HOST=${rds_endpoint}
DB_USER=${db_username}
DB_PASS=${db_password}
DB_NAME=blog_pulse_db
GITHUB_TOKEN=${github_token}
ALB_DNS=${alb_dns_name}
JWT_KEY=${jwt_secret_key}

# === Install dependencies ===
apt-get update -y
apt-get install -y curl git netcat mysql-client

# === Install Node.js (v18) and PM2 ===
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
npm install -g pm2

# === Clone your Blog Pulse repo ===
cd /home/ubuntu
git clone https://${github_token}@github.com/abrarsyedd/blog-pulse.git
cd blog-pulse

# === Backend .env ===
cat <<EOF > ./backend/.env
NODE_ENV=production
PORT=3000
DB_HOST=${rds_endpoint}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
DB_NAME=blog_pulse_db
JWT_SECRET_KEY=${jwt_secret_key}
VITE_GOOGLE_CLIENT_ID=797871057745-vf29udn0p8638fu7frrhrpl941q8egg8.apps.googleusercontent.com
EOF

# === Client .env (Dynamically set API base to ALB) ===
cat <<EOF > ./client/.env
VITE_API_BASE=https://${alb_dns_name}/api # ⬅️ THE FIX IS HERE (http -> https)
VITE_GOOGLE_CLIENT_ID=797871057745-vf29udn0p8638fu7frrhrpl941q8egg8.apps.googleusercontent.com
EOF

# === Wait for RDS to accept connections ===
echo "Waiting for RDS at ${rds_endpoint} to accept connections..."
for i in {1..30}; do
  if nc -zv ${rds_endpoint} 3306; then
    echo "RDS is ready."
    break
  fi
  echo "RDS not ready yet... retrying in 10s"
  sleep 10
done

# === Import schema.sql into RDS ===
if [ -f "./backend/schema.sql" ]; then
  echo "Importing schema into RDS..."
  mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} blog_pulse_db < ./backend/schema.sql
else
  echo "./backend/schema.sql not found, skipping import."
fi

# === Build frontend ===
cd client
npm install
npm run build

# === Install backend dependencies ===
cd ../backend
npm install

# === Copy built frontend into backend/public ===
mkdir -p public
cp -r ../client/dist/* public/

# === Change permissions for ubuntu ===
chown -R ubuntu:ubuntu /home/ubuntu/blog-pulse

# === Start backend with PM2 as ubuntu user ===
sudo -u ubuntu pm2 start /home/ubuntu/blog-pulse/backend/server.js --name blog-pulse-backend
sudo -u ubuntu pm2 save
env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu