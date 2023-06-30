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
              withSonarQubeEnv('sonar123') {
                sh 'mvn sonar:sonar'
              }
            }
          }

    }
}
