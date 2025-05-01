  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  environment { // Declaration of environment variables
    DOCKER_ID = "cpa8876" // replace this with your docker-id
    DOCKER_IMAGE = "ds-fastapi"
    DOCKER_IMAGE1 = "movie-ds-fastapi"
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
<<<<<<< HEAD
            cd /app
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG ./movie-service
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG ./cast-service
=======
            cd /app/movie-service
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG .
            cd /app/cast-service
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG .
>>>>>>> 4765914 (update Jenkinsfile to repalce shell cmd by           docker.withRegistry('https://index.docker.io/v1/', 'dockerHub') {)
            docker image ls -a | grep fastapi
            sleep 6
          '''
        }
      }
    }
// sudo docker network create dm-jenkins-cpa-infra_my-net
// sudo docker network ls
// ssh-add /home/cpa/Documents/.ssh/ssh-key-github-cpa8876
    stage('Docker run'){ // run container from our builded image
      steps {
        script {// docker run --network=dm-jenkins-cpa-infra_my-net -d -p 8800:8000 --name my-ctnr-ds-fastapi $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
          sh '''
            docker compose up -d
            sleep 10
          '''
        }
      }
    }

    stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
      steps {
        script {//curl localhost or curl 127.0.0.1:8480 "curl -svo /dev/null http://localhost" or docker exec -it my-ctnr-ds-fastapi curl localhost
          sh '''
            apt update -y && apt upgrade -y && apt install curl -y
            # curl my-ctnr-ds-fastapi:8000/api/v1/checkapi
          '''
        }
      }
    }

<<<<<<< HEAD
  }
=======
    stage('Docker Push'){ //we pass the built image to our docker hub account
      environment
        {
          DOCKER_PASS = credentials("DOCKER_HUB_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
        }
      steps {
        script {
        //docker login -u $DOCKER_ID -p $DOCKER_PASS
          sh '''
            docker login -u $DOCKER_ID -p  DOCKERHUB_CREDENTIALS.ValueBase
            docker push $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
          '''
        }
      }
    }
  }

>>>>>>> 4765914 (update Jenkinsfile to repalce shell cmd by           docker.withRegistry('https://index.docker.io/v1/', 'dockerHub') {)
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
