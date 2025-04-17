#!/bin/bash
# URL script : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/Jenkins_devops_exams/init-k3d.sh
# This script create a cluster of 1 one master ands two workers of a cluster k3s

# BIBLIO
## B33) Playing with Kubernetes using k3d and Rancher ; Prakhar Malviya ; 47Billion ; Prakhar Malviya ;Published in May 28, 2022
###   • https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23

# VERSIONS
## 20250413.1530 : Creation of script


# BEGIN OF SCRIPT
## 0.) Erase all vm dckr and launch the creation of ctnr docker
sudo docker compose down

sudo docker ps -a
sudo docker rm -f $(sudo docker ps -aq)

sudo docker images
sudo docker image rmi -f $(sudo docker images -q)

sudo docker volume ls
sudo docker volume rm -f $(sudo docker volume ls -q)

sudo docker network ls
sudo docker network rm $(sudo docker network ls -q)


sudo docker network ls
sudo docker volume ls
sudo docker images
sudo docker ps -a

### 0.2) Deploy docker compose jenkins server
sudo docker compose up -d

sleep 6
#ip_jenkins=$(sudo docker exec -it jenkins hostname -i)
# echo $ip_jenkins
#sudo docker exec -it jenkins hostname -i > foo && sed -e 's/^M//g' foo && ip_jenkins=`cat foo` && echo $ip_jenkins && rm foo


ip_source="127\\.0\\.0\\.1"
#ip_jenkins2="https://$ip_jenkins"
ip_jenkins==$(sudo docker exec jenkins hostname -i)
echo $ip_jenkins

## ip_k3s_srvr=$(sudo docker exec k3d-mycluster-server-0 hostname -i)
echo $ip_k3s_srvr
## 1.) Installing the binaries kubectl , k3d and helm
##     1.0.) install docker
### curl -fsSL https://get.docker.com -o get-docker.sh
### sh get-docker.sh

##      1.1.) install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

##      1.2) install helm (this one takes some time)
curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

##      1.3) install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


