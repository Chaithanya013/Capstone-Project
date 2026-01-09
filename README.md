# CI/CD Capstone Project – Docker & Jenkins

## Table of Contents

* [Project Overview](#project-overview)
* [Architecture](#architecture)
* [Technology Stack](#technology-stack)
* [Repository Structure](#repository-structure)
* [CI/CD Pipeline Flow](#cicd-pipeline-flow)
* [Docker Best Practices Applied](#docker-best-practices-applied)
* [Environment Strategy](#environment-strategy)
* [Deployment Runbook](#deployment-runbook)
* [Troubleshooting Guide](#troubleshooting-guide)
* [Ngrok & Webhook Integration](#ngrok--webhook-integration)

---

## Project Overview

This project implements a **complete CI/CD system** that automatically **builds, tests, scans, and deploys** a simple two-tier web application using **Docker** and **Jenkins**.

The pipeline supports **multiple environments (dev, staging, prod)** and follows container security and CI/CD best practices.

**Goal:**

* Achieve repeatable, automated deployments with minimal manual intervention
* Validate code quality and container security before deployment

---

## Architecture

**High-level architecture:**

```
[ Developer ]
     |
     |  Git Push
     v
[ GitHub Repository ]
     |
     |  Webhook (Ngrok)
     v
[ Jenkins CI/CD Pipeline ]
     |
     |  Build • Test • Scan • Push
     v
[ Docker Hub Registry ]
     |
     |  Pull Images
     v
[ Docker Compose Environment ]
     |        |        |
  Frontend  Backend   Database
```

📸 **Screenshot placeholder:** Architecture diagram

---

## Technology Stack

* **Backend:** Python Flask
* **Frontend:** Static HTML (served via Nginx)
* **CI/CD:** Jenkins (Declarative Pipeline)
* **Containers:** Docker & Docker Compose
* **Security Scanning:** Trivy
* **Registry:** Docker Hub
* **Webhook Tunnel:** Ngrok
* **Database:** PostgreSQL

---

## Repository Structure

```
Capstone_Project/
├── backend/
│   ├── app.py
│   ├── dockerfile
│   ├── requirements.txt
│   └── tests/
├── frontend/
│   ├── dockerfile
│   └── index.html
├── scripts/
│   ├── health_check.ps1
│   ├── rollback.ps1
│   └── deploy.sh
├── docker-compose.dev.yml
├── docker-compose.staging.yml
├── docker-compose.prod.yml
├── jenkins/
│   └── jenkinsfile
├── .env.dev
├── .env.staging
├── .env.prod
└── README.md
```

---
## CI/CD Pipeline Flow

This section explains how the CI/CD pipeline works end‑to‑end, from code push to a running application, in a clear and professional way.

---

### 📌 Overview

The CI/CD pipeline is implemented using **Jenkins Declarative Pipeline** and is automatically triggered on every GitHub push using **GitHub Webhooks (via Ngrok)**. The pipeline ensures code quality, security, and reliable deployment across **dev, staging, and prod** environments.

---

### 🔁 Pipeline Trigger (GitHub → Jenkins)

* Developer pushes code to the `main` branch on GitHub
* GitHub Webhook sends an event to Jenkins
* Ngrok exposes the local Jenkins server to GitHub

**Trigger type:** Automatic (no manual build required)

📸 *Screenshot placeholder: GitHub Webhook configuration*

---

### 🧱 Pipeline Stages

Below are the key stages executed in sequence for every build:

---

#### 1️⃣ Checkout Source Code

* Jenkins pulls the latest code from GitHub
* Ensures pipeline always runs on the most recent commit

---

#### 2️⃣ Build Docker Images

* Backend and frontend Docker images are built using **best‑practice Dockerfiles**
* Image tags are environment‑specific: `dev`, `staging`, `prod`
* Uses Docker layer caching for faster builds

---

#### 3️⃣ Unit Tests (Containerized)

* Unit tests are executed **inside the backend Docker container**
* Ensures application logic is validated in an environment identical to production

✔ Tests must pass for the pipeline to continue

---

#### 4️⃣ Security Scan – Trivy

* Docker images are scanned using **Trivy** for vulnerabilities
* Scans focus on **HIGH** and **CRITICAL** severity issues
* Pipeline fails automatically if critical vulnerabilities are detected

This stage ensures container security before images are pushed or deployed.

📸 *Screenshot placeholder: Trivy scan results in Jenkins console*

---

#### 5️⃣ Push Images to Docker Hub

* Jenkins authenticates with Docker Hub using stored credentials
* Successfully built images are pushed with environment‑specific tags

Example:

* `chaithanya013/backend:dev`
* `chaithanya013/backend:staging`
* `chaithanya013/backend:prod`

---

#### 6️⃣ Deploy to Target Environment

* Jenkins deploys the application using **Docker Compose**
* Environment is selected via Jenkins build parameter (`ENV`)
* Existing containers are stopped and replaced with new ones

✔ Supports `dev`, `staging`, and `prod`

---

#### 7️⃣ Health Check Verification

* Jenkins runs an automated health check script
* Verifies backend service availability via `/health` endpoint
* Confirms successful deployment before marking the build as successful

❌ Pipeline fails if health check does not pass

---

#### 8️⃣ Build Status & Feedback

* Build is marked **SUCCESS** only if all stages pass
* Deployment details are visible directly in Jenkins stage view

📸 *Screenshot placeholder: Jenkins pipeline stage view (green checks)*

---

### ✅ Outcome

By the end of the pipeline:

* Secure, tested Docker images are deployed
* Correct environment configuration is applied
* Application is live and verified automatically

This pipeline ensures **speed, reliability, and security** with minimal manual intervention.

---
## Deployment Runbook

This section describes **how to deploy, verify, and rollback** the application using the existing CI/CD pipeline and Docker Compose. It is written so that any team member can safely operate deployments.

---

### Supported Environments

* **dev** – Development environment
* **staging** – Pre-production validation
* **prod** – Production environment

Each environment uses:

* A dedicated Docker image tag (`dev`, `staging`, `prod`)
* A dedicated Docker Compose file (`docker-compose.<env>.yml`)
* A dedicated environment file (`.env.<env>`)

---

### Deployment Prerequisites

Ensure the following are available **before deployment**:

* Jenkins server running and reachable
* Docker & Docker Compose installed on Jenkins agent
* Docker Hub credentials configured in Jenkins (`dockerhub-creds`)
* GitHub repository connected via webhook (Ngrok for local Jenkins)

---

### Standard Deployment (Recommended)

Deployment is **fully automated** via Jenkins.

#### Steps

1. Open Jenkins job
2. Click **Build with Parameters**
3. Select environment:

   * `dev` / `staging` / `prod`
4. Click **Build**

Jenkins will automatically:

* Build backend & frontend images
* Run unit tests inside containers
* Scan images with **Trivy**
* Push images to Docker Hub
* Deploy containers using Docker Compose
* Run health checks

✅ **No manual server access is required**

---

### What Happens During Deployment

For the selected environment:

1. Existing containers are stopped
2. Latest images are pulled from Docker Hub
3. New containers are started
4. Health endpoint (`/health`) is validated
5. Build is marked **SUCCESS** or **FAILURE**

---

### Health Verification

Health is verified automatically using:

* Application endpoint: `/health`
* Docker container health status

Manual verification (optional):

```bash
docker ps
curl http://localhost:<mapped-port>/health
```

Expected response:

```json
{
  "status": "UP"
}
```

---

### Rollback Procedure

Rollback is **automatically triggered** if any stage fails after deployment.

Rollback actions:

* Stop faulty containers
* Revert to previously running containers
* Mark pipeline as FAILED

Manual rollback (if required):

```bash
docker compose -f docker-compose.<env>.yml down
docker compose -f docker-compose.<env>.yml up -d
```

---

### Cleanup (Optional Maintenance)

If required before a fresh deployment:

```bash
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.staging.yml down
docker compose -f docker-compose.prod.yml down

docker system prune -af
```

---

### Screenshots to Include

> 📸 **Insert screenshots at the following points:**

* Jenkins "Build with Parameters" screen
* Successful pipeline execution
* Docker containers running (`docker ps`)
* Application UI in browser

---
## Troubleshooting Guide

This section lists common issues faced during the CI/CD pipeline execution, Docker deployment, and environment setup, along with clear fixes. Use this as a quick reference during failures.

---

### 1. Jenkins Pipeline Not Triggering Automatically

**Symptoms**

* Git push does not start Jenkins build
* No activity in Jenkins job

**Checks & Fixes**

* Ensure GitHub Webhook is configured with the correct URL:

  * `https://<ngrok-url>/github-webhook/`
* Verify webhook delivery status in GitHub → Repository → Settings → Webhooks
* Confirm Jenkins job has **GitHub hook trigger for GITScm polling** enabled

📸 *Screenshot: GitHub webhook delivery success*

---

### 2. Pipeline Fails at Docker Build Stage

**Symptoms**

* `docker build` command fails in Jenkins
* Dockerfile not found or permission denied

**Checks & Fixes**

* Confirm Docker is running on the Jenkins agent
* Verify correct Dockerfile name and path (case-sensitive)
* Run locally:

  ```bash
  docker build -t test-image backend/
  ```
* Ensure Jenkins user has permission to run Docker

---

### 3. Unit Tests Failing in Pipeline but Passing Locally

**Symptoms**

* Pytest fails in Jenkins
* Import errors like `ModuleNotFoundError`

**Checks & Fixes**

* Ensure `PYTHONPATH` is set correctly in Dockerfile:

  ```dockerfile
  ENV PYTHONPATH=/app
  ```
* Confirm test files are copied into the image
* Run inside container to debug:

  ```bash
  docker run --rm <image> pytest -v
  ```

---

### 4. Trivy Scan Failing Pipeline

**Symptoms**

* Pipeline stops at Trivy stage
* Vulnerabilities reported

**Checks & Fixes**

* Verify Trivy image scan uses saved image (`docker save` → `.tar`)
* For learning/demo, keep:

  ```
  --exit-code 0
  ```
* Review Trivy output for HIGH/CRITICAL issues

📸 *Screenshot: Trivy scan output in Jenkins console*

---

### 5. Deployment Stage Fails (Docker Compose)

**Symptoms**

* Port already allocated
* Containers not starting

**Checks & Fixes**

* Stop existing containers before deploy:

  ```bash
  docker compose -f docker-compose.<env>.yml down
  ```
* Ensure each environment uses **unique ports**
* Validate compose file syntax:

  ```bash
  docker compose config
  ```

---

### 6. Health Check Stage Failing

**Symptoms**

* Pipeline fails only at Health Check
* Works in dev but fails in staging/prod

**Checks & Fixes**

* Ensure backend exposes `/health` endpoint
* Verify correct port mapping per environment
* Confirm PowerShell script receives ENV parameter correctly
* Test manually:

  ```bash
  curl http://localhost:<port>/health
  ```

📸 *Screenshot: Successful health check response*

---

### 7. Frontend Not Accessible in Browser

**Symptoms**

* `localhost:9090 / 9091 / 9092` not loading
* Frontend container exits

**Checks & Fixes**

* Check frontend container logs:

  ```bash
  docker logs <frontend-container>
  ```
* Ensure frontend image is built and pushed correctly
* Verify Nginx/HTML files are copied into image

---

### 8. Docker Hub Push Failures

**Symptoms**

* Authentication errors during push

**Checks & Fixes**

* Re-check Docker Hub credentials in Jenkins
* Login locally to validate:

  ```bash
  docker login
  ```
* Ensure correct image tag (`dev`, `staging`, `prod`)

---

### 9. Environment-Specific Issues

**Symptoms**

* Works in dev but not in staging/prod

**Checks & Fixes**

* Verify correct `.env` file is used
* Confirm environment-specific ports and image tags
* Ensure Jenkins parameter `ENV` matches compose file names

---

### Quick Recovery Commands

```bash
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
docker system prune -af
```

Use these only when the environment is completely stuck.

---





