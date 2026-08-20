⚡ DevSecOps Pipeline & Security Command Center

An automated, multi-stack DevSecOps pipeline that turns code into scanned, production-ready container images. Built with Jenkins and Aqua Security Trivy, this workflow executes concurrent multi-language container builds (PHP, Java Spring Boot, Python Flask/FastAPI), performs deep vulnerability scanning, caches vulnerability databases dynamically, and archives security reports.

## 🛠️ Tech Stack & Tools

* **CI/CD Automation:** ![Jenkins](https://img.shields.io/badge/-Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white) ![Git](https://img.shields.io/badge/-Git-F05032?style=flat-square&logo=git&logoColor=white) ![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)
* **Application Stacks:** ![PHP](https://img.shields.io/badge/-PHP-777BB4?style=flat-square&logo=php&logoColor=white) ![Java](https://img.shields.io/badge/-Java-ED8B00?style=flat-square&logo=openjdk&logoColor=white) ![Python](https://img.shields.io/badge/-Python-3776AB?style=flat-square&logo=python&logoColor=white)
* **Containerization:** ![Docker](https://img.shields.io/badge/-Docker-2496ED?style=flat-square&logo=docker&logoColor=white) ![Linux](https://img.shields.io/badge/-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)
* **Security Scanning:** ![Trivy](https://img.shields.io/badge/-Trivy-00B4B6?style=flat-square&logo=aquasecurity&logoColor=white)
* **Target Cloud:** ![AWS EC2](https://img.shields.io/badge/-AWS_EC2-FF9900?style=flat-square&logo=amazon-ec2&logoColor=white) ![AWS S3](https://img.shields.io/badge/-AWS_S3-569A31?style=flat-square&logo=amazon-s3&logoColor=white) ![AWS RDS](https://img.shields.io/badge/-AWS_RDS-527FFF?style=flat-square&logo=amazon-rds&logoColor=white)
  
🔥 Key Highlights

🚀 Concurrent Multi-Language Builds: Leverages Jenkins parallel execution to build container images across PHP, Java, and Python microservices simultaneously.

🛡️ Automated Vulnerability Shield: Integrates Aqua Security Trivy to scan both OS packages and application dependencies before images hit deployment environments.

⚡ Smart Cache Acceleration: Uses a persistent Docker volume (trivy-cache) to store vulnerability signatures across pipeline runs, cutting build times significantly.

📊 Dual-Format Audit Reports: Produces visual, interactive .html dashboards for developers and structured .json reports for automated compliance checking.

🔒 Zero-Config File Isolation: Writes scan reports directly through workspace streams, bypassing host permission blocks and Docker-in-Docker path mismatches.

📂 Archived Security Reports
Whenever a build completes, security audit files are automatically exported and available on your Jenkins build summary dashboard:

## 🧭 Pipeline Execution Flow

1. **🚀 Trigger:** Developer pushes code to GitHub.
2. **🏗️ Stage 1 — Parallel Builds:** 
   * 🐘 Build PHP Image (`app-php:tag`)
   * ☕ Build Java Image (`app-java:tag`)
   * 🐍 Build Python Image (`app-python:tag`)
3. **🛡️ Stage 2 — Security Scans (Trivy):** 
   * Scan all 3 images in parallel for vulnerabilities.
4. **📦 Post Step — Archive Artifacts:** 
   * Save HTML & JSON reports directly to the Jenkins UI.


## 📂 Security Scan Artifacts

* ☕ **Java Reports:** `trivy-java-report.html` | `trivy-java-report.json`
* 🐘 **PHP Reports:** `trivy-php-report.html` | `trivy-php-report.json`
* 🐍 **Python Reports:** `trivy-python-report.html` | `trivy-python-report.json`
