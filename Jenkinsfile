pipeline {
	environment {
		registry = "arunramkrish/docker-demo"
		registryCredential = 'dockerhub'
	} 
  
    agent any

    triggers {
        pollSCM('*/5 * * * 1-5')
    }

    options {
        skipDefaultCheckout(true)
        // Keep the 10 most recent builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }

    stages {

        stage ("Code pull"){
            steps{
                checkout scm
            }
        }

        stage('Unit tests') {
            steps {
                //sh  ''' source activate ${BUILD_TAG}
                //        python -m pytest --verbose --junit-xml reports/unit_tests.xml
                //    '''
                bat "python -m pytest --verbose --junit-xml reports/unit_tests.xml"
            }
            post {
                always {
                    // Archive unit tests for the future
                    echo "Done building"
                    junit allowEmptyResults: true, testResults: 'reports/unit_tests.xml'
                }
                success {
                    echo "Successful"
                }
                failure {
                    emailext (
                        subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                        body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                         <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                        recipientProviders: [[$class: 'CulpritsRecipientProvider']]
                    )
                }
            }
        }
		
		stage('Building image') {
			steps{
				script {
					docker.build registry + ":$BUILD_NUMBER"
				}
			}
		}
		
		stage('Deploy Image') {
			steps{
				bat "docker login -u arunramkrish -p R@AbAi11"
				bat "docker push arunramkrish/docker-demo"
			}
		}
		
		stage('Remove Unused docker image') {
			steps{
				bat "docker rmi $registry:$BUILD_NUMBER"
			}
		}
		/*
		stage('Pull and run docker image') {
			steps{
				bat "docker login -u arunramkrish -p R@AbAi11"
				bat "docker run arunramkrish/docker-demo"
			}
		}*/
    }

}