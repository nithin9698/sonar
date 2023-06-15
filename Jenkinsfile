pipeline {
    agent any

     options {
        //Disable concurrentbuilds for the same job
        disableConcurrentBuilds()         
        // Add timestamps to console log
        timestamps()

        skipDefaultCheckout true      
    }

    environment {
        ARTIFACTID = readMavenPom().getArtifactId()
        VERSION = readMavenPom().getVersion()
        S3_BUCKET = 'raghu-jenkinsartifacts'
        LAMBDA_FUNCTION = 'java-sample-lambq2'

    }

    stages {
         stage ('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: "refs/remotes/origin/main"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'raghu-github', url: 'https://github.com/Raghupatik/java-test.git']]])
            }
          }
        
        stage('Build') {
            steps {
                script {
                    echo 'Build'
                    // timeout(time: 5) {
                      //  sh 'mvn package -Dmaven.test.skip=true'
                    // }
                }
            }
        }

        stage('Test') {
            steps {
                    echo 'Test'
                   // sh 'mvn test'
                }
        }

        stage('Push to artifactory') {
            steps {
                script {
                    echo 'Push to artifactory'         
                    JARNAME = ARTIFACTID+'-'+VERSION+'.jar'
                    echo "JARNAME: ${JARNAME}"
                    sh "aws s3 cp target/${JARNAME} s3://$S3_BUCKET"
                }
            }
        }

        stage('Deploy to Lambda - Test') {
            agent any
            steps {
                script {
                    echo 'Deploy to Test'

                    sh "aws lambda update-function-code --function-name $LAMBDA_FUNCTION --region us-east-1 --s3-bucket $S3_BUCKET --s3-key ${JARNAME}"
                }          
            }
        }

        stage('Release to Prod') {
            agent none
            steps {
                echo 'Release to Prod'
                script {
                    if (env.BRANCH_NAME == "main") {
                        timeout(time: 10) {
                            input('Proceed for Prod  ?')
                        }
                    }
                }

            }
        }

         stage('Deploy to Prod') {
            steps {
                script {
                    if (env.BRANCH_NAME == "main") {
                        echo 'Deploy to Prod'
                        
                       // sh "aws lambda update-function-code --function-name $LAMBDA_FUNCTION --s3-bucket $S3_BUCKET --s3-key ${JARNAME}" 
                    }
                }
            }
        }

    }

    post {
      failure {
        echo 'failed'
        echo "${env.BUILD_NUMBER}"
          
         // can send notifications
      }
      success {
        echo 'Success'
      }
      aborted {
        echo 'aborted'
      }
    }
}
