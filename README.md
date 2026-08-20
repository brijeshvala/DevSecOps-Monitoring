🛡️ DevSecOps & Security Automation Pipeline

An enterprise-ready DevSecOps CI/CD pipeline built with Jenkins and Trivy. This project demonstrates end-to-end container security automation across a multi-technology microservices architecture (PHP, Java Spring Boot, and Python Flask/FastAPI), running parallel builds, vulnerability scanning, and artifact archiving.

🏗️ Architecture Overview
                          ┌───────────────────────────┐
                          │   Git Trigger / Push      │
                          └─────────────┬─────────────┘
                                        │
                                        ▼
┌───────────────────────────────────────────────────────────────────────────────┐
│                          JENKINS DECLARATIVE PIPELINE                         │
├───────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  [ Stage 1: Build Containers (Parallel) ]                                     │
│  ├── Docker Build app-php:${BUILD_NUMBER}                                     │
│  ├── Docker Build app-java:${BUILD_NUMBER}                                    │
│  └── Docker Build app-python:${BUILD_NUMBER}                                  │
│                                                                               │
│  [ Stage 2: Security Scanning & Analysis (Trivy Parallel) ]                    │
│  ├── Scan app-php   ──> Output HTML & JSON Reports                            │
│  ├── Scan app-java  ──> Output HTML & JSON Reports                            │
│  └── Scan app-python ──> Output HTML & JSON Reports                            │
│                                                                               │
│  [ Post Actions: Artifact Archiving ]                                         │
│  └── Publish HTML/JSON vulnerability reports to Jenkins UI                    │
│                                                                               │
└───────────────────────────────────────────────────────────────────────────────┘
✨ Key Features
Multi-Stack Application Coverage: Native Docker builds for PHP, Java (Maven/Spring Boot), and Python (Flask/FastAPI) applications running concurrently.

Automated Container Security Scanning: Integrated Aqua Security Trivy vulnerability scanning for OS packages and application dependencies.

Dual-Format Security Reports: Generates standalone interactive .html reports alongside structured .json data for automated security audits.

Persistent Vulnerability Cache: Employs persistent Docker cache volumes (trivy-cache) to accelerate build execution times and minimize database downloads.

Artifact Archiving: Direct integration with Jenkins' archiveArtifacts for UI file inspection and auditing.

🛠️ Tech Stack & Tools
CI/CD Orchestration: Jenkins (Declarative Pipeline)

Containerization: Docker, Docker-in-Docker (dind)

Security Scanner: Aqua Security Trivy

Supported Stacks: PHP, Java (Spring Boot), Python (Flask/FastAPI)

🚀 Getting Started
Prerequisites
Ensure the host environment has the following installed and running:

Docker Engine (v20.10 or higher)

Jenkins Server with standard Pipeline plugins

Access to /var/run/docker.sock within the Jenkins execution node

Local Repository Setup
Bash
# Clone the repository
git clone https://github.com/brijeshvala/DevSecOps-Monitoring.git
cd DevSecOps-Monitoring

# Ensure reports output directory permissions
mkdir -p reports
chmod -R 777 reports
📄 Jenkins Pipeline Configuration
The pipeline utilizes standard Jenkins Declarative syntax (Jenkinsfile):

Groovy
pipeline {
    agent any

    environment {
        APP_NAME = 'devsecops-suite'
    }

    stages {
        stage('3. Build Containers Parallel') {
            parallel {
                stage('Build PHP') {
                    steps {
                        dir('PHP') { sh 'docker build -t app-php:${BUILD_NUMBER} .' }
                    }
                }
                stage('Build Java') {
                    steps {
                        dir('Java (Maven, Spring Boot)') { sh 'docker build -t app-java:${BUILD_NUMBER} .' }
                    }
                }
                stage('Build Python') {
                    steps {
                        dir('Python (Flask, FastAPI)') { sh 'docker build -t app-python:${BUILD_NUMBER} .' }
                    }
                }
            }
        }

        stage('4. Scan Built Images (Trivy)') {
            parallel {
                stage('Scan PHP Image') {
                    steps {
                        sh """
                            mkdir -p reports
                            docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format template --template "@contrib/html.tpl" \
                              app-php:${BUILD_NUMBER} > reports/trivy-php-report.html || true
                        """
                    }
                }
                // (Java & Python stages configured similarly)
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true
        }
    }
}
📊 Security Artifacts
Upon build execution, scan results are preserved under the Build Artifacts section in Jenkins:

reports/
├── trivy-java-report.html
├── trivy-java-report.json
├── trivy-php-report.html
├── trivy-php-report.json
├── trivy-python-report.html
└── trivy-python-report.json
🤝 Contributing
Fork the Project repository

Create your Feature Branch (git checkout -b feature/SecurityEnhancement)

Commit your changes (git commit -m 'Add automated quality gate thresholds')

Push to the Branch (git push origin feature/SecurityEnhancement)

Open a Pull Request

📝 License
Distributed under the MIT License. See LICENSE for details.
