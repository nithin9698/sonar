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
          stage("quality gate"){
            steps{
              timeout(time: 1,unit: 'HOURS'){
                waitForQualityGate abortPipeline: true
              }
            }
          }
    }
 }

    

