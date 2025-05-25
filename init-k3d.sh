#!/bin/bash
export PS1="\[\e]0;\u@\h:]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\$ "
cpa@debianbu201$
#################################################################################################################################
# URL script : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/Jenkins_devops_exams/init-k3d.sh
# This script deploys an architecture with :
###                  a ctnr dckr server [jenkins] (docker, helm, k3d) included in  [--network "dm-jenkins-cpa-infra_my-net"]
###                  and a cluster k3s [mycluster] included in [--network "dm-jenkins-cpa-infra_my-net"] and composed of :
####                    1 loadbalancer [ ]
####                    1 ctl master
####                    2 workers
####      cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo docker ps -a
##### CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                  NAMES
##### e84a8bbebb9d   ghcr.io/k3d-io/k3d-proxy:5.8.3   "/bin/sh -c nginx-pr…"   28 seconds ago   Up 22 seconds   80/tcp, 0.0.0.0:46673->6443/tcp, 0.0.0.0:8900->30080/tcp, :::8900->30080/tcp, 0.0.0.0:8901->30081/tcp, :::8901->30081/tcp, 0.0.0.0:8902->30082/tcp, :::8902->30082/tcp   k3d-mycluster-serverlb
##### 624fb3e19301   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-1
##### 7599073a5501   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-0
##### 959371b1b206   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 27 seconds                                                                                                                                                                            k3d-mycluster-server-0
##### 371040630af2   jenkins/jenkins:lts              "/usr/bin/tini -- /u…"   2 hours ago      Up 2 hours      0.0.0.0:50000->50000/tcp, :::50000->50000/tcp, 0.0.0.0:8280->8080/tcp, :::8280->8080/tcp                                                                                 jenkins

################################################################

################################################################
# BIBLIO
## B33) Playing with Kubernetes using k3d and Rancher ; Prakhar Malviya ; 47Billion ; Prakhar Malviya ;Published in May 28, 2022
###   • https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23
################################################################

################################################################
# VERSIONS
## 20250417.1500 : Update script to improve this script of deployment of architecture with :
###                  a ctnr dckr server [jenkins] (docker, helm, k3d)
###                  and a cluster k3s composed of :
####                    1 loadbalancer
####                    1 ctl master
####                    2 workers
## 20250413.1530 : Creation of script
#################################################################################################################################




#################################################################################################################################
# BEGIN OF SCRIPT
################################################################

################################################################
## 1.) PREREQUIES
### 1.1) Launch proxmox
###############

###############################
### 1.2) Start vm-114-111-dmj-jenkins
###############

###############################
### 1.3) Start vm-115-&&"-dmj-k3d"
###############
###############

###############################
### 1.4) If vm are without jenkins and k3d applications execute : ./init-vm-proxmox.sh or go to step 2
###############
###############################
################################################################


################################################################
## 2.) Connect to VMs proxmox jenkins and k3d servers
###############

###############################
### 2.1) Initiate variables
url_id_rsa="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa"
url_id_rsa_cpa="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa_cpa"
ip_jenkins="192.168.1.82"
ip_k3d="192.168.1.83"
url_rep_project="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins"
url_rep_ci_cd="$url_rep_project/dr01-python-microservices6"
url_rep_k8s="$url_rep_ci_cd/k8s"
###############

###############################
### 2.2) Access from host PC on vm-114-111-dmj-jenkins
# gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
echo "*************************"
echo "ip_jenkins : "
ssh -i $url_id_rsa root@$ip_jenkins 'hostname -I'
###############

###############################
### 2.3) Access from host PC on vm-114-111-dmj-k3d
# gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_k3d"
gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa root@$ip_k3d"
echo "*************************"
echo "ip_k3d : "
ssh -i $url_id_rsa root@$ip_k3d 'hostname -I'
###############
###############################

################################################################
## 3.)  Erase all vm dckr  on JENKINS SERVER an,d K3D SERVER
###############
################################################################
### 3.1) Erase all vm dckr and launch the creation of ctnr docker on JENKINS SERVER
###############
###############################
####     3..1.1)  List then delete all ctnr dckr
echo "########################################################"
echo "*************************"
echo "docker ps -a  on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker ps -a'
ssh -i $url_id_rsa root@$ip_jenkins 'docker rm -f $(sudo docker ps -aq)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker ps -a'
###############

###############################
####     3..1.2) List and delete all dckr images
echo "########################################################"
echo "*************************"
echo "docker images on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker images'
ssh -i $url_id_rsa root@$ip_jenkins 'docker image rmi -f $(sudo docker images -q)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker images'
###############

###############################
####     3.1.3) List and delete all dckr volumes
echo "########################################################"
echo "*************************"
echo "docker volume ls  on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker volume ls'
ssh -i $url_id_rsa root@$ip_jenkins 'docker volume rm -f $(sudo docker volume ls -q)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker volume ls'
###############

###############################
####     3.1.4) List and delete all dckr networks
echo "########################################################"
echo "*************************"
echo "docker network ls  on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker network ls'
ssh -i $url_id_rsa root@$ip_jenkins 'docker network rm $(sudo docker network ls -q)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker network ls'
###############
###############################
################################################################

################################################################
### 3.2) Erase all vm dckr and launch the creation of ctnr docker on K3D SERVER
###############
###############################
####     3.2.1) Delete namaespace dev
ssh -i $url_id_rsa root@$ip_k3d 'sudo kubectl delete ns dev'
###############

###############################
####     3.2.2) Delete dckr compose deployment
ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app && cd /app && ls -lha /app docker compose down'
###############

###############################
####     3.2.3)  List then delete all ctnr dckr
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
ssh -i $url_id_rsa root@$ip_k3d 'docker rm -f $(sudo docker ps -aq)'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
###############

###############################
#####     3.2.4) List and delete all dckr images
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
ssh -i $url_id_rsa root@$ip_k3d 'docker image rmi -f $(sudo docker images -q)'
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
###############

###############################
######     3.2.5) List and delete all dckr volumes
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume rm -f $(sudo docker volume ls -q)'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls'
###############

###############################
######     3.2.6) List and delete all dckr networks
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
ssh -i $url_id_rsa root@$ip_k3d 'docker network rm $(sudo docker network ls -q)'
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
###############

###############################
######     3.2.7) List and verify all dckr components are well deleted =
echo "*************************"
echo "dckr networks : "
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
echo "*************************"
echo "dckr volumes : "
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls'
echo "*************************"
echo "dckr images : "
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
echo "*************************"
echo "dckr ctnr : "
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
###############
###############################
################################################################


################################################################
## 4) Create cluster k3d with 1 master node and 2 workers nodes
###############
###  Creating the cluster : one master and 2 workers k3S
###       B33-k3d-Rancher-supervision-Playing with Kubernetes using k3d and Rancher | by Prakhar Malviya | 47Billion | Medium:
####         https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23

####          These ports will map to ports 8900, 8901 and 8902 of your localhost respectively.
####          The cluster will have 1 master node and 2 workers nodes. You can adjust these settings using the p and the agent flags as you wish.
#####             sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=172.30.0.6"@server:*
###############

###############################
###    4.1) Create a docker network named "dm-jenkins-cpa-infra_my-net" which wille be use by server Jenkins and cluster k3d
ssh -i $url_id_rsa root@$ip_k3d 'docker network create dm-jenkins-cpa-infra_my-net'
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
###############

