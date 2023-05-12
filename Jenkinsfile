pipeline {
    agent any
    
    stages { 
        stage('Build') {
            steps {
                sh 'flutter clean'
                sh 'flutter packages get'
                sh 'flutter build apk --release'
            }
        }
        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk'
            }
        }
    }
}
