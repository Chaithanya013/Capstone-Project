# Secure CI/CD Pipeline with Jenkins, Docker & Trivy

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement & Goals](#2-problem-statement--goals)
3. [Key Features & Highlights](#3-key-features--highlights)
4. [Architecture](#4-architecture)
5. [Technology Stack](#5-technology-stack)
6. [Repository Structure](#6-repository-structure)
7. [CI/CD Pipeline Flow](#7-cicd-pipeline-flow)
8. [Security Implementation – Trivy](#8-security-implementation--trivy)
9. [Environment Strategy](#9-environment-strategy)
10. [Deployment Runbook](#10-deployment-runbook)
11. [Troubleshooting Guide](#11-troubleshooting-guide)
12. [Conclusion](#12-conclusion)


## 1. Project Overview

This project implements a **secure, end-to-end CI/CD pipeline** designed to automate the complete lifecycle of a containerized web application, including **build, test, security validation, image distribution, and deployment**. The solution leverages **Jenkins** for pipeline orchestration, **Docker** for containerization, and **Trivy** for vulnerability scanning, ensuring that only verified and secure container images are promoted through the delivery process.

The pipeline supports **multiple deployment environments (DEV, STAGING, PROD)** and follows **real-world DevOps and DevSecOps practices** such as automated quality gates, environment consistency, and post-deployment health verification. GitHub webhooks exposed via **Ngrok** enable event-driven pipeline execution, while **Docker Compose** is used to deploy and manage frontend and backend services in a reliable and repeatable manner. This project is designed to closely resemble production-grade CI/CD systems used in modern software delivery.

---

## 2. Problem Statement & Goals

### Problem Statement

In many traditional software delivery workflows, application deployments rely heavily on **manual steps**, environment-specific configurations, and ad-hoc validation. Such approaches often lead to **inconsistent deployments**, delayed releases, and a lack of visibility into application security. Without automated testing and security checks, vulnerable or unstable builds can easily reach higher environments, increasing operational and security risks.

Additionally, the absence of a standardized CI/CD pipeline makes it difficult to maintain parity across **development, staging, and production** environments. Teams frequently face challenges such as configuration drift, deployment failures, and slow feedback cycles, all of which negatively impact delivery speed and reliability.

### Project Goals

The primary goals of this project are:

* Automate the complete CI/CD lifecycle from source code commit to deployment
* Enforce **container security** by integrating Trivy vulnerability scanning into the pipeline
* Ensure **environment consistency** across DEV, STAGING, and PROD
* Reduce manual intervention and human error during deployments
* Provide fast feedback through automated testing and health checks
* Design a CI/CD workflow that closely mirrors **real-world, production-grade DevOps practices**

---

## 3. Key Features & Highlights

This project is designed to demonstrate **practical, production-aligned DevOps and DevSecOps capabilities**. The following key features highlight the core strengths and real-world relevance of the implemented CI/CD solution.

* **End-to-End Automated CI/CD Pipeline**
  Fully automates the process from source code commit to deployment using Jenkins, eliminating manual build and deployment steps.

* **Multi-Environment Deployment Strategy**
  Supports **DEV, STAGING, and PROD** environments with environment-specific Docker image tags, Docker Compose files, and configuration files.

* **Containerized Frontend and Backend Services**
  Application components are containerized using Docker, ensuring consistent runtime behavior across all environments.

* **Docker Multi-Stage Builds**
  Uses multi-stage Docker builds to reduce final image size, improve build efficiency, and follow container best practices.

* **Integrated Security Scanning with Trivy**
  Container images are scanned for vulnerabilities during the pipeline execution. Builds fail automatically if **HIGH or CRITICAL** vulnerabilities are detected.

* **Automated Health Checks**
  Post-deployment health checks validate application availability before marking the pipeline as successful.

* **Event-Driven Pipeline Triggering**
  GitHub webhooks exposed through **Ngrok** enable automatic pipeline execution on every code push.

---

## 4. Architecture

This project follows a **modular, event-driven CI/CD architecture** designed to ensure scalability, security, and consistency across environments. Each component in the architecture has a clearly defined responsibility, enabling reliable automation from code commit to deployment.

### 4.1 High-Level Architecture Overview

The architecture begins with a developer pushing code changes to the GitHub repository. A GitHub webhook, exposed securely using **Ngrok**, notifies Jenkins of the change. Jenkins then orchestrates the complete CI/CD workflow, including building Docker images, running tests, performing security scans, pushing images to Docker Hub, and deploying the application using Docker Compose.

Deployed services run as containers and are grouped by environment (DEV, STAGING, PROD), ensuring isolation and configuration consistency. Post-deployment health checks validate service availability before the pipeline is marked successful.

```
Developer
   |
   | Git Push
   v
GitHub Repository
   |
   | Webhook (Ngrok)
   v
Jenkins CI/CD Pipeline
   |
   | Build → Test → Trivy Scan → Push
   v
Docker Hub Registry
   |
   | Pull Images
   v
Docker Compose (DEV / STAGING / PROD)
   |
   |── Frontend (Nginx)
   |── Backend (Flask)
```

### 4.2 Architecture Design Rationale

* **Jenkins** acts as the central automation engine, coordinating all CI/CD stages
* **Docker** guarantees environment parity by packaging application dependencies
* **Docker Compose** simplifies multi-service deployments and environment separation
* **Ngrok** enables secure webhook communication with a locally hosted Jenkins server
* **Trivy** introduces a security gate to prevent vulnerable images from being deployed

This architecture mirrors **real-world production CI/CD systems**, emphasizing automation, security, and operational reliability.

---

## 5. Technology Stack

The following tools and technologies were selected to build a **production-aligned, secure CI/CD pipeline**. Each component plays a specific role in enabling automation, consistency, and security across the software delivery lifecycle.

| Category                | Technology                     | Purpose                                                         |
| ----------------------- | ------------------------------ | --------------------------------------------------------------- |
| CI/CD                   | Jenkins (Declarative Pipeline) | Orchestrates build, test, scan, and deployment stages           |
| Containerization        | Docker                         | Packages applications and dependencies into portable containers |
| Container Orchestration | Docker Compose                 | Manages multi-service deployments per environment               |
| Security                | Trivy                          | Scans container images for vulnerabilities (HIGH / CRITICAL)    |
| Backend                 | Python Flask                   | Provides REST API and health endpoint                           |
| Frontend                | Nginx (Static HTML)            | Serves the web UI to users                                      |
| Registry                | Docker Hub                     | Stores and distributes Docker images                            |
| Webhooks                | GitHub Webhooks, Ngrok         | Triggers Jenkins builds on code changes                         |
| Configuration           | .env files                     | Manages environment-specific variables                          |

This stack reflects commonly used tools in **real-world DevOps and DevSecOps pipelines**, ensuring the project closely resembles modern production systems.

---

## 6. Repository Structure

This section provides an overview of the repository layout and explains how the project is organized to support a clean, maintainable, and scalable CI/CD workflow. The structure follows **separation of concerns**, making it easy to understand, extend, and operate.

```
Capstone_Project/
├── backend/
│   ├── app.py                # Flask backend application
│   ├── dockerfile            # Backend Docker image definition
│   ├── requirements.txt      # Python dependencies
│   └── tests/                # Unit tests for backend
├── frontend/
│   ├── dockerfile            # Frontend Docker image definition
│   └── index.html            # Static web UI
├── scripts/
│   ├── deploy.sh             # Deployment helper script
│   ├── health_check.ps1      # Post-deployment health validation
│   └── rollback.ps1          # Rollback support script
├── docker-compose.dev.yml    # DEV environment services
├── docker-compose.staging.yml# STAGING environment services
├── docker-compose.prod.yml   # PROD environment services
├── docker-compose.yml        # Multi-Container orchestration
├── jenkins/
│   └── Jenkinsfile           # Jenkins Declarative Pipeline
├── .env.dev                  # DEV environment variables
├── .env.staging              # STAGING environment variables
├── .env.prod                 # PROD environment variables
├── Screenshots               # Project screenshots and proofs
└── README.md                 # Project documentation
```

This structure ensures:

* Clear separation between **application code**, **CI/CD logic**, and **deployment configuration**
* Environment-specific configurations without duplication
* Easy navigation for reviewers and interviewers

---

## 7. CI/CD Pipeline Flow

This section describes the **end-to-end CI/CD workflow** implemented using Jenkins. The pipeline is designed to automatically validate code quality, enforce security checks, and deploy applications consistently across environments with minimal manual intervention.

### 7.1 CI/CD Pipeline Flow Diagram

The following diagram represents the logical flow of the pipeline from source code commit to deployment:

```
Git Push
   ↓
GitHub Repository
   ↓ (Webhook via Ngrok)
Jenkins Pipeline
   ↓
Checkout Source Code
   ↓
Build Docker Images (Multi-Stage)
   ↓
Run Unit Tests (Containerized)
   ↓
Trivy Security Scan
   ↓
Push Images to Docker Hub
   ↓
Deploy using Docker Compose
   ↓
Health Check Validation
```

![CI/CD Flow Diagram](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Pipeline_Flow.png)

---

### 7.2 Pipeline Trigger Mechanism

The pipeline is triggered automatically whenever a developer pushes code to the GitHub repository. This is achieved using **GitHub Webhooks**, which notify Jenkins of repository events. Since Jenkins is hosted locally, **Ngrok** is used to securely expose the Jenkins webhook endpoint to GitHub.

This setup enables **event-driven automation**, ensuring that every code change is immediately validated by the CI/CD pipeline without requiring manual builds.

![Ngrok Terminal](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Ngrok-Terminal.png)

---

### 7.3 Pipeline Stages Explanation

Each pipeline execution follows a well-defined sequence of stages:

1. **Source Code Checkout**
   Jenkins pulls the latest code from the GitHub repository to ensure the pipeline runs on the most recent changes.

2. **Docker Image Build (Multi-Stage)**
   Backend and frontend images are built using **Docker multi-stage builds**, reducing image size and improving build efficiency.

![Multi-Stage Build](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Multi-Stage-Build.png)

3. **Unit Tests Execution**
   Unit tests are executed inside the backend container, ensuring the application is tested in an environment identical to runtime.

4. **Security Scan – Trivy**
   Trivy scans the built Docker images for known vulnerabilities. The pipeline fails automatically if **HIGH or CRITICAL** vulnerabilities are detected.

5. **Push Images to Docker Hub**
   After successful validation, Docker images are tagged according to the selected environment and pushed to Docker Hub.

6. **Deployment using Docker Compose**
   Jenkins deploys the application using the environment-specific Docker Compose file. Existing containers are replaced with updated ones.

7. **Health Check Validation**
   Automated health checks verify backend service availability before marking the pipeline execution as successful.

---

### 7.4 Pipeline Execution Results

The pipeline supports multiple environments and provides clear visibility into deployment success for each environment.

![Jenkins Pipeline DEV](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Jenkins_Pipeline_DEV.png)

![Jenkins Pipeline STAGING](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Jenkins_Pipeline_STAGING.png)

![Jenkins Pipeline PROD](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Jenkins_Pipeline_PROD.png)


This CI/CD pipeline ensures **speed, security, and reliability**, closely aligning with modern DevOps and DevSecOps best practices.

---

## 8. Security Implementation – Trivy

Security is treated as a **first-class citizen** in this project. To ensure that only trusted and secure container images are deployed, **Trivy** is integrated directly into the CI/CD pipeline as a mandatory security gate.

### 8.1 Why Trivy Is Used

Trivy is a lightweight yet powerful vulnerability scanner capable of detecting:

* Operating system package vulnerabilities
* Application dependency vulnerabilities
* Known CVEs with severity classification

Integrating Trivy into the pipeline helps identify security risks **early in the delivery lifecycle**, reducing the chances of deploying vulnerable images to higher environments.

### 8.2 How Security Is Enforced in the Pipeline

* Docker images are scanned immediately after the build stage
* Trivy checks for **HIGH** and **CRITICAL** severity vulnerabilities
* The pipeline automatically **fails** if unacceptable vulnerabilities are detected
* Only successfully scanned images are pushed to Docker Hub and deployed

This approach ensures security issues are caught **before runtime**, aligning with DevSecOps best practices.

![Trivy Scan Results1](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Trivy_Results1.png)

![Trivy Scan Results2](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Trivy_Results2.png)


By embedding security scanning into the CI/CD workflow, this project demonstrates a proactive and automated approach to container security.

---

## 9. Environment Strategy

This project implements a **multi-environment deployment strategy** to closely simulate real-world software delivery practices. Separate environments are used to validate changes progressively before they reach production, reducing risk and improving reliability.

### 9.1 Supported Environments

The CI/CD pipeline supports the following environments:

| Environment | Purpose                         | Docker Image Tag | Docker Compose File          |
| ----------- | ------------------------------- | ---------------- | ---------------------------- |
| DEV         | Development and initial testing | `:dev`           | `docker-compose.dev.yml`     |
| STAGING     | Pre-production validation       | `:staging`       | `docker-compose.staging.yml` |
| PROD        | Production deployment           | `:prod`          | `docker-compose.prod.yml`    |

Each environment is isolated using:

* Environment-specific Docker image tags
* Dedicated Docker Compose files
* Separate `.env` configuration files

---

### 9.2 Environment Selection in CI/CD Pipeline

The target environment is selected dynamically during pipeline execution using a **Jenkins build parameter (`ENV`)**. This approach allows the same pipeline logic to be reused across environments while ensuring environment-specific configurations are applied correctly.

Based on the selected environment:

* Docker images are tagged appropriately
* The corresponding Docker Compose file is used
* Environment-specific variables are loaded

---

### 9.3 Environment Isolation and Consistency

To avoid configuration drift and runtime conflicts:

* Each environment uses **unique port mappings**
* Environment variables are externalized via `.env` files
* The same Docker images are promoted across environments, ensuring consistency

This strategy ensures predictable behavior across DEV, STAGING, and PROD while maintaining flexibility and safety during deployments.

![jenkins Parameters UI](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Jenkins_Build_with_Parameters.png)

---

## 10. Deployment Runbook

This runbook provides **clear operational steps** for deploying, validating, and rolling back the application using the existing CI/CD pipeline. It is intended to be followed by any team member without requiring manual server intervention.

### 10.1 Deployment Prerequisites

Before triggering a deployment, ensure the following prerequisites are met:

* Jenkins server is running and accessible
* Docker and Docker Compose are installed on the Jenkins agent
* Docker Hub credentials are configured in Jenkins
* GitHub webhook is active and reachable via Ngrok

---

### 10.2 Standard Deployment Procedure (Automated)

Deployments are performed **entirely through Jenkins** and do not require manual access to the target host.

**Steps:**

1. Open the Jenkins job
2. Click **Build with Parameters**
3. Select the target environment (`DEV`, `STAGING`, or `PROD`)
4. Click **Build**

During execution, Jenkins automatically:

* Builds Docker images
* Runs unit tests
* Performs Trivy security scans
* Pushes images to Docker Hub
* Deploys services using Docker Compose
* Executes post-deployment health checks

---

### 10.3 Deployment Verification

After deployment, the application is verified automatically and can also be validated manually if required.

**Frontend Verification:**

* Access the web UI in a browser: 

  * `http://localhost:9090`
  * `http://localhost:9091`
  * `http://localhost:9092`



![Frontend UI1](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Frontend_UI_9090.png)

![Frontend UI2](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Frontend_UI_9091.png)

![Frontend UI3](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Frontend_UI_9092.png)



**Backend Verification:**

* Check backend health endpoint:

  * `http://localhost:5000/health`
  * `http://localhost:5001/health`
  * `http://localhost:5002/health`

Expected response:

```json
{
  "service":"backend", "status": "UP" 
}
```


![Backend Health1](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Backend_Health_5000.png)

![Backend Health2](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Backend_Health_5001.png)

![Backend Health3](https://github.com/Chaithanya013/Capstone-Project/blob/d1d582870f47e06f60db60c04f0dd6ec19ade9a7/Screenshots/Backend_Health_5002.png)


---

### 10.4 Rollback Procedure

Rollback is supported to recover quickly from failed or unstable deployments.

**Automatic Rollback:**

* If deployment or health checks fail, the pipeline marks the build as FAILED
* Previously running containers remain available

**Manual Rollback (if required):**

```bash
docker compose -f docker-compose.<env>.yml down
docker compose -f docker-compose.<env>.yml up -d
```

---

### 10.5 Post-Deployment Cleanup (Optional)

For maintenance or troubleshooting purposes:

```bash
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.staging.yml down
docker compose -f docker-compose.prod.yml down

docker system prune -af
```

Use cleanup commands cautiously, especially in higher environments.

---

## 11. Troubleshooting Guide

This section outlines **common issues** that may occur during CI/CD pipeline execution or application deployment, along with recommended checks and resolutions. It is intended as a quick reference for operators during failures.

### 11.1. Jenkins Pipeline Not Triggering Automatically

**Symptoms**

* Git push does not start Jenkins build
* No activity in Jenkins job

**Checks & Fixes**

* Ensure GitHub Webhook is configured with the correct URL:

  * `https://<ngrok-url>/github-webhook/`
* Verify webhook delivery status in GitHub → Repository → Settings → Webhooks
* Confirm Jenkins job has **GitHub hook trigger for GITScm polling** enabled


---

### 11.2. Pipeline Fails at Docker Build Stage

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

### 11.3. Unit Tests Failing in Pipeline but Passing Locally

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

### 11.4. Trivy Scan Failing Pipeline

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


---

### 11.5. Deployment Stage Fails (Docker Compose)

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

### 11.6. Health Check Stage Failing

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


---

### 11.7. Frontend Not Accessible in Browser

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

### 11.8. Docker Hub Push Failures

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

### 11.9. Environment-Specific Issues

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

These commands help reset the environment but should be used cautiously, especially in production.

---

## 12. Conclusion

This project demonstrates the design and implementation of a **secure, automated, multi-environment CI/CD pipeline** using Jenkins, Docker, and Trivy. By integrating build automation, containerization, security scanning, and environment-aware deployments, the solution reflects how modern DevOps and DevSecOps practices are applied in real-world production systems.

Through this project, key competencies such as **CI/CD pipeline design**, **container security enforcement**, **multi-stage Docker builds**, **environment management**, and **operational troubleshooting** are showcased. The use of GitHub webhooks with Ngrok, automated health checks, and structured deployment workflows further emphasize reliability and automation-first thinking.

Overall, this capstone project serves as a strong **portfolio-ready implementation**, demonstrating the ability to build, secure, deploy, and operate scalable containerized applications. It is well-suited for technical discussions, interviews, and real-world DevOps scenarios where automation, security, and consistency are critical.