###############################
###    4.2) This will create a cluster named “mycluster” with 1 ctl manager 2 workers and 1 loadbalancer nginx with 3 ports exposed 30080, 30081 and 30082.
###############
####        B33-4) k3s.yaml-tls-san parameter won't change · Issue #4149 · k3s-io/k3s
#####                  https://github.com/k3s-io/k3s/issues/4149
######                     Make a /etc/rancher/k3s/config.yaml file with your settings. I have:
#######                      write-kubeconfig-mode: "0644"
#######                      token: hoolabaloosecrettoken
#######                      tls-san:
#######                        - 192.168.10.4
#######                        - 192.168.10.10
####          These ports will map to ports 8900, 8901 and 8902 of your localhost respectively.
####          The cluster will have 1 master node and 2 worker nodes. You can adjust these settings using the p and the agent flags as you wish.
#####             sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=172.30.0.6"@server:*
###############
###############
# sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${$ip_jenkins}"@serv
#  ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=localhost"@server:*'
# ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${$ip_jenkins}"@server:*'

####                         k3d cluster delete mycluster
ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster delete -a'
ssh -i $url_id_rsa root@$ip_k3d 'k3d cluster list -o wide'

# ssh -i $url_id_rsa root@$ip_k3d 'k3d cluster create cpacluster --k3s-arg --tls-san=192.168.1.83@server:* -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --servers 1 --agents 2 -p "9080:80@loadbalancer" -p "9043:443@loadbalancer"'
ssh -i $url_id_rsa root@$ip_k3d 'k3d cluster create cpacluster --k3s-arg --tls-san=192.168.1.83@server:* -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --servers 1 --agents 2 -p "8081:80@loadbalancer" -p "8080:8080@loadbalancer" -p "8083:5000@loadbalancer" -p "8084:5001@loadbalancer"'
###############

###############################
echo "########################################################"
echo "###    4.3) List dckr components and kubernetes object of k3d-cpacluster"
echo "*************************"
echo "4.3.1.1) docker ps -a : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo docker ps -a
##### => CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                  NAMES
##### => e84a8bbebb9d   ghcr.io/k3d-io/k3d-proxy:5.8.3   "/bin/sh -c nginx-pr…"   28 seconds ago   Up 22 seconds   80/tcp, 0.0.0.0:46673->6443/tcp, 0.0.0.0:8900->30080/tcp, :::8900->30080/tcp, 0.0.0.0:8901->30081/tcp, :::8901->30081/tcp, 0.0.0.0:8902->30082/tcp, :::8902->30082/tcp   k3d-mycluster-serverlb
##### 624fb3e19301   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-1
##### 7599073a5501   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-0
##### 959371b1b206   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 27 seconds                                                                                                                                                                            k3d-mycluster-server-0
##### 371040630af2   jenkins/jenkins:lts              "/usr/bin/tini -- /u…"   2 hours ago      Up 2 hours      0.0.0.0:50000->50000/tcp, :::50000->50000/tcp, 0.0.0.0:8280->8080/tcp, :::8280->8080/tcp                                                                                 jenkins
###############
echo "########################################################"

echo "*************************"
echo "4.3.1.2) docker network ls : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
echo "########################################################"
echo "########################################################"

echo "*************************"
echo "4.3.2) k3d cluster list : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'k3d cluster list'
echo "########################################################"

echo "*************************"
echo "4.3.3) kubctl cluster-info : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl cluster-info'
### cf DM-JENKINS-B96-03) Search on brave : kubectl cluster-info for Multiple Clusters : https://search.brave.com/search?q=kubectl+cluster-info+with+several+clusters&source=web&summary=1&conversation=b7b978fe62a8dedc30bd48
#### 1) adding the necessary details to your kubeconfig file.
##### $ vim ~/.config/k3d/kubeconfig-mycluster.yaml
#### 2) To switch contexts, you can use the following command:
##### $ kubectl config use-context <context-name>
#### 3)  then use kubectl cluster-info to get information about the cluster associated with that context.
##### $ kubectl cluster-info
echo "########################################################"

echo "*************************"
echo "4.3.4) kubctl get nodes -o wide  : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get nodes -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.5) kubctl namespaces  -A -o wide: on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get ns -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.6) kubctl get pv  -A -o wide :  persitent volumes : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pv -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.7) kubctl get pvc  -A -o wide : persitent volumes claim :on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pvc -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.8) kubctl get all  -A -o wide : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get all -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.9)kubctl get pods -A -o wide :on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pods -A  -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.10) kubctl get svc  -A -o wide : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.11) kubctl get deployment  -A -o wide: on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get deployement -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.3.12) kubctl get statefullset  -A -o wide : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get statefulset -A -o wide'
echo "########################################################"
echo "########################################################"
###############



################################################################
## 5) Create the file .kube/config to access kubectl command  from the server Jenkins and Copy this file on the Jenkins server
###############
####        B33-3) k3d KUBECONFIG option --tls-san : doc1 doc officielle k3s / configuration / Configuration File
#####            / https://docs.k3s.io/installation/configuration
######                /etc/rancher/k3s/config.yaml, and drop-in files are loaded from /etc/rancher/k3s/config.yaml.d/*.yaml in alphabetical order. This path is configurable via the --config CLI flag or K3S_CONFIG_FILE env var. When overriding the default config file name, the drop-in directory path is also modified.
#########################################
###    5.1) Create a kubeconfig-cpacluster.yaml config k3d cluster file
##########

####################
####          5.1.1) Delete and recreate directory [./datas/data-k3d] to restart without existant file [./datas/data-k3d/k3s.yaml]
# url_rep_project="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/"
# url_rep_ci_cd="$url_rep_project/dr01-python-microservices6"
# url_repk8s="$url_rep_ci_cd/k8s"
cd $url_rep_project
pwd
rm -r ./datas/data-k3d
mkdir -p ./datas/data-k3d
cd ./datas/data-k3d
pwd
ls -lha
###### cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ ls -lha ./datas/data-k3d
###### # => total 8,0K
###### # => drwxr-xr-x 2 cpa cpa 4,0K 17 avril 18:59 .
###### # => drwxr-xr-x 3 cpa cpa 4,0K 17 avril 18:59 ..
##########

####################
####          5.1.2) Create the configfile [./datas/data-k3d/k3s.yaml] from the ctl master [k3d-mycluster-server-0] of the k3s cluster
# ssh -i $url_id_rsa root@$ip_k3d 'docker exec -it k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml' | tee ./datas/data-k3d/k3s.yaml
########
##########
#####               5.1.2.1) Method 1 : Create config k3d config file with docker
###### $ sh -i $url_id_rsa root@$ip_k3d 'docker exec k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml'
###### $ ssh -i $url_id_rsa root@$ip_k3d 'docker exec k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml' > ./datas/data-k3d/k3s.yaml
###### $ cat ./datas/data-k3d/k3s.yaml
###### $ sleep 3
########

