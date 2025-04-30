# dm-ds-cdo-may24-jenkins

## Prerequisites
### P1) The folow softwares must be installed on the  local machine:  

1. git
2. docker and his plugin docker compose
3. k3d
4. helm  
<br>
### P2) Verify all these softwares are well installed
```md
sudo git version 

sudo docker version
sudo docker compose version 
which docker
sudo systemctl status docker

sudo k3d version 

sudo helm version
```
### P3) Move to work directory
```md
cd /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins
```

### P4) Synchronize Github repo with local directoy of project
```md
ssh-add ../.ssh/ssh-key-github-cpa8876
git branch -a
git status
git add .
git commit -m "update file ./Docker-composez.yaml to delete blank rom on volume bloc"
git push origin main
```
### P5) Create the docker network "network create dm-jenkins-cpa-infra_my-net"

```md
sudo docker network ls
sudo docker network create dm-jenkins-cpa-infra_my-net
sudo docker network ls
```
### P6) Build container docker of jenkins server 

```md
sudo docker ps -a
sudo docker compose down
sudo docker compose up -d
sudo docker ps -a
```

### P7) Log on  jenkins server 

Log on  [192.168.20.1:8280](192.168.20.1:8280) in firefox private mode
![Screenshot log to jenkins server](./img/Login-jenkins-server.png
  "log jenkins server")
