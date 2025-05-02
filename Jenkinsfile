  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  environment { // Declaration of environment variables
    DOCKERHUB_CREDENTIALS = credentials('dockerHub')
    DOCKER_ID = "cpa8876" // replace this with your docker-id
    DOCKER_IMAGE = "ds-fastapi"
    DOCKER_IMAGE1 = "movies-ds-fastapi"
    DOCKER_IMAGE2 = "casts-ds-fastapi"
    DOCKER_TAG = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build
    //DOCKER_TAG="latest"
    //DOCKER_ID="cpa8876" // replace this with your docker-id
    //DOCKER_IMAGE="ds-fastapi"
    //DOCKER_IMAGE1="movie-ds-fastapi"
    //DOCKER_IMAGE2="casts-ds-fastapi"
}

  agent any // Jenkins will be able to select all available agents

  stages {
    stage('Docker Build'){ // docker build image stage
    // docker rm -f my-ctnr-ds-fastapi
      steps {
        script {
           sh '''
            cd /app/movie-service
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG .
            cd /app/cast-service
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG .
            docker image ls -a | grep fastapi
          sleep 6
          '''
          // dockerImageMovies = docker.build("${env.DOCKER_IMAGE1}:${env.DOCKER_TAG}")
          // dockerImageCasts = docker.build("${env.DOCKER_IMAGE2}:${env.DOCKER_TAG}")
        }
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
