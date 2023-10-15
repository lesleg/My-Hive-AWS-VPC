pipeline {
    agent any

    environment {
        TF_PATH = "/Users/andrewleslie/Library/CloudStorage/OneDrive-Personal/Documents/myawscode/My Hive AWS VPC"
        TF_VAR_FILE = "user.tfvars"
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
                        sh "/usr/local/bin/terraform init"
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform validate"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform plan -var-file=${TF_VAR_FILE}"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir(TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform apply -var-file=${TF_VAR_FILE} -auto-approve"
                    }
                }
            }
        }
    }
}
