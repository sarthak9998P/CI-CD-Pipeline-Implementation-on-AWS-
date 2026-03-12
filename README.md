# 🔄 CI/CD Pipeline Implementation on AWS

A fully automated CI/CD pipeline using **GitHub Actions + AWS** — build, test, deploy, monitor, and auto-rollback on failure.

---

## 📌 Project Overview

This project demonstrates a complete DevOps pipeline:
- **GitHub Actions** triggers on every push to `main`
- **Bash scripts** handle build, deploy, and rollback logic
- **AWS CodeBuild** for cloud-side builds
- **IAM roles** with least-privilege for secure pipeline execution
- **Prometheus + Grafana** to monitor deployment metrics

---

## 🔄 Pipeline Flow

```
Developer pushes code to GitHub
            │
            ▼
    GitHub Actions triggered
            │
      ┌─────┴─────┐
      │   Test    │  ← Validate scripts, check syntax
      └─────┬─────┘
            │
      ┌─────┴─────┐
      │   Build   │  ← Build Docker image, push to ECR
      └─────┬─────┘
            │
      ┌─────┴─────┐
      │  Deploy   │  ← SSH into EC2, pull & run new container
      └─────┬─────┘
            │
      ┌─────┴──────┐
      │ Health Chk │  ← Verify app is running
      └─────┬──────┘
            │
     ✅ Success   ❌ Failure
                       │
                  Auto Rollback
```

---

## 📁 Project Structure

```
AWS-CICD-Pipeline/
├── scripts/
│   ├── build.sh            # Build Docker image
│   ├── deploy.sh           # Deploy to EC2 via SSH
│   ├── rollback.sh         # Rollback to previous version
│   └── health_check.sh     # Verify deployment success
├── buildspec/
│   └── buildspec.yml       # AWS CodeBuild spec
├── monitoring/
│   ├── prometheus.yml      # Prometheus scrape config
│   └── alert_rules.yml     # Prometheus alerting rules
├── .github/
│   └── workflows/
│       └── pipeline.yml    # GitHub Actions workflow
├── docs/
│   └── setup-guide.md      # Step-by-step setup
└── README.md
```

---

## ⚙️ Tech Stack

| Category | Tools |
|----------|-------|
| CI/CD | GitHub Actions, AWS CodeBuild |
| Cloud | AWS EC2, ECR, IAM, S3 |
| Containers | Docker |
| Scripting | Bash |
| Monitoring | Prometheus, Grafana |
| Security | IAM Least Privilege, SSH Key Auth |

---

## 🚀 Quick Start

### Step 1: Clone & Configure
```bash
git clone https://github.com/sarthak9998P/AWS-CICD-Pipeline.git
cd AWS-CICD-Pipeline
```

### Step 2: Add GitHub Secrets
Go to repo → **Settings → Secrets → Actions**:

| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `EC2_HOST` | Your EC2 public IP |
| `EC2_SSH_KEY` | Contents of your `.pem` file |

### Step 3: Push Code → Pipeline Runs Automatically
```bash
git add .
git commit -m "feat: new feature"
git push origin main
# Pipeline triggers automatically!
```

---

## 📊 Monitoring

```bash
# Start Prometheus
docker run -d -p 9090:9090 \
  -v $(pwd)/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

# Start Grafana
docker run -d -p 3000:3000 grafana/grafana
```

Metrics tracked:
- Deployment frequency
- Build success/failure rate
- EC2 CPU & memory during deployments
- Pipeline duration

---

## 🔐 Security

- ✅ IAM role with only required permissions (no root access)
- ✅ SSH key stored as GitHub Secret (never in code)
- ✅ AWS credentials stored as GitHub Secrets
- ✅ `.gitignore` prevents accidental credential commits

---

## 📬 Contact

**Sarthak Pathade**
📧 sarthakpathade9998@gmail.com
📍 Pune, Maharashtra
