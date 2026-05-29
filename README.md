# StartTech Application

A full-stack todo application with React frontend and Golang backend, deployed on AWS with a complete CI/CD pipeline.

## Application Architecture

- **Frontend**: React application deployed to AWS S3 with CloudFront CDN
- **Backend**: Golang API running on EC2 instances behind an Application Load Balancer
- **Database**: MongoDB Atlas for data persistence
- **Cache**: AWS ElastiCache Redis for caching and sessions

## Repository Structure

```
starttech-application/
├── .github/
│   └── workflows/
│       ├── frontend-ci-cd.yml
│       └── backend-ci-cd.yml
├── frontend/
├── backend/
├── scripts/
│   ├── deploy-frontend.sh
│   ├── deploy-backend.sh
│   ├── health-check.sh
│   └── rollback.sh
└── README.md
```

## Prerequisites

- AWS CLI configured
- Docker installed
- Node.js 20+
- Go 1.21+

## Environment Variables

### Frontend
| Variable | Description |
|---|---|
| `VITE_API_URL` | Backend API URL |

### Backend
| Variable | Description |
|---|---|
| `MONGODB_URI` | MongoDB Atlas connection string |
| `REDIS_URL` | ElastiCache Redis endpoint |
| `PORT` | Application port (default: 8080) |
| `JWT_SECRET` | JWT signing secret |

## CI/CD Pipelines

### Frontend Pipeline
Triggers on push to `main` branch when files in `frontend/` change.
- Installs dependencies
- Runs security scan
- Builds production bundle
- Syncs to S3
- Invalidates CloudFront cache

### Backend Pipeline
Triggers on push to `main` branch when files in `backend/` change.
- Runs unit tests
- Runs vulnerability scan
- Builds Docker image
- Pushes to ECR
- Deploys to EC2 via rolling update
- Runs smoke tests

## Manual Deployment

### Deploy Frontend
./scripts/deploy-frontend.sh <s3-bucket-name> <cloudfront-distribution-id>


### Deploy Backend
./scripts/deploy-backend.sh <ecr-registry> <image-tag>


### Health Check

./scripts/health-check.sh


### Rollback

./scripts/rollback.sh <ecr-registry> <previous-image-tag>


## GitHub Secrets Required

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `MONGODB_URI` | MongoDB connection string |
| `VITE_API_URL` | Backend API URL |
| `S3_BUCKET_NAME` | S3 bucket name |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID |
| `ECR_REGISTRY` | ECR registry URL |
```
