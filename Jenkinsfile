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
                        dir('PHP') {
                            sh 'docker build -t app-php:${BUILD_NUMBER} .'
                        }
                    }
                }
                stage('Build Java') {
                    steps {
                        dir('Java (Maven, Spring Boot)') {
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
                            sh """
                                mkdir -p reports
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v "${WORKSPACE}/reports":/reports aquasec/trivy:latest image \
                                  --timeout 15m --scanners vuln \
                                  --format template --template "@contrib/html.tpl" \
                                  --output /reports/trivy-php-report.html app-php:${BUILD_NUMBER} || true

                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v "${WORKSPACE}/reports":/reports aquasec/trivy:latest image \
                                  --timeout 15m --scanners vuln \
                                  --format json \
                                  --output /reports/trivy-php-report.json app-php:${BUILD_NUMBER} || true
                            """
                        }
                    }
                }
                stage('Scan Java Image') {
                    steps {
                        script {
                            sh """
                                mkdir -p reports
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v "${WORKSPACE}/reports":/reports aquasec/trivy:latest image \
                                  --timeout 15m --scanners vuln \
                                  --format template --template "@contrib/html.tpl" \
                                  --output /reports/trivy-java-report.html app-java:${BUILD_NUMBER} || true

                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v "${WORKSPACE}/reports":/reports aquasec/trivy:latest image \
                                  --timeout 15m --scanners vuln \
                                  --format json \
                                  --output /reports/trivy-java-report.json app-java:${BUILD_NUMBER} || true
                            """
                        }
                    }
                }
                stage('Scan Python Image') {
                    steps {
                        script {
                            sh """
                                mkdir -p reports
                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v "${WORKSPACE}/reports":/reports aquasec/trivy:latest image \
                                  --timeout 15m --scanners vuln \
                                  --format template --template "@contrib/html.tpl" \
                                  --output /reports/trivy-python-report.html app-python:${BUILD_NUMBER} || true

                                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                                  -v "${WORKSPACE}/reports":/reports aquasec/trivy:latest image \
                                  --timeout 15m --scanners vuln \
                                  --format json \
                                  --output /reports/trivy-python-report.json app-python:${BUILD_NUMBER} || true
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*.html, reports/*.json', allowEmptyArchive: true
        }
    }
}