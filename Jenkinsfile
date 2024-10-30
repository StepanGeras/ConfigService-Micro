pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "shifer/${env.JOB_NAME}" // имя образа
    }

    docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }

    stages {
        stage('Checkout') {
            steps {
                // Склонировать проект из Git-репозитория
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Собрать проект с помощью Gradle и создать Docker образ
                sh './gradlew clean build' // Собирает проект
                sh "docker build -t ${DOCKER_IMAGE} ." // Создает Docker образ с версией
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Аутентификация и пуш образа в Docker Hub
                withCredentials([usernamePassword(credentialsId: dockerhub-credentials, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                // Деплой образа в Minikube
                script {
                    sh "kubectl set image deployment/${JOB_NAME} ${JOB_NAME}=${DOCKER_IMAGE} --namespace=microservices"
                }
            }
        }
    }
}

