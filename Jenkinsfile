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
                        sh """
                            mkdir -p reports
                            docker run --rm \
                              -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format template --template "@contrib/html.tpl" \
                              app-php:${BUILD_NUMBER} > reports/trivy-php-report.html || true

                            docker run --rm \
                              -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format json \
                              app-php:${BUILD_NUMBER} > reports/trivy-php-report.json || true
                        """
                    }
                }
                stage('Scan Java Image') {
                    steps {
                        sh """
                            mkdir -p reports
                            docker run --rm \
                              -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format template --template "@contrib/html.tpl" \
                              app-java:${BUILD_NUMBER} > reports/trivy-java-report.html || true

                            docker run --rm \
                              -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format json \
                              app-java:${BUILD_NUMBER} > reports/trivy-java-report.json || true
                        """
                    }
                }
                stage('Scan Python Image') {
                    steps {
                        sh """
                            mkdir -p reports
                            docker run --rm \
                              -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format template --template "@contrib/html.tpl" \
                              app-python:${BUILD_NUMBER} > reports/trivy-python-report.html || true

                            docker run --rm \
                              -v /var/run/docker.sock:/var/run/docker.sock \
                              -v trivy-cache:/root/.cache/ \
                              aquasec/trivy:latest image \
                              --timeout 15m --scanners vuln \
                              --format json \
                              app-python:${BUILD_NUMBER} > reports/trivy-python-report.json || true
                        """
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