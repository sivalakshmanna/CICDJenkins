pipeline {
    agent any
    parameters {
        choice(
            name: 'BRANCH_NAME',
            choices: ['main', 'develop', 'dotnetwebapp'],  // Add your branch names here
            description: 'Select the branch to build'
        )
    }
    environment {
        DOCKER_IMAGE = "sivalakshmanna/docker"
        DOCKER_TAG = "latest"
        REGISTRY_CREDENTIALS = "dockerhub"  // Jenkins credential ID
        CONTAINER_NAME = "my-app-container"
       // APP_PORT = "8080"
    }

    stages {
        stage('Checkout Code') {
            steps {
                 echo "Checking out branch: ${params.BRANCH_NAME}"
                 git branch: "${params.BRANCH_NAME}", url: 'https://github.com/sivalakshmanna/CICDJenkins.git'
                 sh 'ls -la' //Replace with your repo URL
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: REGISTRY_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    """

                    // Run the new container
                    sh "docker run -d --name ${CONTAINER_NAME} -p 8081:5000 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker ps -a"
            }
        }
    }
}
