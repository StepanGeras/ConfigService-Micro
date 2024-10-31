pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = 'microservice-configservice:latest'
        IMAGE_NAME = "${DOCKER_HUB_REPO}:${VERSION}"
        MINIKUBE_REGISTRY = 'localhost:51192'
    }
    stages {
        stage('Gradle Build') {
            steps {
                sh './gradlew clean build'
                sh 'ls -la build/libs'
            }
        }
        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                    sh "docker tag ${IMAGE_NAME} ${MINIKUBE_REGISTRY}/${IMAGE_NAME}"
                    sh "docker push ${MINIKUBE_REGISTRY}/${IMAGE_NAME}"
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                sh "kubectl set image deployment/configservice configservice=${MINIKUBE_REGISTRY}/${IMAGE_NAME}"
            }
        }
    }
}
