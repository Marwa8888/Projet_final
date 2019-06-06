pipeline {
	agent any
    stages{
        stage('checkout') {
            steps {
                git branch: 'feauture/kub', credentialsId: '1c240902-a067-40ae-9420-6adba8545569', url: 'https://github.com/Marwa8888/Projet_final.git'
            }
        }

//plugin kubectl
    node {
      stage('List pods') {
        withKubeConfig([credentialsId: '<credential-id>',
                        caCertificate: 'ca.crt',
                        serverUrl: '35.205.196.237',
                        contextName: 'test',
                        clusterName: 'test',
                        namespace: 'default'
                        ]) {
          sh 'kubectl get pods'
        }
      }
    }
// Example when used in a pipeline
node {
  stage('Apply Kubernetes files') {
    withKubeConfig([credentialsId: 'user1', serverUrl: 'https://api.k8s.my-company.com']) {
      sh 'kubectl apply -f deployement.yaml'
    }
  }
}
