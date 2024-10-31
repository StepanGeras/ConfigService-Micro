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
                returnStatus: true
            ) == 0
            
            if (deploymentExists) {
                // Создаем Deployment, если он не существует
                echo "Creating Deployment 'configservice' with image: ${IMAGE_NAME}"
                def createDeploymentStatus = sh(
                    script: """
                        kubectl create deployment configservice --image=${IMAGE_NAME}
                        kubectl expose deployment configservice --type=ClusterIP --port=8888
                    """,
                    returnStatus: true
                )
                
                if (createDeploymentStatus != 0) {
                    error "Failed to create Deployment 'configservice'."
                }
                echo "Deployment 'configservice' created successfully."
            } else {
                // Обновляем образ, если Deployment существует
                echo "Updating Deployment 'configservice' with image: ${IMAGE_NAME}"
                def updateImageStatus = sh(
                    script: "kubectl set image deployment/configservice configservice=${IMAGE_NAME}",
                    returnStatus: true
                )
            
                if (updateImageStatus != 0) {
                    error "Failed to update Deployment 'configservice'."
                }
                echo "Deployment 'configservice' updated successfully."
            }

//             def deploymentExists = sh(
//                 script: "kubectl get deployment configservice --ignore-not-found",
//                 returnStatus: true
//             ) == 0

//             if (!deploymentExists) {
//                 // Создаем Deployment, если он не существует
//                 sh """
//                     kubectl create deployment configservice --image=${IMAGE_NAME} 
//                     kubectl expose deployment configservice --type=ClusterIP --port=8888
//                  """
//             } else {
//             // Обновляем образ, если Deployment существует
//                 sh "kubectl set image deployment/configservice configservice=${IMAGE_NAME}"
//         }    
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
