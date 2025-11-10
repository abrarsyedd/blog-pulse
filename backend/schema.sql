-- Blog Pulse Blog Database Schema and Setup
-- Create database and tables with proper configuration

CREATE DATABASE IF NOT EXISTS blog_pulse_db;

USE blog_pulse_db;

-- Blog Posts Table
CREATE TABLE IF NOT EXISTS blog_posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content LONGTEXT NOT NULL,
  author VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_created (created_at),
  INDEX idx_author (author)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Analytics/Graph Data Table (for future use)
CREATE TABLE IF NOT EXISTS graph_data (
  id INT AUTO_INCREMENT PRIMARY KEY,
  graph_type VARCHAR(50) NOT NULL,
  graph_json LONGTEXT NOT NULL COMMENT 'Stored as JSON string',
  title VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_type (graph_type),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample blog posts with AWS and Azure content
INSERT INTO blog_posts (title, content, author) VALUES
('AWS Lambda: Serverless Computing Simplified',
'AWS Lambda is a compute service that lets you run code without provisioning or managing servers. It automatically scales your applications and you only pay for the time your code is running. Lambda supports multiple programming languages including Python, Node.js, Java, Go, Ruby, C#, and PowerShell. The key advantage of Lambda is that you don\'t need to manage infrastructure at all. AWS handles everything from capacity provisioning to patching, monitoring, and logging automatically. You simply upload your code and Lambda handles the rest of the execution. Lambda functions can be triggered by various AWS services like S3, DynamoDB, SNS, API Gateway, CloudWatch, and SQS. This makes it perfect for building reactive, event-driven architectures. The functions execute in isolated environments ensuring security and performance. With integrated monitoring through CloudWatch and distributed tracing with X-Ray, you can easily debug and optimize your functions. Lambda provides a generous free tier with 1 million requests per month. Performance and cost are significant advantages - you only pay for compute time billed to the nearest millisecond.',
'Cloud Architect'),
('EC2 Auto Scaling: Scale Your Infrastructure Dynamically',
'Amazon EC2 Auto Scaling helps you maintain application availability and automatically increases or decreases EC2 capacity based on demand. This ensures optimal performance while minimizing costs and resource waste. Auto Scaling groups allow you to specify minimum, maximum, and desired number of instances. You define scaling policies that automatically launch new instances when demand increases and terminate instances when demand decreases. Scaling decisions can be based on CPU utilization, memory usage, network traffic, or custom metrics. CloudWatch monitors your application and triggers scaling actions automatically. Auto Scaling works seamlessly with Elastic Load Balancing to distribute incoming traffic across instances. Together, they provide a robust solution for handling variable workloads and traffic spikes. Launch templates ensure that new instances are configured consistently with the same software and settings. Setting up Auto Scaling involves creating a launch template, defining scaling policies, and monitoring metrics. You can use target tracking scaling policies that automatically maintain a target metric value. This approach is very cost-effective because you only pay for the capacity you actually use.',
'DevOps Engineer'),
('AWS CloudFormation: Complete Infrastructure as Code Best Practices',
'AWS CloudFormation lets you model your entire AWS infrastructure in template files written in JSON or YAML format. Infrastructure as Code provides numerous benefits including version control, repeatability, and easy environment replication. Templates describe all your AWS resources and their relationships in a declarative manner. One of the main advantages is that you can create, update, and delete entire stacks of resources with a single action. This eliminates manual configuration errors and reduces the time needed for deployments. Templates can include parameters for customization, mappings for region-specific values, and outputs for useful information. CloudFormation supports all major AWS services including EC2, RDS, S3, Lambda, VPC, and many others. You can create reusable templates called modules and stack policies to prevent accidental resource deletion. Change sets allow you to preview changes before applying them to your production stack. Best practices include using version control for your templates, organizing resources logically, using parameters for flexibility, and implementing proper error handling. CloudFormation hooks help enforce policies and best practices across your organization.',
'Solutions Architect'),
('Automation with AWS Systems Manager: Streamline Operations',
'AWS Systems Manager provides a unified interface to view and manage AWS resources at scale. It includes capabilities for patch management, configuration management, resource groups, and operations automation. Automation documents allow you to standardize and automate common operational tasks across your infrastructure. The Patch Manager feature automates the process of patching EC2 instances and on-premises servers at scale. You can define patch baselines, schedule maintenance windows, and generate compliance reports automatically. This ensures your systems stay secure and up-to-date with minimal manual effort from operations teams. Run Command allows you to execute commands remotely on EC2 instances without needing SSH access. This is useful for troubleshooting, configuration changes, and deployments. Session Manager provides secure interactive shell access to instances through the AWS console, without needing to manage SSH keys or bastion hosts. Parameter Store allows you to store configuration data and secrets securely in a centralized location. Applications can retrieve parameters at runtime, making configuration management centralized and secure.',
'Systems Administrator'),
('AWS CodePipeline: Continuous Integration and Deployment Automation',
'AWS CodePipeline is a fully managed continuous integration and continuous deployment service for automating release processes. It helps you automate the release process for your applications and ensures consistent deployments. CodePipeline connects with source control, build systems, and deployment services to create an automated workflow. A typical pipeline includes source, build, test, and deploy stages that execute sequentially or in parallel. Each stage can have manual approvals to ensure quality gates are met before proceeding. CodePipeline integrates with GitHub, CodeCommit, Bitbucket, and other source control systems seamlessly. Build stages use AWS CodeBuild to compile, test, and package your application automatically. CodePipeline supports multiple deployment targets including EC2, Lambda, on-premises servers, and ECS. You can deploy to multiple environments and perform blue-green deployments to minimize downtime during releases. Setting up CodePipeline involves creating a pipeline definition, configuring stages, and connecting AWS services.',
'DevOps Engineer'),
('Terraform on AWS: Modern Infrastructure as Code with Terraform',
'Terraform is an open-source Infrastructure as Code tool that works seamlessly with AWS and other cloud providers. Unlike CloudFormation, Terraform uses HCL (HashiCorp Configuration Language) and supports multiple cloud providers. This makes it ideal if you work with AWS, Azure, and Google Cloud simultaneously in your organization. Terraform state files track your infrastructure state and enable you to plan and apply changes safely. The terraform plan command shows exactly what changes will be made before you apply them to production. This prevents surprises and allows for careful review of infrastructure changes by the entire team. You can organize Terraform code using modules to create reusable components and reduce code duplication. Remote state storage with S3 and DynamoDB enables team collaboration and prevents state conflicts. Terraform Cloud provides additional features like policy enforcement, cost estimation, and run history tracking. Best practices include using version control for all Terraform code, organizing code logically with modules, using remote state, and implementing testing.',
'Infrastructure Engineer'),
('AWS RDS: Managed Relational Database Services',
'Amazon RDS is a managed relational database service supporting MySQL, PostgreSQL, MariaDB, Oracle, and SQL Server. RDS handles all administrative tasks like backups, patching, and replication automatically for you. This allows you to focus on your application and data rather than database management and infrastructure. Multi-AZ deployments provide high availability by automatically replicating your database to a standby instance in another availability zone. In case of failure, failover happens automatically with minimal downtime and no manual intervention needed. Read replicas can be created for read-heavy workloads, improving performance and scalability significantly. RDS provides automated backups and point-in-time recovery capabilities for disaster recovery scenarios. You can easily scale your database instance up or down as needs change without downtime. Enhanced monitoring provides detailed performance insights through CloudWatch and Performance Insights dashboards. Security features include encryption at rest and in transit, VPC isolation, and IAM database authentication.',
'Database Administrator'),
('AWS DynamoDB: NoSQL Database for Any Scale',
'DynamoDB is AWS\'s fully managed NoSQL database service designed for any scale and performance requirements. It provides single-digit millisecond latency and automatic scaling to handle millions of requests per second. DynamoDB is ideal for applications requiring high performance, low latency, and flexible schema designs. Unlike traditional relational databases, DynamoDB uses key-value and document data models for flexibility. Tables don\'t require predefined schemas, allowing flexible data structures that evolve with your application. Global Secondary Indexes enable querying on non-key attributes, and Local Secondary Indexes provide additional query flexibility. DynamoDB on-demand pricing charges per request, while provisioned billing offers significant savings for predictable workloads. DynamoDB Streams capture changes for real-time processing with Lambda or Kinesis Data Streams. Point-in-time recovery protects against accidental deletions and data corruption incidents. DynamoDB Accelerator (DAX) provides caching for faster reads and reduced database load significantly.',
'Backend Developer'),
('Docker and ECR: Container Management on AWS',
'Docker containers package applications with all dependencies for consistent deployment across environments. AWS Elastic Container Registry (ECR) is a fully managed Docker container registry making it easy to store, manage, and deploy container images. ECR integrates seamlessly with other AWS services like ECS, EKS, and CodePipeline. Building containerized applications involves creating Dockerfiles that define application dependencies and configuration. These are built into images that run consistently across development, testing, and production environments. ECR stores these images securely with encryption and access controls managed through IAM policies. ECR integrates tightly with CodePipeline for automated image builds and deployments in your CI/CD pipeline. Images can be deployed to ECS for orchestration, EKS for Kubernetes, or any Docker-compatible platform. Lifecycle policies automatically clean up old images, reducing storage costs significantly over time. To get started with Docker and ECR, you create a Dockerfile, build an image, push to ECR, and deploy.',
'Container Engineer'),
('AWS ECS: Orchestrate Containers at Scale',
'Elastic Container Service (ECS) is AWS\'s container orchestration service for managing Docker containers at scale. ECS handles scheduling, placement, and lifecycle management of containers automatically and efficiently. It integrates seamlessly with ECR for image storage and other AWS services like Elastic Load Balancing. ECS supports both EC2 and Fargate launch types for different use cases and requirements. EC2 launch type gives you more control and is cost-effective for large workloads. Fargate is serverless - you specify memory and CPU requirements, and AWS handles infrastructure management automatically for you. Task definitions specify container images, memory, CPU requirements, environment variables, and logging configuration. Services manage long-running applications with auto-scaling capabilities that respond to demand. ECS automatically replaces failed containers and distributes them across your cluster intelligently. Integrating with Application Load Balancer enables efficient traffic distribution across containers.',
'DevOps Engineer'),
('AWS Batch: Process Large-Scale Computing Jobs',
'AWS Batch enables you to easily and efficiently run hundreds of thousands of computing jobs on AWS infrastructure. It automatically provisions compute resources and optimizes job distribution across instances intelligently. Batch is ideal for large-scale data processing, scientific simulations, and other compute-intensive workloads. Jobs are organized into job definitions specifying container images, resource requirements, and environment variables. Job queues manage priorities and resource allocation across multiple compute environments. Compute environments define the compute resources including instance types, vCPU limits, and scaling parameters. Batch integrates seamlessly with other AWS services like S3 for data, EC2 for compute, Lambda, and SNS for notifications. Jobs can be submitted through the console, CLI, SDK, or through scheduled events. Batch automatically handles job scheduling, retry logic for failures, and error handling, reducing operational complexity. You only pay for the compute resources actually used for your jobs, not for idle capacity.',
'Data Scientist'),
('Azure Functions: Cloud-Native Serverless Workflows',
'Azure Functions is Microsoft\'s event-driven serverless compute platform. It enables you to run code triggered by HTTP requests, queue messages, event grid events, and more, without managing any infrastructure. The platform supports multiple programming languages including C#, Java, JavaScript, Python, and PowerShell. You can easily connect functions to other Azure services like Cosmos DB, Service Bus, or Event Hubs using built-in bindings. Pricing is based on consumption, so you only pay for execution time and resources consumed by each invocation. The Azure portal offers an integrated development environment to manage, edit, test, and monitor your functions. You can deploy your code continuously from source controls including GitHub, Azure Repos, or Bitbucket, fostering fast development workflows. Functions scale rapidly and automatically in response to incoming request rates. With Durable Functions, you can orchestrate complex workflows such as fan-out/fan-in or human approval, all serverlessly. Logging and monitoring are integrated via Application Insights, giving you real-time telemetry, diagnostics, and distributed tracing. Serverless patterns on Azure drive huge developer productivity gains and allow you to focus on business logic, not glue code or runtime management.',
'Cloud Solutions Architect'),
('Azure Virtual Machine Scale Sets: Dynamic Workload Scaling',
'Azure Virtual Machine Scale Sets enable you to deploy and manage a group of load-balanced VMs that can automatically increase or decrease capacity based on demand. Scale sets integrate seamlessly with Azure Load Balancer and Azure Application Gateway to distribute traffic. You can deploy sets across multiple availability zones for high availability. VMSS supports both Linux and Windows VMs and can be managed with Azure CLI, PowerShell, or ARM templates for infrastructure-as-code. Autoscale policies can be set on metrics like CPU, memory, disk I/O, or custom rules. Integration with Azure Monitor allows for comprehensive insights and proactive scaling actions. Thanks to rolling upgrades, you can roll out OS updates or app changes without downtime. Image upgrades and Azure Spot Instances reduce costs for batch workloads. Scale sets are key for scenarios like microservices, stateless web servers, high-compute apps, and more. Policy-based scaling ensures cost control while guaranteeing performance for peak workloads. VMSS is used widely for both ephemeral, bursty workloads and reliable, scalable long-running applications.',
'Cloud Infrastructure Specialist'),
('Azure Resource Manager: Unified Infrastructure as Code Foundation',
'Azure Resource Manager (ARM) enables unified management of Azure resources from one platform, using JSON-based templates for infrastructure-as-code. ARM templates define deployments declaratively, supporting resource dependencies, secure parameters, and outputs. Resources can be grouped into resource groups for logical management and RBAC policies. ARM provides automatic dependency resolution, so resources are provisioned in the correct order. Templates can be modularized and reused, allowing for composable, versioned infrastructure. Azure Policy and Blueprints build on ARM for compliance and governance enforcement. Change tracking and deployment history in the Azure Portal allow for easy rollback and auditing. ARM integrates with CI/CD tools, API, PowerShell, and Azure CLI for full DevOps pipelines. Management locks and tags ensure accidental changes are prevented and resources are discoverable. ARM supports incremental, full, and complete mode deployments, giving you precision over updates. Export capabilities let you snapshot and iterate infrastructure for agile project needs.',
'Enterprise Architect'),
('Automation with Azure Automation: Streamlined Cloud Operations',
'Azure Automation delivers scalable process automation, configuration management, and update management for your Azure and hybrid environments. Runbooks written in PowerShell or Python automate tasks like VM lifecycle, patching, backup, and scaling across all connected infrastructure. The hybrid worker capability lets you manage on-prem resources as well. Asset inventory, state tracking, and configuration drift detection ensure compliance with internal and external standards. Automation Accounts centralize scheduling, credential management, certificates, variables, and secure asset storage. Azure Desired State Configuration (DSC) ensures environments stay consistent and drift-free. Update management tracks patch status, schedules maintenance, and automates OS patch installation for VMs anywhere. Webhooks trigger automations from external systems like service tickets or monitoring alerts. Logic Apps, Functions, and Event Grid combine with Automation for powerful cloud-native orchestration. Real-time logging, alerts, and dashboards provide operational insights at every automation step. Azure Automation empowers DevOps and IT teams to automate not just Azure, but enterprise-wide IT operations.',
'Automation Engineer'),
('Azure DevOps Pipelines: End-to-End Continuous Integration and Deployment Automation',
'Azure DevOps Pipelines provide a powerful set of cloud-hosted CI/CD tools for building, testing, and deploying code to Azure, AWS, GCP, or on-premises environments. Pipelines support YAML or classic editors, letting you use code-as-pipeline or UI-based workflows. Native GitHub and Azure Repos integration support advanced PR checks, multi-stage pipelines, and gate controls. Built-in agents support Windows, Linux, macOS, and custom containers. Artifacts can be stored and promoted across environments using Azure Artifacts, supporting traceability and provenance. Pipelines integrate with AKS, App Service, VMSS, Functions, or any deployment endpoint. Parallel and matrix build options maximize coverage, and adjustable scaling lets you pay only for needed concurrency. Security is enforced via permissioned service connections, variable groups, and secrets management. Comprehensive reporting and traceability detail test coverage, deployment status, and audit trails. With environment approvals, deployment slots, and rollback support, DevOps Pipelines empower high-trust, high-velocity releases for any dev team.',
'DevOps Integration Specialist');


-- Create additional tables for future enhancements
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_username (username),
  INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT,
  comment_text LONGTEXT NOT NULL,
  author_name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES blog_posts(id) ON DELETE CASCADE,
  INDEX idx_post (post_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verify database setup
SELECT 'Database and tables created successfully!' as status;
SELECT COUNT(*) as total_blog_posts FROM blog_posts;
SELECT DISTINCT author FROM blog_posts ORDER BY author;