<br>
<br>
Log on [http://192.168.20.1:8280/](http://192.168.20.1:8280/)
![Dashboard Jenkins server](./img/tdb-jenkins-srvr.png  "Dashboard Jenkins server")
<br>
### P8) Log on Github repo of jenkins homework  
Log on [https://github.com/cpa8876/dm-ds-cdo-may24-jenkins#](https://github.com/cpa8876/dm-ds-cdo-may24-jenkins#) 
![Log on github cpa8876](./img/log-on-github-cpa8876.png  "Log github cpa8876")
<br>
<br>
Log on [https://github.com/cpa8876/dm-ds-cdo-may24-jenkins](https://github.com/cpa8876/dm-ds-cdo-may24-jenkins)
![Dashboard Github cpa8876](./img/tdb-github-cpa8876.png  "Dashboard Github cpa8876")

### P9) Log on Dockerhub repo of jenkins homework  
Log on [Dockerhub](https://hub.docker.com/repositories/dmcpa8876)

![Log on dockerhub cpa8876](./img/log-on-dockerhub-cpa8876.png "Log dockerhub cpa8876")
<br>
<br>
Log on [https://hub.docker.com/repositories/cpa8876](https://hub.docker.com/repositories/cpa8876)
![Dashboard Dockerhub cpa8876](./img/tdb-repo-dockerhub-cpa8876.png  "Dashboard dockrhub cpa8876")
<br>
### Step 1)  Create a directory for the homework
```md
mkdir -p DM-SP04-C04-JENKINS-CPA-MAY2024
cd   ./DM-SP04-C04-JENKINS-CPA-MAY2024
```
<br>
### Step 2) Create Dockerhub account
#### S-2.1) Create a repository Docker hub : "cpa8876"

#### S-2.2) Create this docker images
##### S-2.2.1)  docker image for the application fastapi to manage movies :
`sudo docker push cpa8876/movies-dm-ds-jenkins-fastapi:tagname`

##### S-2.2.2)  docker image for th database useb by movies-dm-ds-jenkins-fastap:
`sudo docker push cpa8876/db-movies-dm-ds-jenkins-fastapi:tagname`

##### S-2.2.3)  application fastapi to manage casts :
`sudo docker push cpa8876/casts-dm-ds-jenkins-fastapi:tagname`

##### S-2.2.2)  docker image for the database useb by casts-dm-ds-jenkins-fastapi:
```md 
sudo docker push cpa8876/db-casts-dm-ds-jenkins-fastapi:tagname
docker push dmcpa8876/dm-jenkins-cpa8876-fastapi:tagname \
https://hub.docker.com/repositories/dmcpa8876
```

<br>
### Step 3) Create Github account and a repository for homework
#### S-3.1) Url  repo github of homework  [github cpa8876 for jenkins homework]( https://github.com/cpa8876/) 
  
#### S-3.2) Url to clone this repo  : 
`git clone https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git`

#### S-3.3) Generate with sshgen and save a pair of ssh keys to connect to the Github account 
Url where is saved  this keypair ssh access github repo:  ./.ssh/ssh-key-github-cpa8876 and ssh-key-github-cpa8876.pub`

<br>
### Step 4) Clone repo github jenkins datascientest homeworks
#### S-4.1) the fisrt time :

##### S-4.1.1) Clone the repository github datascientest included files for the jenkins homework.
```md
git clone https://github.com/DataScientest/Jenkins_devops_exams.git
git status
git branch -a
```
##### S-4.1.2) Clone the dm jenkins Github repo to my PC
```md
cd ~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins
ssh -add ../.ssh/ssh-key-github-cpa8876
  
git clone https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git
  
ls -lha
=> total  20K
drwxr-xr-x  5 cpa cpa 4,0K 24 avril 16:05 .
drwxr-xr-x 16 cpa cpa 4,0K 24 avril 16:04 ..
drwxr-xr-x  7 cpa cpa 4,0K 24 avril 16:06 dm-ds-cdo-may24-jenkins
drwxr-xr-x  6 cpa cpa 4,0K 15 avril 23:24 Jenkins_devops_exams
drwxr-xr-x  5 cpa cpa 4,0K 25 mars  22:00 .ssh
```

##### S-4.1.3) Create the first version of README.md to test Github cpa8876/dm-ds-cdo-may24-jenkins
```md
git  status
git  add README.md
git commit -m "Create README to explain architecture of my homework Jenkins version  1

git push origin main
```

#### S-4.2) Connect to github personal repository for the homework the second time and after
```md
cd ~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins
ssh-add ../.ssh/ssh-key-github-cpa8876
git status
git branch -a
```
<br>
###  Step 5)  Delete all docker containers and images 
 
#### S-5.1)  List all  dockers volumes, networks, images, and containers.
```md
sudo docker network ls
sudo docker volume ls
sudo docker image ls -a 
sudo docker ps -a
```
<br>
#### S-5.2)  Delete all  containers, images, volumes and  networks. .
```md
sudo docker rm -f $(sudo docker ps -aq)
sudo docker image rmi -f $(sudo docker image ls  -q)
sudo docker volume rm -f $(sudo docker volume ls -q)
sudo docker network rm  $(sudo docker network ls -q)
```

#### S-5.3)  Verify the deletion of  all  dockers networks, volumes,  images and containers.
```md
sudo docker network ls
sudo docker volume ls
sudo docker image ls -a
sudo docker ps -a
```

### Step 6)  Create a script shell file "init-k3d.sh" to create my infrastructure 

This script create an infrastructuture with:  
- one server jenkins,  
- one loadbalancer to access to a cluster k3d  composed by :  
&nbsp; &nbsp; - one control master  
&nbsp; &nbsp; - and    two workers  
        
#### S-6.1)  Create a container Docker for jenkins with a Docker-compose.yml
```md
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/docker-compose.yml
version: '3'
name: <dm-jenkins-cpa-infra>

services:
  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8280:8080
      - 50000:50000
    container_name: jenkins
    restart: always
    environment:
      - KUBECONFIG="/usr/local/k3s.yaml

    volumes:
     # - /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/dm-ds-cdo-may24-jenkins5/datas/data-k3d:/datas/data-k3d
      - ./init-k3d.sh:/app/init-k3d.sh
      - /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/dm-ds-cdo-may24-jenkins5/datas/data-k3d/k3s_v2.yaml:/usr/local/k3s.yaml
      - /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/dm-ds-cdo-may24-jenkins5/dr01-python-microservices6:/app
      - /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/dm-ds-cdo-may24-jenkins5/fastapi:/fastapi
      - /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/dm-ds-cdo-may24-jenkins5/fastapiapp:/fastapiapp
      - /opt/jenkins-training/jenkins_compose/jenkins_configuration:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/run/docker-compose.sock:/var/run/docker-compose.sock
      - /var/run/kubectl.sock:/var/run/kubectl.sock
      - /var/run/helm.sock:/var/run/helm.sock
      - /usr/bin/docker:/usr/bin/docker
      - /usr/bin/docker-compose:/usr/bin/docker-compose
      - /usr/local/bin/kubectl:/usr/local/bin/kubectl
      - /usr/local/bin/helm:/usr/local/bin/helm

# https://forums.docker.com/t/docker-compose-cant-connect-to-existing-network/94370/13
    networks:
      #- my-net
      - dm-jenkins-cpa-infra_my-net

    # command: ["/app/init-k3d.sh"]

networks:
  dm-jenkins-cpa-infra_my-net:
    external: true
    driver: bridge
```
#### S-6.2) : Create a script shell « init-k3d.sh » to build all architecture and execute sudo docker compose up -d command

#### S-6.3) : Execute script shell « init-k3d.sh » to build all architecture and execute sudo docker compose up -d command
```md
cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins$ sudo docker ps -a
CONTAINER ID   IMAGE                            COMMAND                  CREATED         STATUS         PORTS                                                                                                                                                                          NAMES
6d9355f287d7   jenkins/jenkins:lts              "/usr/bin/tini -- /u…"   2 minutes ago   Up 2 minutes   0.0.0.0:50000->50000/tcp, [::]:50000->50000/tcp, 0.0.0.0:8280->8080/tcp, [::]:8280->8080/tcp                                                                                   jenkins
a529bb43b3c1   ghcr.io/k3d-io/k3d-proxy:5.8.3   "/bin/sh -c nginx-pr…"   3 minutes ago   Up 3 minutes   80/tcp, 0.0.0.0:34389->6443/tcp, 0.0.0.0:8900->30080/tcp, [::]:8900->30080/tcp, 0.0.0.0:8901->30081/tcp, [::]:8901->30081/tcp, 0.0.0.0:8902->30082/tcp, [::]:8902->30082/tcp   k3d-mycluster-serverlb
27c924c01aef   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   3 minutes ago   Up 3 minutes                                                                                                                                                                                  k3d-mycluster-agent-1
2b0ad4c23daf   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   3 minutes ago   Up 3 minutes                                                                                                                                                                                  k3d-mycluster-agent-0
c8f9641dcd22   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   3 minutes ago   Up 3 minutes                                                                                                                                                                                  k3d-mycluster-server-0
cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins$ sudo kubectl get all -n dev
No resources found in dev namespace.
cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins$ sudo kubectl get nodes
NAME                     STATUS   ROLES                  AGE     VERSION
k3d-mycluster-agent-0    Ready    <none>                 3m58s   v1.31.5+k3s1
k3d-mycluster-agent-1    Ready    <none>                 3m58s   v1.31.5+k3s1
k3d-mycluster-server-0   Ready    control-plane,master   4m7s    v1.31.5+k3s1
```
<br>
### Step 7)  Connect with firefox on the jenkins server http://192.168.20.1:8280

#### S-7.1) Access on jenkins server
![ ](img/jenkins-login.png)

#### S-7.2) Install plugins
1. plugins suggered on initialisation of jenkins server
2. Github integration
3. Pipeline stage view
4.  Email Extension Plugin Version 1876.v28d8d38315b_d 

#### S-7.3) Install pluginsScreenshots of installed plugins
![ ](img/jenkins-plugins-installed.png)

#### S-7.4) Create a Jenkins API token
Create a Jenkins API token
First, we going to generate a Jenkins API token which will be used by the webhook to communicate with the Jenkins build job.
Go to Jenkins home page > Click on your name > Configure > Add new token
Give the new token a name and remember to copy and save the API token.

http://192.168.20.1:8280/job/dm-jenkins-ci-cd/configure
Jeton d'authentification:  wh-cpa8876

#### S-7.5) Configure personnal access token access to dockerhub  in secret variable system on jenkins

https://app.docker.com/settings/personal-access-tokens 
Access token description
DAT
Expires on
Never
Access permissions
Read, Write, Delete
![ ](img/dockerhub-token.png)


#### S-7.6) Configure the token dockerhub in secret variable system on jenkins

http://192.168.20.1:8280/manage/credentials/store/system/domain/_/newCredentials
Type : Secret text
Portée Global (Jenkins, agent, items,etc…)
Secret : 
id : token_dockerhub
Description : token_dockerhub for the dm Jenkins
![ ](img/secret-token-dockerhub.png)

<br>
### Step 8 : Create a docker for the server jenkins and a specific network. 

#### S-8.1) Create a docker network "dm-jenkins-cpa-infra_my-net", that will be used by the containers of "jenkins" server and the cluster k3d composed with a control master and 2 worker and a loadbalancer
```md
sudo docker network rm d dm-jenkins-cpa-infra_my-net
sudo docker network create dm-jenkins-cpa-infra_my-net
 sudo docker network ls
```

#####S-8.2) Create the docker infrastructure composed by a server jenkins, a cluster k3d composed one loadbalancer server, a control master and 2 workers
```md
sudo docker compose down
sudo docker compose up -d
```

###### S-8.2.1) List  the docker  containers, images, volumes and networks.
```md
sudo docker ps -a
sudo docker image ls -a
sudo docker volume ls 
sudo docker network ls 
```

###### S-8.2.1)  Connect on the container docker jenkins and verify docker commands.
```md
 sudo docker exec -it jenkins bash

 docker ps -a
docker image ls -a
docker volume ls 
docker network ls 

 ls -lha /app/
exit
```

<br>
### Step 9)  Test docker compose fastapi applications with ./dr01-python-microservices6/docker-compose .yaml
#### S-9.1) Execute : « docker compose up -d » from /dr01-python-microservices6/
```md
cd dr01-python-microservices6/
sudo docker compose up -d
```

#### S-9.2)  Test movies api from 192.168.20.1:8001
- Test curl 
```md
 curl http://192.168.20.1:8001/api/v1/movies/docs 

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/movies/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
```

- Screenshot from firefox
http://192.168.20.1:8001/api/v1/movies/docs 
![ ](img/8001-api-v1-movies-docs.png)

#### S-9.3)  Test movies api from 192.168.20.1:8080
- Test curl 
```md
curl http://192.168.20.1:8080/api/v1/movies/docs

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/movies/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
```

- Screenshot from firefox
http://192.168.20.1:8080/api/v1/movies/docs 
![ ](img/8080-api-v1-movies-docs.png)

#### S-9.3)  Test casts api from 192.168.20.1:8002
- Test curl 
```md
curl http://192.168.20.1:8002/api/v1/casts/docs 

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/casts/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
```

- Screenshot from firefox
http://192.168.20.1:8002/api/v1/casts/docs
![ ](img/8002-api-v1-casts-docs.png) 

#### S-9.4)  Test casts api from 192.168.20.1:8080
- Test curl 
```md
curl http://192.168.20.1:8080/api/v1/casts/docs

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/casts/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
```

- Screenshot from firefox
http://192.168.20.1:8080/api/v1/casts/docs 
![ ](img/8080-api-v1-casts-docs.png)

<br>
### Step 10)  Test des charts helm fastapi applications with /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/charts/Chart.yaml
- Test curl 
```md


```
### Step 11)  Create jenkinsfile and execute pipeline CI
#### S-11.1) Build : « ./Jenkinsfile » from /dr01-python-microservices6/
-  ./Jenkinsfile
```md
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
        // cast_db_username:cast_db_password@cast_db/cast_db_dev cpa8876/casts-ds-fastapi:v.4.0 uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
        // movie_db_username:movie_db_password@movie_db/movie_db_dev -e CAST_SERVICE_HOST_URL=http://cast_service:8000/api/v1/casts/ cpa8876/movies-ds-fastapi:v.4.0 uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
          sh '''
            cd /app
            docker volume create postgres_data_movie
            docker volume create postgres_data_cast
            docker run -d --name cast_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_cast:/var/lib/postgresql/data/ -e POSTGRES_USER=cast_db_username -e POSTGRES_PASSWORD=cast_db_password -e POSTGRES_DB=cast_db_dev --health-cmd "CMD-SHELL,pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}" --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine
            sleep 6
            docker run -d --name cast_service --net dm-jenkins-cpa-infra_my-net -p 8002:8000 -e DATABASE_URI=postgresql://cast_db_username:cast_db_password@cast_db/cast_db_dev $DOCKER_ID/$DOCKER_IMAGE2:$DOCKER_TAG uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
            sleep 2
            docker run -d  --name movie_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_movie:/var/lib/postgresql/data/ -e POSTGRES_USER=movie_db_username -e POSTGRES_PASSWORD=movie_db_password -e POSTGRES_DB=movie_db_dev --health-cmd "CMD-SHELL,pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}" --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine &
            sleep 6
            docker run -d --name movie_service --net dm-jenkins-cpa-infra_my-net -p 8001:8000 -e DATABASE_URL=postgresql://movie_db_username:movie_db_password@movie_db/movie_db_dev -e CAST_SERVICE_HOST_URL=http://cast_service:8000/api/v1/casts/ $DOCKER_ID/$DOCKER_IMAGE1:$DOCKER_TAG uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
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
            echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
            docker exec cast_db psql -h localhost -p 5432 -U cast_db_username -d cast_db_dev -c "select * from pg_database"
            echo -e "\n\n Test-02 : curl on ip-cast_service:8000/api/v1/casts/docs"
            curl $(docker exec cast_service hostname -i):8000/api/v1/casts/docs
            echo -e "\n Test-03 : Sql query on movie_db : select * from pg_database :"
            docker exec movie_db psql -h localhost -p 5432 -U movie_db_username -d movie_db_dev -c "select * from pg_database"
            echo -e "\n\n Test-04 : curl on ip-movie_service:8000/api/v1/casts/docs"
            curl $(docker exec movie_service hostname -i):8000/api/v1/movies/docs
            echo -e "\n\n Test-05 : curl on ip-nginx:8080/api/v1/movies/docs"
            curl $(docker exec nginx hostname -i):8080/api/v1/movies/docs
            echo -e "\n\n Test-06 : curl on ip-nginx:8080/api/v1/casts/docs"
            curl $(docker exec nginx hostname -i):8080/api/v1/casts/docs
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

            docker rm -f nginx movie_service movie_db cast_service cast_db
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
```

#### S-11.2) Screenshots after execute the pipeline with Jenkinsfile: « ./Jenkinsfile » from /dr01-python-microservices6/  
<br>
-  Stage view from Jenkinsfile
![Screenshot from dashborad on pipeline Jenkins dm2 jenkins](./img/tdb-test24-dm2-jenkins.png  "Dashboard test24dm2-jenkins pipeline")
<br>
<br>
-  Screenshot of the console output Tableau de bord / dm2-jenkins #24 view from Jenkinsfile : console-output-test24-dm2-jenkins.png
![Extract frome test acceptance from console-output-test24-dm2-jenkins.png](./img/console-output-test24-dm2-jenkins.png  "Scrennshot extract from consople output test24-dm2")

- Terminal execution pipeline 24
```md
Started by user cpa
Obtained Jenkinsfile from git https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/jenkins_home/workspace/dm2-jenkins
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
The recommended git tool is: git
No credentials specified
 > git rev-parse --resolve-git-dir /var/jenkins_home/workspace/dm2-jenkins/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git # timeout=10
Fetching upstream changes from https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git
 > git --version # timeout=10
 > git --version # 'git version 2.39.5'
 > git fetch --tags --force --progress -- https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 51f1f303e3fcdb7bb934ac72120700be34b60ab6 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 51f1f303e3fcdb7bb934ac72120700be34b60ab6 # timeout=10
Commit message: "update file Jenkinsfile to add Tests acceptance CRUD casts fastapi application"
 > git rev-list --no-walk 9f118b060dde41a63df43daca1fece4229129f44 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Docker Build)
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ cd /app/movie-service
+ docker rm -f cpa8876/movies-ds-fastapi
Error response from daemon: No such container: cpa8876/movies-ds-fastapi
+ docker build -t cpa8876/movies-ds-fastapi:v.24.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon   25.6kB

Step 1/6 : FROM python:3.8-slim
 ---> b5f62925bd0f
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 4c8b39cf70f0
Step 3/6 : COPY ./requirements.txt /app/requirements.txt
 ---> Using cache
 ---> a6ebcc85c827
Step 4/6 : RUN apt-get update     && apt-get install gcc -y     && apt-get clean
 ---> Using cache
 ---> 45b551dd00e1
Step 5/6 : RUN pip install -r /app/requirements.txt     && rm -rf /root/.cache/pip
 ---> Using cache
 ---> ce5a5e48b597
Step 6/6 : COPY . /app/
 ---> Using cache
 ---> cae8f07ecd77
Successfully built cae8f07ecd77
Successfully tagged cpa8876/movies-ds-fastapi:v.24.0
+ cd /app/cast-service
+ docker rm -f cpa8876/casts-ds-fastapi
Error response from daemon: No such container: cpa8876/casts-ds-fastapi
+ docker build -t cpa8876/casts-ds-fastapi:v.24.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  20.99kB

Step 1/6 : FROM python:3.8-slim
 ---> b5f62925bd0f
Step 2/6 : WORKDIR /app
 ---> Using cache
 ---> 4c8b39cf70f0
Step 3/6 : COPY ./requirements.txt /app/requirements.txt
 ---> Using cache
 ---> 8b9d7b1abc7d
Step 4/6 : RUN apt-get update     && apt-get install gcc -y     && apt-get clean
 ---> Using cache
 ---> f364ed3dab48
Step 5/6 : RUN pip install -r /app/requirements.txt     && rm -rf /root/.cache/pip
 ---> Using cache
 ---> b074cae8898e
Step 6/6 : COPY . /app/
 ---> Using cache
 ---> 13c6753885ff
Successfully built 13c6753885ff
Successfully tagged cpa8876/casts-ds-fastapi:v.24.0
+ docker image ls -a
+ grep fastapi
cpa8876/casts-ds-fastapi    v.10.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.11.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.12.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.13.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.14.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.15.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.16.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.17.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.18.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.19.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.20.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.21.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.22.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.24.0        13c6753885ff   2 hours ago    462MB
cpa8876/casts-ds-fastapi    v.9.0         13c6753885ff   2 hours ago    462MB
cpa8876/movies-ds-fastapi   v.10.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.11.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.12.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.13.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.14.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.15.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.16.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.17.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.18.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.19.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.20.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.21.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.22.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.24.0        cae8f07ecd77   2 hours ago    469MB
cpa8876/movies-ds-fastapi   v.9.0         cae8f07ecd77   2 hours ago    469MB
+ sleep 6
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Docker run)
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ cd /app
+ docker volume create postgres_data_movie
postgres_data_movie
+ docker volume create postgres_data_cast
postgres_data_cast
+ docker run -d --name cast_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_cast:/var/lib/postgresql/data/ -e POSTGRES_USER=cast_db_username -e POSTGRES_PASSWORD=cast_db_password -e POSTGRES_DB=cast_db_dev --health-cmd CMD-SHELL,pg_isready -U  -d  --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine
d95225895c142067b2c62d66d6f0560006ffbc849d40f62b90c700bd02df3b50
+ sleep 6
+ docker run -d --name cast_service --net dm-jenkins-cpa-infra_my-net -p 8002:8000 -e DATABASE_URI=postgresql://cast_db_username:cast_db_password@cast_db/cast_db_dev cpa8876/casts-ds-fastapi:v.24.0 uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
30c4e4692d42b75e0e4b5626a4d39ca7379f2f16b5a3575fd4c008c6fff9db05
+ sleep 2
+ sleep 6
+ docker run -d --name movie_db --net dm-jenkins-cpa-infra_my-net -v postgres_data_movie:/var/lib/postgresql/data/ -e POSTGRES_USER=movie_db_username -e POSTGRES_PASSWORD=movie_db_password -e POSTGRES_DB=movie_db_dev --health-cmd CMD-SHELL,pg_isready -U  -d  --health-interval 10s --health-retries 5 --health-start-period 30s --health-timeout 10s postgres:12.1-alpine
9ac079857971dab5e3a9062ae7946e46fed5e70a7715abba3a995e40e86e3c12
+ docker run -d --name movie_service --net dm-jenkins-cpa-infra_my-net -p 8001:8000 -e DATABASE_URL=postgresql://movie_db_username:movie_db_password@movie_db/movie_db_dev -e CAST_SERVICE_HOST_URL=http://cast_service:8000/api/v1/casts/ cpa8876/movies-ds-fastapi:v.24.0 uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
6c99e8ee3d0f09c654cc98bf7a1a36330eef40ba4beedf9a84845a26a50c48bc
+ sleep 2
+ docker run -d --name nginx --net dm-jenkins-cpa-infra_my-net -p 8080:8080 nginx:latest
4ad3e7540f17ab70a9da94e4878e0cf59d83ce045914423bca2ebf694c6a56ee
+ docker cp nginx_config.conf nginx:/etc/nginx/conf.d/default.conf
+ docker restart nginx
nginx
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test Acceptance)
[Pipeline] script
[Pipeline] {
[Pipeline] sh
+ apt update -y

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Hit:1 http://deb.debian.org/debian bookworm InRelease
Hit:2 http://deb.debian.org/debian bookworm-updates InRelease
Get:3 http://deb.debian.org/debian-security bookworm-security InRelease [48.0 kB]
Fetched 48.0 kB in 0s (285 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.
+ apt full-upgrade-y

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

E: Invalid operation full-upgrade-y
+ echo -e 

 -------------------------------------------------------------------
-e 

 -------------------------------------------------------------------
+ echo -e Tests acceptance access on contenaires  cast_db, movie_db, cast _sezrvice, movie_service and loadbalancer
  
-e Tests acceptance access on contenaires  cast_db, movie_db, cast _sezrvice, movie_service and loadbalancer
  
+ echo -e 

 ------------------------------------------
-e 

 ------------------------------------------
+ echo -e 
 Test-01 : Sql query on cast_db : select * from pg_database :
-e 
 Test-01 : Sql query on cast_db : select * from pg_database :
+ docker exec cast_db psql -h localhost -p 5432 -U cast_db_username -d cast_db_dev -c select * from pg_database
  oid  |   datname   | datdba | encoding | datcollate |  datctype  | datistemplate | datallowconn | datconnlimit | datlastsysoid | datfrozenxid | datminmxid | dattablespace |                           datacl                            
-------+-------------+--------+----------+------------+------------+---------------+--------------+--------------+---------------+--------------+------------+---------------+-------------------------------------------------------------
 13423 | postgres    |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13422 |          480 |          1 |          1663 | 
 16384 | cast_db_dev |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13422 |          480 |          1 |          1663 | 
     1 | template1   |     10 |        6 | en_US.utf8 | en_US.utf8 | t             | t            |           -1 |         13422 |          480 |          1 |          1663 | {=c/cast_db_username,cast_db_username=CTc/cast_db_username}
 13422 | template0   |     10 |        6 | en_US.utf8 | en_US.utf8 | t             | f            |           -1 |         13422 |          480 |          1 |          1663 | {=c/cast_db_username,cast_db_username=CTc/cast_db_username}
(4 rows)

+ echo -e 

 Test-02 : curl on ip-cast_service:8000/api/v1/casts/docs
-e 

 Test-02 : curl on ip-cast_service:8000/api/v1/casts/docs
+ docker exec cast_service hostname -i
+ curl 172.18.0.4:8000/api/v1/casts/docs
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   911  100   911    0     0   901k      0 --:--:-- --:--:-- --:--:--  889k

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/casts/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
    + echo -e 
 Test-03 : Sql query on movie_db : select * from pg_database :
-e 
 Test-03 : Sql query on movie_db : select * from pg_database :
+ docker exec movie_db psql -h localhost -p 5432 -U movie_db_username -d movie_db_dev -c select * from pg_database
  oid  |   datname    | datdba | encoding | datcollate |  datctype  | datistemplate | datallowconn | datconnlimit | datlastsysoid | datfrozenxid | datminmxid | dattablespace |                             datacl                             
-------+--------------+--------+----------+------------+------------+---------------+--------------+--------------+---------------+--------------+------------+---------------+----------------------------------------------------------------
 13423 | postgres     |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13422 |          480 |          1 |          1663 | 
 16384 | movie_db_dev |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13422 |          480 |          1 |          1663 | 
     1 | template1    |     10 |        6 | en_US.utf8 | en_US.utf8 | t             | t            |           -1 |         13422 |          480 |          1 |          1663 | {=c/movie_db_username,movie_db_username=CTc/movie_db_username}
 13422 | template0    |     10 |        6 | en_US.utf8 | en_US.utf8 | t             | f            |           -1 |         13422 |          480 |          1 |          1663 | {=c/movie_db_username,movie_db_username=CTc/movie_db_username}
(4 rows)

+ echo -e 

 Test-04 : curl on ip-movie_service:8000/api/v1/casts/docs
-e 

 Test-04 : curl on ip-movie_service:8000/api/v1/casts/docs
+ docker exec movie_service hostname -i
+ curl 172.18.0.6:8000/api/v1/movies/docs
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   912  100   912    0     0   959k      0 --:--:-- --:--:-- --:--:--  890k

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/movies/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
    + echo -e 

 Test-05 : curl on ip-nginx:8080/api/v1/movies/docs
-e 

 Test-05 : curl on ip-nginx:8080/api/v1/movies/docs
+ docker exec nginx hostname -i
+ curl 172.18.0.7:8080/api/v1/movies/docs
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   912  100   912    0     0   926k      0 --:--:-- --:--:-- --:--:--  890k

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/movies/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
    + echo -e 

 Test-06 : curl on ip-nginx:8080/api/v1/casts/docs
-e 

 Test-06 : curl on ip-nginx:8080/api/v1/casts/docs
+ docker exec nginx hostname -i
+ curl 172.18.0.7:8080/api/v1/casts/docs
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   911  100   911    0     0   711k      0 --:--:-- --:--:-- --:--:--  889k

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/api/v1/casts/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true
    })
    </script>
    </body>
    </html>
    + echo -e 

 -------------------------------------------------------------------
-e 

 -------------------------------------------------------------------
+ echo -e Tests acceptance CRUD movies fastapi with contenair nginx (loadbalancer) application
  
-e Tests acceptance CRUD movies fastapi with contenair nginx (loadbalancer) application
  
+ echo -e 

 ------------------------------------------
-e 

 ------------------------------------------
+ echo -e 

 Test-07 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=1 Star wars IX
-e 

 Test-07 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=1 Star wars IX
+ docker exec nginx hostname -i
+ curl -X POST 172.18.0.7:8080/api/v1/movies/ -H accept: application/json -H Content-Type: application/json -d {
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
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   272    0     0  100   272      0    226  0:00:01  0:00:01 --:--:--   226
100   482  100   210  100   272    167    217  0:00:01  0:00:01 --:--:--   384
{"id":1,"name":"Star Wars: Episode IX - The Rise of Skywalker","plot":"The surviving members of the resistance face the First Order once again.","genres":["Action","Adventure","Fantasy"],"casts_id":[1,2,3,4,5]}+ echo -e 

 Test-08 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=2 Star wars VI
-e 

 Test-08 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=2 Star wars VI
+ docker exec nginx hostname -i
+ curl -X POST 172.18.0.7:8080/api/v1/movies/ -H accept: application/json -H Content-Type: application/json -d {
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
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   337  100    21  100   316   5623  84627 --:--:-- --:--:-- --:--:--  109k
Internal Server Error+ echo -e 

 Test-09 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=3 Star wars V
-e 

 Test-09 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=3 Star wars V
+ docker exec nginx hostname -i
+ curl -X POST 172.18.0.7:8080/api/v1/movies/ -H accept: application/json -H Content-Type: application/json -d {
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
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   328  100    21  100   307   9341   133k --:--:-- --:--:-- --:--:--  160k
Internal Server Error+ echo -e 

 Test-10 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/
-e 

 Test-10 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/
+ docker exec nginx hostname -i
+ curl -X GET 172.18.0.7:8080/api/v1/movies/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   727  100   727    0     0   253k      0 --:--:-- --:--:-- --:--:--  354k
[{"id":2,"name":"Star Wars: Episode VI - Return of the Jedi","plot":"The evil Galactic Empire is building a new Death Star space station to permanently destroy the Rebel Alliance, its main opposition.","genres":["Action","Adventure","Fantasy"],"casts_id":[3,4,5]},{"id":3,"name":"Star Wars: Episode V - The Empire Strikes Back","plot":"Set three years after the events of Star Wars, the film recounts the battle between the malevolent Galactic Empire, ","genres":["Action","Adventure","Fantasy"],"casts_id":[3,4,5]},{"id":1,"name":"Star Wars: Episode IX - The Rise of Skywalker","plot":"The surviving members of the resistance face the First Order once again.","genres":["Action","Adventure","Fantasy"],"casts_id":[1,2,3,4,5]}]+ echo -e 

 Test-11 : curl -X GET id=1 on ip-nginx:8080/api/v1/movies/1
-e 

 Test-11 : curl -X GET id=1 on ip-nginx:8080/api/v1/movies/1
+ docker exec nginx hostname -i
+ curl -X GET 172.18.0.7:8080/api/v1/movies/1/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   210  100   210    0     0  70469      0 --:--:-- --:--:-- --:--:--  102k
{"id":1,"name":"Star Wars: Episode IX - The Rise of Skywalker","plot":"The surviving members of the resistance face the First Order once again.","genres":["Action","Adventure","Fantasy"],"casts_id":[1,2,3,4,5]}+ echo -e 

 Test-12 : curl -X PUT update id=1 on ip-nginx:8080/api/v1/movies/1
-e 

 Test-12 : curl -X PUT update id=1 on ip-nginx:8080/api/v1/movies/1
+ docker exec nginx hostname -i
+ curl -X PUT 172.18.0.7:8080/api/v1/movies/1 -H accept: application/json -H Content-Type: application/json -d {
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
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   252  100     4  100   248    946  58712 --:--:-- --:--:-- --:--:-- 63000
null+ echo -e 

 Test-13 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/
-e 

 Test-13 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/
+ docker exec nginx hostname -i
+ curl -X GET 172.18.0.7:8080/api/v1/movies/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   719  100   719    0     0   317k      0 --:--:-- --:--:-- --:--:--  351k
[{"id":2,"name":"Star Wars: Episode VI - Return of the Jedi","plot":"The evil Galactic Empire is building a new Death Star space station to permanently destroy the Rebel Alliance, its main opposition.","genres":["Action","Adventure","Fantasy"],"casts_id":[3,4,5]},{"id":3,"name":"Star Wars: Episode V - The Empire Strikes Back","plot":"Set three years after the events of Star Wars, the film recounts the battle between the malevolent Galactic Empire, ","genres":["Action","Adventure","Fantasy"],"casts_id":[3,4,5]},{"id":1,"name":"Star Wars: Episode IX - The Rise of Skywalker","plot":"The surviving members of the resistance face the First Order once again.","genres":["Action","Adventure","Fantasy"],"casts_id":[1]}]+ echo -e 

 Test-14 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/movies/1
-e 

 Test-14 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/movies/1
+ docker exec nginx hostname -i
+ curl -X DELETE 172.18.0.7:8080/api/v1/movies/1 -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100     4  100     4    0     0   1203      0 --:--:-- --:--:-- --:--:--  1333
null+ echo -e 

 Test-15 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/
-e 

 Test-15 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/
+ docker exec nginx hostname -i
+ curl -X GET 172.18.0.7:8080/api/v1/movies/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   516  100   516    0     0   208k      0 --:--:-- --:--:-- --:--:--  251k
[{"id":2,"name":"Star Wars: Episode VI - Return of the Jedi","plot":"The evil Galactic Empire is building a new Death Star space station to permanently destroy the Rebel Alliance, its main opposition.","genres":["Action","Adventure","Fantasy"],"casts_id":[3,4,5]},{"id":3,"name":"Star Wars: Episode V - The Empire Strikes Back","plot":"Set three years after the events of Star Wars, the film recounts the battle between the malevolent Galactic Empire, ","genres":["Action","Adventure","Fantasy"],"casts_id":[3,4,5]}]+ echo -e 

 -------------------------------------------------------------------
-e 

 -------------------------------------------------------------------
+ echo -e Tests acceptance CRUD casts fastapi application
  
-e Tests acceptance CRUD casts fastapi application
  
+ echo -e 

 ------------------------------------------
-e 

 ------------------------------------------
+ echo -e 

 Test-16 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/
-e 

 Test-16 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X POST http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json -H Content-Type: application/json -d {
  "name": "Adam Driver",
  "nationality": "USA"
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   100  100    49  100    51   5630   5860 --:--:-- --:--:-- --:--:-- 12500
{"name":"Adam Driver","nationality":"USA","id":1}+ echo -e 

 Test-17 : curl -X GET POST  create id=1 cast on ip-nginx:8080/api/v1/casts/
-e 

 Test-17 : curl -X GET POST  create id=1 cast on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X POST http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json -H Content-Type: application/json -d {
  "name": "Daisy Ridley",
  "nationality": "USA"
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   102  100    50  100    52  20056  20858 --:--:-- --:--:-- --:--:-- 51000
{"name":"Daisy Ridley","nationality":"USA","id":2}+ echo -e 

 Test-18 : curl -X POST create id=2 cast ALL on ip-nginx:8080/api/v1/casts/
-e 

 Test-18 : curl -X POST create id=2 cast ALL on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X POST http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json -H Content-Type: application/json -d {
  "name": "Carrie FISHER",
  "nationality": "USA"
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   104  100    51  100    53  18385  19105 --:--:-- --:--:-- --:--:-- 52000
{"name":"Carrie FISHER","nationality":"USA","id":3}+ echo -e 

 Test-19 : curl -X POST create id=3 cast on ip-nginx:8080/api/v1/casts/
-e 

 Test-19 : curl -X POST create id=3 cast on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X POST http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json -H Content-Type: application/json -d {
  "name": "Mark HAMILL",
  "nationality": "USA"
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   100  100    49  100    51  17632  18351 --:--:-- --:--:-- --:--:-- 50000
{"name":"Mark HAMILL","nationality":"USA","id":4}+ echo -e 

 Test-20 : curl -X POST create id=4 cast on ip-nginx:8080/api/v1/casts/
-e 

 Test-20 : curl -X POST create id=4 cast on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X POST http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json -H Content-Type: application/json -d {
  "name": "Harisson FORD",
  "nationality": "USA"
}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   104  100    51  100    53  19332  20090 --:--:-- --:--:-- --:--:-- 52000
{"name":"Harisson FORD","nationality":"USA","id":5}+ echo -e 

 Test-21 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/
-e 

 Test-21 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X GET http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   256  100   256    0     0   100k      0 --:--:-- --:--:-- --:--:--  125k
[{"name":"Adam Driver","nationality":"USA","id":1},{"name":"Daisy Ridley","nationality":"USA","id":2},{"name":"Carrie FISHER","nationality":"USA","id":3},{"name":"Mark HAMILL","nationality":"USA","id":4},{"name":"Harisson FORD","nationality":"USA","id":5}]+ echo -e 

 Test-22 : curl -X GET id=1 on ip-nginx:8080/api/v1/casts/1
-e 

 Test-22 : curl -X GET id=1 on ip-nginx:8080/api/v1/casts/1
+ docker exec nginx hostname -i
+ curl -X GET http://172.18.0.7:8080/api/v1/casts/1/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100    49  100    49    0     0  18553      0 --:--:-- --:--:-- --:--:-- 24500
{"name":"Adam Driver","nationality":"USA","id":1}+ echo -e 

 Test-23 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/casts/
-e 

 Test-23 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X DELETE http://172.18.0.7:8080/api/v1/casts/1 -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100     4  100     4    0     0    938      0 --:--:-- --:--:-- --:--:--  1000
null+ echo -e 

 Test-24 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/
-e 

 Test-24 : curl -X GET ALL on ip-nginx:8080/api/v1/casts/
+ docker exec nginx hostname -i
+ curl -X GET http://172.18.0.7:8080/api/v1/casts/ -H accept: application/json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   206  100   206    0     0  87846      0 --:--:-- --:--:-- --:--:--  100k
[{"name":"Daisy Ridley","nationality":"USA","id":2},{"name":"Carrie FISHER","nationality":"USA","id":3},{"name":"Mark HAMILL","nationality":"USA","id":4},{"name":"Harisson FORD","nationality":"USA","id":5}]+ docker rm -f nginx movie_service movie_db cast_service cast_db
nginx
movie_service
movie_db
cast_service
cast_db
+ docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED       STATUS       PORTS                                                                                          NAMES
2beb1756c30a   jenkins/jenkins:lts   "/usr/bin/tini -- /u…"   4 hours ago   Up 4 hours   0.0.0.0:50000->50000/tcp, [::]:50000->50000/tcp, 0.0.0.0:8280->8080/tcp, [::]:8280->8080/tcp   jenkins
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```
