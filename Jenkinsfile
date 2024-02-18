pipeline {
    agent any

    environment {
        TF_PATH = "/Users/andrewleslie/Library/CloudStorage/OneDrive-Personal/Documents/myawscode/My Hive AWS VPC"
        TF_VAR_FILE = "user.tfvars"
    }

    stages {
        // Previous stages remain unchanged

        stage('Select Terraform Action') {
            steps {
                script {
                    // Define a Groovy variable to hold the user's choice. No need to use 'env.' prefix
                    TERRAFORM_ACTION = input(
                        id: 'userInput',
                        message: 'Select Terraform action:',
                        parameters: [
                            choice(
                                name: 'CHOICE',
                                choices: ['apply', 'destroy'],
                                description: 'Choose terraform action to execute.'
                            )
                        ]
                    )
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    // Now, TERRAFORM_ACTION is a script-level Groovy variable
                    if (TERRAFORM_ACTION == 'apply') {
                        dir(env.TF_PATH) {
                            sh "/usr/local/bin/terraform apply -var-file=${env.TF_VAR_FILE} -auto-approve"
                        }
                    } else if (TERRAFORM_ACTION == 'destroy') {
                        dir(env.TF_PATH) {
                            sh "/usr/local/bin/terraform destroy -var-file=${env.TF_VAR_FILE} -auto-approve"
                        }
                    }
                }
            }
        }
    }
}