################
#####               5.1.2.2) Method 2 : Create a config k3d files with k3d-cli
# search brave with follow keywords : "k3d get-kubeconfig"
## DM-JENKINS-B96-01) https://search.brave.com/search?q=r+creating+the+admin+kubeconfig+file+and+try+again+k3d+init&source=desktop&summary=1&conversation=675f5faf652a6d4327352c
## K3d get-kubeconfig
### To retrieve the kubeconfig for a k3d cluster, you can use the k3d kubeconfig get command. This command allows you to specify one or more clusters by name or use the --all flag to get kubeconfigs for all clusters. The output can be directed to a file or used directly to configure kubectl access to the cluster.
#### For example, to get the kubeconfig for a cluster named mycluster, you can run:
##### k3d kubeconfig get mycluster : cf DM-JENKINS-B96-02-serach brave with follow keywords : "k3d get-kubeconfig" : https://search.brave.com/search?q=k3d+get-kubeconfig&source=desktop&summary=1&conversation=47236dee18d99355bbd333
###### For example, to get the kubeconfig for a cluster named mycluster, you can run:
####### $ k3d kubeconfig get mycluster
###### To get kubeconfigs for all clusters and save them to a file named kubeconfig, you can use:
####### $ k3d kubeconfig get --all > kubeconfig
###### Additionally, you can use the k3d kubeconfig write command to export the kubeconfig to a specific file, such as $HOME/.k3d/kubeconfig-mycluster.yaml, which is useful for managing Kubernetes remotely from other workstations.
####### $ k3d kubeconfig write mycluster
###### You can also merge multiple kubeconfigs into a single file using the k3d kubeconfig merge command, which is helpful for managing access to multiple clusters in a single configuration file.
####### $ k3d kubeconfig merge
###### For more detailed options and flags, you can refer to the k3d documentation on handling kubeconfigs
###### To get kubeconfigs for all clusters and save them to a file named kubeconfig, you can use:
####### $ k3d kubeconfig get --all > kubeconfig

###### $ ssh -i $url_id_rsa root@$ip_k3d 'rm /root/.config/k3d/*.yaml'
###### $ ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /root/.config/k3d/'
###### $ ssh -i $url_id_rsa root@$ip_k3d 'k3d kubeconfig write cpacluster'
####### => cpa@debianbu201$  ssh -i $url_id_rsa root@$ip_k3d 'k3d kubeconfig write cpacluster'
####### => /root/.config/k3d/kubeconfig-cpacluster.yaml

###### $ ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /root/.config/k3d/'
########

################
#####               5.1.2.3) Method 3 : Create a config k3d files with kubectl-cli

echo "$(ssh -i $url_id_rsa root@$ip_k3d 'kubectl config view --raw')" >  ./kubeconfig-k3d-cpacluster.yaml
scp -i $url_id_rsa ./kubeconfig-k3d-cpacluster.yaml root@$ip_k3d:/root/.config/k3d/kubeconfig-cpacluster.yaml
ssh -i $url_id_rsa root@$ip_k3d 'cat /root/.config/k3d/kubeconfig-cpacluster.yaml'
#ssh -i $url_id_rsa root@$ip_k3d 'export KUBECONFIG="/root/.config/k3d/kubeconfig-cpacluster.yaml"; echo $KUBECONFIG'

##########
###############

####################
####          5.1.3) From the existant file [./datas/data-k3d/k3s.yaml], create a second file [./datas/data-k3d/k3s_v2.yaml] with the configuration which be able to connect the kubectl server from jenkins server.
#sed -i "s|server: https://127.0.0.1:6443|server: https://$$ip_jenkins:6443|g" ./datas/data-k3d/k3s.yaml
# sed -i 's/'$ip_source'\b/'$$ip_jenkins'/g' ./datas/data-k3d/k3s.yaml
# sed -E 's~(https?://)[^ :;]+(:?\d*)~\1'$$ip_jenkins2'\2~' -i ./datas/data-k3d/k3s.yaml
ip_source="127\\.0\\.0\\.1"
echo "ip_source: " $ip_source
#$ip_jenkins2="https://$$ip_jenkins"
####             ip_jenkins=$(sudo docker exec jenkins hostname -i)
# ip_jenkins=$(ssh -i $url_id_rsa root@$ip_k3d 'docker exec jenkins hostname -i')
# echo "$ip_jenkins: " $ip_jenkins

####              ip_k3s_srvr=$(ssh -i $url_id_rsa root@$ip_k3d 'docker exec k3d-mycluster-server-0 hostname -i')
####              echo "ip_k3s_srvr: " $ip_k3s_srvr

pwd
ls -lha
cp ./kubeconfig-k3d-cpacluster.yaml ./kubeconfig-k3d-cpacluster_v2.yaml
####              sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s_v2.yaml
pwd
ls -lha
sed -i 's+0.0.0.0+'$ip_k3d'+g' ./kubeconfig-k3d-cpacluster_v2.yaml
pwd
ls -lha
cat ./kubeconfig-k3d-cpacluster_v2.yaml
#sudo docker exec -it jenkins export KUBECONFIG=/datas/data-k3d/k3s_v2.yaml
##########
###############

###############################
##    5.2) Copy ./datas/data-k3d/k3s_v2.yaml jenkins:/usr/local/k3s.yaml to permitt acces of kubectl command from Jenkins server
###                           sudo docker cp ./datas/data-k3d/k3s_v2.yaml jenkins:/usr/local/k3s.yaml
scp -i $url_id_rsa ./kubeconfig-k3d-cpacluster_v2.yaml root@$ip_jenkins:/usr/local/k3s.yaml
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /usr/local/k3s.yaml'
ssh -i  $url_id_rsa root@$ip_jenkins 'cat /usr/local/k3s.yaml'
###############

###############################
##    5.3) Verify copy on the vm jenkins server to access on commands kubectl get nodes/pods on the k3d cluster
###                           sudo docker exec -it jenkins cat /usr/local/k3s.yaml
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get nodes'
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get pods --all-namespaces'
sleep 3
#$ip_jenkins=$(sudo docker exec -it jenkins hostname -i)
# echo $$ip_jenkins
#sudo docker exec -it jenkins hostname -i > foo && sed -e 's/^M//g' foo && $ip_jenkins=`cat foo` && echo $$ip_jenkins && rm foo
###############
###############################
################################################################



################################################################
## 6) Deploying Dashboard traefik on the cluster
##    6.1) Erase old file
cd $url_rep_k8s
pwd
rm -r ./monitoring/dashboard_traefik
mkdir -p ./monitoring/dashboard_traefik

cd ./monitoring/dashboard_traefik
pwd
ls -lha


ssh -i $url_id_rsa root@$ip_k3d 'rm -r /app/monitoring/dashboard_traefik'
ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
ssh -i $url_id_rsa root@$ip_k3d 'cd /app/monitoring/dashboard_traefik && pwd && ls -lha'
####################

########################################
# Doc off traefik : Quick Start¶
## https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/
### Permissions and Accesses¶
#### Traefik uses the Kubernetes API to discover running services.
#
#### To use the Kubernetes API, Traefik needs some permissions. This permission mechanism is based on roles defined by the cluster administrator.
##### The role is then bound to an account used by an application, in this case, Traefik Proxy.

###### 6.2) The first step is to create the role. The ClusterRole resource enumerates the resources and actions available for the role. In a file called 00-role.yml, put the following ClusterRole:
### 00-role.yml
manifest_name="00-role.yml"
cat <<EOF > ${manifest_name}
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: traefik-role

