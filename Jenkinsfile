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
		        sh "mvn clean package -Dmaven.test.skip=true"
            }
        }
        stage('build') {
            steps {
                sh 'docker build -t image:1 .'
            }
        }
    }
}
