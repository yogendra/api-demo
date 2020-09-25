pipeline {  
  environment { 
    build_id = "$NODE_NAME-$JOB_NAME-$BUILD_NUMBER-$BUILD_ID"
  }  
  agent any  
  stages {
    
    stage('Checkout'){
      steps {
        checkout scm
      }
    }
    stage('Cleanup') {
      steps{
        script {
          withKubeConfig([credentialsId: 'k8s-cluster-1']){
            sh "curl -L https://storage.googleapis.com/kubernetes-release/release/v1.18.8/bin/linux/amd64/kubectl -o /tmp/kubectl"
            sh "chmod a+x /tmp/kubectl"
            sh "/tmp/kubectl delete -f tmc-cas.yaml"
          }
        }
      } 
    }
  }
}

