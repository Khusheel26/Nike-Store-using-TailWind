pipeline {
    agent any
    tools {
        terraform 'TERRAFORM_HOME'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'KAN-104-Workspace-Dev-FE-Branch', credentialsId: '362a03ec-f92e-43ef-b87d-158fecbdbb29', url: 'https://github.com/Octobit8-scm/roadrolls-fe.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
                    sh 'terraform apply --auto-approve'
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
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
    }
}
