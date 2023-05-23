pipeline {
    agent any
    
    stages { 
        stage('Build') {
            steps {
                sh 'flutter clean'
                sh 'flutter pub get'
                sh 'flutter build apk'
            }
        }
        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t prithvirajpowar/krushee:1.0 .'
            }
        }
        
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                }
                sh 'docker push prithvirajpowar/krushee:1.0'
            }
        }
    }
}
