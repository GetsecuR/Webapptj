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
    stage ('Source Composition Analysis') {
      steps {
                dependencyCheck additionalArguments: ''' 
                    -o "./" 
                    -s "./"
                    -f "ALL" 
                    --prettyPrint''', odcInstallation: 'OWASP-DC'

                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
            }
    }
    stage ('SAST') {
      steps {
        withSonarQubeEnv('sonar') {
          sh 'mvn sonar:sonar'
          sh 'cat target/sonar/report-task.txt'
        }
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
          sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@13.234.225.9:/home/ubuntu/prod/apache-tomcat-8.5.54/webapps/webapp.war'
        }
      }
   }
    stage ('DAST-ZAP') {
      steps {
        sshagent(['ZAP']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@13.126.125.238 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://http://13.234.225.9:8080/webapp/" || true' 
        }
      }
    }
 }
}
