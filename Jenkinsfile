  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
  //
  // ## VERSIONS
  // ### 21/06/2025 16:27 : Remplacement des cmd docker file par le docker compose dans le satge Docker run
  // ### /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/ARCHIVES/Jenkinsfile_V5_Dckr_cmd_20250621.1330 : version av ec cmd docker


pipeline {
  environment { // Declaration of environment variables
    nom='dm-jenkins-cpa'                                                    // nom="dm-jenkins-cpa"
    DOCKER_ID="cpa8876"                                                    // replace this with your docker-id DOCKER_ID="cpa8876"
    DOCKER_IMAGE="ds-fastapi"                                              // DOCKER_IMAGE="ds-fastapi"
    DOCKER_IMAGE1="movie-ds-fastapi"                                       // DOCKER_IMAGE1="movie-ds-fastapi"
    DOCKER_IMAGE2="casts-ds-fastapi"                                       // DOCKER_IMAGE2="casts-ds-fastapi"
    DOCKER_TAG="v.${BUILD_ID}.0"                                           // we will tag our images with the current build in order to increment the value by 1 with each new build DOCKER_TAG="v.75.0"
    URL_REPO_GH_LOCAL="/var/lib/jenkins/workspace/dm-jenkins"                //Repo local github synchronized with https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git
    URL_REP_DOCKERFILE_FAT="$URL_REPO_GH_LOCAL/dm-jenkins-cpa"   // Directory containned script Dockerfile of fastapi-movie and fastapi-cast
    URL_REP_DCKR_FAT_CAST="$URL_REP_DOCKERFILE_FAT/cast-service"            // Directory containned script Dockerfile of fastapi-cast 
    URL_REP_DCKR_FAT_MOVIE="$URL_REP_DOCKERFILE_FAT/movie-service"          // Directory containned script Dockerfile of fastapi-movie   
    URL_REP_HELM_FAT="$URL_REPO_GH_LOCAL/dm-jenkins-cpa"                             // Directory containned chart helm of fastapi-movie and fastapi-cast
    URL_REP_HELM_FAT_CAST_DB="$URL_REP_HELM_FAT/cast-service/helm/cast-db"                  // Directory containned chart helm of fastapi-cast_db 
    URL_REP_HELM_FAT_MOVIE_DB="$URL_REP_HELM_FAT/movie-service/helm/movie-db"                // Directory containned chart helm of fastapi-movie_db  
    URL_REP_HELM_FAT_CAST_SERVICE="$URL_REP_HELM_FAT/cast-service/helm/cast-fastapi"        // Directory containned chart helm of cast_service
    URL_REP_HELM_FAT_MOVIE_SERVICE="$URL_REP_HELM_FAT/movie-service/helm/movie-fastapi"      // Directory containned chart helm of fastapi-movie_service 
    URL_FILE_CONFIG_MINIKUBE="/home/jenkins/.minikube/config"              // Url file of config to enable connect on minikube cluster
    KUBE_CONTEXT="devops-develop"
    KUBE_NAMESPACE="develop"
    HELM_VALUES_FILE="value-develop.yaml"
    name_branch0="${env.ref}"
     }
  agent any // Jenkins will be able to select all available agents
  // How-to's and Support; Jenkins Multibranch Pipeline With Git Tutorial :
  //   https://www.cloudbees.com/blog/jenkins-multibranch-pipeline-with-git-tutorial
   options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '5', daysToKeepStr: '', numToKeepStr: '5')
   }
  stages {
    stage('Docker Build'){
      steps {
          //echo  "\n\n### Building branch: ${env.BRANCH_NAME}"
          // https://search.brave.com/search?q=sed+caract%C3%A8re+sp%C3%A9ciaux+%2F&source=desktop&summary=1&conversation=bc5fb68b4e385ab86446da
          // /bin/sh -c "name_branch=$(echo ${name_branch0} | sed 's#refs/heads/##g'); echo \"#### Building branch: ${name_branch}\"; if [ \"$name_branch\" = \"develop\" ]; then  echo \"$name_branch\"; fi"
          sh '''
            echo  "\n\n### Building branch: $name_branch0"
            name_branch=$(echo $name_branch0 | sed "s#refs/heads/##g")
            echo  "\n\n ### Build images docker with dockerfile of the branch: $name_branch"
            echo $name_branch 
            cd $URL_REPO_GH_LOCAL
            pwd
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1_$name_branch
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1-$name_branch:$DOCKER_TAG $URL_REP_DCKR_FAT_MOVIE
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2-$name_branch:$DOCKER_TAG $URL_REP_DCKR_FAT_CAST
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
            name_branch=$(echo $name_branch0 | sed "s#refs/heads/##g")
            echo  "\n\n ### Test acceptance on contenair docker crezated with image fastapi-cast and fastapi-movie applications built with dockerfile of the branch: $name_branch"
            echo  "\n\n -------------------------------------------------------------------"
            echo  "Tests acceptance access on contenaires  cast_db, movie_db, cast _service, movie_service and loadbalancer\n  "
            echo  "\n\n ------------------------------------------"
            echo  "\n Test-01 : Sql query on cast_db : select * from pg_database :"
            docker exec dm-jenkins-cpa-cast_db-1 psql -h localhost -p 5432 -U cast_db_username -d cast_db_dev -c "select * from pg_database"
            echo  "\n\n Test-02 : curl on dm-jenkins-cpa-cast_service-1:5000/api/v1/casts/docs"
            curl $(docker exec dm-jenkins-cpa-cast_service-1 hostname -i):5000/api/v1/casts/docs
            echo  "\n Test-03 : Sql query on dm-jenkins-cpa-movie_db-1 : select * from pg_database :"
            docker exec dm-jenkins-cpa-movie_db-1 psql -h localhost -p 5432 -U movie_db_username -d movie_db_dev -c "select * from pg_database"
            echo  "\n\n Test-04 : curl on dm-jenkins-cpa-movie_service-1:5000/api/v1/casts/docs"
            curl $(docker exec dm-jenkins-cpa-movie_service-1 hostname -i):5000/api/v1/movies/docs
            echo  "\n\n Test-05 : curl on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/docs"
            curl $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/docs
            echo  "\n\n Test-06 : curl on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/docs"
            curl $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/docs
            echo  "\n\n -------------------------------------------------------------------"
            echo  "Tests acceptance CRUD movies fastapi with contenair nginx (loadbalancer) application\n  "
            echo  "\n\n ------------------------------------------"
            echo  "\n\n Test-07 : curl -X POST on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/ for id=1 Star wars IX"
            curl -X 'POST'   $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
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
            echo  "\n\n Test-08 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=2 Star wars VI"
            curl -X 'POST'   $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
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
            echo  "\n\n Test-09 : curl -X POST on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/ for id=3 Star wars V"
            curl -X 'POST'   $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
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
            echo  "\n\n Test-10 : curl -X GET ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo  "\n\n Test-11 : curl -X GET id=1 on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/1"
            curl -X 'GET' \
  $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/1/ \
  -H 'accept: application/json'
            echo  "\n\n Test-12 : curl -X PUT update id=1 on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/1"
            curl -X 'PUT' \
  $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/1 \
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
            echo  "\n\n Test-13 : curl -X GET ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo  "\n\n Test-14 : curl -X DELETE id=1 on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/1"
            curl -X 'DELETE' \
  $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/1 \
  -H 'accept: application/json'
            echo  "\n\n Test-15 : curl -X GET ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/movies/"
            curl -X 'GET' \
  $(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/movies/ \
  -H 'accept: application/json'
            echo  "\n\n -------------------------------------------------------------------"
            echo  "Tests acceptance CRUD casts fastapi application\n  "
            echo  "\n\n ------------------------------------------"
            echo  "\n\n Test-16 : curl -X GET ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'POST' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Adam Driver",
  "nationality": "USA"
}'
            echo  "\n\n Test-17 : curl -X GET POST  create id=1 cast on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'POST' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Daisy Ridley",
  "nationality": "USA"
}'
            echo  "\n\n Test-18 : curl -X POST create id=2 cast ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
           curl -X 'POST' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Carrie FISHER",
  "nationality": "USA"
}'
            echo  "\n\n Test-19 : curl -X POST create id=3 cast on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'POST'   http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "name": "Mark HAMILL",
  "nationality": "USA"
}'
            echo  "\n\n Test-20 : curl -X POST create id=4 cast on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'POST'   http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/   -H 'accept: application/json'   -H 'Content-Type: application/json'   -d '{
  "name": "Harisson FORD",
  "nationality": "USA"
}'
            echo  "\n\n Test-21 : curl -X GET ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'GET' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json'
            echo  "\n\n Test-22 : curl -X GET id=1 on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/1"
            curl -X 'GET' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/1/ \
  -H 'accept: application/json'
            echo  "\n\n Test-23 : curl -X DELETE id=1 on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'DELETE' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/1 \
  -H 'accept: application/json'
            echo  "\n\n Test-24 : curl -X GET ALL on dm-jenkins-cpa-nginx-1:8080/api/v1/casts/"
            curl -X 'GET' \
  http://$(docker exec dm-jenkins-cpa-nginx-1 hostname -i):8080/api/v1/casts/ \
  -H 'accept: application/json'

            docker rm -f dm-jenkins-cpa-nginx-1 movie_service movie_db cast_service cast_db
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
                name_branch=$(echo $name_branch0 | sed "s#refs/heads/##g")
                echo  "\n\n ### Push docker images fastapi-cast and fastapi-movie with dockerfile of the branch: $name_branch"
                docker login -u $USERNAME -p $PASSWORD
                docker push $DOCKER_ID/$DOCKER_IMAGE1-$name_branch:$DOCKER_TAG
                docker push $DOCKER_ID/$DOCKER_IMAGE2-$name_branch:$DOCKER_TAG
             '''
             }
          }
        }
      }
     stage('Deploy') {
            environment {
                      KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
                    }
            steps{
              script {
                // initialisation of kubeconfig file on jenkins server to enalble to access minikube cluster
                // K8s/Kubectl/B12-01/Kode cloud; Kubectl / How to Use Kubectl Config Set-Context; https://kodekloud.com/blog/kubectl-change-context/
                  sh '''
                      echo "\n\n### initialisation of kubeconfig file on jenkins server to enalble to access minikube cluster"
                      mkdir -p /home/jenkins/.minikube/profiles/minikube/;
                      ls -lha /home/jenkins/.minikube/profiles/minikube/;
                      cat $KUBECONFIG > $URL_FILE_CONFIG_MINIKUBE;
                      echo $URL_FILE_CONFIG_MINIKUBE;
                      cat $URL_FILE_CONFIG_MINIKUBE;
                      pwd;
                   '''
              }
              script {
                  // B02-02_bin/sh -c 'name_branch=$(echo ${name_branch0} | sed "s#refs/heads/##g"); echo  "\n\n#### Building branch: $name_branch"; if [ "$name_branch"=="develop" ]; then  echo "OK"; fi'; # Rep att : #### Building branch:  OK
                  // https://search.brave.com/search?q=error+bin%2Fsh%2520-c%2520%27name_branch%3D%24(echo%2520%24%257Bname_branch0%257D%2520%257C%2520sed%2520%22s%23refs%2Fheads%2F%23%23g%22)%3B%2520echo%2520%22%23%23%23%23%2520Building%2520branch%3A%2520%24name_branch%22%2520if%2520%5B%2520%22%24name_branch%22%2520%3D%3D%2520%22develop%22%2520%5D%2520then%2520%2520echo%2520%22OK%3B%2520fi%27%2520%2Fbin%2Fsh%3A%25201%3A%2520Syntax%2520error%3A%2520Unterminated%2520quoted%2520string&source=desktop
                  //                         echo  "\n timeout(time: 15, unit: "MINUTES") \{
                  //           input message: \'Do you want to deploy in production ?\', ok: \'Yes\'
                  //           \}"
                  sh '''
                     name_branch=$(echo $name_branch0 | sed 's#refs/heads/##g')
                     echo  "\n\n ### Deploy on the cluster minikube fastapi-cast and fastapi-movie application with chart helms of the branch: $name_branch"
                     if [ "$name_branch"=="develop" ]; 
                     then                      
                        echo  "\n### Déploiement sur l'environnement DEV";
                        echo  "\n\n### Choose context deops-develop defined on kubeconfig file of the cluster minikube with user minikube";
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config use-context devops-$name_branch;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config get-contexts;
                        whoami;
                        hostname -I;
                        pwd;
                     elif [ "$name_branch"=="qa" ]; 
                     then    
                        echo  "\n\n### Déploiement sur l'environnement QA";
                        echo  "\n\n### Choose context deops-develop defined on kubeconfig file of the cluster minikube with user minikube";
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config use-context devops-$name_branch;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config get-contexts;
                        whoami;
                        hostname -I;
                        pwd;
                     elif [ "$name_branch"=="staging" ]; 
                     then  
                        echo  "\n\n### Déploiement sur l'environnement STAGING";
                        echo  "\n\n### Choose context deops-develop defined on kubeconfig file of the cluster minikube with user minikube";
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config use-context devops-$name_branch;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config get-contexts;
                        whoami;
                        hostname -I;
                        pwd;
                     elif [ "$name_branch"=="main" ]; 
                     then  
                        echo  "\n\n### Déploiement sur l'environnement PROD";
                        echo  "\n\n###// Create an Approval Button with a timeout of 15minutes.";
                        echo  "\n\n###// this require a manuel validation in order to deploy on production environment";
                        echo  "\n\n### Choose context deops-develop defined on kubeconfig file of the cluster minikube with user minikube";
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config use-context devops-$name_branch;
                        kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE config get-contexts;
                        whoami;
                        hostname -I;
                        pwd;
                      else
                        echo  "\n\n### Branche $name_branch non configurée pour ce pipeline de déploiement"
                      fi

                      echo  "\n\n################### DEPLOY ALL CHARTS HELM ON ENVIRONMENT ON RIGHT BRANCH ##############################"


                      echo  "\n\n######################## DEPLOY CAST-DB" 
                      echo  "\n\n### Before to deploy on the branch: $name_branch on the environment:  $name_branch, list nodes and all elements existant on the minikube cluster  with cmd : \n$: kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes; kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get all -n $name_branch;";
                      kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes;
                      kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get all -n $name_branch;

                      echo  "\n\n### Place on the right directory before to deploy cast-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/cast-service/helm/cast-db\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/cast-service/helm/cast-db";
                      pwd;
                      
                      echo  "\n\n### Deploy cast-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE upgrade --install cast-db-$name_branch --namespace $name_branch --create-namespace --values=values-$name_branch.yml; sleep 10;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE upgrade --install cast-db-develop --namespace develop --create-namespace --values=values-develop.yml .;
                      sleep 10;

                      echo  "\n\n###  List all deployments on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls -A;

                      echo  "\n\n### Test with a sql query after to have deployed cast-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: kubectl exec -t cast-db-postgres-0 -n develop -- /bin/bash -c \"psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \'select * from pg_database\'\"";
                      kubectl exec -t cast-db-postgres-0 -n develop -- /bin/bash -c "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'select * from pg_database'"
                     

                      echo  "\n\n######################## DEPLOY CAST-FASTAPI-WEB"
                      echo  "\n\n### Place on the right directory before to deploy cast-fastapi on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/cast-service/helm/cast-fastapi\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/cast-service/helm/cast-fastapi";
                      pwd;
                      
                      echo  "\n\n### Deploy cast-fastapi on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE upgrade --install cast-fastapi-$name_branch --namespace $name_branch --create-namespace --values=values-$name_branch.yaml; sleep 10;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE upgrade --install cast-fastapi-develop --namespace develop --create-namespace --values=values-develop.yaml .;
                      sleep 10;

                      echo  "\n\n###  List all deployments on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;

                      echo  "\n\n### Test with a cmd curl after to have deployed cast-fastapi-web on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: curl $(docker exec dm-jenkins-cpa-cast_service-1 hostname -i):5000/api/v1/casts/docs";
                      echo -e "/n/n ******* kubectl exec -t cast-fastapi-web-0 -n develop -- /bin/bash -c \"psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \'select * from pg_database\';\"";
                      echo -e "\n\n###         9.4.4.8) curl --resolve 'dm-jenkins.cpa:80:$( minikube ip )' -i http://dm-jenkins.cpa/ from minikube server";
                      echo "***** ssh -i $url_id_rsa_cpa  cpa@$ip_minikube curl --resolve \"dm-jenkins.cpa:80:$( ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip )\" -i http://dm-jenkins.cpa/api/v1/casts/docs";
                      echo "***** # curl --resolve 'dm-jenkins.cpa:80:192.168.49.2' -i http://dm-jenkins.cpa/api/v1/casts/docs;";
                      
                      
                      echo  "\n\n######################## DEPLOY MOVIE-DB "
                      echo  "\n\n### Place on the right directory before to deploy movie-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-db\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-db";
                      pwd;
                      
                      echo  "\n\n### Deploy movie-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE upgrade --install movie-db-$name_branch --namespace $name_branch --create-namespace --values=values-$name_branch.yml; sleep 10;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE upgrade --install movie-db-develop --namespace develop --create-namespace --values=values-develop.yml .;
                      sleep 10;

                      echo  "\n\n###  List all deployments on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;

                      echo  "\n\n### Test with a sql query after to have deployed movie-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: kubectl exec -t movie-db-postgres-0 -n develop -- /bin/bash -c \"psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \'select * from pg_database\'\"";
                      kubectl exec -t movie-db-postgres-0 -n develop -- /bin/bash -c "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'select * from pg_database'"


                      echo  "\n\n######################## DEPLOY MOVIE-FASTAPI-WEB"
                      echo  "\n\n### Place on the right directory before to deploy movie-fastapi-web on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-fastapi\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-fastapi";
                      pwd;
                      


                      echo  "\n\n######################## DEPLOY PROXY-NGINX-WEB"
                      echo  "\n\n### Place on the right directory before to deploy proxy-nginx-web on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-fastapi\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-fastapi";
                      pwd;


                      echo  "\n\n######################## DELETE ALL HELM DEPLOYMENT #####################################"
                      
                      echo  "\n\n######################## DELETE CAST-DB" 
                      echo  "\n\n### Place at the right directory before deploying cast-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/cast-service/helm/cast-db\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/cast-service/helm/cast-db";
                      pwd;

                      echo  "\n\n### Delete the helm chart cast-db-develop deployment on the branch: $name_branch on the environement:  $name_branch, with cmd : \n$:helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE uninstall cast-db-develop --namespace develop;sleep 10; ";
                      echo "helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE uninstall cast-db-develop --namespace develop;"
                      echo "sleep 10;"
                      
                      echo  "\n\n### Verify deleting the helm chart cast-db-develop on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;


                      echo  "\n\n######################## DELETE CAST-FASTAPI-WEB"
                      
                      
                      
                      echo  "\n\n######################## DELETE MOVIE-DB" 
                      echo  "\n\n### Place on the right directory before to deploy movie-db on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: cd \"$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-db\"; pwd;";
                      cd "$URL_REPO_GH_LOCAL/dm-jenkins-cpa/movie-service/helm/movie-db";
                      pwd;

                      echo  "\n\n### Delete the helm chart movie-db-develop deployment on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$:helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE uninstall movie-db-develop --namespace develop;sleep 10; ";
                      echo "helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE uninstall movie-db-develop --namespace develop;"
                      echo "sleep 10;"
                      
                      echo  "\n\n### Verify deleting the helm chart movie-db-develop on the branch: $name_branch on the environment:  $name_branch, with cmd : \n$: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;";
                      helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls;
                      
                      
                      
                      echo  "\n\n######################## DELETE MOVIE-FASTAPI-WEB"
                      
                      
                      
                      
                      echo  "\n\n######################## DELETE PROXY-NGINX-WEB" 

                      '''
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
      echo "### This will run if the job succeed"
      mail to: "cristofe.pascale@gmail.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has succed",
        body: "For more info on the pipeline success, check out the console output at ${env.BUILD_URL}"
                }
    failure {
      echo "### This will run if the job failed"
      mail to: "cristofe.pascale@gmail.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
        body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    }
  // ..
  }
}
