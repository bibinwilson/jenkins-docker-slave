pipeline {
    agent none
    options{
        skipStagesAfterUnstable()
        skipDefaultCheckout()
    }
    stages {
        stage("Prepare container") {
            agent {
                docker {
                    image 'maven:3.8.1-openjdk-11-slim'
                }
            }
        }
        stages {
            stage('Build') {
                steps {
                    echo 'Hello world'
                }
            }
        }
    }
}