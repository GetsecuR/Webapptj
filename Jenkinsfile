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
    stage ('Check-Git-Secrets') {
      steps {
        sh 'rm trufflehogout || true'
        sh 'docker run gesellix/trufflehog --json https://github.com/GetsecuR/Webapptj.git > trufflehogout'
        sh 'pwd'
        sh 'whoami'
        sh 'cat trufflehogout'
      }
    }
    stage ('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
    stage ('Deploy-To-Tomcat') {
      steps {
        sshagent (['tomcat']) {
          sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@13.233.38.36:/prod/apache-tomcat-8.5.54/webapps/webapp.war'
        }
      }
   }
    stage ('DAST-ZAP') {
      steps {
        sshagent(['zap']) {
          sh 'ssh -o StrictHostKeyChecking=no target/*.war ubuntu@13.126.48.114 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://13.233.38.36:8080/webapp/" ' 
        }
      }
    }
 }
}
