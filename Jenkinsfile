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
    }
}
