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

        stage("Subindo container") {
            steps {
                echo 'Build container'
                sh 'docker build --file jmeter-server-image.dockerfile -t yaman-sre-jmeter-node-container:latest --no-cache=true --build-arg build_job_name=${JOB_NAME} --build-arg build_job_number=${JOB_NUMBER} --build-arg build_date=202401 .'
            }
        }
    }
}