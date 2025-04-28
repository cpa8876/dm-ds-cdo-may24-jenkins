  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  environment { // Declaration of environment variables
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
        }
      }
    }
    stage('Docker run'){ // run container from our builded image
      steps {
        script {// docker run --network=dm-jenkins-cpa-infra_my-net -d -p 8800:8000 --name my-ctnr-ds-fastapi $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
        //docker run -d --name test_loadbalancer_fastapi --net dm-jenkins-cpa-infra_my-net -p 8080:8080 -v /app/nginx_config.conf:/etc/nginx/conf.d/default.conf nginx:latest
          sh '''
            cd /app
            docker volume create postgres_data_movie
            docker volume create postgres_data_cast
            docker run -d --name cast_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_cast:/var/lib/postgresql/data/ -e POSTGRES_USER=cast_db_username -e POSTGRES_PASSWORD=cast_db_password -e POSTGRES_DB=cast_db_dev --health-cmd "CMD-SHELL,pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}" --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine
            sleep 6
            docker run -d --name cast_service --net dm-jenkins-cpa-infra_my-net -p 8002:8000 -e DATABASE_URI=postgresql://cast_db_username:cast_db_password@cast_db/cast_db_dev cpa8876/casts-ds-fastapi:v.4.0 uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
            sleep 2
            docker run -d  --name movie_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_movie:/var/lib/postgresql/data/ -e POSTGRES_USER=movie_db_username -e POSTGRES_PASSWORD=movie_db_password -e POSTGRES_DB=movie_db_dev --health-cmd "CMD-SHELL,pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}" --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine &
            sleep 6
            docker run -d --name movie_service --net dm-jenkins-cpa-infra_my-net -p 8001:8000 -e DATABASE_URL=postgresql://movie_db_username:movie_db_password@movie_db/movie_db_dev -e CAST_SERVICE_HOST_URL=http://cast_service:8000/api/v1/casts/ cpa8876/movies-ds-fastapi:v.4.0 uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
            sleep 2
            docker run -d --name nginx --net dm-jenkins-cpa-infra_my-net -p 8080:8080 nginx:latest
            docker cp nginx_config.conf nginx:/etc/nginx/conf.d/default.conf
            docker restart nginx
          '''
        }
      }
    }

    stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
      steps {
        script {//curl localhost or curl 127.0.0.1:8480 "curl -svo /dev/null http://localhost" or docker exec -it my-ctnr-ds-fastapi curl localhost
          sh '''
            apt update -y && apt full-upgrade-y && apt install curl -y
            docker exec cast_db psql -h localhost -p 5432 -U cast_db_username -d cast_db_dev -c "select * from pg_database"
            curl $(docker exec test_casts_fastapi hostname -i):8000/api/v1/casts/docs
            docker exec movie_db psql -h localhost -p 5432 -U movie_db_username -d movie_db_dev -c "select * from pg_database"
            curl $(docker exec movie_service hostname -i):8000/api/v1/movies/docs
            curl $(docker exec nginx hostname -i):8080/api/v1/movies/docs
            curl $(docker exec nginx hostname -i):8080/api/v1/casts/docs
            docker rm -f nginx movie_service movie_db cast_service casts_db
            docker ps -a
          '''
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
