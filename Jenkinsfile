pipeline {
    agent any

    environment {
        TF_PATH = "/Users/andrewleslie/Library/CloudStorage/OneDrive-Personal/Documents/myawscode/My Hive AWS VPC"
        TF_VAR_FILE = "user.tfvars"
        TERRAFORM_ACTION = "apply" // Default action, can be overwritten by the input step.
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
                    dir(TF_PATH) {
                        echo "Navigated to ${TF_PATH}"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir(TF_PATH) {
                    script {
                        sh "terraform init"
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(TF_PATH) {
                    script {
                        sh "terraform validate"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TF_PATH) {
                    script {
                        sh "terraform plan -var-file=${TF_VAR_FILE}"
                    }
                }
            }
        }

        stage('Select Terraform Action') {
            steps {
                script {
                    TERRAFORM_ACTION = input(message: 'Select Terraform action:', parameters: [choice(choices: 'apply\ndestroy', description: 'Choose terraform action to execute.')])
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            when {
                expression { TERRAFORM_ACTION == 'apply' }
            }
            steps {
                dir(TF_PATH) {
                    script {
                        sh "terraform apply -var-file=${TF_VAR_FILE} -auto-approve"
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { TERRAFORM_ACTION == 'destroy' }
            }
            steps {
                dir(TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform destroy -var-file=${TF_VAR_FILE} -auto-approve"
                    }
                }
            }
        }
    }
}
