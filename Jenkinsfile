pipeline {
    agent any
    parameters {
    		choice(name: 'alm_level',
		          choices: 'Feature\nRelease',
		              description: 'Application Life Cycle Level - Feature, Release')
			choice(name: 'devops_stage',
	                      choices: 'DEV\nSIT\nUAT\nPRE-PROD\nPROD\nDR',
	                      description: 'DevOps Stages - DEV, SIT, UAT, PRE-PROD, PROD, DR')
    		
    		string(name: 'product',   defaultValue: 'CBS', description: 'No Product Specified')
    		
    		string(name: 'giturl', defaultValue: 'https://github.com', description: 'Git URL of repository.')
    		string(name: 'gitorgname', defaultValue: 'USFB-IBM', description: 'Git Organization')
    		string(name: 'git_reponame', defaultValue: 'USFB', description: 'Git repository')
    		//string(name: 'git_branchname', defaultValue: 'master', description: 'Git Branch Name')
    		choice(name: 'git_branchname',
		          choices: 'dev\nsit\nuat\npre-prod\nprod\ndr',
		              description: 'Git Branch Names - dev, sit, uat, pre-prod, prod, dr')
        	string(name: 'sourcedir', defaultValue: 'APICv10', description:'Source Directory.')
			
    	  
		
        }
        environment {
			alm_level = "${params.alm_level}"
            branch_name="${params.git_branchname}"
			vendor_name="${params.product}"
            gitrepourl = "${params.giturl}/${params.gitorgname}/${params.git_reponame}.git"
			builddir = "${BUILD_NUMBER}"
            apic_credential = "apic-credential"
            apic_server_name="https://localhost:2000"
            apic_org_name="localtest"
            apic_realm='provider/default-idp-2'
			apic_catalog="sandbox"
			PATH="C:\\cygwin64\\bin;$PATH"
        }
    stages {
		
		stage('Pipeline\nInitialization') {
				steps {
					script{
						
						currentBuild.displayName = "#${BUILD_NUMBER} [ ${alm_level} : ${branch_name} : ${vendor_name} ]"
                        taskComplCode="0";
					}
				    script{
					    
						   //echo "alm_level=${params.alm_level}, devops_stage=${params.devops_stage}, product_name=${params.product}-${params.client_code}, clientid=${params.client_code}, clientid=${params.client_code}, repo_name=${params.git_reponame}, base_build_number=${params.base_build_number}"
					    //displaying build name
					    echo currentBuild.displayName
					    bat "\"C:\\cygwin64\\bin\\sh.exe\" -c 'mkdir -pv ${builddir}'"
						dir(builddir) {
						    initParams();
						} //end dir(builddir)
					}
				}
		}
		stage('Code Checkout') {

		    steps {
		        echo "Clone the repository under a specified directory. Sparse Check-out will be used for ${gitclientdir}"
				script {
					// Print the payload for debugging
					echo "Received GitHub webhook payload: ${env}"
					
					// Extract commit information
					def commits = env.CHANGELOG // This may vary based on webhook payload structure
					
					if (commits) {
						// Example: Loop through commits and print commit paths
						for (commit in commits) {
							echo "Commit message: ${commit.message}"
							echo "Commit paths:"
							for (path in commit.added + commit.modified) {
								echo "  - ${path}"
							}
						}
					} else {
						echo "No commits found in webhook payload."
					}
				}
				script{
					 //taskName= "code_checked_out"; taskSeq=taskSeq.toInteger()+1;

				    def paths = [["path":"${gitclientdir}"],["path": "/common"],["path": "/devops"]]
					dir(builddir) {
					    checkOutGitRepo(paths)
					}
					sendEventNotification()
					
				}
		    }	
		}		
    }
}

def initParams(){
	//initParams initiated
	env.gitclientdir =  "/USFB/APICv10/Products"
}
def checkOutGitRepo(paths){
		checkout([$class: 'GitSCM',
		   branches: [[name: '*/'+branch_name]],
		   doGenerateSubmoduleConfigurations: false,
		   extensions: [
				[$class: 'SparseCheckoutPaths',
				 sparseCheckoutPaths: paths
				]
			],
		   submoduleCfg: [],
		   userRemoteConfigs: [[  credentialsId: credentialkey, url: 'http://'+gitrepourl]]])	
}