rules:
  - apiGroups:
      - ""
    resources:
      - services
      - secrets
      - nodes
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - discovery.k8s.io
    resources:
      - endpointslices
    verbs:
      - list
      - watch
  - apiGroups:
      - extensions
      - networking.k8s.io
    resources:
      - ingresses
      - ingressclasses
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - extensions
      - networking.k8s.io
    resources:
      - ingresses/status
    verbs:
      - update
  - apiGroups:
      - traefik.io
    resources:
      - middlewares
      - middlewaretcps
      - ingressroutes
      - traefikservices
      - ingressroutetcps
      - ingressrouteudps
      - tlsoptions
      - tlsstores
      - serverstransports
      - serverstransporttcps
    verbs:
      - get
      - list
      - watch
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.3) The next step is to create a dedicated service account for Traefik. In a file called 00-account.yml, put the following ServiceAccount resource:
######  00-account.yml
manifest_name="00-account.yml"
cat <<EOF > ${manifest_name}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: traefik-account
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.4) And then, bind the role on the account to apply the permissions and rules on the latter. In a file called 01-role-binding.yml, put the following ClusterRoleBinding resource:
####### roleRef is the Kubernetes reference to the role created in 00-role.yml.
####### subjects is the list of accounts reference.
######## In this guide, it only contains the account created in 00-account.yml
######  01-role-binding.yml
manifest_name="01-role-binding.yml"
cat <<EOF > ${manifest_name}
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: traefik-role-binding

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: traefik-role
subjects:
  - kind: ServiceAccount
    name: traefik-account
    namespace: default # This tutorial uses the "default" K8s namespace.
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.5) Deployment and Exposition¶:
######## This section can be managed with the help of the Traefik Helm chart. : https://doc.traefik.io/traefik/getting-started/install-traefik/#use-the-helm-chart
####### The ingress controller is a software that runs in the same way as any other application on a cluster.
####### To start Traefik on the Kubernetes cluster, a Deployment resource must exist to describe how to configure and scale containers horizontally to support larger workloads.
######## The deployment contains an important attribute for customizing Traefik: args.
######## These arguments are the static configuration for Traefik.
######## From here, it is possible to enable the dashboard, configure entry points, select dynamic configuration providers, and more.
######## In this deployment, the static configuration enables the Traefik dashboard, and uses Kubernetes native Ingress resources as router definitions to route incoming requests.
######## When there is no entry point in the static configuration
######## Traefik creates a default one called web using the port 80 routing HTTP requests.
######## When enabling the api.insecure mode, Traefik exposes the dashboard on the port 8080.
######  02-traefik.yml
manifest_name="02-traefik.yml"
cat <<EOF > ${manifest_name}
kind: Deployment
apiVersion: apps/v1
metadata:
  name: traefik-deployment
  labels:
    app: traefik

spec:
  replicas: 1
  selector:
    matchLabels:
      app: traefik
  template:
    metadata:
      labels:
        app: traefik
    spec:
      serviceAccountName: traefik-account
      containers:
        - name: traefik
          image: traefik:v3.4
          args:
            - --api.insecure
            - --providers.kubernetesingress
          ports:
            - name: web
              containerPort: 80
            - name: dashboard
              containerPort: 8080
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.6) A deployment manages scaling and then can create lots of containers, called Pods. Each Pod is configured following the spec field in the deployment.
###### Given that, a Deployment can run multiple Traefik Proxy Pods, a piece is required to forward the traffic to any of the instance: namely a Service.
######  02-traefik-services.yml


manifest_name="02-traefik-services.yml"
cat <<EOF > ${manifest_name}
apiVersion: v1
kind: Service
metadata:
  name: traefik-dashboard-service

spec:
  type: LoadBalancer
  ports:
    - port: 8080
      targetPort: dashboard
  selector:
    app: traefik
---
apiVersion: v1
kind: Service
metadata:
  name: traefik-web-service

spec:
  type: LoadBalancer
  ports:
    - targetPort: web
      port: 80
  selector:
    app: traefik
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.7) Proxying applications
####### The only part still missing is the business application behind the reverse proxy.
####### For this guide, we use the example application traefik/whoami, but the principles are applicable to any other application.

####### The whoami application is an HTTP server running on port 80 which answers host-related information to the incoming requests.
####### As usual, start by creating a file called 03-whoami.yml and paste the following Deployment resource:
######  03-whoami.yml
manifest_name="03-whoami.yml"
cat <<EOF > ${manifest_name}
kind: Deployment
apiVersion: apps/v1
metadata:
  name: whoami
  labels:
    app: whoami

spec:
  replicas: 1
  selector:
    matchLabels:
      app: whoami
  template:
    metadata:
      labels:
        app: whoami
    spec:
      containers:
        - name: whoami
          image: traefik/whoami
          ports:
            - name: web
              containerPort: 80
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.8) And continue by creating the following Service resource in a file called 03-whoami-services.yml:
###### 03-whoami-services.yml
manifest_name="03-whoami-services.yml"
cat <<EOF > ${manifest_name}
apiVersion: v1
kind: Service
metadata:
  name: whoami

spec:
  ports:
    - name: web
      port: 80
      targetPort: web

  selector:
    app: whoami
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

########################################
###### 6.9) Thanks to the Kubernetes API, Traefik is notified when an Ingress resource is created, updated, or deleted.
####### This makes the process dynamic.
####### The ingresses are, in a way, the dynamic configuration for Traefik.
######  04-whoami-ingress.yml
manifest_name="04-whoami-ingress.yml"
cat <<EOF > ${manifest_name}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: whoami-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: whoami
            port:
              name: web
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

echo "########################################"
echo "###### 6.10)  Verify access on dashboard of traefik with cmd : curl -v 192.168.1.83:8080/dashboard/"
####### Now you should be able to access the whoami application and the Traefik dashboard. Load the dashboard on a web browser: http://localhost:8080.
####### $ curl -v http://localhost/
echo "curl $ip_k3d:8080/"
echo $(curl -v  $ip_k3d:8080/)
echo " #################### "

echo -e "\n\n ########################################"
echo "###### 6.11) and now access the whoami application with cmd : curl -v 192.168.1.83:8081/"
echo "curl -v 192.168.1.83:8081/"
echo $(curl -v 192.168.1.83:8081/)
echo " ######################################## "
###############
###############################
################################################################



################################################################
## 7) configure jenkins server to permitt to access to vm k3d cluster
# cd /home/cpa//Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins

# sudo docker network create dm-jenkins-cpa-infra_my-net
# sudo docker network ls

# ssh-add /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/ssh-key-github-cpa8876
# git branch -a
# git status
# git add .
# git commit -m "update final version of Jenkinsfile step 1 buil images"
# git push origin main
###############################

###############################
## 7.0) Excute script ./docker-compose.yml script to build container docker Jenkins server
# sudo docker compose up -d
###############

###############################
## 7.1) Configure jenkins server and copy data from the project dm jenkins
##########
####################
####          7.1.1) Procedure to assure that docker is well configure about docker group
####################
ssh -i $url_id_rsa root@$ip_jenkins 'groupadd docker'
ssh -i $url_id_rsa root@$ip_jenkins 'usermod -aG docker jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'reboot'
sleep 2
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
ssh -i $url_id_rsa root@$ip_jenkins 'newgrp docker'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl restart docker.service'
##########
##########

