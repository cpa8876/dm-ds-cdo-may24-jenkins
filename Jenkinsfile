  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
  //
  // ## VERSIONS
  // ### 21/06/2025 16:27 : Remplacement des cmd docker file par le docker compose dans le satge Docker run
  // ### /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/ARCHIVES/Jenkinsfile_V5_Dckr_cmd_20250621.1330 : version av ec cmd docker


pipeline {
  agent any // Jenkins will be able to select all available agents
  // How-to's and Support; Jenkins Multibranch Pipeline With Git Tutorial :
  //   https://www.cloudbees.com/blog/jenkins-multibranch-pipeline-with-git-tutorial
   options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '5', daysToKeepStr: '', numToKeepStr: '5')
  environment { // Declaration of environment variables
    nom='dm-jenkins-cpa'                                                    // nom="dm-jenkins-cpa"
    DOCKER_ID="cpa8876"                                                    // replace this with your docker-id DOCKER_ID="cpa8876"
    DOCKER_IMAGE="ds-fastapi"                                              // DOCKER_IMAGE="ds-fastapi"
    DOCKER_IMAGE1="movie-ds-fastapi"                                       // DOCKER_IMAGE1="movie-ds-fastapi"
    DOCKER_IMAGE2="casts-ds-fastapi"                                       // DOCKER_IMAGE2="casts-ds-fastapi"
    DOCKER_TAG="v.${BUILD_ID}.0"                                           // we will tag our images with the current build in order to increment the value by 1 with each new build DOCKER_TAG="v.75.0"
    URL_REPO_GH_LOCAL="/var/lib/jenkins/workspace/dm-jenkins"                //Repo local github synchronized with https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git
    URL_REP_DOCKERFILE_FAT="$URL_REPO_GH_LOCAL/dr01-python-microservices6"   // Directory containned script Dockerfile of fastapi-movie and fastapi-cast
    URL_REP_DCKR_FAT_CAST="$URL_REP_DOCKERFILE_FAT/cast-service"            // Directory containned script Dockerfile of fastapi-cast 
    URL_REP_DCKR_FAT_MOVIE="$URL_REP_DOCKERFILE_FAT/movie-service"          // Directory containned script Dockerfile of fastapi-movie   
    URL_REP_HELM_FAT="$URL_REPO_GH_LOCAL/charts"                             // Directory containned chart helm of fastapi-movie and fastapi-cast
    URL_REP_HELM_FAT_CAST_DB="$URL_REP_HELM_FAT/cast-db"                  // Directory containned chart helm of fastapi-cast_db 
    URL_REP_HELM_FAT_MOVIE_DB="$URL_REP_HELM_FAT/movie-db"                // Directory containned chart helm of fastapi-movie_db  
    URL_REP_HELM_FAT_CAST_SERVICE="$URL_REP_HELM_FAT/cast-service"        // Directory containned chart helm of cast_service
    URL_REP_HELM_FAT_MOVIE_SERVICE="$URL_REP_HELM_FAT/movie-service"      // Directory containned chart helm of fastapi-movie_service 
    URL_FILE_CONFIG_MINIKUBE="/home/jenkins/.minikube/config"              // Url file of config to enable connect on minikube cluster
     }
  stages {
    stage('Docker Build'){
      steps {
          //echo "Building branch: ${env.BRANCH_NAME}"
    
          sh '''
            echo "Building branch: ${env.ref}"
            name_branch=$(echo  ${env.ref} | sed 's/refs\/heads\///g')
            echo $name_branch 
            cd URL_REPO_GH_LOCAL
            pwd
            git branch $name_branch
            git
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1_$name_branch
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1_$name_branch:$DOCKER_TAG $URL_REP_DCKR_FAT_MOVIE
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2_$name_branch:$DOCKER_TAG $URL_REP_DCKR_FAT_CAST
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
            cd $URL_REP_DOCKERFILE_FAT
            docker compose up -d 
            docker ps -a
          '''
            }
         }
      }
    stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
      steps {
        script {//curl localhost or curl 127.0.0.1:8480 "curl -svo /dev/null http://localhost" or docker exec -it my-ctnr-ds-fastapi curl localhost
          sh '''
            echo -e "\n\n -------------------------------------------------------------------"
            echo -e "Tests acceptance access on contenaires  cast_db, movie_db, cast _service, movie_service and loadbalancer\n  "
            echo -e "\n\n ------------------------------------------"
            echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
            docker exec dr01-python-microservices6-cast_db-1 psql -h localhost -p 5432 -U cast_db_username -d cast_db_dev -c "select * from pg_database"
            echo -e "\n\n Test-02 : curl on dr01-python-microservices6-cast_service-1:5000/api/v1/casts/docs"
            curl $(docker exec dr01-python-microservices6-cast_service-1 hostname -i):5000/api/v1/casts/docs
            echo -e "\n Test-03 : Sql query on dr01-python-microservices6-movie_db-1 : select * from pg_database :"
            docker exec dr01-python-microservices6-movie_db-1 psql -h localhost -p 5432 -U movie_db_username -d movie_db_dev -c "select * from pg_database"
            echo -e "\n\n Test-04 : curl on dr01-python-microservices6-movie_service-1:5000/api/v1/casts/docs"
            curl $(docker exec dr01-python-microservices6-movie_service-1 hostname -i):5000/api/v1/movies/docs
            echo -e "\n\n Test-05 : curl on dr01-python-microservices6-nginx-1:8080/api/v1/movies/docs"
            curl $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/docs
            echo -e "\n\n Test-06 : curl on dr01-python-microservices6-nginx-1:8080/api/v1/casts/docs"
            curl $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/docs
            echo -e "\n\n -------------------------------------------------------------------"
            echo -e "Tests acceptance CRUD movies fastapi with contenair nginx (loadbalancer) application\n  "
            echo -e "\n\n ------------------------------------------"
            echo -e "\n\n Test-07 : curl -X POST on dr01-python-microservices6-nginx-1:8080/api/v1/movies/ for id=1 Star wars IX"
            curl -X 'POST'   $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
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
            curl -X 'POST'   $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
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
            echo -e "\n\n Test-09 : curl -X POST on dr01-python-microservices6-nginx-1:8080/api/v1/movies/ for id=3 Star wars V"
            curl -X 'POST'   $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
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
            echo -e "\n\n Test-10 : curl -X GET ALL on dr01-python-microservices6-nginx-1:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-11 : curl -X GET id=1 on dr01-python-microservices6-nginx-1:8080/api/v1/movies/1"
            curl -X 'GET' \
  $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/1/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-12 : curl -X PUT update id=1 on dr01-python-microservices6-nginx-1:8080/api/v1/movies/1"
            curl -X 'PUT' \
  $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/1 \
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
            echo -e "\n\n Test-13 : curl -X GET ALL on dr01-python-microservices6-nginx-1:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-14 : curl -X DELETE id=1 on dr01-python-microservices6-nginx-1:8080/api/v1/movies/1"
            curl -X 'DELETE' \
  $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/1 \
  -H 'accept: application/json'
            echo -e "\n\n Test-15 : curl -X GET ALL on dr01-python-microservices6-nginx-1:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo -e "\n\n -------------------------------------------------------------------"
            echo -e "Tests acceptance CRUD casts fastapi application\n  "
            echo -e "\n\n ------------------------------------------"
            echo -e "\n\n Test-16 : curl -X GET ALL on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'POST' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Adam Driver",
  "nationality": "USA"
}'
            echo -e "\n\n Test-17 : curl -X GET POST  create id=1 cast on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'POST' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Daisy Ridley",
  "nationality": "USA"
}'
            echo -e "\n\n Test-18 : curl -X POST create id=2 cast ALL on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
           curl -X 'POST' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Carrie FISHER",
  "nationality": "USA"
}'
            echo -e "\n\n Test-19 : curl -X POST create id=3 cast on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'POST'   http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "name": "Mark HAMILL",
  "nationality": "USA"
}'
            echo -e "\n\n Test-20 : curl -X POST create id=4 cast on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'POST'   http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "name": "Harisson FORD",
  "nationality": "USA"
}'
            echo -e "\n\n Test-21 : curl -X GET ALL on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'GET' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-22 : curl -X GET id=1 on dr01-python-microservices6-nginx-1:8080/api/v1/casts/1"
            curl -X 'GET' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/1/ \
  -H 'accept: application/json'
            echo -e "\n\n Test-23 : curl -X DELETE id=1 on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'DELETE' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/1 \
  -H 'accept: application/json'
            echo -e "\n\n Test-24 : curl -X GET ALL on dr01-python-microservices6-nginx-1:8080/api/v1/casts/"
            curl -X 'GET' \
  http://$(docker exec dr01-python-microservices6-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json'

            docker rm -f dr01-python-microservices6-nginx-1 movie_service movie_db cast_service cast_db
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
     stage('Deploy') {
            environment {
                      KUBECONFIG = credentials("kubeconfig-dev") // we retrieve  kubeconfig from secret file called config saved on jenkins
                    }
            steps {
                script {
                     name_branch=$(echo  ${env.ref} | sed 's/refs\/heads\///g')
                     if ($name_branch == 'develop') {
                      sh '''
                        echo "Déploiement sur l'environnement DEV"
                        mkdir -p /home/jenkins/.minikube/profiles/minikube/;
                        ls -lha /home/jenkins/.minikube/profiles/minikube/;
                        cat $KUBECONFIG > $URL_FILE_CONFIG_MINIKUBE;
                        echo $URL_FILE_CONFIG_MINIKUBE
                        cat $URL_FILE_CONFIG_MINIKUBE;
                        whoami;
                        pwd;
                        hostname -I;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get all -n dev
                        cp fastapi/values.yaml values.yml
                        cat values.yml
                        sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
                        helm --kubeconfig $URL_FILE_CONFIG_MINIKUB upgrade --install app fastapi --values=values.yml --namespace dev
                      '''
                    } else if ($name_branch == 'qa') {
                      sh '''
                        echo "Déploiement sur l'environnement QA"
                        mkdir -p /home/jenkins/.minikube/profiles/minikube/;
                        ls -lha /home/jenkins/.minikube/profiles/minikube/;
                        cat $KUBECONFIG > $URL_FILE_CONFIG_MINIKUBE;
                        whoami;
                        pwd;
                        hostname -I;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get all -n qa
                        '''
                    } else if ($name_branch == 'staging') {
                      sh '''
                        echo "Déploiement sur l'environnement STAGING"
                        mkdir -p /home/jenkins/.minikube/profiles/minikube/;
                        ls -lha /home/jenkins/.minikube/profiles/minikube/;
                        cat $KUBECONFIG > $URL_FILE_CONFIG_MINIKUBE;
                        whoami;
                        pwd;
                        hostname -I;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get all -n staging
                        '''
                    } else if ($name_branch == 'main' || $name_branch == 'master') {
                      sh '''
                        echo "Déploiement sur l'environnement PROD"
                        mkdir -p /home/jenkins/.minikube/profiles/minikube/;
                        ls -lha /home/jenkins/.minikube/profiles/minikube/;
                        cat $KUBECONFIG > $URL_FILE_CONFIG_MINIKUBE;
                        whoami;
                        pwd;
                        hostname -I;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get all -n prod
                        '''
                    } else {
                      sh '''
                        echo $branch
                        echo "Branche non configurée pour déploiement automatique"
                      '''
                    }
                }
              }
      }

  }  
  post { // send email when the job has failed
  // ..
    success {
       // Instantly share code, notes, and snippets; merikan/Jenkinsfile ; Last active 3 weeks ago
       // https://gist.github.com/merikan/228cdb1893fca91f0663bab7b095757c
        // slackSend(
                     // teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                    // token: "${env.SLACK_TOKEN}",
                    // channel: "${env.SLACK_CHANNEL}",
                    // color: "good",
                    // message: "${env.STACK_PREFIX} production deploy: *${env.DEPLOY_VERSION}*. <${env.DEPLOY_URL}|Access service> - <${env.BUILD_URL}|Check build>"
                    //)
      echo "This will run if the job succeed"
      mail to: "cristofe.pascale@gmail.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has succed",
        body: "For more info on the pipeline success, check out the console output at ${env.BUILD_URL}"
                }
    failure {
      echo "This will run if the job failed"
      mail to: "cristofe.pascale@gmail.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
        body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    }
  // ..
  }
}
