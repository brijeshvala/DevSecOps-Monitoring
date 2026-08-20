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
                        sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --severity CRITICAL --exit-code 1 app-php:${BUILD_NUMBER}'
                    }
                }
                stage('Scan Java Image') {
                    steps {
                        sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --severity CRITICAL --exit-code 1 app-java:${BUILD_NUMBER}'
                    }
                }
                stage('Scan Python Image') {
                    steps {
                        sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --severity CRITICAL --exit-code 1 app-python:${BUILD_NUMBER}'
                    }
                }
            }
        }
    }

    post {
        success {
            sh './notify.sh SUCCESS "DevSecOps Pipeline" "All multi-stack images built and verified safe!"'
        }
        failure {
            echo "Pipeline failed due to build errors or security policy violations."
        }
    }
}