####################

####################
####          7.1.2) Update access on the jenkins server : replace the port 8080 by the port 8082
#####              B01) Change Jenkins Port 8080
######                  update  variable HTTP_PORT of /etc/default/jenkins file et modifiez la fo example  8082.
######                  https://search.brave.com/search?q=changer+le+port+8080+jenkins&source=desktop&summary=1&conversation=db7acd09354d14ca679e9c
#######                       sed -i "s|server: https://127.0.0.1:6443|s'erver: https://$$ip_jenkins:6443|g" ./datas/data-k3d/k3s.yaml
##############
######             B02) How to change port for jenkins window service when 8080 is being used; 11 months ago; Modified 9 months ago; Part of CI/CD Collectivesudo systemctl stop jenkins :
######                  https://stackoverflow.com/questions/23769478/how-to-change-port-for-jenkins-window-service-when-8080-is-being-used
##############


#######                       sudo nano /etc/default/jenkins
#######                   In ubuntu
#######                       systemctl stop jenkins
#######                     CHANGE THIS: HTTP_PORT=9090
#######                       sudo systemctl edit --full jenkins

#######                     CHANGE THIS: Environment="JENKINS_PORT=9090"
#######                       sudo systemctl daemon-reload
#######                       sudo systemctl restart jenkins
##########

####################
####                  7.1.2.1) Method 1

ssh -i $url_id_rsa root@$ip_jenkins 'cat /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'nano /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sed -i "s|HTTP_PORT=8080|HTTP_PORT=8082|g" /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'cat /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl restart jenkins'
##########

####################
####                  7.1.2.2) Method 2
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl stop jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl status jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'cat /etc/systemd/system/jenkins.service'
ssh -i $url_id_rsa root@$ip_jenkins 'sed -i "s|JENKINS_PORT=8080|JENKINS_PORT=8082|g" /etc/systemd/system/jenkins.service'
ssh -i $url_id_rsa root@$ip_jenkins 'cat /etc/systemd/system/jenkins.service'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl daemon-reload'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl restart jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl status jenkins'
##########

####################
####                  7.1.2.3) Verify the update of access port of jenkins server
echo $(curl -v $ip_jenkins:8082)
##########

####################
####         7.1.3) Copy the fastapi files and script of the homework jenkins
ssh -i $url_id_rsa root@$ip_jenkins ' rm -r /app'
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app'
ssh -i $url_id_rsa root@$ip_jenkins 'mkdir -p /app'
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app'
scp -r -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/cast-service root@$ip_jenkins:/app/
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/cast-service/'

scp -r -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/movie-service root@$ip_jenkins:/app/movie-service
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/movie-service/'

scp -r -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/k8s-test8 root@$ip_jenkins:/app/fastapiapp
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/fastapiapp'

scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/docker-compose.yml root@$ip_jenkins:/app/

scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/nginx_config.conf root@$ip_jenkins:/app/

scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/README.md root@$ip_jenkins:/app/

ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/'
###############
###############################
### 7.2) Access from host PC on vm-114-111-dmj-jenkins
# gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
echo "*************************"
echo "ip_jenkins : "
ssh -i $url_id_rsa root@$ip_jenkins 'hostname -I'
###############

###############################
### 7.3) Access from host PC on vm-114-111-dmj-k3d
# gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_k3d"
gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa root@$ip_k3d"
echo "*************************"
echo "ip_k3d : "
ssh -i $url_id_rsa root@$ip_k3d 'hostname -I'
###############
###############################
###############################
################################################################


################################################################
#  8) Verification on vm k3d
##########
###############

###############################
###   8.1) Display all VM docker
echo " 8.1) ############################### "
echo "*************************"
echo "docker images / volumes / ctnr  on gnome-terminal k3d :"
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls -a'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
###############

###############################
###   8.2) Display all nodes of the k3d cluster
echo " 8.2) ############################### "
echo "*************************"
echo "kubctl get all -A -o wide from jenkins to k3d server :"
ssh -i $url_id_rsa root@$ip_k3d 'docker exec -it jenkins kubectl --kubeconfig /usr/local/k3s.yaml get all -A -o wide'
##########

####################
####   8.3) Display all nodes of the k3d cluster
echo " 8.3) ############################### "
echo "*************************"
echo "kubctl get pods -A -o wide from jenkins to k3d server :"
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get pods -A -o wide'
##########

####################
####   8.4) Display all namespaces of the k3d cluster
echo " 8.4) ############################### "
echo "*************************"
echo "kubctl get namesopaces -o wide from jenkins to k3d server :"
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get ns -A -o wide'
##########

####################
####   8.5) Display all pods of the k3d cluster
echo " 8.5) ############################### "
echo "*************************"
echo "kubctl get svc -A -o wide from jenkins to k3d server :"
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get svc -A -o wide'
##########

####################
####    8.6) Display the password rancher monitoring k3s cluster
# echo " 8.6) ############################### "
# echo "*************************"
# echo "kubctl get svc -A -o wide from jenkins to k3d server :"
# kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
###############
###############################


################################################################
#  9) Tests with k8s manifest to deploy a postgresql database, fastapi
##########
###############
###############################
###   9.1) test deployment of a postgresql cast-db on k3d cluster
echo "\n###############################"
echo "*************************"
echo "9.1) test deployment of a postgresql cast-db on tghe k3d cluster "

cd $url_rep_k8s
pwd
rm -r ./cast
mkdir -p ./cast

cd ./cast
pwd

manifest_name="cast-db-deployment.yml"
cat <<EOF > ${manifest_name}
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/cast-service/k8s/cast-deployment.yaml
### BIBLIO
#### DM-JENKIN§S-B623 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
apiVersion: v1
kind: Secret
metadata:
  name: cast-db-secret
type: Opaque
data:
  cast-db-username: ZmFzdGFwaV91c2Vy       # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
  cast-db-password: ZmFzdGFwaV9wYXNzd2Q=   # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
  cast-db-database: ZmFzdGFwaV9kYg==       # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db
---
apiVersion: v1
kind: Service
metadata:
  name: cast-db-service
spec:
  selector:
    app: cast-db
  ports:
    - name: cast-db-service
      port: 5432
      targetPort: 5432
---
apiVersion: apps/v1
#kind: Deployment
kind: StatefulSet
metadata:
  name: cast-db-sts
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cast-db
  template:
    metadata:
      labels:
        app: cast-db
    spec:
      containers:
        - name: cast-db
          image: postgres
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-username
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-password
            - name: POSTGRES_DB
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-database
          ports:
            - containerPort: 5432
---
EOF
pwd
ls -lha
cat $manifest_name



ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/cast'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/cast/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get sts -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get po -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -o wide'
echo -e "\n############################### "
echo "*************************"
sleep 10 
echo "9.1) test deployment of a postgresql cast-db on k3d cluster"
echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
ssh -i $url_id_rsa root@$ip_k3d kubectl exec cast-db-sts-0 -- 'psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c "select * from pg_database"'

