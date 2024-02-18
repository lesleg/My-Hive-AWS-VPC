pipeline {
    agent any

    environment {
        TF_PATH = "/Users/andrewleslie/Library/CloudStorage/OneDrive-Personal/Documents/myawscode/My Hive AWS VPC"
        TF_VAR_FILE = "user.tfvars"
        // Initialize the TERRAFORM_ACTION variable; it will be updated based on user input later.
        TERRAFORM_ACTION = ""
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
                        sh "/usr/local/bin/terraform init"
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform validate"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(env.TF_PATH) {
                    script {
                        sh "/usr/local/bin/terraform plan -var-file=${env.TF_VAR_FILE}"
                    }
                }
            }
        }

        stage('Select Terraform Action') {
            steps {
                script {
                    // Use the script block to update the environment variable based on user input
                    env.TERRAFORM_ACTION = input(
                        id: 'userInput', // It's a good practice to assign an ID for the input step
                        message: 'Select Terraform action:',
                        parameters: [
                            choice(
                                name: 'CHOICE', // Name of the variable that will hold the user's choice
                                choices: ['apply', 'destroy'],
                                description: 'Choose terraform action to execute.'
                            )
                        ]
                    )
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            when {
                anyOf {
                    expression { env.TERRAFORM_ACTION == 'apply' }
                    expression { env.TERRAFORM_ACTION == 'destroy' }
                }
            }
            steps {
                dir(env.TF_PATH) {
                    script {
                        if (env.TERRAFORM_ACTION == 'apply') {
                            sh "/usr/local/bin/terraform apply -var-file=${env.TF_VAR_FILE} -auto-approve"
                        } else if (env.TERRAFORM_ACTION == 'destroy') {
                            sh "/usr/local/bin/terraform destroy -var-file=${env.TF_VAR_FILE} -auto-approve"
                        }
                    }
                }
            }
        }
    }
}

