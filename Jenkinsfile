def branch
def revision
def registryIp

pipeline {

    agent {
        kubernetes {
            label 'build-service-pod'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    job: build-service
spec:
  containers:
  - name: gradle
    image: gradle:7.6.0-jdk-11
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: repository
      mountPath: /root/.gradle/caches
  - name: docker
    image: docker:18.09.2
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: repository
    persistentVolumeClaim:
      claimName: repository
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }
    options {
        skipDefaultCheckout true
    }

    stages {
        stage ('checkout') {
            steps {
                script {
                    def repo = checkout scm
                    revision = sh(script: 'git log -1 --format=\'%h.%ad\' --date=format:%Y%m%d-%H%M | cat', returnStdout: true).trim()
                    branch = repo.GIT_BRANCH.take(20).replaceAll('/', '_')
                    if (branch != 'master') {
                        revision += "-${branch}"
                    }
                    sh "echo 'Building revision: ${revision}'"
                }
            }
        }
        stage ('compile') {
            steps {
                container('gradle') {
                    sh 'gradle clean build'
                }
            }
        }
        stage ('unit test') {
            steps {
                container('gradle') {
                    sh 'gradle test'
                }
            }
        }
        stage ('integration test') {
            steps {
                container ('gradle') {
                    sh 'gradle check'
                }
            }
        }
        stage ('build artifact') {
            steps {
                container('gradle') {
                    sh "gradle assemble -Drevision=${revision}"
                }
                container('docker') {
                    script {
                        registryIp = sh(script: 'getent hosts registry.kube-system | awk \'{ print $1 ; exit }\'', returnStdout: true).trim()
                        sh "docker build . -t ${registryIp}/demo/app:${revision} --build-arg REVISION=${revision}"
                    }
                }
            }
        }
        stage ('publish artifact') {
            when {
                expression {
                    branch == 'master'
                }
            }
            steps {
                container('docker') {
                    sh "docker push ${registryIp}/demo/app:${revision}"
                }
            }
        }
        stage ('deploy to minikube') {
            steps {
                script {
                    // Убедитесь, что у вас установлен kubectl
                    sh "kubectl apply -f k8s/deployment.yaml" // Путь к вашему yaml-файлу деплоя
                    sh "kubectl apply -f k8s/service.yaml" // Путь к вашему yaml-файлу сервиса
                }
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

