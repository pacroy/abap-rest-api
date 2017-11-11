import jenkins.model.*

node {
	def skip_pipeline = false
    stage('Preparation') {
        deleteDir()
        git poll: true, branch: 'master', url:'https://github.com/pacroy/abap-rest-api.git'
		dir('sap-pipeline') {
			bat "git clone https://github.com/pacroy/abap-ci-postman.git ."
		}
    }
    
    stage('ABAP Unit and Code Coverage') {
		dir('sap-pipeline') {
			withCredentials([usernamePassword(credentialsId: 'NPL', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
				bat "newman run abap_unit_coverage.postman_collection.json --insecure --bail --environment G4E_Pipeline.postman_environment.json --global-var username=$USERNAME --global-var password=$PASSWORD --timeout-request 120000"
			}
		}
    }
    
    stage('ABAP Code Inspector') {
		dir('sap-pipeline') {
			withCredentials([usernamePassword(credentialsId: 'NPL', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
				bat "newman run abap_sci.postman_collection.json --insecure --bail --environment G4E_Pipeline.postman_environment.json --global-var username=$USERNAME --global-var password=$PASSWORD --timeout-request 120000"
			}
		}
    }
    
    stage('SAP API Tests') {
			withCredentials([usernamePassword(credentialsId: 'NPL', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
				try {
					bat "newman run SimpleRESTTest.postman_collection.json --insecure --bail --environment NPL.postman_environment.json --reporters junit --global-var username=$USERNAME --global-var password=$PASSWORD --timeout-request 10000"
				} catch(e) {
					skip_pipeline = true
					currentBuild.result = 'FAILURE'
				}
				junit 'newman/*.xml'
			}
    }
}
