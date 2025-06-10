  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  agent any // Jenkins will be able to select all available agents
  environment { // Declaration of environment variables
    nom = 'datascientest' // nom="datascientest"
    DOCKER_ID = "cpa8876" // replace this with your docker-id DOCKER_ID="cpa8876"
    DOCKER_IMAGE = "ds-fastapi"  // DOCKER_IMAGE="ds-fastapi"
    DOCKER_IMAGE1 = "movie-ds-fastapi"   // DOCKER_IMAGE1="movie-ds-fastapi"
    DOCKER_IMAGE2 = "casts-ds-fastapi"   // DOCKER_IMAGE2="casts-ds-fastapi"
    DOCKER_TAG = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build DOCKER_TAG="v.75.0"
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
    stage('Docker run'){ // run container from our builded image
      steps {
        script {// docker run --network=dm-jenkins-cpa-infra_my-net -d -p 8800:5000 --name my-ctnr-ds-fastapi $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
                    // docker rm -f $(docker ps -aq); docker network rm dm-jenkins-cpa-infra_my-net
          sh '''
            cd /app
            docker volume create postgres_data_movie
            docker volume create postgres_data_cast
            docker network create dm-jenkins-cpa-infra_my-net
            docker run -d --name cast_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_cast:/var/lib/postgresql/data/ -e POSTGRES_USER=cast_db_username -e POSTGRES_PASSWORD=cast_db_password -e POSTGRES_DB=cast_db_dev --health-cmd "CMD-SHELL,pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}" --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine
            sleep 6
            docker run -d --name cast_service --net dm-jenkins-cpa-infra_my-net -p 8002:5000 -e DATABASE_URI=postgresql://cast_db_username:cast_db_password@cast_db/cast_db_dev $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG uvicorn app.main:app --reload --host 0.0.0.0 --port 5000
            sleep 2
            docker run -d  --name movie_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_movie:/var/lib/postgresql/data/ -e POSTGRES_USER=movie_db_username -e POSTGRES_PASSWORD=movie_db_password -e POSTGRES_DB=movie_db_dev --health-cmd "CMD-SHELL,pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}" --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine &
            sleep 6
            docker run -d --name movie_service --net dm-jenkins-cpa-infra_my-net -p 8001:5000 -e DATABASE_URL=postgresql://movie_db_username:movie_db_password@movie_db/movie_db_dev -e CAST_SERVICE_HOST_URL=http://cast_service:5000/api/v1/casts/ $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG uvicorn app.main:app --reload --host 0.0.0.0 --port 5000
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
            echo -e "\n\n -------------------------------------------------------------------"
            echo -e "Tests acceptance access on contenaires  cast_db, movie_db, cast _service, movie_service and loadbalancer\n  "
            echo -e "\n\n ------------------------------------------"
            echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
            docker exec cast_db psql -h localhost -p 5432 -U cast_db_username -d cast_db_dev -c "select * from pg_database"
            echo -e "\n\n Test-02 : curl on ip-cast_service:5000/api/v1/casts/docs"
            curl $(docker exec cast_service hostname -i):5000/api/v1/casts/docs
            echo -e "\n Test-03 : Sql query on movie_db : select * from pg_database :"
            docker exec movie_db psql -h localhost -p 5432 -U movie_db_username -d movie_db_dev -c "select * from pg_database"
            echo -e "\n\n Test-04 : curl on ip-movie_service:5000/api/v1/casts/docs"
            curl $(docker exec movie_service hostname -i):5000/api/v1/movies/docs
            echo -e "\n\n Test-05 : curl on ip-nginx:8080/api/v1/movies/docs"
            curl $(docker exec nginx hostname -i):8080/api/v1/movies/docs
            echo -e "\n\n Test-06 : curl on ip-nginx:8080/api/v1/casts/docs"
            curl $(docker exec nginx hostname -i):8080/api/v1/casts/docs
            echo -e "\n\n -------------------------------------------------------------------"
            echo -e "Tests acceptance CRUD movies fastapi with contenair nginx (loadbalancer) application\n  "
            echo -e "\n\n ------------------------------------------"
            echo -e "\n\n Test-07 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=1 Star wars IX"
            curl -X 'POST'   $(docker exec nginx hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "id": 1,
  "name": "Star Wars: Episode IX - The Rise of Skywalker",
  "plot": "The surviving members of the resistance face the First Order once again.",
  "genres": [
    "Action",
    "Adventure",
    "Fantasy"
  ],
  "casts_id": [
   1,
   2,
   3,
   4,
   5
  ]
}'
            echo -e "\n\n Test-08 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=2 Star wars VI"
            curl -X 'POST'   $(docker exec nginx hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "id": 2,
  "name": "Star Wars: Episode VI - Return of the Jedi",
  "plot": "The evil Galactic Empire is building a new Death Star space station to permanently destroy the Rebel Alliance, its main opposition.",
  "genres": [
    "Action",
    "Adventure",
    "Fantasy"
  ],
  "casts_id": [
   3,
   4,
   5
  ]
}'
            echo -e "\n\n Test-09 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=3 Star wars V"
            curl -X 'POST'   $(docker exec nginx hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
 "id": 3,
  "name": "Star Wars: Episode V - The Empire Strikes Back",
  "plot": "Set three years after the events of Star Wars, the film recounts the battle between the malevolent Galactic Empire, ",
  "genres": [
    "Action",
    "Adventure",
    "Fantasy"
  ],
  "casts_id": [
    3,
    4,
    5
  ]
}'
            echo -e "\n\n Test-10 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec nginx hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-11 : curl -X GET id=1 on ip-nginx:8080/api/v1/movies/1"
            curl -X 'GET' \
  $(docker exec nginx hostname -i):8080/api/v1/movies/1/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-12 : curl -X PUT update id=1 on ip-nginx:8080/api/v1/movies/1"
            curl -X 'PUT' \
  $(docker exec nginx hostname -i):8080/api/v1/movies/1 \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "id": 1,
  "name": "Star Wars: Episode IX - The Rise of Skywalker",
  "plot": "The surviving members of the resistance face the First Order once again.",
  "genres": [
    "Action",
    "Adventure",
    "Fantasy"
  ],
  "casts_id": [
   1
  ]
}'
            echo -e "\n\n Test-13 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec nginx hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-14 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/movies/1"
            curl -X 'DELETE' \
  $(docker exec nginx hostname -i):8080/api/v1/movies/1 \
  -H 'accept: application/json'
            echo -e "\n\n Test-15 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec nginx hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo -e "\n\n -------------------------------------------------------------------"
            echo -e "Tests acceptance CRUD casts fastapi application\n  "
            echo -e "\n\n ------------------------------------------"
            echo -e "\n\n Test-16 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/"
            curl -X 'POST' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Adam Driver",
  "nationality": "USA"
}'
            echo -e "\n\n Test-17 : curl -X GET POST  create id=1 cast on ip-nginx:8080/api/v1/casts/"
            curl -X 'POST' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Daisy Ridley",
  "nationality": "USA"
}'
            echo -e "\n\n Test-18 : curl -X POST create id=2 cast ALL on ip-nginx:8080/api/v1/casts/"
           curl -X 'POST' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Carrie FISHER",
  "nationality": "USA"
}'
            echo -e "\n\n Test-19 : curl -X POST create id=3 cast on ip-nginx:8080/api/v1/casts/"
            curl -X 'POST'   http://$(docker exec nginx hostname -i):8080/api/v1/casts/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "name": "Mark HAMILL",
  "nationality": "USA"
}'
            echo -e "\n\n Test-20 : curl -X POST create id=4 cast on ip-nginx:8080/api/v1/casts/"
            curl -X 'POST'   http://$(docker exec nginx hostname -i):8080/api/v1/casts/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "name": "Harisson FORD",
  "nationality": "USA"
}'
            echo -e "\n\n Test-21 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/"
            curl -X 'GET' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-22 : curl -X GET id=1 on ip-nginx:8080/api/v1/casts/1"
            curl -X 'GET' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/1/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-23 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/casts/"
            curl -X 'DELETE' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/1 \
  -H 'accept: application/json'
            echo -e "\n\n Test-24 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/"
            curl -X 'GET' \
  http://$(docker exec nginx hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json'

            docker rm -f nginx movie_service movie_db cast_service cast_db
            docker ps -a
            '''
          }
        }
      }
    stage('Docker Push'){ //we pass the built image to our docker hub account
      environment
        {
          DOCKER_PASS = credentials("DOCKER_HUB_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
         // DOKER_CREDENTIALS=credentials('dockerhub')
         // USERNAME: "$(env.DOKER_CREDENTIALS_USR)"
          //PASSWORD: "$(env.DOCKER_CREDENTIALS_PSW)"
        }
      steps {
        script {// docker login -u $USERNAME -p $PASSWORD
             //docker push $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG
          withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
          sh '''
                docker login -u $USERNAME -p $PASSWORD
                docker push $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG
                docker push $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG
             '''
             }
          }
        }
      }
    stage('Deploiement en dev'){
      #environment {
        #KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
      #}
      steps {
        script {
          // withKubeConfig(caCertificate: '', clusterName: 'k3d-mycluster', contextName: 'k3d-mycluster', credentialsId: 'k8s-jenkins-secret', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://0.0.0.0:41521') {
    // some block
                // helm upgrade --install app fastapi --values=values.yml --namespace dev
                // cf B52 helm --kubeconfig : https://helm.sh/docs/helm/helm/

          sh '''
            cd /app/fastapiapp
            ls -lha
            kubectl --kubeconfig /usr/local/k3s.yaml apply -f fastapi-cast.yaml
            cp /fastapi/values-dev.yaml /fastapiapp/values.yaml
            cat /fastapiapp/values.yaml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml

            helm upgrade --kubeconfig /usr/local/k3s.yaml --install fastapi-dev /charts --namespace dev --create-namespace
          '''
          // kubectl --kubeconfig /usr/local/k3s.yaml delete namespace dev
        //}
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
