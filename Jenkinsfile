pipeline {
    agent any
    tools {
        terraform 'TERRAFORM_HOME'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'prod-fe', changelog: false, credentialsId: '70ef5427-1490-4d73-b7ad-fd77bb21a57c', poll: false, url: 'https://github.com/Khusheel26/Nike-Store-using-TailWind.git'
            }
        }
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
                    bat 'terraform apply --auto-approve'
                }
            }
        }
        stage('Approve Destroy') {
            steps {
                script {
                    timeout(time: 1, unit: 'MINUTES') {
                        input message: 'Do you want to proceed with Terraform destroy?'
                    }
                }
            }
        }
        stage('Destroy Infrastructure') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
                    bat 'terraform destroy --auto-approve'
                }
            }
        }
    }
}
