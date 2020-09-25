pipeline {  
  environment { 
    registry = "yogendra/tmc-cluster-autoscaler"
    build_id = "$NODE_NAME-$JOB_NAME-$BUILD_NUMBER-$BUILD_ID"
  }  
  agent any  
  stages {
    
    stage('Checkout'){
      steps {
        checkout scm
      }
    }
    stage('Building image') {
      steps{
        script {
          imageName = registry + ":$BUILD_NUMBER"
          context = "."
          dockerImage = docker.build(imageName, context)
        }
      }
    }
    stage ("Publish"){
      steps {
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
            dockerImage.push("latest")
          }
        }
      }
    }
  }
}
