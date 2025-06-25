  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
  //
  // ## VERSIONS
  // ### 21/06/2025 16:27 : Remplacement des cmd docker file par le docker compose dans le satge Docker run
  // ### /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/ARCHIVES/Jenkinsfile_V5_Dckr_cmd_20250621.1330 : version av ec cmd docker


pipeline {
  agent any // Jenkins will be able to select all available agents
  environment { // Declaration of environment variables
    nom='datascientest'                                                    // nom="datascientest"
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
          sh '''
            pwd
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE1
            docker build -t $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG $URL_REP_DCKR_FAT_MOVIE
            docker rm -f $DOCKER_ID/$DOCKER_IMAGE2
            docker build -t $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG $URL_REP_DCKR_FAT_CAST
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
    stage('Deploiement en dev'){
      environment {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
        CACRT= credentials("cacrt") // we retrieve  kubeconfig from secret file called config saved on jenkins
        CLIENTCRT = credentials("clientcrt") // we retrieve  kubeconfig from secret file called config saved on jenkins
        CLIENTKEY = credentials("clientkey") // we retrieve  kubeconfig from secret file called config saved on jenkins
      }
      steps {
        script {
          // withKubeConfig(caCertificate: '', clusterName: 'k3d-mycluster', contextName: 'k3d-mycluster', credentialsId: 'k8s-jenkins-secret', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://0.0.0.0:41521') {
    // some block
                // helm upgrade --install app fastapi --values=values.yml --namespace dev
                // cf B52 helm --kubeconfig : https://helm.sh/docs/helm/helm/
                // kubectl --kubeconfig /usr/local/k3s.yaml apply -f fastapi-cast.yaml
                //             sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml

            //helm upgrade --kubeconfig /usr/local/k3s.yaml --install fastapi-dev /charts --namespace dev --create-namespace
            //             cp /fastapi/values-dev.yaml /fastapiapp/values.yaml
            // cat /fastapiapp/values.yaml
            // sudo sed -i 's+cpa+'jenkins'+g' /home/jenkins/.minikube/config
            // 1) delete and restart minikube from pc developper on minikube server
            // ssh -i $url_id_rsa_cpa cpa@$ip_minikube  'minikube delete --all'
            // sleep 15
            // ssh -i $url_id_rsa_cpa cpa@$ip_minikube  'minikube start --apiserver-ips=192.168.1.83 --listen-address=0.0.0.0 --cpus max --memory 5120mb'
            // sleep 15
            //
            // 2) Create config file and copy variables and certificate files mentionned on the config filez of the cluster minikube  to enable access of jenkins server on minikube cluster saved on minikube server (5.1.2.3)
            //   echo -e "\n####        5.1.2.5) Save number of access port of minikube server used to connect on minikube cluster 8443 with cmd : \n $: port=$(echo $(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker port minikube' | grep 8443) | tail -c-6); echo $port;"
            //
            // echo -e "\n####        5.1.2.6) Save ip of minikube server with cmd : \n $: ip_minikube2=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube ip'); echo $ip_minikube;"
            // ip_minikube2=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube ip')
            //
            // echo -e "\n####        5.1.2.15) Copy config file of the minikub cluster with cmd : \n $: echo "$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl config view --raw --flatten')" >  $url_pccpa_dir_kconfig/config"
            //
            // echo -e "\n####          5.1.3) Copy ./$filename_pccpa_kconfig  to ./$filename_pccpa_kconfig2 and update ./$filename_pccpa_kconfig2 replace ip_minikube_cluster by ip_minikube_server with cmd : \n $: cd $url_pccpa_dir_kconfig; \n pwd; \n ls -lha; \n cp $url_pccpa_dir_kconfig/config $url_pccpa_dir_kconfig/config2; \n cat $url_pccpa_dir_kconfig/config2; \nsed 's+'$ip_minikube2':8443+'$ip_minikube:$port'+g' -i $url_pccpa_dir_kconfig/config2; \n pwd; \n ls -lha; \n cat $url_pccpa_dir_kconfig/config2"

          sh '''
            echo "Create configuration files to enable jenkins server to connect to cluster of the minikube server  with kubectl cmd" 
            mkdir -p /home/jenkins/.minikube/profiles/minikube/
            ls -lha /home/jenkins/.minikube/profiles/minikube/
            cat $KUBECONFIG > $URL_FILE_CONFIG_MINIKUBE
            whoami
            pwd
            hostname -I
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get nodes

          '''

          sh '''
            echo "Deploy helm chart on DEV environment" 
            cd $URL_REP_HELM_FAT_CAST_DB
            # cp /fastapi/values-dev.yaml /fastapiapp/values.yaml
            
            echo "manifest k8s to deploy persistent volume with cmd : cat ./environments/dev/ns.k8s.cast.db.dev.yaml" 
            cat ./environments/dev/ns.k8s.cast.db.dev.yaml
            echo "manifest k8s to deploy persistent volume with cmd : cat ./environments/dev/pv.k8s.cast.db.dev.yaml" 
            cat ./environments/dev/pv.k8s.cast.db.dev.yaml
            echo "manifest k8s to deploy persistent volume with cmd : cat ./environments/dev/pvc.k8s.cast.db.dev.yaml" 
            cat ./environments/dev/pvc.k8s.cast.db.dev.yaml
            echo "manifest k8s to deploy persistent volume with cmd : cat ./environments/dev/secrets.k8s.cast.db.dev.yaml" 
            cat ./environments/dev/secrets.k8s.cast.db.dev.yaml
                    
            echo -e "\n####             11.7.2.1) List namespaces of the cluster minikube with cmd : \n $: kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns -A -o wide" 
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns -A -o wide

            echo -e "\n####             11.7.7.1)  List helm charts deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  ls"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  ls

            echo -e "\n####             11.7.7.2)  Add the Helm repository  and Update the Helm repository: :$ \n helm repo add bitnami https://charts.bitnami.com/bitnami; helm repo update;"

            echo -e "\n####             11.7.7.2.1) Add repo bitnami with cmd : \n $: helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  repo add bitnami https://charts.bitnami.com/bitnami;"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  repo add bitnami https://charts.bitnami.com/bitnami;

            echo -e "\n####             11.7.7.2.2) Update repo bitnami with cmd : \n $: 'helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  repo update;"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  repo update;

            echo -e "\n####             11.7.7.2.3) List repo bitnami present on the jenkins servr with cmd : \n $: 'helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  repo ls;"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  repo ls;

            echo -e "\n####             11.7.8)  Deploy namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE  get ns -A -o wide"
          
            echo -e "\n####             11.7.7.8.1) List helm charts deployed from the jenkins server on minikube servr with cmd : \n $: 'helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  ls -A;"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  ls -A;
            pwd

            echo -e "\n####             11.7.8.2) Deploy on namespace dev from the jenkins server on minikube srvr the cast-db-charts(dev postgrersql database uised by fastapi-cast with the cmd ) : \n $: kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE  get ns -A -o wide"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls -A;
            test_dep=$(helm --kubeconfig /home/jenkins/.minikube/config ls -A -q);
            echo $test_dep;
            [ -z "$test_dep" ] && echo "Empty" ||   helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE delete -n dev cast-db-charts-dev
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls -A

            # helm install --kubeconfig $URL_FILE_CONFIG_MINIKUBE  cast-db-charts-dev bitnami/postgresql --set persistence.existingClaim=postgresql-pv-claim --set volumePermissions.enabled=true --namespace dev --create-namespace -f $URL_REP_HELM_FAT_CAST_DB/environments/dev/values.charts.cast.db.dev.yaml
            helm install --kubeconfig $URL_FILE_CONFIG_MINIKUBE  cast-db-charts-dev bitnami/postgresql --set persistence.existingClaim=postgresql-pv-claim --set volumePermissions.enabled=true --namespace dev --create-namespace --values=$URL_REP_HELM_FAT_CAST_DB/environments/dev/values.charts.cast.db.dev.yaml  -f $URL_REP_HELM_FAT_CAST_DB/environments/dev/secrets.k8s.cast.db.dev.yaml -f $URL_REP_HELM_FAT_CAST_DB/environments/dev/pv.k8s.cast.db.dev.yaml -f $URL_REP_HELM_FAT_CAST_DB/environments/dev/pvc.k8s.cast.db.dev.yaml


            echo -e "\n####             11.7.8.3) List persistent volumes with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pv -A"
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pv -A 
            
            echo -e "\n####             11.7.8.4) List helm charts deployed from the jenkins server on minikube servr with cmd : \n $: 'helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  ls -n dev;"
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE  ls -n dev;

            echo -e "\n####             11.7.8.5) List namespaces with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns -n dev"
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns dev



            echo -e "\n####             11.7.8.6) List persistent volume claims with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pvc -n dev"
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pvc -n dev

            echo -e "\n####             11.7.8.7) List secrets with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get secrets -n dev"
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get secrets -n dev

            echo -e "\n####             11.7.8.8) List services with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get svc -n dev"
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get svc -n dev

            echo -e "\n####             11.7.8.9) List pods with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pods -n dev"
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pods -n dev





            echo -e "\n####             11.7.10.20) Delete every element from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE delete ns dev; \nkubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns -n dev;  \nkubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns dev"

            echo -e "\n####             11.7.10.20.1) Delete cast-db-charts-dev helm release with cmd : \n $: test_dep=$(helm --kubeconfig /home/jenkins/.minikube/config ls -A -q); \n echo $test_dep; [ -z \"$test_dep\" ] && echo \"Empty\" ||   helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE delete -n dev cast-db-charts-dev; \nhelm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls -A"

            test_dep=$(helm --kubeconfig /home/jenkins/.minikube/config ls -A -q);
            echo $test_dep;
            [ -z "$test_dep" ] && echo "Empty" ||   helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE delete -n dev cast-db-charts-dev;
            helm --kubeconfig $URL_FILE_CONFIG_MINIKUBE ls -A;

            echo -e "\n####             11.7.10.20.2) Delete ns dev with cmd : \n $:   test_dep=$(kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns dev --no-headers=true); \n [ -z \"$test_dep\" ] && echo \"Empty\" ||   kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE delete ns dev;"
            test_dep=$(kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns dev --no-headers=true);
            [ -z "$test_dep" ] && echo "Empty" ||   kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE delete ns dev;

            echo -e "\n####             11.7.10.20.3) List namespaces with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns -A -o wide "
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get ns -A -o wide;

            echo -e "\n####             11.7.10.20.3) List persistent volumes with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pv -A -o wide "
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pv -A -o wide;

            echo -e "\n####             11.7.10.20.3) List persistent volume claims with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pvc -A -o wide "
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pvc -A -o wide;

            echo -e "\n####             11.7.10.20.3) List secrets with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get secrets -A -o wide "
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get secrets -A -o wide;

            echo -e "\n####             11.7.10.20.3) List services with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get svc -A -o wide "
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get svc -A -o wide;

            echo -e "\n####             11.7.10.20.3) List pods with cmd : \n $:  kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pods -A -o wide "
            kubectl --kubeconfig $URL_FILE_CONFIG_MINIKUBE get pods -A -o wide;
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