# 
## K8S-kubctl-B06-Serach brave with kyeywords : create a pod to test access psql on postgresql sts
### https://search.brave.com/search?q=create+a+pod+to+test+access+psql+on+postgresql+sts&source=desktop&summary=1&conversation=37b6dc12548adece71b018
## kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=<your_password>" --command -- psql --host <postgresql_sts_service_name> -U postgres -d <your_database_name>
#### root@debian-pve:/app/cast# kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host 10.42.0.8 -U fastapi_user -d fastapi_db
##### => If you don't see a command prompt, try pressing enter.
##### => 
##### => fastapi_db=# 
ssh -i $url_id_rsa root@$ip_k3d 'kubectl run postgresql-client -it --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c "select * from pg_database"'
##### => cpa@debianbu201$ ssh -i $url_id_rsa root@$ip_k3d 'kubectl run postgresql-client -it --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c "select * from pg_database"'
##### => Unable to use a TTY - input is not a terminal or the right kind of file
##### => If you don't see a command prompt, try pressing enter.
##### => warning: couldn't attach to pod/postgresql-client, falling back to streaming logs: error stream protocol error: unknown error
##### =>   oid  |  datname   | datdba | encoding | datlocprovider | datistemplate | datal
##### => lowconn | dathasloginevt | datconnlimit | datfrozenxid | datminmxid | dattablesp
##### => ace | datcollate |  datctype  | datlocale | daticurules | datcollversion |      
##### =>                datacl                      
##### => -------+------------+--------+----------+----------------+---------------+------
##### => --------+----------------+--------------+--------------+------------+-----------
##### => ----+------------+------------+-----------+-------------+----------------+------
##### => -------------------------------------------
##### =>      5 | postgres   |     10 |        6 | c              | f             | t    
##### =>         | f              |           -1 |          731 |          1 |          1
##### => 663 | en_US.utf8 | en_US.utf8 |           |             | 2.36           | 
##### =>  16384 | fastapi_db |     10 |        6 | c              | f             | t    
##### =>         | f              |           -1 |          731 |          1 |          1
##### => 663 | en_US.utf8 | en_US.utf8 |           |             | 2.36           | 
##### =>      1 | template1  |     10 |        6 | c              | t             | t    
##### =>         | f              |           -1 |          731 |          1 |          1
##### => 663 | en_US.utf8 | en_US.utf8 |           |             | 2.36           | {=c/f
##### => astapi_user,fastapi_user=CTc/fastapi_user}
##### =>      4 | template0  |     10 |        6 | c              | t             | f    
##### =>         | f              |           -1 |          731 |          1 |          1
##### => 663 | en_US.utf8 | en_US.utf8 |           |             |                | {=c/f
##### => astapi_user,fastapi_user=CTc/fastapi_user}
##### => (4 rows)

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete pod postgresql-client'
# $ cpa@debianbu201$ ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete pod postgresql-client'
##### => pod "postgresql-client" deleted
sleep 10 
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pods'
# $cpa@debianbu201$ ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pods'
##### => NAME                                  READY   STATUS    RESTARTS       AGE
##### => cast-db-sts-0                         1/1     Running   0              31m
##### => fastapi-cast-596b57b48c-8sjgd         1/1     Running   16 (33m ago)   85m
##### => traefik-deployment-657fd9d7b9-lrnw6   1/1     Running   0              165m
##### => whoami-86c8d79cf4-5dgrf               1/1     Running   0              165m
##### => cpa@debianbu201$ 

##### => postgres@postgresql-client:/$ psql -h 10.42.0.8 -p 5432 -U fastapi_user -d fastapi_db
##### => psql (17.5)
##### => Type "help" for help.
##### => 
##### => fastapi_db=# \q
##### => could not save history to file "//.psql_history": Permission denied
##### => pod "postgresql-client" deleted
##### => 
##### => kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" -- /bin/bash
##### => root@debian-pve:/app/cast# kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db
##### =>If you don't see a command prompt, try pressing enter.
##### =>
##### =>fastapi_db=# \l
##### =>                                                           List of databases
##### =>    Name    |    Owner     | Encoding | Locale Provider |  Collate   |   Ctype    | Locale | ICU Rules |       Access privileges       
##### =>------------+--------------+----------+-----------------+------------+------------+--------+-----------+-------------------------------
##### => fastapi_db | fastapi_user | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | 
##### => postgres   | fastapi_user | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | 
##### => template0  | fastapi_user | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | =c/fastapi_user              +
##### =>            |              |          |                 |            |            |        |           | fastapi_user=CTc/fastapi_user
##### => template1  | fastapi_user | UTF8     | libc            | en_US.utf8 | en_US.utf8 |        |           | =c/fastapi_user              +
##### =>            |              |          |                 |            |            |        |           | fastapi_user=CTc/fastapi_user
##### =>(4 rows)
##### =>
##### =>fastapi_db=# 
###############

###############################
###   9.2) Test deployment of fastapi-cast on k3d cluster
echo "\n###############################"
echo "*************************"
echo "9.2) Test deployment of a fastapi-cast on the k3d cluster "

cd $url_rep_k8s
pwd
rm -r ./cast
mkdir -p ./cast

cd ./cast
pwd

manifest_name="fastapi-cast-deployment.yml"
cat <<EOF > ${manifest_name}
# # /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/cast-service/k8s/fastapi-cast-deployment.yaml
##################
### BIBLIO
#### DM-JENKINS-B62-3 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
---
apiVersion: v1
kind: Secret
metadata:
  name: fastapi-cast-secret
  labels:
    app: fastapi-cast
data:
# echo \$(echo -n "postgresql://fastapi_user:fastapi_passwd@cast-db-service:5432/fastapi_db" | base64)
# => cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBjYXN0LWRiLXNlcnZpY2U6 NTQzMi9mYXN0YXBpX2Ri
  URL: cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBjYXN0LWRiLXNlcnZpY2U6NTQzMi9mYXN0YXBpX2Ri
---
# fastapi-cast-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: fastapi-cast-service
spec:
  type: ClusterIP
  selector:
    app: fastapi-cast-deployment
  ports:
    - name: http
      port: 5000
      targetPort: 5000
      protocol: TCP
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: fastapi-cast-configmap
data:
  database-url: cast-db-service
---
# fastapi-cast-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-cast-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fastapi-cast-deployment
  template:
    metadata:
      labels:
        app: fastapi-cast-deployment
    spec:
      containers:
        - name: fastapi-cast-ctnr
          image: lahcenedergham/fastapi-image:latest
          env:
          - name: DATABASE_URL
#             value: "postgresql://fastapi_user:fastapi_passwd@10.43.162.83:5432/fastapi_db" 
#            value: "postgresql://fastapi_user:fastapi_passwd@cast-db-service:5432/fastapi_db" 
            valueFrom:
              secretKeyRef:
                name: fastapi-cast-secret
                key: URL
          ports:
            - containerPort: 5000
---
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/cast'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/cast/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get sts -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get po -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -o wide'

echo -e "\n############################### "
echo "*************************"
echo "9.2) test deployment of a postgresql cast-db on k3d cluster"
echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
echo "*************************"
echo "ssh -i $url_id_rsa root@$ip_k3d 'kubectl get po -o wide'"
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get po -o wide'
echo "*************************"
echo "ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -o wide'"
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -o wide'
echo "*************************"
echo "ssh -i $url_id_rsa root@$ip_k3d 'kubectl get sts -o wide'"
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get sts -o wide'
echo "*************************"

