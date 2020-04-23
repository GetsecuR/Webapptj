pipeline {
  agent any
  tools {
    maven 'Maven'
  }
  stages {
    stage ('Ínitialize') {
      steps {
        sh '''
                echo "PATH = ${PATH}"
                echo "M2_HOME = ${M2_HOME}"
           '''
       }
     }
    stage ('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
    Stage ('Deploy-To-Tomcat') {
      steps {
        sshagent (['tomcat']) {
          sh 'scp -o StringHostKeyChecking=no target/*.war ubuntu@13.233.54.209:/home/ubuntu/prod/apache-tomcat-8.5.54/webapps/webapp.war'
        }
      }
   }
 }
