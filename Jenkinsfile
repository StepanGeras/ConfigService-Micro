pipeline {
    agent any
    environment {
        IMAGE_NAME = "shifer/configservice:latest"
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
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }
        stage('Deploy to Minikube') {
    steps {
        script {
            def deploymentExists = sh(
                script: "kubectl get deployment configservice --ignore-not-found",
                returnStatus: false
            ) == 0

            if (deploymentExists) {
                // Обновляем образ, если Deployment существует
                sh "kubectl set image deployment/configservice configservice=${IMAGE_NAME}"
            } else {
                // Создаём Deployment, если его нет
                sh """
                    kubectl create deployment configservice --image=${IMAGE_NAME} 
                    kubectl expose deployment configservice --type=ClusterIP --port=8080
                """
            }
        }
    }
}
        // stage('Deploy to Minikube') {
        //     steps {
        //         sh "kubectl set image deployment/configservice configservice=${IMAGE_NAME}"
        //     }
        // }
    }
}
