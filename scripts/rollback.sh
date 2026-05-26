#!/bin/bash

set -e

# Variables
ECR_REGISTRY=$1
PREVIOUS_IMAGE_TAG=$2
ASG_NAME="starttech-asg"
AWS_REGION="us-east-1"

# Check arguments
if [ -z "$ECR_REGISTRY" ] || [ -z "$PREVIOUS_IMAGE_TAG" ]; then
  echo "Usage: ./rollback.sh <ecr-registry> <previous-image-tag>"
  exit 1
fi

echo "Starting rollback to image tag: $PREVIOUS_IMAGE_TAG..."

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $ECR_REGISTRY

# Pull previous image
echo "Pulling previous Docker image..."
docker pull $ECR_REGISTRY/starttech-backend:$PREVIOUS_IMAGE_TAG

# Trigger rolling update with previous image
echo "Starting rollback rolling update..."
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --region $AWS_REGION \
  --preferences MinHe