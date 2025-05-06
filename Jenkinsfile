pipeline {
    agent any

    environment {
        REGISTRY = "your-docker-registry"
        IMAGE_NAME = "your-app"
        DEPLOYMENT_NAME = "my-app"
        NAMESPACE = "default"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://your-repo-url.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def version = "${env.BUILD_NUMBER}"
                    env.IMAGE_TAG = "${REGISTRY}/${IMAGE_NAME}:${version}"

                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker push ${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    kubectl set image deployment/${DEPLOYMENT_NAME} ${DEPLOYMENT_NAME}=${IMAGE_TAG} -n ${NAMESPACE}
                    """
                }
            }
        }

        stage('Run Health Check') {
            steps {
                script {
                    def result = sh(script: "./scripts/health_check.sh", returnStatus: true)
                    if (result != 0) {
                        currentBuild.result = 'FAILURE'
                        error("Health check failed. Rolling back.")
                    }
                }
            }
        }
    }

    post {
        failure {
            script {
                echo "Rolling back..."
                sh "kubectl rollout undo deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE}"
            }
        }

        success {
            echo "Deployment successful!"
        }
    }
}
