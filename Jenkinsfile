pipeline {
    agent any

    environment {
        APP_NAME = 'devsecops-suite'
        SLACK_WEBHOOK = 'https://hooks.slack.com/services/YOUR/WEBHOOK/HERE'
    }

    stages {
        stage('1. Secret Scanning (Gitleaks)') {
            steps {
                script {
                    def status = sh(
                        script: 'docker run --rm -v "$(pwd)":/path zricethezav/gitleaks:latest detect --source="/path" -v',
                        returnStatus: true
                    )
                    if (status != 0) {
                        sh './notify.sh FAILURE "Secret Scanning" "Hardcoded secrets found in codebase!"'
                        error("Gitleaks security check failed!")
                    }
                }
            }
        }

        stage('2. Multi-Stack SCA Scan (Trivy)') {
            steps {
                script {
                    def status = sh(
                        script: 'docker run --rm -v "$(pwd)":/root/src aquasec/trivy:latest fs --severity HIGH,CRITICAL --exit-code 1 /root/src',
                        returnStatus: true
                    )
                    if (status != 0) {
                        sh './notify.sh FAILURE "SCA Dependency Scan" "Vulnerable dependencies found in stack!"'
                        error("Trivy dependency check failed!")
                    }
                }
            }
        }

        stage('3. Build Containers Parallel') {
            parallel {
                stage('Build PHP') {
                    steps {
                        dir('PHP') {
                            sh 'docker build -t app-php:${BUILD_NUMBER} .'
                        }
                    }
                }
                
                stage('Build Java') {
                    steps {
                             dir('Java (Maven, Spring Boot)/app') {
                                sh 'docker build -t app-java:${BUILD_NUMBER} .'
                                 }
                             }
                    }
                stage('Build Python') {
                    steps {
                        dir('Python (Flask, FastAPI)') {
                            sh 'docker build -t app-python:${BUILD_NUMBER} .'
                        }
                    }
                }
            }
        }
        
        stage('4. Scan Built Images (Trivy)') {
            parallel {
                stage('Scan PHP Image') {
                    steps {
                        script {
                            sh '''
                                mkdir -p reports
                                # Generate HTML report
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v $(pwd)/reports:/reports aquasec/trivy:latest image \
                                  --format template --template "@contrib/html.tpl" \
                                  --output /reports/trivy-php-report.html app-php:${BUILD_NUMBER} || true

                                # Generate JSON report
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v $(pwd)/reports:/reports aquasec/trivy:latest image \
                                  --format json \
                                  --output /reports/trivy-php-report.json app-php:${BUILD_NUMBER} || true
                            '''
                        }
                    }
                }
                stage('Scan Java Image') {
                    steps {
                        script {
                            sh '''
                                mkdir -p reports
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v $(pwd)/reports:/reports aquasec/trivy:latest image \
                                  --format template --template "@contrib/html.tpl" \
                                  --output /reports/trivy-java-report.html app-java:${BUILD_NUMBER} || true

                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v $(pwd)/reports:/reports aquasec/trivy:latest image \
                                  --format json \
                                  --output /reports/trivy-java-report.json app-java:${BUILD_NUMBER} || true
                            '''
                        }
                    }
                }
                stage('Scan Python Image') {
                    steps {
                        script {
                            sh '''
                                mkdir -p reports
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v $(pwd)/reports:/reports aquasec/trivy:latest image \
                                  --format template --template "@contrib/html.tpl" \
                                  --output /reports/trivy-python-report.html app-python:${BUILD_NUMBER} || true

                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v $(pwd)/reports:/reports aquasec/trivy:latest image \
                                  --format json \
                                  --output /reports/trivy-python-report.json app-python:${BUILD_NUMBER} || true
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            // Store HTML and JSON reports on the Jenkins server build page
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true

            // Publish as formatted HTML tab if the HTML Publisher plugin is installed
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'trivy-php-report.html, trivy-java-report.html, trivy-python-report.html',
                reportName: 'Trivy Vulnerability Security Reports'
            ])
        }
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    }
    post {
        always {
            // Store HTML and JSON reports on the Jenkins server build page
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true

            // Publish as formatted HTML tab if the HTML Publisher plugin is installed
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'trivy-php-report.html, trivy-java-report.html, trivy-python-report.html',
                reportName: 'Trivy Vulnerability Security Reports'
            ])
        }
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    }
    post {
        always {
            // Store HTML and JSON reports on the Jenkins server build page
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true

            // Publish as formatted HTML tab if the HTML Publisher plugin is installed
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'trivy-php-report.html, trivy-java-report.html, trivy-python-report.html',
                reportName: 'Trivy Vulnerability Security Reports'
            ])
        }
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    }notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
    post {
        always {
            // Store HTML and JSON reports on the Jenkins server build page
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true

            // Publish as formatted HTML tab if the HTML Publisher plugin is installed
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'trivy-php-report.html, trivy-java-report.html, trivy-python-report.html',
                reportName: 'Trivy Vulnerability Security Reports'
            ])
        }
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    }
    post {
        always {
            // Store HTML and JSON reports on the Jenkins server build page
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true

            // Publish as formatted HTML tab if the HTML Publisher plugin is installed
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'trivy-php-report.html, trivy-java-report.html, trivy-python-report.html',
                reportName: 'Trivy Vulnerability Security Reports'
            ])
        }
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    } failed due to build errors or security policy violations."
    post {
        always {
            // Store HTML and JSON reports on the Jenkins server build page
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true

            // Publish as formatted HTML tab if the HTML Publisher plugin is installed
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'reports',
                reportFiles: 'trivy-php-report.html, trivy-java-report.html, trivy-python-report.html',
                reportName: 'Trivy Vulnerability Security Reports'
            ])
        }
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    }