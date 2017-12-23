import jenkins.model.*

node {
	def HOST = "vhcalnplci.dummy.nodomain"
	def CREDENTIAL = "NPL"
	def PACKAGE = "$REST_SIMPLE"
	def COVERAGE = 80
	
    stage('Preparation') {
        deleteDir()
        git poll: true, branch: 'master', url:'https://github.com/pacroy/abap-rest-api.git'
		dir('sap-pipeline') {
			bat "git clone https://github.com/pacroy/abap-ci-postman.git ."
		}
    }
    
	def sap_pipeline = load "sap-pipeline/sap.groovy"
	sap_pipeline.abap_unit_coverage(HOST,CREDENTIAL,PACKAGE,COVERAGE)
	sap_pipeline.abap_sci(HOST,CREDENTIAL,PACKAGE)
	sap_pipeline.sap_api_test(HOST,CREDENTIAL)
}
