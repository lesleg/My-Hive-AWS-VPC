pipeline {
    agent any
    parameters {
        choice(
            name: 'GIT_BRANCH',
            choices: ['main', 'testbranch'],
            description: 'Select the Git branch to use.'
        )
        choice(
            name: 'TERRAFORM_COMMAND',
            choices: ['apply', 'destroy', 'plan'],
            description: 'Choose terraform action to execute.'
        )
    }
    environment {
        TF_PATH = "/Users/andrewleslie/Library/CloudStorage/OneDrive-Personal/Documents/myawscode/My Hive AWS VPC"
        TF_VAR_FILE = "user.tfvars"
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Using the provided Git repository URL for checkout
                    git branch: "${params.GIT_BRANCH}", url: 'git@github.com:lesleg/My-Hive-AWS-VPC.git'
                }
            }
        }
        // Your previous stages remain unchanged

        stage('Terraform Apply/Destroy/Plan') {
            steps {
                script {
                    if (params.TERRAFORM_COMMAND == 'apply') {
                        dir(env.TF_PATH) {
                            sh "/usr/local/bin/terraform apply -var-file=${env.TF_VAR_FILE} -auto-approve"
                        }
                    } else if (params.TERRAFORM_COMMAND == 'destroy') {
                        dir(env.TF_PATH) {
                            sh "/usr/local/bin/terraform destroy -var-file=${env.TF_VAR_FILE} -auto-approve"
                        }
                    } else if (params.TERRAFORM_COMMAND == 'plan') {
                        dir(env.TF_PATH) {
                            sh "/usr/local/bin/terraform plan -var-file=${env.TF_VAR_FILE}"
                        }
                    }
                }
            }
        }
    }
}
