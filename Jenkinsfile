pipeline {
    agent any
    
    stages { 
        stage('Build') {
            steps {
                sh 'flutter packages get'
                sh 'flutter build apk --debug'
            }
        }
        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-debug.apk'
            }
        }
    }
}
