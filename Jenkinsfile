pipeline {
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
                    echo "Failure"
                }
            }
        }

    }

}