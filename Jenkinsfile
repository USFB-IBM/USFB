pipeline {
    agent any
    parameters {
    		//string(name: 'devops_stage', defaultValue: 'buildandpackage', description: 'DevOps Stage - buildandpackage, SIT, UAT')
    		//string(name: 'alm_level', defaultValue: 'Feature', description: 'Application Life Cycle Level - Feature, Testing, Release')
    		//string(name: 'target_environment', defaultValue: 'Non-Prod', description: 'Target Environment - Prod, Non-Prod')
    		choice(name: 'alm_level', 
		          choices: 'Feature\nRelease', 
		              description: 'Application Life Cycle Level - Feature, Release')

	    choice(name: 'devops_stage', 
	                      choices: 'buildandpackage\nDEV\nSIT\nUAT\nPRE-PROD\nPROD\nDR', 
	                      description: 'DevOps Stages - buildandpackage, DEV, SIT, UAT, PRE-PROD, PROD, DR') 
    		
    		string(name: 'product',   defaultValue: 'CBS', description: 'No Product Specified')
			
			//below parameters not required for IT deployment.
    		//string(name: 'clientid',  defaultValue: 'MR42', description: 'Client Id for which the build will be processed')
    		//string(name: 'project_id', defaultValue: 'Project_NA', description: 'Project ID')
    		//string(name: 'build_initiating_user_id', defaultValue: 'NA_user_id', description: 'Buld Initiating User ID')
    		
    		string(name: 'giturl', defaultValue: 'https://github.com', description: 'Git URL of repository.')
    		string(name: 'gitorgname', defaultValue: 'USFB-IBM', description: 'Git Organization')
    		string(name: 'git_reponame', defaultValue: 'USFB', description: 'Git repository')
    		//string(name: 'git_branchname', defaultValue: 'master', description: 'Git Branch Name')
    		choice(name: 'git_branchname', 
		          choices: 'dev\nsit\nuat\npre-prod\nprod\ndr', 
		              description: 'Git Branch Names - dev, sit, uat, pre-prod, prod, dr')
        	string(name: 'sourcedir', defaultValue: 'APICv10', description:'Source Directory.')
			
			//string(name: 'event_publishing_endpoint', defaultValue: 'EndPoint_Not_Aailable', description: 'Event Publishing URL')

    		//string(name: 'sonar_project_name', defaultValue: 'This_is_my_FSCM_POC_project', description: 'Sonar Project Name')
			
    	    
		
        }
        environment {
            branch_name="${params.git_branchname}"
            gitrepourl = "${params.giturl}/${params.gitorgname}/${params.git_reponame}.git"
        }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from the Git repository
                git branch: "${branch_name}", url: "${gitrepourl}"
            }
        }
    }
}
//Test
