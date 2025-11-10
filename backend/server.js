import express from "express";
import mysql from "mysql2/promise";
import path from "path";
import cors from "cors";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";

dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;
const __dirname = path.dirname(fileURLToPath(import.meta.url));

app.use(cors());
app.use(express.json());

// ✅ MySQL Connection
const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "password",
  database: process.env.DB_NAME || "blog_pulse_db",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// ✅ Google OAuth
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// ✅ Helper Functions
async function getUserByEmail(email) {
  const conn = await pool.getConnection();
  const [rows] = await conn.query("SELECT * FROM users WHERE email = ?", [email]);
  conn.release();
  return rows[0];
}

async function createUser(displayName, email, passwordHash) {
  const conn = await pool.getConnection();
  const [result] = await conn.query(
    "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)",
    [displayName, email, passwordHash]
  );
  conn.release();
  return result.insertId;
}

// ✅ Auth Middleware
function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Access denied. Please log in." });

  // ⭐️ SECURITY RECOMMENDATION: Ensure JWT_SECRET is set in your .env
  const secret = process.env.JWT_SECRET;
  if (!secret) {
    console.error("FATAL ERROR: JWT_SECRET is not defined.");
    return res.status(500).json({ error: "Internal server configuration error." });
  }

  jwt.verify(token, secret, (err, user) => {
    if (err) return res.status(403).json({ error: "Invalid token" });
    req.user = user;
    next();
  });
}

// ✅ Signup
app.post("/api/signup", async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password)
      return res.status(400).json({ error: "All fields are required." });

    const existingEmail = await getUserByEmail(email);
    if (existingEmail) {
      return res.status(400).json({ error: "Email is already registered." });
    }

    const hash = await bcrypt.hash(password, 10);
    const userId = await createUser(username, email, hash);

    const token = jwt.sign({ id: userId, email, username }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(201).json({ message: "User registered successfully", token });
  } catch (err) {
    console.error("Signup error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ✅ Login
app.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await getUserByEmail(email);
    if (!user) return res.status(401).json({ error: "Invalid credentials" });

    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) return res.status(401).json({ error: "Invalid credentials" });

    const token = jwt.sign(
      { id: user.id, email: user.email, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.json({ message: "Login successful", token });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ✅ Google Sign-In/Up Combined
app.post("/api/google-login", async (req, res) => {
  try {
    const { token } = req.body;
    const ticket = await googleClient.verifyIdToken({
      idToken: token,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const { email, name } = payload;

    let user = await getUserByEmail(email);
    if (!user) {
      // Create a complex, unique password for Google users
      const passwordHash = await bcrypt.hash(email + process.env.JWT_SECRET, 10);
      const newUserId = await createUser(name, email, passwordHash);
      user = { id: newUserId, email, username: name };
    }

    const jwtToken = jwt.sign(
      { id: user.id, email: user.email, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.json({ message: "Google login successful", token: jwtToken });
  } catch (err) {
    console.error("Google login error:", err);
    res.status(401).json({ error: "Invalid Google token" });
  }
});

// ✅ Create Blog Post (Protected)
app.post("/api/create-post", authenticateToken, async (req, res) => {
  try {
    const { title, content } = req.body;
    if (!title || !content)
      return res.status(400).json({ error: "Title and content are required." });

    // Use the username from the verified JWT token
    const author = req.user.username || req.user.email;
    const conn = await pool.getConnection();
    await conn.query(
      "INSERT INTO blog_posts (title, content, author) VALUES (?, ?, ?)",
      [title, content, author]
    );
    conn.release();

    res.json({ message: "Post created successfully!" });
  } catch (err) {
    console.error("Create post error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ⬇️⬇️⬇️ THIS BLOCK IS NOW OPTIMIZED ⬇️⬇️⬇️
// ✅ Get All Blogs
app.get("/api/blogs", async (req, res) => {
  try {
    const conn = await pool.getConnection();
    
    // Select only the fields needed for the preview card
    // and truncate the content to 300 characters
    const [rows] = await conn.query(
      "SELECT id, title, author, created_at, SUBSTRING(content, 1, 300) as content_preview FROM blog_posts ORDER BY created_at DESC"
    );
    
    // Map the results to rename 'content_preview' back to 'content'
    // This way, we don't have to change any frontend code
    const optimizedRows = rows.map(row => ({
      id: row.id,
      title: row.title,
      author: row.author,
      created_at: row.created_at,
      content: row.content_preview + (row.content_preview.length === 300 ? '...' : '')
    }));
    
    conn.release();
    res.json(optimizedRows); // Send the much smaller, optimized JSON
    
  } catch (error) {
    console.error("Error fetching blogs:", error);
    res.status(500).json({ error: "Failed to fetch blogs" });
  }
});
// ⬆️⬆️⬆️ END OF OPTIMIZED BLOCK ⬆️⬆️⬆️

// ✅ Get Single Blog (This route is unchanged, as it needs the full content)
app.get("/api/blogs/:id", async (req, res) => {
  try {
    const conn = await pool.getConnection();
    const [rows] = await conn.query("SELECT * FROM blog_posts WHERE id = ?", [req.params.id]);
    conn.release();
    if (rows.length === 0) return res.status(404).json({ error: "Blog not found" });
    res.json(rows[0]);
  } catch (error) {
    console.error("Error fetching blog by ID:", error);
    res.status(500).json({ error: "Failed to fetch blog" });
  }
});


// ✅ Serve Frontend in Production
if (process.env.NODE_ENV === "production") {
  
  // This path now matches the 'public' folder created by user-data.sh
  const clientDist = path.join(__dirname, "public");  
  
  app.use(express.static(clientDist));
  app.get("*", (_, res) => res.sendFile(path.join(clientDist, "index.html")));
}


app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`));