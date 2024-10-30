pipeline {
    agent {
        docker {
            image 'gradle:7.6.0-jdk-11'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'gradle clean build'
            }
        }
        stage('Test') {
            steps {
                sh 'gradle test'
            }
        }
        stage('Deploy') {
            steps {
                // Команды для деплоя в Minikube, например:
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}




// pipeline {
//     agent any
    
//     environment {
//         DOCKER_IMAGE = "localhost:61701/${env.JOB_NAME}:${env.BUILD_ID}" // имя образа
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }

//         stage('Build') {
//             steps {
//                 sh './gradlew clean build'
//                 sh "docker build -t ${DOCKER_IMAGE} ."
//             }
//         }

//         stage('Push to Minikube Registry') {
//             steps {
//                 sh "docker push ${DOCKER_IMAGE}"
//             }
//         }

//         stage('Deploy to Minikube') {
//             steps {
//                 script {
//                     sh "kubectl set image deployment/${JOB_NAME} ${JOB_NAME}=${DOCKER_IMAGE} --namespace=microservices"
//                 }
//             }
//         }
//     }
// }


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