########################################
###### 9.2.2) Thanks to the Kubernetes API, Traefik is notified when an Ingress resource is created, updated, or deleted.
####### This makes the process dynamic.
####### The ingresses are, in a way, the dynamic configuration for Traefik.
######  04-whoami-ingress.yml
manifest_name="fastapi-cast-ingress.yml"
cat <<EOF > ${manifest_name}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fastapi-cast-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: fastapi-cast-service
            port:
              name: http
EOF
pwd
ls -lha
cat $manifest_name

ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/monitoring/dashboard_traefik'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/monitoring/dashboard_traefik/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/monitoring/dashboard_traefik/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/monitoring/dashboard_traefik/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/monitoring/dashboard_traefik/'${manifest_name}
####################

echo "########################################"
echo "###### 9.2.3)  Verify access on fastapi-cast of traefik with cmd : curl -v 192.168.1.83:8083/dashboard/"
####### Now you should be able to access the whoami application and the Traefik dashboard. Load the dashboard on a web browser: http://localhost:8080.
####### $ curl -v http://localhost/
echo "curl $ip_k3d:8083/"
echo $(curl -v  $ip_k3d:8080/)
echo " #################### "

echo -e "\n\n ########################################"
echo "###### 6.11) and now access the whoami application with cmd : curl -v 192.168.1.83:8081/"
echo "curl -v 192.168.1.83:8081/"
echo $(curl -v 192.168.1.83:8081/)
echo " ######################################## "
###############
###############################
################################################################

#  ssh -i $url_id_rsa root@$ip_k3d 'kubectl describe po fastapi-cast-7d86478b49-b8gv5'
#  ssh -i $url_id_rsa root@$ip_k3d kubectl describe po $(kubectl get po -o wide | grep fastapi | awk '{ print $1 }')
# kubectl get po -o wide
# kubectl get svc -o wide
# kubectl delete -f /app/cast/fastapi-cast-deployment.yml
# kubectl apply -f /app/cast/fastapi-cast-deployment.yml
# vim fastapi-cast-deployment.yml



## K8S-kubctl-B07 : search brave : kubectl log
### https://search.brave.com/search?q=kubectl+log&source=desktop&summary=1&conversation=33d470c001dd9ffb038b15
#### Kubectl log
#### The kubectl logs command is used in Kubernetes to retrieve and display the logs from a running container in a pod. It is primarily used for debugging and monitoring applications deployed in a Kubernetes cluster.
#### 
#### The basic syntax for retrieving logs from a pod is:
#### 
#### kubectl logs [OPTIONS] POD_NAME [-c CONTAINER_NAME]
#### If your pod has only one container, you can simply run kubectl logs, replacing POD_NAME with the name of your pod. If your pod has multiple containers, you can specify which container's logs you want to view using the -c option.
#### 
#### For example, to retrieve the logs of a specific container in a pod within a specific namespace, you would run:
#### 
####  $ kubectl logs my-pod -c my-container -n my-namespace
#### You can also use the kubectl logs command to view logs from previously terminated pods using the --previous flag.
#### 
#### To view logs in real-time and follow new logs, you can use the -f option:
#### 
####  $ kubectl logs -f my-pod
#### This command will continually stream new logs to your terminal until you exit (e.g., using CTRL+C in Windows PowerShell).
#### 
#### If you don't see the logs you're expecting, check if your Pod has restarted using the kubectl describe pod command. You might need to look at logs for the previous container using the --previous flag.
#### 
#### Pods: kubectl logs can be used to retrieve logs from a specific pod.
#### Containers: If a pod contains multiple containers, you can specify the container's logs to view using the -c option.
#### Namespaces: To specify the namespace if the pod is not in the default namespace, use the -n option.
#### Previous Containers: To view logs from a previously failed pod, use the --previous flag.
#### Timestamps: To include timestamps on each line of the log output, use the --since-time or --since options
####                            $ postgresql://fastapi_user:fastapi_passwd@cast-db-service:5432/fastapi_db
##### => Traceback (most recent call last):
##### =>   File "/usr/local/lib/python3.10/site-packages/sqlalchemy/engine/base.py", line 3211, in _wrap_pool_connect
##### =>     return fn()
##### =>  ...
##### =>     conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
##### => psycopg2.OperationalError: could not connect to server: Connection refused
##### => 	Is the server running on host "cast-db-service" (10.43.162.83) and accepting
##### => 	TCP/IP connections on port 5432?

#### Search brave : create a pod to test access curl
##### https://search.brave.com/search?q=create+a+pod+to+test+access+curl&source=web&summary=1&conversation=0507083e42d2e0fd07cb90
######      $  kubectl run -it --rm --image=curlimages/curl curly -- /bin/sh
#####      $ ssh -i $url_id_rsa root@$ip_k3d 'kubectl run -it --rm --image=curlimages/curl curly -- "curl fastapi-cast-service:5000/"'
#

##### K8s/KubCTL/B08 : How do I run curl command from within a Kubernetes pod ; Asked 9 years, 04/01/2026 23:18 o; Viewed 221k times
###### https://stackoverflow.com/questions/34601650/how-do-i-run-curl-command-from-within-a-kubernetes-pod
####### 101
######## Here is how you get a curl command line within a kubernetes network to test and explore your internal REST endpoints.
######## 
######## To get a prompt of a busybox running inside the network, execute the following command. (A tip is to use one unique container per developer.)
######## 
########       $  kubectl run curl-<YOUR NAME> --image=radial/busyboxplus:curl -i --tty --rm
######## You may omit the --rm and keep the instance running for later re-usage. To reuse it later, type:
######## 
######## kubectl attach <POD ID> -c curl-<YOUR NAME> -i -t
######## Using the command kubectl get pods you can see all running POD's. The <POD ID> is something similar to curl-yourname-944940652-fvj28.
######## 
######## EDIT: Note that you need to login to google cloud from your terminal (once) before you can do this! Here is an example, make sure to put in your zone, cluster and project:
######## 
########          $  gcloud container clusters get-credentials example-cluster --zone europe-west1-c --project example-148812

