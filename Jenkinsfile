pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = 'microservice-configservice'
        IMAGE_NAME = "${DOCKER_HUB_REPO}:${VERSION}"
        MINIKUBE_REGISTRY = 'localhost:51528'
    }
    stages {
        stage('Gradle Build') {
            steps {
                sh './gradlew clean build'
                sh 'ls -la build/libs'
            }
        }
        stage('Clean Old Docker Images') {
            steps {
                script {
                    // Получение списка старых образов, соответствующих вашему репозиторию
                    def oldImages = sh(script: "docker images -q ${DOCKER_HUB_REPO}*", returnStdout: true).trim()
                    if (oldImages) {
                        // Удаление старых образов
                        sh "docker rmi ${oldImages} || true" // || true для игнорирования ошибок, если образа не существует
                    }
                }
            }
        }
        stage('Check Docker') {
            steps {
                sh 'docker --version'
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
