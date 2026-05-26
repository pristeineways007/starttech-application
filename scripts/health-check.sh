#!/bin/bash

set -e

echo "Starting backend deployment..."

# Variables
ECR_REGISTRY=$1
IMAGE_TAG=$2
ASG_NAME="starttech-asg"
AWS_REGION="us-east-1"

# Check arguments
if [ -z "$ECR_REGISTRY" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Usage: ./deploy-backend.sh <ecr-registry> <image-tag>"
  exit 1
fi

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $ECR_REGISTRY

# Pull latest image
echo "Pulling Docker image..."
docker