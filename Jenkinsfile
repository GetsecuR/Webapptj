Pipeline {
  agent any
  tools {
    maven 'Maven'
  }
  stage {
    stage (Ínitialize') {
      steps {
        sh '''
                echo "PATH = ${PATH}"
                echo "M2_HOME = ${M2_HOME}"
           '''
       }
     }
    stages ('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
   }
 }
