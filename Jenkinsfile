  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  agent any // Jenkins will be able to select all available agents
  environment { // Declaration of environment variables
    nom = 'datascientest'
    DOCKER_ID = "cpa8876" // replace this with your docker-id
    DOCKER_IMAGE = "ds-fastapi"
    DOCKER_IMAGE1 = "movie-ds-fastapi"
    DOCKER_IMAGE2 = "casts-ds-fastapi"
    DOCKER_TAG = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build
    }
  stages {
    stage('Docker Build'){
      steps {
          sh '''
            cd /app
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG ./movie-service
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG ./cast-service
            docker image ls -a | grep fastapi
            sleep 6
          '''
        }
      }
    }
  post { // send email when the job has failed
  // ..
    failure {
      echo "This will run if the job failed"
      mail to: "cristofe.pascale@gmail.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
        body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    }
  // ..
  }
}
