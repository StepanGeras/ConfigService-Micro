pipeline {
    agent { 
        label 'master' 
    }
    stages {
        stage('Checkout') {
            steps {
                // Клонирует изменения из Git
                // git branch: 'main', url: 'https://github.com/StepanGeras/ConfigService-Micro.git'
                checkout scm
            }
        }
        stage('Login to Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                        echo "${DOCKER_PASSWORD}" | docker login 192.168.49.2:58886 -u "${DOCKER_USERNAME}" --password-stdin
                        '''
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Собирает Docker-образ
                    sh './gradlew clean build' // Собирает проект
                    def imageName = "192.168.49.2:58886/shifer/microservice-configservice"
                    sh "docker build -t ${imageName} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Пушит собранный образ в Minikube registry
                    sh "docker push $REGISTRY/$IMAGE_NAME:${env.BUILD_NUMBER}"
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                script {
                    // Применяет обновления в кластере Minikube
                    sh """
                    kubectl set image deployment/your-deployment-name your-container=$REGISTRY/$IMAGE_NAME:${env.BUILD_NUMBER} -n your-namespace
                    """
                }
            }
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

