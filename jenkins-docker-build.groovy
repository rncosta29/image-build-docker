#!groovy

def PROJECT_REPOSITORY = "https://yaman-services@dev.azure.com/yaman-services/efficiency-core/_git/yaman-jmeter-docker-image"
def BRANCH = "main"

pipeline {
    agent any

    stages {
        stage("Testando") {
            steps {
                echo 'Hello World'
            }
        }
    }
}