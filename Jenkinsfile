pipeline {
    options {
        disableConcurrentBuilds()
    }
    agent none
    triggers {
        pollSCM 'H/2 * * * *'
    }
    environment {
        OKTA_API_TOKEN                    = credentials('okta-api-token')
        OKTA_BASE_URL                     = credentials('okta-base-url')
        OKTA_ORG_NAME                     = credentials('okta-org-name')
        AWS_ACCESS_KEY_ID                 = credentials('aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY             = credentials('aws-secret-access-key')
        TF_INPUT                          = 0
        TF_IN_AUTOMATION                  = 'Jenkins'
        TF_BACKEND_S3_BUCKET              = credentials('terraform-backend-s3-bucket')
        TF_BACKEND_S3_REGION              = credentials('terraform-backend-s3-region')
        TF_BACKEND_S3_DYNAMODB_TABLE      = credentials('terraform-backend-s3-dynamodb-table')
    }
    stages {
        stage('Plan') {
            agent any
            when {
                branch 'main'
            }
            steps {
                sh './generate.sh' // Generate backend
                sh 'terraform -v'
                sh 'terraform init'
                sh 'terraform plan'
            }
        }
        stage('Promote') {
            agent any // critical, since we don't want to block agents
            when {
                branch 'main'
            }
            steps {
                timeout(time: 60, unit: 'MINUTES') {
                    input(id: 'Promotion Gate', message: 'Promote changes?', ok: 'Promote')
                }
            }
        }
        stage('Apply') {
            agent any
            when {
                branch 'main'
            }
            steps {
                sh './generate.sh'
                sh 'terraform -v'
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Destroy?') {
            agent any // critical, since we don;t want to block agents
            when {
                branch 'main'
            }
            steps {
                timeout(time: 60, unit: 'MINUTES') {
                    input(id: 'Approve Destruction', message: 'Destroy changes?', ok: 'Destroy')
                }
            }
        }
        stage('Destroy') {
            agent any
            when {
                branch 'main'
            }
            steps {
                sh './generate.sh'
                sh 'terraform -v'
                sh 'terraform init'
                sh 'terraform apply -destroy -auto-approve'
            }
        }
    }
}
