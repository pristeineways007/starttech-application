# StartTech Runbook

## Operations and Troubleshooting Guide

## Deployments

### Deploy Frontend Manually
./scripts/deploy-frontend.sh <s3-bucket-name> <cloudfront-distribution-id>
```

### Deploy Backend Manually
./scripts/deploy-backend.sh <ecr-registry> <image-tag>
```

### Check Application Health
./scripts/health-check.sh
```

### Rollback Backend
./scripts/rollback.sh <ecr-registry> <previous-image-tag>
```

## Troubleshooting

### Application is Down

1. Run health check:
./scripts/health-check.sh
```

2. Check ALB target group health in AWS Console:
- EC2 → Load Balancers → starttech-alb
- Click Target Groups → Check health status

3. Check EC2 instance logs in CloudWatch:
- CloudWatch → Log Groups → /starttech/production/app

4. If instances are unhealthy, check ASG:
- EC2 → Auto Scaling Groups → starttech-asg
- Check Activity History for errors

### Pipeline Failed

1. Go to GitHub Actions tab in the repo
2. Click the failed workflow
3. Expand the failed step to see the error
4. Fix the error and push again

### High CPU Alert

1. Check CloudWatch dashboard for CPU metrics
2. If sustained high CPU, manually scale up:
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name starttech-asg \
  --desired-capacity 4
```

### Database Connection Issues

1. Check MongoDB Atlas dashboard for cluster status
2. Verify network access allows EC2 IP ranges
3. Check backend logs in CloudWatch for connection errors

### Redis Connection Issues

1. Check ElastiCache cluster status in AWS Console
2. Verify security group allows EC2 to connect on port 6379
3. Check backend logs for Redis connection errors

## Accessing EC2 Instances

### SSH via Bastion Host

1. Get bastion public IP from Terraform outputs:
cd starttech-infra/terraform
terraform output bastion_public_ip
```

2. SSH into bastion:
ssh -i ways.pem ec2-user@<bastion-public-ip>


3. From bastion, SSH into private EC2:
ssh -i ways.pem ec2-user@<private-ec2-ip>


## Destroying Infrastructure

When done, destroy all AWS resources to stop billing:
cd starttech-infra/terraform
terraform destroy
```

Type `yes` when prompted.
```
