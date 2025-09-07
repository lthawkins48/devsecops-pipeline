# devsecops-pipline
End-to-end DevSecOps CI/CD pipeline demo with FastAPI, GitHub Actions, Docker, Terraform, and AWS ECS. Includes security scans (Bandit, Trivy, Gitleaks, Checkov) plus automated testing, containerization, deployment, and rollback for secure cloud delivery.
This repository demonstrates a complete DevSecOps CI/CD pipeline. It shows how to build, test, secure, and deploy a containerized FastAPI application using GitHub Actions, Docker, Terraform, and AWS ECS, with integrated security checks and automated rollback.

## Governance & Branch Protection

For demonstration, some strict GitHub branch protection rules have been temporarily disabled (such as requiring signed commits).  

- ✅ In real-world production pipelines, I would enforce **signed commits** using GPG or SSH-based signing to ensure commit authenticity and integrity.  
- ⚡ For this demo project, unsigned commits are allowed to simplify merging and testing CI/CD flows.  
- 📝 Note: Signed commit setup instructions are included in project documentation for reference.  
.
