
pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "localhost:5000" // Minikube registry
        DOCKER_IMAGE = "${DOCKER_REGISTRY}/${env.JOB_NAME}" // Уникальное имя образа для микросервиса
        DOCKER_HOST = "tcp://$(minikube ip):2376" // Docker демон Minikube
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Images') {
            steps {
                script {
                    // Сборка Docker-образа
                    sh "docker build -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ."
                    sh "docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Установка образа в текущий Deployment Minikube
                    sh "kubectl set image deployment/${JOB_NAME} ${JOB_NAME}=${DOCKER_IMAGE}:${env.BUILD_NUMBER} --namespace=microservices"
                }
            }
        }
    }

    post {
        always {
            // Убираем неиспользуемые образы после завершения
            sh 'docker image prune -f'
        }
    }
}


// pipeline {

//     agent any
    
//     environment {
//         DOCKER_IMAGE = "shifer/${env.JOB_NAME}" // имя образа
//         DOCKER_HOST = "tcp://192.168.49.2:2376" // Подключение к Docker-демону Minikube
//         DOCKER_TLS_VERIFY = "1"
//         DOCKER_CERT_PATH = "${env.HOME}/.minikube/certs" // Убедитесь, что сертификаты присутствуют
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 // Склонировать проект из Git-репозитория
//                 checkout scm
//             }
//         }

//         stage('Install Docker') {
//             steps {
//                 sh 'apt-get update && apt-get install -y docker.io'
//             }
//         }


//         stage('Build') {
//             steps {
//                 // Собрать проект с помощью Gradle и создать Docker образ
//                 sh './gradlew clean build' // Собирает проект
//                 sh "docker build -t ${DOCKER_IMAGE} ." // Создает Docker образ с версией
//             }
//         }

//         stage('Push to Docker Hub') {
//             steps {
//                 // Аутентификация и пуш образа в Docker Hub
//                 withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
//                     sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
//                     sh "docker push ${DOCKER_IMAGE}"
//                 }
//             }
//         }

//         stage('Deploy to Minikube') {
//             steps {
//                 // Деплой образа в Minikube
//                 script {
//                     sh "kubectl set image deployment/${JOB_NAME} ${JOB_NAME}=${DOCKER_IMAGE} --namespace=microservices"
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             // Убираем неиспользуемые образы после завершения
//             sh 'docker image prune -f'
//         }
//     }
// }

