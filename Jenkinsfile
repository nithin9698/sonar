pipeline {
    agent any


    stages {
        stage('Build') {
            steps {
                echo 'Build'
                sh 'mvn package'
            }
        }
        
         stage("SonarQube analysis") {
            agent any
            steps {
              withSonarQubeEnv('sonar') {
                sh 'mvn sonar:sonar'
              }
            }
          }
    }
 }

    

