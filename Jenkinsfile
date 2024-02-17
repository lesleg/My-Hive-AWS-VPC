pipeline {
    agent any

    environment {
        TF_PATH = "/Users/andrewleslie/Library/CloudStorage/OneDrive-Personal/Documents/myawscode/My Hive AWS VPC"
        TF_VAR_FILE = "user.tfvars"
        // Initialize TERRAFORM_ACTION with a default value, can still be overridden.
        TERRAFORM_ACTION = "apply"
    }

    stages {
        stage('Set PATH and Navigate to Directory') {
            steps {
                script {
                    // Set the PATH
                    withEnv(["PATH+TERRAFORM=/usr/local/bin"]) {
                        sh "echo 'Current PATH: $PATH'"
                    }

                    // Navigate to the directory
                    dir(env.TF_PATH) {
                        echo "Navigated to ${env.TF_PATH}"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "terraform init"
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "terraform validate"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "terraform plan -var-file=${env.TF_VAR_FILE}"
                    }
                }
            }
        }

        stage('Select Terraform Action') {
            steps {
                script {
                    env.TERRAFORM_ACTION = input(message: 'Select Terraform action:', parameters: [choice(choices: ['apply', 'destroy'], description: 'Choose terraform action to execute.')])
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            when {
                expression { env.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "terraform apply -var-file=${env.TF_VAR_FILE} -auto-approve"
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { env.TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform destroy -var-file=${env.TF_VAR_FILE} -auto-approve"
                    }
                }
            }
        }
    }
}

