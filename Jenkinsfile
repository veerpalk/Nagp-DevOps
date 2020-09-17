pipeline{
    agent any
	    tools
		{
			maven 'Maven3'
		}
		options
	{
	    timestamps()
		timeout(time: 1, unit: 'HOURS')
		
		skipDefaultCheckout()
		
		buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr: '10'))
		
		disableConcurrentBuilds()
	}
    stages{
        stage('Checkout'){
        steps{
            echo "build in master branch -1"
			checkout scm
        }
		}
		
		stage('Build'){
        steps{
            echo "build in master branch -2"
			bat "mvn clean install"
        }
		}
		
		stage('Unit Testing'){
        steps{
		    echo "unit test in master branch -3"
			bat "mvn test"
        }
		}
		
		stage('Sonar Analysis'){
        steps{
		    echo "sonar analysis in master branch -4"
			withSonarQubeEnv("Test_Sonar")
			{
			 bat "mvn sonar:sonar"
			}
        }
		}
		
		stage('Upload to Artifactory'){
        steps{
		    echo "upload to artifactory in master branch -5"
			rtMavenDeployer(
			id: 'deployer',
			serverId: '123456789@artifactory',
			releaseRepo: 'CI-Automation-JAVA',
			snapshotRepo: 'CI-Automation-JAVA'
			)
			rtMavenRun(
			 pom: 'pom.xml',
			 goals: 'clean install',
			 deployerId: 'deployer'
			)
			rtPublishBuildInfo(
			serverId: '123456789@artifactory'
			)
        }
		}
		
		stage('Docker Image'){
        steps{
		    echo "Docker Image in master branch -6"
			bat "docker build -t dtr.nagarro.com:443/i-veerpalkaur-master --no-cache -f Dockerfile ."
			}
        }
		
		stage('Push to DTR'){
        steps{
		    echo "Push to DTR in master branch -7"
			bat "docker push dtr.nagarro.com:443/i-veerpalkaur-master"
        }
		}
		
		stage('Stop Running Container'){
        steps{
		    echo "Stop Running Container in master branch -8"
			bat '''
			for /f %%i in ('docker ps -qf "name=^c-veerpalkaur-master"') do set containerId=%%i
            echo %containerId%
            If "%containerId%" == "" (
              echo "No Container running"
             ) ELSE (
            docker stop %ContainerId%
            docker rm -f %ContainerId%
             )
			'''
        }
		}
		
		stage('Docker Delopyment'){
        steps{
		    echo "Docker Delopyment in master branch -9"
			bat "docker run --name c-veerpalkaur-master -d -p 6200:8080  dtr.nagarro.com:443/i-veerpalkaur-master"
        }
		}
		
		
		stage('Helm charts deployment'){
        steps{
		    echo "Helm charts deployment in master branch -10"
			bat '''
			helm install my-nagp-app nagp-vk-chart
			'''
        }
		}
		
		}
		
		post
		{
		always{
		junit 'target/surefire-reports/*.xml'
		}
		}
    }