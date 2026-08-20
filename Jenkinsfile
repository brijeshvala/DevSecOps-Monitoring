pipeline {
    agent any

    environment {
        APP_NAME = 'multi-lang-app'
        IMAGE_NAME = "myorg/${APP_NAME}:${BUILD_NUMBER}"
        SLACK_WEBHOOK = 'https://hooks.slack.com/services/YOUR/WEBHOOK/HERE'
    }

    stages {
        stage('1. Secret Scanning (Gitleaks)') {
            steps {
                script {
                    // Added double quotes around "$(pwd)"
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

        stage('2. Multi-Stack Dependency Scan (Trivy SCA)') {
            steps {
                script {
                    // Added double quotes around "$(pwd)"
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

        stage('3. Build Container Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('4. Container Image Scan (Trivy Image)') {
            steps {
                script {
                    def status = sh(
                        script: 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --severity CRITICAL --exit-code 1 ${IMAGE_NAME}',
                        returnStatus: true
                    )
                    if (status != 0) {
                        sh './notify.sh FAILURE "Container Image Scan" "Critical vulnerabilities in OS packages!"'
                        error("Container scanning security gate failed!")
                    }
                }
            }
        }
    }

    post {
        success {
            sh './notify.sh SUCCESS "All DevSecOps Gates Passed" "Image ${IMAGE_NAME} verified safe to deploy."'
        }
        failure {
            echo "Pipeline halted due to security policy violations."
        }
    }
}