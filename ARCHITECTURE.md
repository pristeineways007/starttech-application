# StartTech Architecture

## System Overview

```
Internet
    │
    ▼
CloudFront (CDN)
    │
    ├── S3 Bucket (React Frontend)
    │
    └── Application Load Balancer
            │
            ▼
    Auto Scaling Group
    ├── EC2 Instance (AZ1)
    └── EC2 Instance (AZ2)
            │
            ├── ElastiCache Redis
            └── MongoDB Atlas
```

## Components

### Frontend
- React application built with Vite
- Hosted on AWS S3 as static files
- Served globally through CloudFront CDN
- Environment specific configuration via environment variables

### Backend
- Golang REST API
- Runs in Docker containers on EC2 instances
- Sits behind Application Load Balancer
- Auto scales based on CPU utilization
- Connects to MongoDB Atlas and Redis

### Networking
- VPC with public and private subnets across 2 Availability Zones
- Public subnets host ALB and Bastion host
- Private subnets host EC2 instances and ElastiCache
- NAT Gateway allows private instances to reach internet
- Security groups restrict traffic between components

### Security
- EC2 instances are in private subnets — not publicly accessible
- Only ALB can send traffic to EC2 instances
- Only EC2 instances can connect to Redis
- Bastion host is the only way to SSH into private instances
- All secrets stored in GitHub Secrets
- Docker images scanned for vulnerabilities before deployment

### Monitoring
- CloudWatch Log Groups collect application logs
- CloudWatch Alarms alert on high CPU, errors, and response times
- CloudWatch Dashboard provides visual overview of system health

## CI/CD Flow

```
Developer pushes code
        │
        ▼
GitHub Actions triggered
        │
        ├── Frontend changes → Build → S3 → CloudFront invalidation
        │
        └── Backend changes → Test → Docker build → ECR → EC2 rolling update
```

## Scaling

- ASG minimum: 2 instances
- ASG maximum: 4 instances
- Scale up when CPU > 80%
- Scale down when CPU < 40%
- ALB health checks ensure unhealthy instances are replaced
```
