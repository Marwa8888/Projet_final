pipeline {
	agent any
    stages{
        stage('checkout') {
            steps {
                git branch: 'branch_test', credentialsId: '1c240902-a067-40ae-9420-6adba8545569', url: 'https://github.com/Marwa8888/Projet_final.git'
            }
        }
    	stage('testing') {
			parallel {
            	stage('junit') {

                    steps {
                        sh "mvn -s settings.xml  test -Dmaven.test.failure.ignore=true"
                    }
                }
                stage('failfast') {
                    steps {
                        echo "mvn clean test -ff"
                    }
                }
            }
    	}
        stage('deploy') {
            
            steps{
		        sh "mvn clean install -Dmaven.test.skip=true"
            }
        }
        stage('build') {
            steps {
                sh 'docker build -t image:1 .'
            }
        }
        stage('Dockehub') {
		    steps {
                sh "docker login -u di122 -p connan122"
                sh 'docker tag di122/projetfinal:1.0.0-SNAPSHOT di122/projetfinal:1.0.0-SNAPSHOT'
                sh 'docker push di122/projetfinal:1.0.0-SNAPSHOT'
            }
        }
        
        stage('Run gcloud') {
            steps {
                withEnv(['GCLOUD_PATH=/var/lib/jenkins/google-cloud-sdk/bin']){
                    sh '$GCLOUD_PATH/gcloud --version'
                }
            }
        }
        stage('checkoutkub') {
            steps {
                sh 'echo $PATH'
                withEnv(['GCLOUD_PATH=/var/lib/jenkins/google-cloud-sdk/bin']){
                sh '$GCLOUD_PATH/gcloud container clusters get-credentials test --zone europe-west1-b --project projetfinale-242610'
                }
                git branch: 'feature/Kub', credentialsId: '1c240902-a067-40ae-9420-6adba8545569', url: 'https://github.com/Marwa8888/Projet_final.git'
            }
        }
        stage('namespace') {
            steps {
                sh 'kubectl create namespace pfinal || exit 0'
            }
        }
        stage('clientapp') {
            steps {
                sh 'kubectl apply -f ./deployement.yaml'
            }
        }
        stage('serviceapp') {
            steps {
                sh 'kubectl apply -f ./service.yaml '
            }
        }     
    }
}
