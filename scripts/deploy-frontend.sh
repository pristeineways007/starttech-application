#!/bin/bash

set -e

echo "Starting frontend deployment..."

# Variables
S3_BUCKET=$1
CLOUDFRONT_DISTRIBUTION_ID=$2
FRONTEND_DIR="../frontend"

# Check arguments
if [ -z "$S3_BUCKET" ] || [ -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo "Usage: ./deploy-frontend.sh <s3-bucket-name> <cloudfront-distribution-id>"
  exit 1
fi

# Build frontend
echo "Building frontend..."
cd $FRONTEND_DIR
npm ci
npm run build
cd ..

# Sync to S3
echo "Syncing to S3..."
aws s3 sync $FRONTEND_DIR/dist/ s3://$S3_BUCKET --delete

# Invalidate CloudFront cache
echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
  --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
  --paths "/*"

echo "Frontend deployment complete!"