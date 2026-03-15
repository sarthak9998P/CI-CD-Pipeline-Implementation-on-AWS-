# Setup Guide — AWS CI/CD Pipeline

## Step 1: Clone Repo
```bash
git clone https://github.com/sarthak9998P/AWS-CICD-Pipeline.git
cd AWS-CICD-Pipeline
```

## Step 2: Add GitHub Secrets
Go to repo Settings → Secrets → Actions:

| Secret | How to get |
|--------|-----------|
| `AWS_ACCESS_KEY_ID` | IAM Console → Your User → Security Credentials |
| `AWS_SECRET_ACCESS_KEY` | Same as above |
| `EC2_HOST` | EC2 Console → Your instance Public IP |
| `EC2_SSH_KEY` | `cat your-key.pem` and paste full content |

## Step 3: Create ECR Repository
```bash
aws ecr create-repository \
  --repository-name aws-cicd-app \
  --region ap-south-1
```

## Step 4: Add ECR_REPO secret
Add to GitHub Secrets:
- `ECR_REPO` = your ECR URI (from above command output)

## Step 5: Push Code
```bash
git add .
git commit -m "initial commit"
git push origin main
```
Pipeline will trigger automatically!

## Monitoring Setup
```bash
# Prometheus
docker run -d -p 9090:9090 \
  -v $(pwd)/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v $(pwd)/monitoring/alert_rules.yml:/etc/prometheus/alert_rules.yml \
  prom/prometheus

# Grafana
docker run -d -p 3000:3000 grafana/grafana
# Open http://localhost:3000 → admin/admin
```
