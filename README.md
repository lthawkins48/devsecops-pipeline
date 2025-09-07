## CI/CD + DevSecOps Architecture

```text
┌───────────┐       ┌─────────────┐       ┌─────────────┐
│ Developer │  git  │ GitHub Repo │ CI/CD │ GitHub      │
│  Commit   ├──────▶│  (branch)   ├──────▶│ Actions     │
└───────────┘       └─────────────┘       └─────┬───────┘
                                                │
                           ┌────────────────────┼─────────────────────┐
                           ▼                    ▼                     ▼
                     Static Code Scan     Dependency Scan       Secret Scan
                     (Bandit, Flake8)     (pip-audit)           (Gitleaks)
                           │                    │                     │
                           └───────────────┬────┴───────────────┬─────┘
                                           ▼                    ▼
                                    Docker Build          IaC Scan (Checkov)
                                           │
                                           ▼
                                   Docker Image Built
                                           │
                                           ▼
                                 Local Deployment (demo)
                                 or Push to Cloud (live)


# DevSecOps CI/CD Demo Pipeline

This repository demonstrates a secure CI/CD pipeline that showcases DevSecOps practices (build, test, scan, deploy, rollback). It runs locally for demonstration but includes notes on how it would work in a real live deployment.

---

## Features

* CI/CD Pipeline with GitHub Actions
* Static Code Analysis (Bandit, Flake8)
* Dependency Scanning (pip-audit)
* Container Scanning (Trivy)
* Governance & Branch Protection
* Local & Live Deployment paths

---

### Governance & Branch Protection

> For this demo, some strict rules (e.g., requiring signed commits) are relaxed. In production:

* Enforce **signed commits** using GPG/SSH
* Require reviews before merge
* Restrict direct pushes to `main`

**Signed Commit Setup (production best practice):**

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git commit -S -m "Your signed commit"
```

---

### Local Deployment (Demo)

```bash
docker build -t devsecops-demo-app .
docker run -p 5000:5000 devsecops-demo-app
```

Visit → [http://localhost:5000](http://localhost:5000)

Run workflows locally with [`act`](https://github.com/nektos/act):

```bash
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
act
```

---

### Live Deployment (If Extended)

If deploying to cloud (AWS, Azure, GCP):

1. CI builds Docker image → pushes to registry (ECR/GCR/ACR).
2. IaC (Terraform/K8s manifests) provisions infrastructure.
3. CD deploys container to ECS, GKE, AKS, or Kubernetes cluster.
4. Rollback handled by redeploying previous stable image.

Example (AWS ECS):

```bash
docker tag devsecops-demo-app:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/devsecops-demo-app:latest
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/devsecops-demo-app:latest
```

CI/CD pipeline (GitHub Actions) would then trigger ECS task update.

---

### Rollback & Recovery

Stop current container:

```bash
docker ps -q --filter "ancestor=devsecops-demo-app" | xargs -r docker stop
```

Run last stable:

```bash
docker run -p 5000:5000 devsecops-demo-app:stable
```

Tag stable:

```bash
docker tag devsecops-demo-app devsecops-demo-app:stable
```

---

### Quick Demo with Scripts

**Deploy:**

```bash
./deploy.sh
```

**Rollback:**

```bash
./rollback.sh
```

Both scripts automate build, run, and recovery for a smoother demo.

---

### Summary

* Local demo shows **CI/CD pipeline + security scans + rollback**
* README includes **live deployment notes** for recruiters
* Governance best practices (signed commits, branch protection) explained
* Quick scripts make deployment and rollback fast & repeatable

✅ Successful deployment: [http://localhost:5000](http://localhost:5000)

