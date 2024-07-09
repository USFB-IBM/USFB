pipeline {
    agent any
    parameters {
    		choice(name: 'alm_level',
		          choices: 'Feature\nRelease',
		              description: 'Application Life Cycle Level - Feature, Release')
	    	choice(name: 'devops_stage',
	                      choices: 'buildandpackage\nDEV\nSIT\nUAT\nPRE-PROD\nPROD\nDR',
	                      description: 'DevOps Stages - buildandpackage, DEV, SIT, UAT, PRE-PROD, PROD, DR')  		
    		string(name: 'product',   defaultValue: 'CBS', description: 'No Product Specified')
    		string(name: 'giturl', defaultValue: 'https://github.com', description: 'Git URL of repository.')
    		string(name: 'gitorgname', defaultValue: 'USFB-IBM', description: 'Git Organization')
    		string(name: 'git_reponame', defaultValue: 'USFB', description: 'Git repository')
    		choice(name: 'git_branchname',
		          choices: 'dev\nsit\nuat\npre-prod\nprod\ndr',
		              description: 'Git Branch Names - dev, sit, uat, pre-prod, prod, dr')
        	string(name: 'sourcedir', defaultValue: 'APICv10', description:'Source Directory.')
        }
        environment {
            branch_name="${params.git_branchname}"
            gitrepourl = "${params.giturl}/${params.gitorgname}/${params.git_reponame}.git"
            apic_credential = "apic-credential"
            apic_server_name="https://localhost:2000"
            apic_org_name="localtest"
            apic_realm='provider/default-idp-2'
			apic_catalog="sandbox"
			PATH="C:\\cygwin64\\bin;$PATH"
        }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from the Git repository
                git branch: "${branch_name}", url: "${gitrepourl}"
                dir('APICv10/Products/Jocata/RAMPWebservice'){
                    echo "API Deployment"
            		withCredentials([usernamePassword(credentialsId: 'apic-credential',
            		      usernameVariable: 'apic_username',
            			  passwordVariable: 'apic_password')]) {
				    echo "Publishing APIs to portal"
				    bat "\"C:\\cygwin64\\bin\\sh.exe\" deploy-apis_1.sh"
	            	}   
                }
            }
			/*stage('Deploy API') {
            steps {
                script {
                    dir('Products/Jocata/RAMPWebservice') {
                        deployAPI()
                    }
                }
            }
        }*/
        }
		}
	/*def deployAPI(){
		withCredentials([usernamePassword(credentialsId: 'apic-credential',
			  passwordVariable: 'apic_password',
			  usernameVariable: 'apic_username')]) {
				 sh './deploy-apis.sh'
		} //end of withCredentials	
	}*/