####### 26
######## There's an official curl team image these days:
######## https://hub.docker.com/r/curlimages/curl
######## Run it with:
########                         $ kubectl run -it --rm --image=curlimages/curl curly -- /bin/sh
######## or without shell
########                        $ kubectl run -it --rm --image=curlimages/curl curly -- curl -Lk domain.com
######
######
###### ON VM K3d serve
# r
#                                $ kubectl delete pod curl-cpa      
##### =>root@debian-pve:/app/cast# kubectl delete pod curl-cpa
##### =>Error from server (NotFound): pods "curl-cpa" not found
# 
#                                $  kubectl get pod
##### =>root@debian-pve:/app/cast# kubectl get pod 
##### =>NAME                                       READY   STATUS    RESTARTS   AGE
##### =>cast-db-sts-0                              1/1     Running   0          107m
##### =>fastapi-cast-deployment-775bdbf665-bv6tt   1/1     Running   0          71m
##### =>traefik-deployment-657fd9d7b9-lrnw6        1/1     Running   0          4h1m
##### =>whoami-86c8d79cf4-5dgrf                    1/1     Running   0          4h1m
#
#                                $ kubectl run curl-cpa --image=radial/busyboxplus:curl -i --tty --rm
##### =>root@debian-pve:/app/cast# kubectl run curl-cpa --image=radial/busyboxplus:curl -i --tty --rm
##### =>If you don't see a command prompt, try pressing enter.
# 
#                                $ curl -Lk fastapi-cast-service:5000/docs
##### => [ root@curl-cpa:/ ]$ curl -Lk fastapi-cast-service:5000/docs
##### =>
##### =>    <!DOCTYPE html>
##### =>    <html>
##### =>    <head>
##### =>    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
##### =>    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
##### =>    <title>FastAPI - Swagger UI</title>
##### =>    </head>
##### =>    <body>
##### =>    <div id="swagger-ui">
##### =>    </div>
##### =>    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
##### =>    <!-- `SwaggerUIBundle` is now available on the page -->
##### =>    <script>
##### =>    const ui = SwaggerUIBundle({
##### =>        url: '/openapi.json',
##### =>    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
##### =>        dom_id: '#swagger-ui',
##### =>        presets: [
##### =>        SwaggerUIBundle.presets.apis,
##### =>        SwaggerUIBundle.SwaggerUIStandalonePreset
##### =>        ],
##### =>        layout: "BaseLayout",
##### =>        deepLinking: true,
##### =>        showExtensions: true,
##### =>        showCommonExtensions: true
##### =>    })
##### =>    </script>
##### =>    </body>
##### =>    </html>
#
#                                $   curl -Lk fastapi-cast-service:5000/users
##### =>[ root@curl-cpa:/ ]$ curl -Lk fastapi-cast-service:5000/users
##### =>[]
##### =>[ root@curl-cpa:/ ]$ 
#
#                                 $ curl -Lkv fastapi-cast-service:5000/users/
##### => [ root@curl-cpa:/ ]$ curl -Lkv fastapi-cast-service:5000/users/
##### => > GET /users/ HTTP/1.1
##### => > User-Agent: curl/7.35.0
##### => > Host: fastapi-cast-service:5000
##### => > Accept: */*
##### => > 
##### => < HTTP/1.1 200 OK
##### => < date: Sat, 24 May 2025 16:32:21 GMT
##### => < server: uvicorn
##### => < content-length: 2
##### => < content-type: application/json
##### => < 
#
#                                 $   exit
##### => [ root@curl-cpa:/ ]$ exit
##### => Session ended, resume using 'kubectl attach curl-cpa -c curl-cpa -i -t' command when the pod is running
##### => pod "curl-cpa" deleted

###############


###############################
###   9.1) test deployment of a postgresql cast-db on k3d cluster
echo "\n###############################"
echo "*************************"
echo "9.1) test deployment of a postgresql cast-db on tghe k3d cluster "
ssh -i $url_id^rsa root@$ip_k3d 'docker images'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls -a'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'

url_rep_project="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/"
url_rep_ci_cd="$url_rep_project/dr01-python-microservices6"
url_rep_k8s="$url_rep_ci_cd/k8s"
cd $url_rep_k8s
pwd
rm -r ./cast
mkdir -p ./cast

cd ./cast
pwd

manifest_name="cast-db-deployment.yml"
cat <<EOF > ${manifest_name}
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/cast-service/k8s/cast-deployment.yaml
### BIBLIO
#### DM-JENKIN§S-B623 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
apiVersion: v1
kind: Secret
metadata:
  name: cast-db-secret
type: Opaque
data:
  cast-db-username: ZmFzdGFwaV91c2Vy       # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
  cast-db-password: ZmFzdGFwaV9wYXNzd2Q=   # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
  cast-db-database: ZmFzdGFwaV9kYg==       # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db
---
apiVersion: v1
kind: Service
metadata:
  name: cast-db-service
spec:
  selector:
    app: postgres
  ports:
    - name: cast-db-service-port
      port: 5432
      targetPort: 5432
---
apiVersion: apps/v1
#kind: Deployment
kind: StatefulSet
metadata:
  name: cast-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cast-db
  template:
    metadata:
      labels:
        app: cast-db
    spec:
      containers:
        - name: cast-db
          image: postgres
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-username
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-password
            - name: POSTGRES_DB
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-database
          ports:
            - containerPort: 5432
---
EOF
pwd
ls -lha
cat $manifest_name



ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/cast'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/cast/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get sts -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get po -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -o wide'
echo -e "\n############################### "
echo "*************************"
echo "9.1) test deployment of a postgresql cast-db on k3d cluster"
echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
ssh -i $url_id_rsa root@$ip_k3d kubectl exec cast-db-0 -- 'psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c "select * from pg_database"'
###############


###############################
###   9.1) test deployment of a postgresql cast-db on k3d cluster
echo "\n###############################"
echo "*************************"
echo "9.1) test deployment of a postgresql cast-db on tghe k3d cluster "
ssh -i $url_id^rsa root@$ip_k3d 'docker images'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls -a'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'

url_rep_project="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/"
url_rep_ci_cd="$url_rep_project/dr01-python-microservices6"
url_rep_k8s="$url_rep_ci_cd/k8s"
cd $url_rep_k8s
pwd
rm -r ./cast
mkdir -p ./cast

cd ./cast
pwd

manifest_name="cast-db-deployment.yml"
cat <<EOF > ${manifest_name}
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/cast-service/k8s/cast-deployment.yaml
### BIBLIO
#### DM-JENKIN§S-B623 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
apiVersion: v1
kind: Secret
metadata:
  name: cast-db-secret
type: Opaque
data:
  cast-db-username: ZmFzdGFwaV91c2Vy       # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
  cast-db-password: ZmFzdGFwaV9wYXNzd2Q=   # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
  cast-db-database: ZmFzdGFwaV9kYg==       # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db
---
apiVersion: v1
kind: Service
metadata:
  name: cast-db-service
spec:
  selector:
    app: postgres
  ports:
    - name: cast-db-service-port
      port: 5432
      targetPort: 5432
---
apiVersion: apps/v1
#kind: Deployment
kind: StatefulSet
metadata:
  name: cast-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cast-db
  template:
    metadata:
      labels:
        app: cast-db
    spec:
      containers:
        - name: cast-db
          image: postgres
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-username
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-password
            - name: POSTGRES_DB
              valueFrom:
                secretKeyRef:
                  name: cast-db-secret
                  key: cast-db-database
          ports:
            - containerPort: 5432
---
EOF
pwd
ls -lha
cat $manifest_name



ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app/cast'
scp -i $url_id_rsa ${manifest_name} root@$ip_k3d:/app/cast/
ssh -i $url_id_rsa root@$ip_k3d 'ls -lha /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'cat /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl delete -f /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f /app/cast/'${manifest_name}

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get sts -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get po -o wide'
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -o wide'
echo -e "\n############################### "
echo "*************************"
echo "9.1) test deployment of a postgresql cast-db on k3d cluster"
echo -e "\n Test-01 : Sql query on cast_db : select * from pg_database :"
ssh -i $url_id_rsa root@$ip_k3d kubectl exec cast-db-0 -- 'psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c "select * from pg_database"'
###############


################################################################

###############
###############################
################################################################



################################################################

################################################################
# END OF SCRIPT
#################################################################################################################################
#################################################################################################################################
