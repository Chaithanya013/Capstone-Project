## 1. Project Overview

This project implements a **secure, end-to-end CI/CD pipeline** designed to automate the complete lifecycle of a containerized web application, including **build, test, security validation, image distribution, and deployment**. The solution leverages **Jenkins** for pipeline orchestration, **Docker** for containerization, and **Trivy** for vulnerability scanning, ensuring that only verified and secure container images are promoted through the delivery process.

The pipeline supports **multiple deployment environments (DEV, STAGING, PROD)** and follows **real-world DevOps and DevSecOps practices** such as automated quality gates, environment consistency, and post-deployment health verification. GitHub webhooks exposed via **Ngrok** enable event-driven pipeline execution, while **Docker Compose** is used to deploy and manage frontend and backend services in a reliable and repeatable manner. This project is designed to closely resemble production-grade CI/CD systems used in modern software delivery.

> 📸 **Screenshot Placement (Not required for this section)**
> This section is intentionally kept text-only. Screenshots will be placed in later sections such as **CI/CD Pipeline Flow**, **Deployment Runbook**, and **Security Implementation** where visual proof adds more value.

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

> 📸 **Screenshot Placement (Not required for this section)**
> This section focuses on problem context and objectives. Visual evidence will be provided in later sections such as **CI/CD Pipeline Flow**, **Security Implementation**, and **Deployment Runbook** where execution results are demonstrated.

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

> 📸 **Screenshot Placement**
>
> * Docker multi-stage build proof (Docker build logs)
>   `screenshots/docker-multistage-build.png`

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

> 📸 **Screenshot Placement**
>
> * High-level architecture diagram
>   `screenshots/architecture-diagram.png`

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

> 📸 **Screenshot Placement (Optional)**
> This section is primarily descriptive. Screenshots are optional and typically not required here. Tool usage evidence is demonstrated in later sections such as **CI/CD Pipeline Flow**, **Security Implementation**, and **Deployment Runbook**.

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
├── jenkins/
│   └── Jenkinsfile           # Jenkins Declarative Pipeline
├── .env.dev                  # DEV environment variables
├── .env.staging              # STAGING environment variables
├── .env.prod                 # PROD environment variables
├── screenshots/              # Project screenshots and proofs
└── README.md                 # Project documentation
```

This structure ensures:

* Clear separation between **application code**, **CI/CD logic**, and **deployment configuration**
* Environment-specific configurations without duplication
* Easy navigation for reviewers and interviewers

> 📸 **Screenshot Placement (Not required for this section)**
> Repository structure is self-explanatory and does not require visual proof.

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

> 📸 **Screenshot Placement**
>
> * CI/CD pipeline flow diagram
>   `screenshots/cicd-pipeline-flow.png`

---

### 7.2 Pipeline Trigger Mechanism

The pipeline is triggered automatically whenever a developer pushes code to the GitHub repository. This is achieved using **GitHub Webhooks**, which notify Jenkins of repository events. Since Jenkins is hosted locally, **Ngrok** is used to securely expose the Jenkins webhook endpoint to GitHub.

This setup enables **event-driven automation**, ensuring that every code change is immediately validated by the CI/CD pipeline without requiring manual builds.

> 📸 **Screenshot Placement**
>
> * Ngrok terminal showing public URL
>   `screenshots/ngrok-terminal.png`

---

### 7.3 Pipeline Stages Explanation

Each pipeline execution follows a well-defined sequence of stages:

1. **Source Code Checkout**
   Jenkins pulls the latest code from the GitHub repository to ensure the pipeline runs on the most recent changes.

2. **Docker Image Build (Multi-Stage)**
   Backend and frontend images are built using **Docker multi-stage builds**, reducing image size and improving build efficiency.

   > 📸 **Screenshot Placement**
   >
   > * Docker multi-stage build logs
   >   `screenshots/docker-multistage-build.png`

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

> 📸 **Screenshot Placement**
>
> * Jenkins pipeline success – DEV environment
>   `screenshots/jenkins-dev-success.png`
> * Jenkins pipeline success – STAGING environment
>   `screenshots/jenkins-staging-success.png`
> * Jenkins pipeline success – PROD environment
>   `screenshots/jenkins-prod-success.png`

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

> 📸 **Screenshot Placement**
>
> * Trivy vulnerability scan results in Jenkins console
>   `screenshots/trivy-scan.png`

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

> 📸 **Screenshot Placement (Optional)**
>
> * Jenkins "Build with Parameters" screen showing ENV selection
>   `screenshots/jenkins-env-selection.png`

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

> 📸 **Screenshot Placement**
>
> * Frontend application UI
>   `screenshots/frontend-ui.png`

**Backend Verification:**

* Check backend health endpoint:

  * `http://localhost:5002/health`

Expected response:

```json
{
  "status": "UP"
}
```

> 📸 **Screenshot Placement**
>
> * Backend health endpoint response
>   `screenshots/backend-health.png`

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
docker system prune -af
```

Use cleanup commands cautiously, especially in higher environments.

---

## 11. Troubleshooting Guide

This section outlines **common issues** that may occur during CI/CD pipeline execution or application deployment, along with recommended checks and resolutions. It is intended as a quick reference for operators during failures.

### 11.1 Jenkins Pipeline Not Triggering

**Symptoms:**

* Git push does not start a Jenkins build
* No recent activity visible in Jenkins

**Checks & Resolutions:**

* Verify GitHub webhook configuration and delivery status
* Ensure the webhook URL matches the Ngrok public URL
* Confirm Jenkins job has webhook trigger enabled

> 📸 **Screenshot Placement**
>
> * GitHub webhook delivery success / Ngrok terminal output
>   `screenshots/ngrok-terminal.png`

---

### 11.2 Docker Image Build Failures

**Symptoms:**

* Pipeline fails during Docker build stage
* Errors related to Dockerfile or missing files

**Checks & Resolutions:**

* Ensure Docker is running on the Jenkins agent
* Verify correct Dockerfile paths and naming
* Review Docker build logs for syntax or dependency errors

---

### 11.3 Unit Test Failures in Pipeline

**Symptoms:**

* Tests pass locally but fail in Jenkins
* Import or dependency errors during test execution

**Checks & Resolutions:**

* Ensure all dependencies are included in the Docker image
* Confirm test files are copied correctly into the container
* Re-run tests inside the container for debugging

---

### 11.4 Trivy Security Scan Failures

**Symptoms:**

* Pipeline stops at the Trivy scan stage
* HIGH or CRITICAL vulnerabilities reported

**Checks & Resolutions:**

* Review Trivy scan output in Jenkins logs
* Update base images and dependencies
* Rebuild images and re-run the pipeline

> 📸 **Screenshot Placement**
>
> * Trivy scan failure or results output
>   `screenshots/trivy-scan.png`

---

### 11.5 Deployment Failures (Docker Compose)

**Symptoms:**

* Containers fail to start
* Port conflicts or service not reachable

**Checks & Resolutions:**

* Stop existing containers before deployment
* Verify environment-specific port mappings
* Validate Docker Compose configuration files

---

### 11.6 Health Check Failures

**Symptoms:**

* Pipeline fails during health check stage
* Application containers are running but marked unhealthy

**Checks & Resolutions:**

* Confirm backend `/health` endpoint is accessible
* Validate correct port mapping for the selected environment
* Inspect container logs for runtime errors

---

### 11.7 General Recovery Commands

Use the following commands **only if the environment becomes unstable**:

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
