#!/bin/bash
export PS1="\[\e]0;\u@\h:]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\$ "
# => cpa@debianbu201$
#################################################################################################################################
echo -e "\n\n# URL script : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/Jenkins_devops_exams/init-k3d.sh"
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
## DM-JENKINSB33) Playing with Kubernetes using minikube and Rancher ; Prakhar Malviya ; 47Billion ; Prakhar Malviya ;Published in May 28, 2022
###   • https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23
## MINIKUBE-B04) Setting up Minikube and Accessing Minikube Dashboard Remotely; Aris Munawar, S. T., M. Sc.; Aris Munawar, S. T., M. Sc.; 5 min read; ; Dec 2, 2023
### https://medium.com/@areesmoon/setting-up-minikube-and-accessing-minikube-dashboard-09b42fa25fb6
#### $     minikube addons list
#### $     minikube addons enable ingress
#### $     minikube addons disable <addon-name>
#### $     minikube dashboard
#### $     curl http://127.0.0.1:46873/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
#### $     kubectl proxy
#####   => tarting to serve on 127.0.0.1:8001
#### $     ssh -L 12345:localhost:8001 root@<ip-of-your-server>
####       using localhost / 127.0.0.1 at port 12345. The link for the dashboard is now 
#### $      http://localhost:12345/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
##### =>  Your local port 12345 will be tied up with the server at port 8001 as long as the SSH connection is connected.
##
## MINIKUBE-B02) Exple fastapi-react -minikube ; borys25ol / fastapi-react-kubernetes; Public
### https://github.com/borys25ol/fastapi-react-kubernetes?tab=readme-ov-file
#### $     minikube start
#### $     minikube dashboard
####       fastapi-react-kubernetes / /kubernetes/ : https://github.com/borys25ol/fastapi-react-kubernetes/tree/master/kubernetes
#####         Running FastAPI React Application on Kubernetes; FastAPI React: Source code ; Backend; FastAPI Todo App: click Frontend ; React Todo App: https://github.com/borys25ol/fastapi-todo-example-app
#####        Frontend : React Todo App: click : https://github.com/borys25ol/react-todo-example-app

####           fastapi-react-kubernetes/kubernetes / /fastapi-secret.yml :  DATABASE_URL=postgresql://postgres:postgres@postgres-db-service:5432/tododb : https://github.com/borys25ol/fastapi-react-kubernetes/blob/master/kubernetes/fastapi-secret.yml
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
echo -e "\n###############################"
echo -e "\n\n### 1.1) Launch proxmox and list all vm"
sudo qm list
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n###############################"
echo -e "\n\n### 1.2) Start VM pve : jenkins server for homework jenkins"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n###############################"
echo -e "\n\n### 1.3) List all vm"
sudo qm list
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 1.4 ) Write number of the vm to start for jenkins server"
read -p "Saisr le numéro de la vm jenkins à démarrer: " ref_vm_jenkins
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 1.5 ) Start vm proxmox of jenkins server and verify status vm"
sudo qm start $ref_vm_jenkins
sudo qm status $ref_vm_jenkins
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n###############################"
echo -e "\n\n### 1.6) List all vm"
sudo qm list
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 1.7 ) Write number of the vm to start for minikube server"
read -p "indiquer le numéro de la vm with minikube server  à démarrer: " ref_vm_minikube
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 1.8 ) Start vm proxmox of minikube server and verify status vm"
sudo qm start $ref_vm_minikube
sudo qm status $ref_vm_jenkins
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n###############################"
echo -e "\n\n### 1.69 List all vm"
sudo qm list
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
##############
###############################
################################################################


################################################################
echo -e "\n################################################################"
echo -e "\n\n## 2.) Open 2 others tab gnome-terminal with ssh access on server jenkins and server minikube"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################";
echo -e "\n\n### 2.1) Initiate variables";
url_id_rsa="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa";
url_id_rsa_cpa="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa_cpa";
ip_jenkins="192.168.1.82";
ip_minikube="192.168.1.83";
url_rep_project_n0="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024"
url_rep_project="$url_rep_project_n0/dm-ds-cdo-may24-jenkins";
url_rep_ci_cd="$url_rep_project/dm-jenkins-cpa";
url_rep_k8s="$url_rep_ci_cd/k8s";
url_rep_charts="$url_rep_ci_cd/charts";
url_rep_backup="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/datas/backups";
url_jenkins_dir_kconfig="/usr/local";
url_pccpa_dir_kconfig="$url_rep_project_n0/.minikube";
filename_pccpa_kconfig="kubeconfig-minikube-cpacluster.yaml";
filename_pccpa_kconfig2="kubeconfig-minikube-cpacluster_cpa.yaml";
filename_pccpa_kconfig3="kubeconfig-minikube-cpacluster_jenkins.yaml";
filename_jenkins_kconfig=$filename_pccpa_kconfig2;
url_jenkins_kconfig=$url_jenkins_dir_kconfig"/"$filename_jenkins_kconfig;
echo -e "###############";
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 2.2) Move to directory"
cd $url_rep_project
pwd 
ls -lha
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 2.3) Access from host PC on vm-114-111-dmj-jenkins"
# gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
sleep 3
gnome-terminal --tab --name="jenkins2" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
echo "*************************"
echo "ip_jenkins : "
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'hostname -I'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###  2.4) Access from host PC on vm-114-111-dmj-k3d"
# gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_minikube"
gnome-terminal --tab --name="minikube2" --command "ssh -i $url_id_rsa_cpa cpa@$ip_minikube"
echo "*************************"
echo "ip_minikube : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'hostname -I'
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo -e "\n\n## 3.)  Erase all vm dckr  on JENKINS SERVER an,d minikube SERVER"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 3.1) Erase all vm dckr and launch the creation of ctnr docker on JENKINS SERVER"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####     3..1.1)  List then delete all ctnr dckr"
echo "########################################################"
echo "*************************"
echo "docker ps -a  on gnome-terminal jenkins :"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker ps -a'
# ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker rm -f $(sudo docker ps -aq)'
# ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker ps -a'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\necho -e "\n####     3..1.2) List and delete all dckr images""
echo "########################################################"
echo "*************************"
echo "docker images on gnome-terminal jenkins :"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker images'
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker image rmi -f $(sudo docker images -q)'
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker images'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\necho -e "\n####     3.1.3) List and delete all dckr volumes""
echo "########################################################"
echo "*************************"
echo "docker volume ls  on gnome-terminal jenkins :"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker volume ls'
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker volume rm -f $(sudo docker volume ls -q)'
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker volume ls'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####     3.1.4) List and delete all dckr networks"
echo "########################################################"
echo "*************************"
echo "docker network ls  on gnome-terminal jenkins :"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker network ls'
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker network rm $(sudo docker network ls -q)'
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'docker network ls'
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
echo -e "###############"
###############
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"#############################################################

################################################################
echo -e "\n\n### 3.2) Erase all vm dckr and launch the creation of ctnr docker on minikube"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####     3.2.1) Delete namaespace dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'sudo kubectl delete ns dev'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####     3.2.2) Delete dckr compose deployment"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'mkdir -p /app && cd /app && ls -lha /app docker compose down'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####     3.2.3)  List then delete all ctnr dckr"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker ps -a'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker rm -f $(sudo docker ps -aq)'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker ps -a'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n#####     3.2.4) List and delete all dckr images"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker images'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker image rmi -f $(sudo docker images -q)'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker images'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n######     3.2.5) List and delete all dckr volumes"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker volume ls'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker volume rm -f $(sudo docker volume ls -q)'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker volume ls'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n######     3.2.6) List and delete all dckr networks"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network ls'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network rm $(sudo docker network ls -q)'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network ls'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n######     3.2.7) List and verify all dckr components are well deleted ="
echo "*************************"
echo "dckr networks : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network ls'
echo "*************************"
echo "dckr volumes : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker volume ls'
echo "*************************"
echo "dckr images : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker images'
echo "*************************"
echo "dckr ctnr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker ps -a'
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################

################################################################
echo -e "\n################################################################"
## 4) Create cluster minikube with 1 master node and 2 workers nodes
###############
###  Creating the cluster : one master and 2 workers k3S
###       B33-k3d-Rancher-supervision-Playing with Kubernetes using minikube and Rancher | by Prakhar Malviya | 47Billion | Medium:
####         https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23

####          These ports will map to ports 8900, 8901 and 8902 of your localhost respectively.
####          The cluster will have 1 master node and 2 workers nodes. You can adjust these settings using the p and the agent flags as you wish.
#####             sudo minikube cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=172.30.0.6"@server:*
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.1) Create a docker network named "dm-jenkins-cpa-infra_my-net" which wille be use by server Jenkins and cluster k3d"
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network create dm-jenkins-cpa-infra_my-net'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network ls'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.2) This will create a cluster intituled \"minikube\" with 1 ctl manager"
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
#####             sudo minikube cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=172.30.0.6"@server:*
###############
###############
# sudo minikube cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${$ip_jenkins}"@serv
#  ssh -i $url_id_rsa_cpa cpa@$ip_minikube  'minikube cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=localhost"@server:*'
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube  'minikube cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${$ip_jenkins}"@server:*'

####                        minikube delete cluster
ssh -i $url_id_rsa_cpa cpa@$ip_minikube  'minikube delete --all'
sleep 15
ssh -i $url_id_rsa_cpa cpa@$ip_minikube  'minikube start --apiserver-ips=192.168.1.83 --listen-address=0.0.0.0 --cpus max --memory 5120mb'
sleep 15
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.3) Verify that minikube is enable"
###############
#### Setting up Minikube and Accessing Minikube Dashboard Remotely; Aris Munawar, S. T., M. Sc.; Aris Munawar, S. T., M. Sc.; 5 min read; Dec 2, 2023
##### https://medium.com/@areesmoon/setting-up-minikube-and-accessing-minikube-dashboard-09b42fa25fb6
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube cluster list -o wide'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube profile list'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.4) Enable ingress addon:"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube addons list'
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube addons enable ingress'
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube addons disable ingress'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.5) Enable and Access Minikube Dashboard"
# gnome-terminal --tab --name="cpa2" --command PS1="\[\e]0;\u@\h:]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\$ "
gnome-terminal --tab --title="cpa2" --command="bash -c 'PS1=\"\\[\\e[0;31m\\]\\u\\[\\e[m\\] \\[\\e[1;34m\\]\\w\\[\\e[m\\] \\[\\e[0;31m\\]\\$ \\[\\e[m\\]\\[\\e[0;32m\\]\"; exec bash'"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.6)  Enable and Access Minikube Dashboard"
gnome-terminal --tab --title="cpa2" --command="ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube dashboard --url'"

## ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'curl -v http://127.0.0.1:44713/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.7) Accessing Dashboard remotely"
gnome-terminal --tab  --command="ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl proxy'"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.8) Create tunnel SSH to your server minikube , using -L option. Open terminal/command prompt on your local PC/laptop and type the following command:"
gnome-terminal  --tab --command="bash -c 'ssh -L 12345:localhost:8001 -i /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa_cpa cpa@192.168.1.83; exec bash -i'"

###   MINIKUBE-B04) Setting up Minikube and Accessing Minikube Dashboard Remotely; Aris Munawar, S. T., M. Sc.; Aris Munawar, S. T., M. Sc.; 5 min read; Dec 2, 2023: https://medium.com/@areesmoon/setting-up-minikube-and-accessing-minikube-dashboard-09b42fa25fb6
####  Step 1. Managing Addons on Minikube
####    $    minikube addons list
####    $    minikube addons enable ingress  # enable ingress addon: / minikube addons disable <addon-name>
####  Step 2. Enabling and Accessing Minikube Dashboard
####    $    minikube dashboard
####    $    curl http://127.0.0.1:46873/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
####  Step 3. Accessing Dashboard remotely
####    $    kubectl proxy
####  => Starting to serve on 127.0.0.1:8001
####    $    ssh -L 12345:localhost:8001 root@<ip-of-your-server>
####    $    curl  http://localhost:12345/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
####  => Your local port 12345 will be tied up with the server at port 8001 as long as the SSH connection is connected. Following is the Kubernetes dashboard, accessed remotely from local machine.
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    4.9)  Test on another terminal or/andfirefox "
curl -v  http://localhost:12345/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
###############
##   A How To Guide: Remotely Accessing Minikube Kubernetes on KVM; 
#### https://zepworks.com/posts/access-minikube-remotely-kvm/

ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker port minikube'
##### => 8443/tcp -> 127.0.0.1:32806

cpa@pve$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube ip'
##### => 192.168.49.2
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo "########################################################"
echo "###    4.10) List dckr components and kubernetes object of k3d-cpacluster"
echo "*************************"
echo "4.10.1) docker ps -a : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker ps -a'
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
echo "4.10.2) docker network ls : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker network ls'
echo "########################################################"
echo "########################################################"

echo "*************************"
echo "4.10.3) minikube cluster list : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube cluster list'
echo "########################################################"

echo "*************************"
echo "4.10.4) kubctl cluster-info : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl cluster-info'
### cf DM-JENKINS-B96-03) Search on brave : kubectl cluster-info for Multiple Clusters : https://search.brave.com/search?q=kubectl+cluster-info+with+several+clusters&source=web&summary=1&conversation=b7b978fe62a8dedc30bd48
#### 1) adding the necessary details to your kubeconfig file.
##### $ vim ~/.config/k3d/kubeconfig-mycluster.yaml
#### 2) To switch contexts, you can use the following command:
##### $ kubectl config use-context <context-name>
#### 3)  then use kubectl cluster-info to get information about the cluster associated with that context.
##### $ kubectl cluster-info
echo "########################################################"

echo "*************************"
echo "4.10.5) kubctl get nodes -o wide  : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get nodes -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.6) kubctl namespaces  -A -o wide: on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get ns -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.7 kubctl get pv  -A -o wide :  persitent volumes : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get pv -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.8) kubctl get pvc  -A -o wide : persitent volumes claim :on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get pvc -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.9) kubctl get all  -A -o wide : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get all -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.10)kubctl get pods -A -o wide :on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get pods -A  -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.11) kubctl get svc  -A -o wide : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get svc -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.12) kubctl get deployment  -A -o wide: on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get deployement -A -o wide'
echo "########################################################"

echo "*************************"
echo "4.10.13) kubctl get statefullset  -A -o wide : on  minikube servr : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get statefulset -A -o wide'
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"

###############
###############################
################################################################




################################################################
echo -e "\n################################################################"
echo -e "\n\n## 5) Create the file .kube/config to access kubectl command  from the server Jenkins and Copy this file on the Jenkins server"
###############
####        B33-3) minikube KUBECONFIG option --tls-san : doc1 doc officielle k3s / configuration / Configuration File
#####            / https://docs.k3s.io/installation/configuration
######                /etc/rancher/k3s/config.yaml, and drop-in files are loaded from /etc/rancher/k3s/config.yaml.d/*.yaml in alphabetical order. This path is configurable via the --config CLI flag or K3S_CONFIG_FILE env var. When overriding the default config file name, the drop-in directory path is also modified.
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n###    5.1) Create a kubeconfig-cpacluster.yaml config minikube cluster file"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####          5.1.1) Delete and recreate directory [./datas/data-k3d] to restart without existant file [./datas/data-k3d/$filename_pccpa_kconfig]"
# url_rep_project="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/"
# url_rep_ci_cd="$url_rep_project/dm-jenkins-cpa"
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
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker exec -it k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml' | tee ./datas/data-k3d/k3s.yaml
########
##########
#####               5.1.2.1) Method 1 : Create config minikube config file with docker
###### $ sh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker exec k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml'
###### $ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker exec k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml' > ./datas/data-k3d/k3s.yaml
###### $ cat ./datas/data-k3d/k3s.yaml
###### $ sleep 3
########

################
#####               5.1.2.2) Method 2 : Create a config minikube files with k3d-cli
# search brave with follow keywords : "minikube get-kubeconfig"
## DM-JENKINS-B96-01) https://search.brave.com/search?q=r+creating+the+admin+kubeconfig+file+and+try+again+k3d+init&source=desktop&summary=1&conversation=675f5faf652a6d4327352c
## minikube get-kubeconfig
### To retrieve the kubeconfig for a minikube cluster, you can use the minikube kubeconfig get command. This command allows you to specify one or more clusters by name or use the --all flag to get kubeconfigs for all clusters. The output can be directed to a file or used directly to configure kubectl access to the cluster.
#### For example, to get the kubeconfig for a cluster named mycluster, you can run:
##### minikube kubeconfig get mycluster : cf DM-JENKINS-B96-02-serach brave with follow keywords : "minikube get-kubeconfig" : https://search.brave.com/search?q=k3d+get-kubeconfig&source=desktop&summary=1&conversation=47236dee18d99355bbd333
###### For example, to get the kubeconfig for a cluster named mycluster, you can run:
####### $ minikube kubeconfig get mycluster
###### To get kubeconfigs for all clusters and save them to a file named kubeconfig, you can use:
####### $ minikube kubeconfig get --all > kubeconfig
###### Additionally, you can use the minikube kubeconfig write command to export the kubeconfig to a specific file, such as $HOME/.k3d/kubeconfig-mycluster.yaml, which is useful for managing Kubernetes remotely from other workstations.
####### $ minikube kubeconfig write mycluster
###### You can also merge multiple kubeconfigs into a single file using the minikube kubeconfig merge command, which is helpful for managing access to multiple clusters in a single configuration file.
####### $ minikube kubeconfig merge
###### For more detailed options and flags, you can refer to the minikube documentation on handling kubeconfigs
###### To get kubeconfigs for all clusters and save them to a file named kubeconfig, you can use:
####### $ minikube kubeconfig get --all > kubeconfig

###### $ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'rm /root/.config/k3d/*.yaml'
###### $ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'ls -lha /root/.config/k3d/'
###### $ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube kubeconfig write cpacluster'
####### => cpa@debianbu201$  ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube kubeconfig write cpacluster'
####### => /root/.config/k3d/kubeconfig-cpacluster.yaml

###### $ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'ls -lha /root/.config/k3d/'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n#####               5.1.2.3) Method 3 : Create a config minikube files with kubectl-cli"
### Generate Minikube Kubeconfig : https://search.brave.com/search?q=generate+kubeconfig+minikube&summary=1&conversation=ce276599bca5e0b44e1bba
#####    $     Start minikube with the --kubeconfig flag to specify the path to your kubeconfig file:
####     $    minikube start --kubeconfig=/path/to/your/kubeconfig
####     Alternatively, you can set the KUBECONFIG environment variable to point to your kubeconfig file:
####     $    export KUBECONFIG=/path/to/your/kubeconfig
####     $    minikube start
####     After setting up minikube, you can verify that the kubeconfig file has been correctly configured by running:
####     $    kubectl config get-contexts
####     This command will list all the contexts available in your kubeconfig file, including the one for minikube.
####     If you want to switch to the minikube context, you can use:
####     $    kubectl config use-context minikube

#### MINIKUBE-B07) Remote access minikube service problem when I minikube start --listen-address='0.0.0.0', it not works, no any local address listening #14364https://github.com/kubernetes/minikube/issues/14364 ; minikube kubectl -- config view --flatten > ~/Download/remote-config ;  Fritskee ; on Sep 17, 2023 ; I finally tested successfully.
##### S1) When you do your first "minikube start", you have to specify the option of 
#####       $  "--apiserver-ips", setting it to the IP address of the minikube host, 
#####       $   and the option of "--listen-address=0.0.0.0". 
#####       $   Otherwise, you need to do "minikube delete" and re-create minikube docker image with the 2 options.
##### 
##### S2) Next, you have to copy 4 files: ca.crt, client.crt, client.key and config on the minikube server to your remote machine.
##### 
##### S3)  Then, on your remote machine, you have to change "config" file by specifying the locations of 
#####    $     ca.crt, client.crt and client.key, 
#####    $     as well as the IP address and port on the line "server: https://<IP.address.of.minikube>:49154". Remember that minikube is listening to 0.0.0.0:49154 and not 8443.
##### 
##### S4) Finally, you can do "kubectl --kubeconfig <location_of_config> get pods -A
##### 
##### And it worked!!
##### 
##### This one actually saved me! Thanks so much!
##### 
##### robipresotto
##### robipresotto commented on Jan 26
##### robipresotto
##### on Jan 26
##### you can use the command below without the need of copying the certificates.
#####    $     minikube kubectl -- config view --flatten > ~/Download/remote-config
echo -e "###############"
###############
echo -e "###############################\n"
echo "*************************"
 
echo -e "\n####        5.1.2.4) List of port used oin minikube server "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker port minikube'
echo "*************************"
 
echo -e "\n####        5.1.2.5) Save number of access port of minikube server used to connect on minikube cluster 8443 with cmd : \n $: port=$(echo $(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker port minikube' | grep 8443) | tail -c-6); echo $port;"
port=$(echo $(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker port minikube' | grep 8443) | tail -c-6)
echo $port
echo "*************************"

echo -e "\n####        5.1.2.6) Save ip of minikube server with cmd : \n $: ip_minikube2=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube ip'); echo $ip_minikube;"
ip_minikube2=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube ip')
echo $ip_minikube2
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker port minikube'
#####  => cpa@debian-pve:~$ docker port minikube
#####  => 22/tcp -> 127.0.0.1:32793
#####  => 2376/tcp -> 127.0.0.1:32794
#####  => 5000/tcp -> 127.0.0.1:32795
#####  => 8443/tcp -> 127.0.0.1:32796
#####  => 32443/tcp -> 127.0.0.1:32797
echo "*************************"
 
echo -e "\n####        5.1.2.7) create a directory to save certificate files useb by minikube cluster /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.minikube/profiles/minikube with cmd : \n $:rm -r ../.minikube; mkdir -p ../.minikube/profiles/minikube/; ls -lha ../.minikube/profiles/minikube"
# url_rep_project_n0="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024"
# url_rep_project="$url_rep_project_n0/dm-ds-cdo-may24-jenkins";
cd $url_rep_project_n0;
pwd;
ls -lha;
rm -r ./.minikube;
pwd;
ls -lha ./.minikube;

mkdir -p ./.minikube/profiles/minikube/
cd ./.minikube/profiles/minikube/
pwd 
ls -lha 
echo "*************************"
 
echo -e "\n####        5.1.2.8) copy client.crt and client.key certrificates with cmd : \n $: scp -r -i $url_id_rsa_cpa cpa@$ip_minikube:/home/cpa/.minikube/profiles/minikube/client* ../.minikube/profiles/minikube/ "
cd $url_rep_project_n0/.minikube/profiles/minikube/;
pwd;
ls -lha
scp -r -i $url_id_rsa_cpa cpa@$ip_minikube:/home/cpa/.minikube/profiles/minikube/client* .
pwd;
ls -lha  ;
cat ./client.crt;
cat ./client.key;
echo "*************************"
 
echo -e "\n####        5.1.2.9) Copy ca.crt from minikube server to PC developper to test with the user cpa on jenkins server with cmd  : \n $: cd $url_rep_project; \ncd datas/.minikube; \nrm -r ca.crt; \npwd; \nls -lha; \nscp -r -i $url_id_rsa_cpa cpa@$ip_minikube:/home/cpa/.minikube/ca.crt .; \npwd; \nls -lha; \ncat ca.crt;"
cd $url_rep_project_n0/.minikube;
pwd;
ls -lha
rm -r ca.crt
pwd;
ls -lha;
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'echo -e \"cat /home/cpa/.minikube/ca.crt\n\"; cat /home/cpa/.minikube/ca.crt'"
scp -r -i $url_id_rsa_cpa cpa@$ip_minikube:/home/cpa/.minikube/ca.crt .
pwd;
ls -lha $url_rep_project_n0/.minikube/ca.crt;
cat $url_rep_project_n0/.minikube/ca.crt;
echo "*************************"
 
echo -e "\n####        5.1.2.10) Copy client.crt from PC developper to jenkins server to test with the user cpa on jenkins server with cmd : \n $: scp -r -i $url_id_rsa_cpa ./profiles/minikube/client.crt cpa@$ip_jenkins:/home/cpa/.minikube/profiles/minikube/; \nssh -i $url_id_rsa_cpa cpa@$ip_jenkins \"bash -c ' cat /home/cpa/.minikube/profiles/minikube/client.crt;'\""
ls -lha $url_rep_project_n0/.minikube/profiles/minikube/client.crt
cat $url_rep_project_n0/.minikube/profiles/minikube/client.crt
scp -r -i $url_id_rsa_cpa $url_rep_project_n0/.minikube/profiles/minikube/client.crt cpa@$ip_jenkins:/home/cpa/.minikube//profiles/minikube/
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c ' cat /home/cpa/.minikube/profiles/minikube/client.crt'"
echo "*************************"
 
echo -e "\n####        5.1.2.11) Copy client.key from PC developper to jenkins server to test with the user cpa on jenkins server with cmd : \n $: scp -r -i $url_id_rsa_cpa ./profiles/minikube/client.key cpa@$ip_jenkins:/home/cpa/.minikube/profiles/minikube/; \nssh -i $url_id_rsa_cpa cpa@$ip_jenkins \"bash -c ' cat /home/cpa/.minikube/profiles/minikube/client.key;'\""
ls -lha $url_rep_project_n0/.minikube/profiles/minikube/client.key
cat $url_rep_project_n0/.minikube/profiles/minikube/client.key
scp -r -i $url_id_rsa_cpa $url_rep_project_n0/.minikube/profiles/minikube/client.key cpa@$ip_jenkins:/home/cpa/.minikube//profiles/minikube/
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c ' cat /home/cpa/.minikube/profiles/minikube/client.key'"

echo "*************************"
echo -e "\n####        5.1.2.12) Copy ca.crt from PC developper to jenkins server to test with the user cpa on jenkins server with cmd : \n $: scp -r -i $url_id_rsa_cpa ./profiles/minikube/client.crt cpa@$ip_jenkins:/home/cpa/.minikube/profiles/minikube/; \nssh -i $url_id_rsa_cpa cpa@$ip_jenkins \"bash -c ' cat /home/cpa/.minikube/profiles/minikube/client.crt;'\""
ls -lha $url_rep_project_n0/.minikube/ca.crt
cat $url_rep_project_n0/.minikube/ca.crt
scp -r -i $url_id_rsa_cpa $url_rep_project_n0/.minikube/ca.crt cpa@$ip_jenkins:/home/cpa/.minikube/
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c ' cat /home/cpa/.minikube/ca.crt'"
echo "*************************"

echo "*************************"
echo -e "\n####        5.1.2.13) Create context devops-[develop, qa, staging, prod] from PC developper to jenkins server to test with the user cpa on jenkins server with cmd : \n $: scp -r -i $url_id_rsa_cpa ./profiles/minikube/client.crt cpa@$ip_jenkins:/home/cpa/.minikube/profiles/minikube/; \nssh -i $url_id_rsa_cpa cpa@$ip_jenkins \"bash -c ' cat /home/cpa/.minikube/profiles/minikube/client.crt;'\""

echo -e "\n####  View contexts and the clusters : kubectl config get-contexts"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config get-contexts'"

echo -e "\n####  Delete context devops-develop on the kubeconfig file with cmd: \n$: kubectl config delete-context [devops-develop devops-qa devops-staging devops-prod]"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config delete-context devops-develop'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config delete-context devops-qa'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config delete-context devops-staging'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config delete-context devops-prod'"

echo -e "\n####  View contexts and the clusters : kubectl config get-contexts"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config get-contexts'"

echo -e "\n####  Create context devops-develop on the kubeconfig file with cmd : \n$: bash -c \'kubectl config set-context devops-develop --user=minikube --cluster=minikube --namespace=develop\'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config set-context devops-develop --user=minikube --cluster=minikube --namespace=develop'"

echo -e "\n####  Create context devops-qa on the kubeconfig file with cmd : \n$: bash -c \'kubectl config set-context devops-qa --user=minikube --cluster=minikube --namespace=qa\'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config set-context devops-qa --user=minikube --cluster=minikube --namespace=qa'"

echo -e "\n####  Create context devops-staging on the kubeconfig file with cmd : \n$: bash -c \'kubectl config set-context devops-staging --user=minikube --cluster=minikube --namespace=staging\'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config set-context devops-staging --user=minikube --cluster=minikube --namespace=staging'"

echo -e "\n####  Create context devops-prod on the kubeconfig file with cmd : \n$: bash -c \'kubectl config set-context devops-prod --user=minikube --cluster=minikube --namespace=prod\'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config set-context devops-prod --user=minikube --cluster=minikube --namespace=prod'"

echo -e "\n####  View contexts and the clusters : kubectl config get-contexts"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config get-contexts'"

echo -e "\n####  Opening the kubeconfig file using the command: kubectl config view"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl config view'"

echo "*************************"

 
echo -e "\n####        5.1.2.15) Copy config file of the minikub cluster with cmd : \n $: echo \"$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl config view --raw')\" >  $url_pccpa_dir_kconfig/$filename_pccpa_kconfig; \ncat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig"
# url_pccpa_dir_kconfig="$url_rep_project_n0/.minikube";
$url_pccpa_dir_kconfig
pwd;
ls -lha;
#  minikube kubectl -- config view --flatten > ~/Download/remote-config
echo "$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl config view --raw')" >  $url_pccpa_dir_kconfig/$filename_pccpa_kconfig
echo "$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl config view --raw --flatten')" >  $url_pccpa_dir_kconfig/config
pwd;
ls -lha $url_pccpa_dir_kconfig/$filename_pccpa_kconfig;
cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig

ls -lha $url_pccpa_dir_kconfig/config
cat $url_pccpa_dir_kconfig/config
# echo "$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'minikube kubectl -- config view --flatten')" >  ./kubeconfig-k3d-cpacluster.yaml
## scp -i $url_id_rsa_cpa ./kubeconfig-k3d-cpacluster.yaml root@$ip_minikube:/home/cpa/.config/k3d/kubeconfig-cpacluster.yaml
## ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'cat /root/.config/k3d/kubeconfig-cpacluster.yaml'
#ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'export KUBECONFIG="/root/.config/k3d/kubeconfig-cpacluster.yaml"; echo $KUBECONFIG'
echo "*************************"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####          5.1.3) Copy ./$filename_pccpa_kconfig  to ./$filename_pccpa_kconfig2 and update ./$filename_pccpa_kconfig2 replace ip_minikube_cluster by ip_minikube_server with cmd : \n $: cd $url_pccpa_dir_kconfig; \n pwd; \n ls -lha; \n cp ./$filename_pccpa_kconfig ./$filename_pccpa_kconfig2; \n cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2; \n sed 's+'$ip_minikube2':8443+'$ip_minikube:$port'+g' -i $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2; \n pwd; \n ls -lha; \n cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2"
#sed -i "s|server: https://127.0.0.1:6443|server: https://$$ip_jenkins:6443|g" ./datas/data-k3d/k3s.yaml
# sed -i 's/'$ip_source'\b/'$$ip_jenkins'/g' ./datas/data-k3d/k3s.yaml
# sed -E 's~(https?://)[^ :;]+(:?\d*)~\1'$$ip_jenkins2'\2~' -i ./datas/data-k3d/k3s.yaml
ip_source="127\\.0\\.0\\.1"
echo "ip_source: " $ip_source
#$ip_jenkins2="https://$$ip_jenkins"
####             ip_jenkins=$(sudo docker exec jenkins hostname -i)
# ip_jenkins=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker exec jenkins hostname -i')
# echo "$ip_jenkins: " $ip_jenkins

####              ip_k3s_srvr=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker exec k3d-mycluster-server-0 hostname -i')
####              echo "ip_k3s_srvr: " $ip_k3s_srvr
cd $url_pccpa_dir_kconfig
pwd
ls -lha
cp $url_pccpa_dir_kconfig/$filename_pccpa_kconfig $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2
####              sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s_v2.yaml
cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2

cp $url_pccpa_dir_kconfig/config $url_pccpa_dir_kconfig/config2
####              sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s_v2.yaml
cat $url_pccpa_dir_kconfig/config2

## sed -i 's+$ip_minikube:8443+'$ip_minikube:$port'+g' ./kubeconfig-k3d-cpacluster_v2.yaml
sed 's+'$ip_minikube2':8443+'$ip_minikube:$port'+g' -i $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2

## sed -i 's+$ip_minikube:8443+'$ip_minikube:$port'+g' ./kubeconfig-k3d-cpacluster_v2.yaml
sed 's+'$ip_minikube2':8443+'$ip_minikube:$port'+g' -i $url_pccpa_dir_kconfig/config2

ls -lha $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2
cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2

ls -lha $url_pccpa_dir_kconfig/config2
cat $url_pccpa_dir_kconfig/config2

#sudo docker exec -it jenkins export KUBECONFIG=/datas/data-k3d/k3s_v2.yaml
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####          5.1.4) Copy ./$filename_pccpa_kconfig2  to ./$filename_pccpa_kconfig2 and update ./$filename_pccpa_kconfig3 replace home/cpa by /home/jenkins with cmd : \n $: cd $url_pccpa_dir_kconfig; \n pwd; \n ls -lha; \n cp ./$filename_pccpa_kconfig ./$filename_pccpa_kconfig2; \n cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2; \n sed 's+'$ip_minikube2':8443+'$ip_minikube:$port'+g' -i $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2; \n pwd; \n ls -lha; \n cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2"

cd $url_pccpa_dir_kconfig
pwd
ls -lha
cp ./$filename_pccpa_kconfig2 ./$filename_pccpa_kconfig3
####              sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s_v2.yaml
cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig3

## sed -i 's+$ip_minikube:8443+'$ip_minikube:$port'+g' ./kubeconfig-k3d-cpacluster_v2.yaml
sed 's+'/home/cpa/'+'/home/jenkins/'+g' -i $url_pccpa_dir_kconfig/$filename_pccpa_kconfig3

pwd
ls -lha $url_pccpa_dir_kconfig/$filename_pccpa_kconfig3
cat $url_pccpa_dir_kconfig/$filename_pccpa_kconfig3
#sudo docker exec -it jenkins export KUBECONFIG=/datas/data-k3d/k3s_v2.yaml
echo -e "###############"
###############
echo -e "###############################\n"
###############################

################################################################
echo -e "\n################################################################"
echo -e "\n\n##    5.2) Copy ./datas/data-k3d/k3s_v2.yaml jenkins:$url_jenkins_dir_kconfig/ to enable acces of kubectl command from Jenkins server"
###                           sudo docker cp ./datas/data-k3d/k3s_v2.yaml jenkins:$url_jenkins_kconfig
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "mkdir -p /home/cpa/.kube"
scp -i $url_id_rsa $url_pccpa_dir_kconfig/$filename_pccpa_kconfig2 root@$ip_jenkins:/home/cpa/.kube/config
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "ls -lha /home/cpa/.kube/config"
ssh -i  $url_id_rsa_cpa cpa@$ip_jenkins "cat /home/cpa/.kube/config"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n##    5.3) Verify copy on the vm jenkins server to access on commands kubectl get nodes/pods on the minikube cluster"
###                           sudo docker exec -it jenkins cat $url_jenkins_kconfig
echo -e "\n####        5.3.1) From jenkins server : kubectl --kubeconfig $url_jenkins_kconfig get nodes"  
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get nodes -o wide"

echo -e "\n####        5.3.2) From jenkins server : kubectl --kubeconfig $url_jenkins_kconfig get pods --all-namespaces -o wide"  
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get pods -A -o wide"
#$ip_jenkins=$(sudo docker exec -it jenkins hostname -i)
# echo $$ip_jenkins
#sudo docker exec -it jenkins hostname -i > foo && sed -e 's/^M//g' foo && $ip_jenkins=`cat foo` && echo $$ip_jenkins && rm foo
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo -e "\n\n# 7) configure jenkins server to enable the access to vm minikube cluster"
# cd /home/cpa//Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins

# sudo docker network create dm-jenkins-cpa-infra_my-net
# sudo docker network ls

# ssh-add /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/ssh-key-github-cpa8876
# git branch -a
# git status
# git add .
# git commit -m "update final version of Jenkinsfile step 1 buil images"
# git push origin main
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n## 7.0) Adduser jenkins"
ssh -i $url_id_rsa root@$ip_jenkins 'adduser jenkins'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n## 7.1) Configure jenkins server and copy data from the project dm jenkins"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####          7.1.1) Procedure to assure that docker is well configure about docker group reboot delay 10s"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
ssh -i $url_id_rsa root@$ip_jenkins 'useradd -m jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'groupadd docker'
ssh -i $url_id_rsa root@$ip_jenkins 'usermod -aG docker jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'reboot'
sleep 10
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
ssh -i $url_id_rsa root@$ip_jenkins 'newgrp docker'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl restart docker.service'
sleep 3
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####          7.1.2) Update access on the jenkins server : replace the port 8080 by the port 8082"
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
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####                  7.1.2.1) Method 1"

ssh -i $url_id_rsa root@$ip_jenkins 'cat /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'nano /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sed -i "s|HTTP_PORT=8080|HTTP_PORT=8082|g" /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo cat /etc/default/jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo systemctl restart jenkins'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####                  7.1.2.2) Method 2"
ssh -i $url_id_rsa root@$ip_jenkins 'sudo -S systemctl stop jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo systemctl status jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo cat /etc/systemd/system/jenkins.service'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo sed -i "s|JENKINS_PORT=8080|JENKINS_PORT=8082|g" /etc/systemd/system/jenkins.service'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo cat /etc/systemd/system/jenkins.service'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo systemctl daemon-reload'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo systemctl restart jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'sudo systemctl status jenkins'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####                  7.1.2.3) Verify the update of access port of jenkins server"
echo $(curl -v $ip_jenkins:8082)
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n####         7.1.3) Copy the fastapi files and script of the homework jenkins"
ssh -i $url_id_rsa root@$ip_jenkins ' rm -r /app'
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app'
ssh -i $url_id_rsa root@$ip_jenkins 'mkdir -p /app'
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app'


scp -r -i $url_id_rsa $url_rep_ci_cd/cast-service root@$ip_jenkins:/app/
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/cast-service/'

scp -r -i $url_id_rsa $url_rep_ci_cd/movie-service root@$ip_jenkins:/app/movie-service
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/movie-service/'

scp -r -i $url_id_rsa $url_rep_ci_cd/k8s-test8 root@$ip_jenkins:/app/fastapiapp
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/fastapiapp'

scp -i $url_id_rsa $url_rep_ci_cd/docker-compose.yml root@$ip_jenkins:/app/

scp -i $url_id_rsa $url_rep_ci_cd/nginx_config.conf root@$ip_jenkins:/app/

scp -i $url_id_rsa $url_rep_ci_cd/nginx_config2.conf root@$ip_jenkins:/app/

scp -i $url_id_rsa $url_rep_ci_cd/README.md root@$ip_jenkins:/app/

ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/'

scp -i $url_id_rsa -r root@$ip_jenkins:/app/* root@$ip_minikube:/app/

ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'ls -lha /app/'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 7.2) Access from host PC on vm-114-111-dmj-jenkins"
# gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
echo "*************************"
echo "ip_jenkins : "
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'hostname -I'
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo -e "\n\n### 7.3) Access from host PC on vm-114-111-dmj-k3d"
# gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_minikube"
gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_minikube"
echo "*************************"
echo "ip_minikube : "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'hostname -I'
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################




################################################################
echo -e "\n################################################################"
echo -e "\n\n# 8) Verification on vm minikube"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo "####   8.0.1) Display ip of cluster"
echo "*************************"
echo -e "\n\n###         8.0.1)cmd from minikube srvr: minikube ip"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube ip"
echo -e "###############"
###############
echo -e "###############################\n"
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.0.2) Display ip of cluster"
echo "*************************"
echo -e "\n\n###         8.0.2.1)cmd from minikube srvr: minikube profile list"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube profile list"

echo -e "\n###############################"
echo "*************************"
echo -e "\n\n###        8.0.2.2) cmd from jenkins srvr : k cluster-info"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig cluster-info"

echo -e "\n###############################"
echo "*************************"
echo -e "\n\n###        8.0.2.3) cmd from jenkins srvr : k cluster-info dump not executed"
# ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig cluster-info dump"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.1) Display all VM docker : "
echo "*************************"
echo -e "\n\n###         8.1.1)cmd from minikube srvr: docker images"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker images'

echo "*************************"
echo -e "\n\n###         8.1.2)cmd from minikube srvr: docker volume ls"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker volume ls'

echo "*************************"
echo -e "\n\n###         8.1.3)cmd from minikube srvr: docker ps -a"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'docker ps -a'
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.2) Display all elements of the minikube cluster from minikube server"
echo "*************************"
echo -e "\n\n###         8.2.1)cmd from minikube srvr: kubectl get all -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get all -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.3) Display all nodes of the minikube cluster from jenkins server"
echo "*************************"
echo -e "\n\n###         8.3.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get pods -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get pods -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.4) Display all namespaces of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.4.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide"
##########
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.5) Display all services of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.5.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get svc -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get svc -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.6) Display all deployment of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.6.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get deployment -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get deployment -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.7) Display all statefulset of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.7.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get sts -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get sts -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.8) Display all daemons Set of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.8.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get ds -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get ds -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.9) Display all ingress of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.9.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get ingress -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get ingress -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.10) Display all configmap of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.10.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get configmap -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get configmap -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.11) Display all secret of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.11.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get secret-A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get secret -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.12) Display all persitant volume of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.12.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get pv-A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get pv -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo "####   8.13) Display all persistant volume claim of the minikube cluster"
echo "*************************"
echo -e "\n\n###         8.13.1)cmd from jenkins srvr: kubectl --kubeconfig $url_jenkins_kconfig get pvc -A -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get pvc -A -o wide"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
####    8.14) Display the password rancher monitoring k3s cluster
# echo " 8.6) ############################### "
# echo "*************************"
# echo "kubctl get svc -A -o wide from jenkins to minikube server :"
# kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################



################################################################
echo -e "\n\n################################################################"
echo -e "## BEGIN 9) Tests with k8s manifest to deploy a postgresql database, fastapi"
##########
###############
###############################
echo "####     9.1) test deployment of a postgresql cast-db on minikube cluster"
echo "\n###############################"
manifest_name="cast-db-deployment.yml"
echo "*************************"
echo -e "\n####        9.1.1) Create a directory on PC developper ./cast to save a $manifest_name to deploy cast-db postgresql with its secret, service, pvc and sts with file $manifest_name "

cd $url_rep_k8s
pwd
rm -r ./cast
mkdir -p ./cast

cd ./cast
pwd



cat <<EOF > ${manifest_name}
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dm-jenkins-cpa/cast-service/k8s/cast-deployment.yaml
### BIBLIO
#### DM-JENKIN§S-B623 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
---
kind: Namespace
apiVersion: v1
metadata:
  name: dev
  labels:
    name: fastapi-dm-jenkins
---
# K8s/B18) How to Deploy Postgres to Kubernetes Cluster; Published on January 19, 2024; https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
apiVersion: v1
kind: PersistentVolume
metadata:
  name: casts-db-volume-pv
  labels:
    type: local
    app: casts-db
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /data/postgresql
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: casts-db-pvc
  namespace: dev
  labels:
    app: casts-db
    namespace: dev
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Secret
metadata:
  name: cast-db-secret
  namespace: dev
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
  namespace: dev
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
  namespace: dev
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
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: cast-db-data
      volumes:
        - name: cast-db-data
          persistentVolumeClaim:
            claimName: casts-db-pvc
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "*************************\n"

echo -e "\n####        9.1.2) Create a directory on vm minikube srvr /app/cast to save a $manifest_name to deploy cast-db postgresql with its secret, service, pvc and sts"
ssh -i $url_id_rsa root@$ip_minikube 'mkdir -p /app/cast'
ssh -i $url_id_rsa root@$ip_minikube 'cd /app/cast; hostname -I; pwd'
ssh -i $url_id_rsa root@$ip_minikube 'ls -lha /app/cast'
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/cast/
ssh -i $url_id_rsa root@$ip_minikube 'ls -lha /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_minikube 'cat /app/cast/'${manifest_name}
ssh -i $url_id_rsa root@$ip_minikube 'mkdir -p /data/postgres'
echo -e "*************************\n"

echo -e "\n####        9.1.3.1) Delete previous deployment on vm minikube srvr  with cmd : \n    $kubectl delete -f /app/cast/${manifest_name}"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/cast/${manifest_name}"
echo -e "*************************\n"

echo -e "\n####        9.1.3.2) Wait 10 seconds to deploy all elements : secret, service, pvc and sts with the file $manifest_name"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        9.1.4) Apply deployment on vm minikube srvr  with cmd : \n    $kubectl apply -f /app/cast/${manifest_name}"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/cast/${manifest_name}"
echo -e "*************************\n"

echo -e "\n####        9.1.5) Wait 10 seconds to deploy all elements : secret, service, pvc and sts with the file $manifest_name"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        9.1.6) List namespaces  on vm minikube srvr  with cmd : \n    $kubectl get ns -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get ns -o wide"
echo -e "*************************\n"

echo -e "\n####        9.1.7.1) List pv deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get pv -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pv -A -o wide -n dev"
echo -e "************************\n\n"

echo -e "\n####        9.1.7.2) List pvc deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get pvc -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pvc -A -o wide -n dev"
echo -e "************************\n\n"


echo -e "\n####        9.1.7.3) List secrets deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get secrets -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get secrets -A -o wide -n dev"
echo -e "************************\n\n"

echo -e "\n####        9.1.8) List statefullset deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get sts -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get sts -o wide -n dev"

echo -e "*************************\n"
echo -e "\n####        9.1.11) List pods deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get po-o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get po -o wide -n dev"
echo -e "*************************\n"

echo -e "\n####        9.1.12) List services deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get svc -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide -n dev"
echo -e "*************************\n"

echo -e "\n####        9.1.13.1) Wait 10 seconds to deploy all elements : secret, service, pvc and sts with the file $manifest_name"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        9.1.13.2) Query sql on pod cast-db-sts-0 to test the deployment of a postgresql cast-db on minikube cluster on namesapace  dev with cmd :  kubectl exec cast-db-sts-0 -n dev -- \"psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \'select * from pg_database\'\""
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'select * from pg_database'"

# 
## K8S-kubctl-B06-Serach brave with kyeywords : create a pod to test access psql on postgresql sts
### https://search.brave.com/search?q=create+a+pod+to+test+access+psql+on+postgresql+sts&source=desktop&summary=1&conversation=37b6dc12548adece71b018
## kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=<your_password>" --command -- psql --host <postgresql_sts_service_name> -U postgres -d <your_database_name>
#### root@debian-pve:/app/cast# kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host 10.42.0.8 -U fastapi_user -d fastapi_db
##### => If you don't see a command prompt, try pressing enter.
##### => 
##### => fastapi_db=# 
echo -e "*************************\n"


echo -e "\n####        9.1.14) Deploy a test pod with image dckr bitnami/postgresql and execute a query sql on this pod to test the deployment of a postgresql cast-db on minikube cluster on namesapace  dev with cmd : \n    $kubectl run postgresql-client -it --namespace dev --image bitnami/postgresql --env=\'PGPASSWORD=fastapi_passwd\' --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c \'select * from pg_database\'\""
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl run postgresql-client -it --namespace dev --image bitnami/postgresql --env='PGPASSWORD=fastapi_passwd' --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c 'select * from pg_database'"
##### => cpa@debianbu201$ ssh -i $url_id_rsa root@$ip_minikube 'kubectl run postgresql-client -it --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c "select * from pg_database"'
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
echo -e "*************************\n"

echo -e "\n####        9.1.15) List pods deployed on namesapace dev on the minikube cluister with cmd : \n    $kubectl get pods -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -n dev"
echo -e "*************************\n"

echo -e "\n####        9.1.16) Delete test pod deployed with image dckr bitnami/postgresql with cmd : \n    $kubectl delete pod postgresql-client -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete pod postgresql-client -n dev"
# $ cpa@debianbu201$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl delete pod postgresql-client'
##### => pod "postgresql-client" deleted
echo -e "*************************\n"

echo -e "\n####        9.5.17) Wait 10 seconds to delete pod deployed with image dckr bitnami/postgresql with cmd : sleep 10"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        9.1.18) List pods deployed on namesapace dev on the minikube cluister with cmd : \n    $kubectl get pods -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -n dev"

# $cpa@debianbu201$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get pods'
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
echo -e "*************************\n"

echo -e "\n####        9.1.19) Replace on the dirtectory $url_rep_current"
echo $url_rep_current
cd $url_rep_backup
echo $url_rep_backup
echo -e "###############"
echo -e "###############################\n" 
echo -e "*************************\n"

echo -e "\n####        9.1.20) Wait 10 seconds to delete pod deployed with image dckr bitnami/postgresql with cmd : sleep 10"
sleep 10 
echo -e "*************************\n"

###############
###############################




################################################################
echo -e "\n################################################################"
echo "####     9.2) Test deployment of fastapi-cast on minikube cluster"
echo -e "\n###############################"
echo -e "*************************\n"
echo -e "###         9.2.1) Delete and recreate directory ./fastapi-cast "

cd $url_rep_k8s
pwd
rm -r ./fastapi-cast
mkdir -p ./fastapi-cast

cd ./cast
pwd
echo -e "*************************\n"

echo -e "###         9.2.2) Create yaml manifest ./$name_dir_manifest/fastapi-cast-deployment.yml "
$name_dir_manifest="fastapi-cast"
manifest_name="fastapi-cast-deployment.yml"
cat <<EOF > ${manifest_name}
# # /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dm-jenkins-cpa/cast-service/k8s/fastapi-cast-deployment.yaml
##################
### BIBLIO
#### DM-JENKINS-B62-3 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
---
apiVersion: v1
kind: Secret
metadata:
  name: fastapi-cast-secret
  namespace: dev
  labels:
    app: fastapi-cast
data:
# export DATABASE_URL="postgresql://username:password@hostname/dbname"
# echo \$(echo -n "postgresql://fastapi_user:fastapi_passwd@cast-db-service/fastapi_db" | base64)
# => cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBjYXN0LWRiLXNlcnZpY2UvZmFzdGFwaV9kYg==
  URL: cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBjYXN0LWRiLXNlcnZpY2UvZmFzdGFwaV9kYg==
---
# fastapi-cast-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: fastapi-cast-service
  namespace: dev
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
  namespace: dev
data:
  database-url: cast-db-service
---
# fastapi-cast-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-cast-deployment
  namespace: dev
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
#          image: lahcenedergham/fastapi-image:latest
          image: cpa8876/casts-ds-fastapi:v.32.0
#          command: ["uvicorn", "app.main:app", "--reload", "--host 0.0.0.0", "--port 5000"] # uvicorn app.main:app --reload --host 0.0.0.0 --port 5000
          command: ["/bin/sh"]     # https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/
          args: ["-c", "while true; do cd /app; uvicorn app.main:app --reload --host 0.0.0.0 --port 5000;done"]
#          command: ["sleep", "3600"]  # kubectl get po -o wide; kubectl exec -it fastapi-cast-deployment-7b994c9bdf-h8zcn -- /bin/bash; uvicorn app.main:app --reload --host 0.0.0.0 --port 5000
          env:
            - name: DATABASE_URI
#             value: "postgresql://fastapi_user:fastapi_passwd@10.43.162.83:5432/fastapi_db" 
#              value: "postgresql://fastapi_user:fastapi_passwd@cast-db-service/fastapi_db"
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
echo -e "\n############################### "
echo -e "*************************\n"

echo -e "##     9.2.3) Copy manifest ./$name_dir_manifest/$manifest_name from pc-cpa to minikube server"

echo -e "\n\n###         9.2.3.1) Delete and recreate directory /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "rm -r /app/$name_dir_manifest"
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /app/$name_dir_manifest"

echo -e "\n\n###         9.2.3.2) Copy ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server /app/fastapi-cast/${manifest_name}"
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/$name_dir_manifest/
ssh -i $url_id_rsa root@$ip_minikube "ls -lha /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "cat /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         9.2.3.3) Delete fastapi-cast pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         9.2.3.4) Kubectl apply fastapi-cast pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/$name_dir_manifest/${manifest_name}"
sleep 10 

echo -e "\n\n###         9.2.3.5) kubectl get sts -o wide from minikube server -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get sts -o wide"

echo -e "\n\n###         9.2.3.6) kubectl get po -o wide from minikube server -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get po -o wide"

echo -e "\n\n###         9.2.3.7) kubectl get svc -o wide from minikube server -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide"

echo -e "\n\n###         9.2.3.8) kubectl  get deployment -o wide from minikube server"
sleep 10 
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get deployment -A -o wide -n dev"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
###############
###############################






################################################################
echo -e "\n################################################################"
echo "####     9.3) Test deployment of nginx on minikube cluster"
###############
#### Minikube-B12) Search Brave : kubectl create configmap with a ngix.conf file
##### https://search.brave.com/search?q=kubectl+create+configmap+with+a+ngix.conf+file&summary=1&conversation=334bc4cb88f8106602562f
###### S1) Alternatively, you can also use the kubectl create configmap command directly with the --from-file option to specify the location of the nginx.conf file:
######      $    kubectl create configmap nginx-conf --from-file=nginx.conf=/path/to/your/nginx.conf --namespace=nginx-ingress
###### S2) After creating the ConfigMap, you can mount it into your Nginx deployment as shown in the sample deployment YAML file provided in the context:
###### => apiVersion: apps/v1
###### => kind: Deployment
###### => metadata:
###### =>   name: nginx-deployment
###### =>   namespace: nginx-ingress
###### => spec:
###### =>   selector:
###### =>     matchLabels:
###### =>       app: nginx
###### =>   replicas: 1
###### =>   template:
###### =>     metadata:
###### =>       labels:
###### =>         app: nginx
###### =>     spec:
###### =>       nodeSelector:
###### =>         compute1: worker1
###### => [      volumes:
###### =>       - name: nginx-conf
###### =>         configMap:
###### =>           name: nginx-conf
###### =>           items:
###### =>             - key: nginx.conf
###### =>               path: nginx.conf
###### => ]      containers:
###### =>       - name: nginx-alpine-perl
###### =>         image: docker.io/library/nginx@sha256:51212c2cc0070084b2061106d5711df55e8aedfc6091c6f96fabeff3e083f355
###### =>         ports:
###### =>         - containerPort: 80
###### =>         securityContext:
###### =>           allowPrivilegeEscalation: false
###### => [        volumeMounts:
###### =>           - name: nginx-conf
###### =>             mountPath: /etc/nginx
###### =>             readOnly: true
###### => ] 
###### S3) AMake sure to adjust the paths and configurations according to your environment and requirements.
###############################
#####  MINIKUBE-B13) Kubernetes: Deploying NGINX with a ConfigMap; Chanel; Chanel; 7 min read; Mar 18, 2023: https://medium.com/nerd-for-tech/kubernetes-deploying-nginx-with-a-configmap-e8a2fe59bcb1 
###### Your final YAML file should look like this.
###### => apiVersion: apps/v1
###### => kind: Deployment
###### => metadata:
###### =>   name: nginx-deployment
###### =>   labels:
###### =>     app: nginx
###### => spec:
###### =>   replicas: 2
###### =>   selector:
###### =>     matchLabels:
###### =>       app: nginx
###### =>   template:
###### =>     metadata:
###### =>       labels:
###### =>         app: nginx
###### =>     spec:
###### =>       containers:
###### =>         - name: nginx
###### =>           image: nginx:1.23.3
###### =>           ports:
###### =>             - containerPort: 80
###### =>           volumeMounts:
###### =>             - name: nginx-config
###### =>               mountPath: /usr/share/nginx/html #nginx specific
###### =>       volumes:
###### =>         - name: nginx-config
###### =>           configMap:
###### =>             name: my-config1

echo -e "*************************\n"
echo -e "###         9.3.1) Delete and recreate directory ./nginx "
name_dir_manifest="nginx"
manifest_name="nginx-deploy.yml"
cd $url_rep_k8s
url_rep_ci_cd
pwd
rm -r ./$name_dir_manifest
mkdir -p ./$name_dir_manifest

cd ./$name_dir_manifest
pwd

echo -e "*************************\n"
echo -e "###         9.3.2) Create a namespace nginx-ingress and a configmap nginx-conf"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl create ns nginx-ingress"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete configmap nginx-conf --namespace=nginx-ingress"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl create configmap nginx-conf --from-file=/app/nginx_config2.conf --namespace=nginx-ingress"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "cd /app; pwd; ls -lha"

echo -e "*************************\n"
echo -e "###         9.3.3) Create yaml manifest ./$name_dir_manifest/$name_dir_manifest-deployment.yml "

cat <<EOF > ${manifest_name}
---
# nginx-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-cpa-svc
  namespace: dev
spec:
  type: NodePort
#  type: ClusterIP
  selector:
    app: nginx-cpa
  ports:
    - protocol: TCP
      port: 80
 #     targetPort: 80
---
# nginx-dep.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-cpa-dep
  namespace: dev
spec:
  selector:
    matchLabels:
      app: nginx-cpa
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx-cpa
    spec:
#      nodeSelector:
#        compute1: minikube
#      volumes:
#      - name: nginx-conf
#        configMap:
#          name: nginx-conf
      containers:
      - name: nginx-cpa-dep
        image: nginx:1.23.3
        ports:
        - containerPort: 80
#        securityContext:
#          allowPrivilegeEscalation: false
#        volumeMounts:
#          - name: nginx-conf
#            mountPath: /usr/share/nginx/html
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "\n############################### "
echo -e "*************************\n"
echo -e "##     9.3.3) Copy manifest ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server"
echo -e "\n\n###         9.3.3.1) Delete and recreate directory /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "rm -r /app/$name_dir_manifest"
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /app/$name_dir_manifest"

echo -e "\n\n###         9.3.2) Copy ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server /app/fastapi-cast/${manifest_name}"
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/$name_dir_manifest/
ssh -i $url_id_rsa root@$ip_minikube "ls -lha /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "cat /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         9.3.3) Delete $name_dir_manifest pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         9.3.4) Kubectl apply $name_dir_manifest pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/$name_dir_manifest/${manifest_name}"

sleep 6
echo -e "\n\n###         9.3.5) kubectl get sts -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get sts -o wide -n dev"

echo -e "\n\n###         9.3.6) kubectl get po -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get po -A -o wide -n dev"

echo -e "\n\n###         9.3.7) kubectl get svc -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -A -o wide -n dev"

echo -e "\n\n###         9.3.8) kubectl  get deployment -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get deployment -A -o wide -n dev"

echo -e "\n\n###         9.3.9) kubectl  get configmap -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get configmap -A -o wide -n dev"

echo -e "\n\n###         9.3.10) kubectl  minikube service nginx-cpa-svc from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube service nginx-cpa-svc -n dev"

#### On PC developper
#####     $   ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get po -A"
#####     $   ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl describe po $(kubectl get po -n nginx-ingress --no-headers=true | awk '{ print $1 }')  -n nginx-ingress"
#####     $   ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl logs $(kubectl get po -n nginx-ingress --no-headers=true | awk '{ print $1 }') -n nginx-ingress"

######    $ kubectl api-resources #shows what needs to match labels in yaml file

######    $  kubectl get svc nginx-svc -n nginx-ingress -o jsonpath='{.spec.ports.nodePort}'

###### Serach Brave : install lsof on debian 12 : https://search.brave.com/search?q=install+lsof+on+debian+12&summary=1&conversation=1891ac7871d70ea91a057b 
######    $ sudo apt update
######  Then, install lsof:
######    $ sudo apt install lsof

###### Serach Brave : install netstat on debian 12 : https://search.brave.com/search?q=install+netstat+on+debian+12&summary=1&conversation=74b620cc0be3f4c803ce9c
######    $  apt install net-tools

###### Serach Brave : install ss command on debian 12 : https://search.brave.com/search?q=install+ss+command+on+debian+12&summary=1&conversation=ea8b5067c9e2dfae7f576e
######    $ sudo apt update
######  Then, install iproute2 paket
######    $ sudo apt install iproute2

###### Serach Brave : Install Nmap Debian 12 : https://search.brave.com/search?q=install+nmap++on+debian+12&summary=1&conversation=200df39fd0c61187719f70
######    $ sudo apt-get update
######  Then, install nmap packet
######    $ sudo apt-get install nmap
######  If you also want to install the graphical user interface Zenmap, you can include it in the installation command:
######    $ sudo apt-get install nmap zenmap

###### How to check if port is in use on Linux or Unix; Author: Vivek Gite Last updated: June 14, 2024 19 comments : https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/
######    $ Open a terminal application i.e. shell prompt.
######  Run any one of the following command on Linux to see open ports:
######    $sudo lsof -i -P -n | grep LISTEN
######    $sudo netstat -tulpn | grep LISTEN
######    $sudo ss -tulpn | grep LISTEN
######    $sudo lsof -i:22 ## see a specific port such as 22 ##
######    $sudo nmap -sTU -O IP-address-Here
######    $ sudo nmap -sTU -O 127.0.0.1
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
###############
###############################





################################################################
echo -e "\n################################################################"
echo "####     9.4) Create Create an Ingress"
### MINIKUBE-B14 : Set up Ingress on Minikube with the NGINX Ingress Controller: https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
#### The following manifest defines an Ingress that sends traffic to your Service via hello-world.example.
#####    Create example-ingress.yaml from the following file:
###############

echo -e "*************************\n"
echo -e "###         9.4.1) Delete and recreate directory ./nginx "
name_dir_manifest="ingress"
manifest_name="ingress-fastapi-cast.yml"
cd $url_rep_k8s
url_rep_ci_cd
pwd
rm -r ./$name_dir_manifest
mkdir -p ./$name_dir_manifest

cd ./$name_dir_manifest
pwd

echo -e "*************************\n"
echo -e "###         9.4.2) Delete ingress path with the manifest ingress-fastapi-cast.yml"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete ingress -f $manifest_name"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "cd /app; pwd; ls -lha"

echo -e "*************************\n"
echo -e "###         9.4.3) Create yaml manifest ./$name_dir_manifest/$name_dir_manifest-deployment.yml "

cat <<EOF > ${manifest_name}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dm-jenkins-ingress
  namespace: dev
spec:
  ingressClassName: nginx
  rules:
    - host: dm-jenkins.cpa
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-cpa-svc
                port:
                  number: 80
          - path: /api/v1/casts/
            pathType: Prefix
            backend:
              service:
                name: fastapi-cast-service
                port:
                  number: 5000
---
EOF

pwd
ls -lha
cat $manifest_name
echo -e "\n############################### "

echo -e "*************************\n"
echo -e "##     9.4.4) Copy manifest ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server"
echo -e "\n\n###         9.4.4.1) Delete and recreate directory /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "rm -r /app/$name_dir_manifest"
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /app/$name_dir_manifest"

echo -e "\n\n###         9.4.4.2) Copy ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server /app/fastapi-cast/${manifest_name}"
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/$name_dir_manifest/
ssh -i $url_id_rsa root@$ip_minikube "ls -lha /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "cat /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         9.4.4.3) Delete $name_dir_manifest pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         9.4.4.4) Kubectl apply $name_dir_manifest pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/$name_dir_manifest/${manifest_name}"

sleep 6
echo -e "\n\n###         9.4.4.5) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get ingress -o wide -n dev"

echo -e "\n\n###         9.4.4.6) curl --resolve "dm-jenkins.cpa:8080:$( minikube ip )" -i http://dm-jenkins.cpa"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( minikube ip )" -i http://dm-jenkins.cpa

echo -e "\n\n###         9.4.4.7) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube service  --url"

echo -e "\n\n###         9.4.4.6) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide -n dev"
echo -e "\n\n###         9.4.4.5) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -o wide -n dev"

echo -e "\n\n###         9.4.4.6) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide -n dev"

echo -e "\n\n###         9.4.4.7) curl --resolve 'dm-jenkins.cpa:80:$( minikube ip )' -i http://dm-jenkins.cpa/ Ffrom minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip )" -i http://dm-jenkins.cpa/
### MINIKUBE-B14) : https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
####   curl --resolve "hello-world.example:80:$( minikube ip )" -i http://hello-world.example
####         $    curl --resolve 'dm-jenkins.cpa:80:192.168.49.2' -i http://dm-jenkins.cpa/

echo -e "\n\n###         9.4.4.8) curl --resolve 'dm-jenkins.cpa:80:$( minikube ip )' -i http://dm-jenkins.cpa/ from minikube server"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip )" -i http://dm-jenkins.cpa/api/v1/casts/docs
# curl --resolve 'dm-jenkins.cpa:80:192.168.49.2' -i http://dm-jenkins.cpa/api/v1/casts/docs

echo -e "\n\n###         9.4.4.9) From the PC developer, with ssh tunel ssdh -L 12345 with minikube cluster proxy : access metadata on svc fastapi-cast-servcice"
curl -Lk http://localhost:12345/api/v1/namespaces/dev/services/fastapi-cast-service/

echo -e "\n\n###         9.4.4.10) From the PC developer, with ssh tunel ssdh -L 12345 with minikube cluster proxy : access metadata on svc nginx-cpa-svc"
curl -Lk http://localhost:12345/api/v1/namespaces/dev/services/nginx-cpa-svc/


echo -e "\n\n###         9.4.4.11) Example url prox minikube access to one pod"
####=> http://localhost:12345/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/replicaset/default/fastapi-cast-deployment-6fd748fd5b?namespace=_all
# curl -Lk "http://localhost:12345/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/replicaset/default/fastapi-cast-deployment-6fd748fd5b?namespace=_all"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 

###############
###############################





################################################################
echo -e "\n################################################################"
echo "####     9.5) Configure /etc/hosts from the PC developper (192.168.1.100) and minikube server (192.168.1.83) to access with a ssh tunnel 2 applications : nginx-cpa and fastapi-cast deployed on minikube server with minikube ip =192.168.49.2"
echo -e "*************************\n"

echo -e "###         9.5.1)  Create tunnel SSH to your server minikube , using -L option. Open terminal/command prompt on your local PC/laptop and type the following command:"
gnome-terminal  --tab --command="bash -c 'ssh -L 12347:dm-jenkins.cpa:80 -i /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa_cpa cpa@192.168.1.83; exec bash -i'"
echo -e "*************************\n"

echo -e "###         9.5.2) Configure file /etc/hosts of the minikube server on adding follow line : 192.168.49.2  dm-jenkins.cpa"
ip_minikube_cluster=$(echo "$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip)  dm-jenkins.cpa")
echo $ip_minikube_cluster
ssh -i $url_id_rsa root@$ip_minikube "echo $ip_minikube_cluster | tee -a  /etc/hosts"
ssh -i $url_id_rsa root@$ip_minikube "cat /etc/hosts"
###### => 192.168.49.2 dm-jenkins.cpa
1###### => 92.168.49.2 dm-jenkins.cpa
1###### => 27.0.0.1	localhost
###### => 127.0.1.1	debian-pve.net.cpa.fr	debian-pve
###### => # The following lines are desirable for IPv6 capable hosts
###### => ::1     localhost ip6-localhost ip6-loopback
###### => ff02::1 ip6-allnodes
###### => ff02::2 ip6-allrouters
###### => 127.0.0.1 dm-jenkins.cpa
###### => 192.168.49.2 dm-jenkins.cpa
echo -e "*************************\n"

echo -e "###         9.5.4) Test application access  nginx-cpa with cmd ssh and curl   : curl -v http://dm-jenkins.cpa/"
ssh -i $url_id_rsa root@$ip_minikube "curl -v http://dm-jenkins.cpa/"
echo -e "*************************\n"

echo -e "###         9.5.5) Test application access fastapi-cast with cmd curl  : curl -v http://dm-jenkins.cpa/api/v1/casts/docs"
ssh -i $url_id_rsa root@$ip_minikube "curl -v http://dm-jenkins.cpa/api/v1/casts/docs"
echo -e "*************************\n"

echo -e "###         9.5.6) Configure file /etc/hosts of the pc developer on adding line with the  : 127.0.0.1 dm-jenkins.cpa"
ip_minikube_server_lh="127.0.0.1 dm-jenkins.cpa"
echo $ip_minikube_server_lh
echo $ip_minikube_server_lh | sudo tee -a  /etc/hosts
sudo cat /etc/hosts
echo -e "*************************\n"

echo -e "###         9.5.7) Test application access  nginx-cpa directly with cmd : curl -v http://dm-jenkins.cpa:12347/"
curl -v "http://dm-jenkins.cpa:12347/"
echo -e "*************************\n"

echo -e "###         9.5.8) Test application access fastapi-cast with cmd curl with option -v  : curl -v http://dm-jenkins.cpa:12347/api/v1/casts/docs"
curl -v "http://dm-jenkins.cpa:12347/api/v1/casts/docs"
echo -e "*************************\n"

echo -e "###         9.5.9) Test2 application access fastapi-cast with cmd curl with option Lk : curl -Lk http://dm-jenkins.cpa:12347/api/v1/casts/docs"
curl -Lk dm-jenkins.cpa:12347/api/v1/casts/docs
echo -e "*************************\n"

echo -e "###         9.5.10) Test-16-CRUD add cast Adam Driver in the cast-db with fastapi-cast application deployed on the minikube cluster"
curl -X 'POST' \
 dm-jenkins.cpa:12347/api/v1/casts/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'  \
   -d '{
   "name": "Adam Driver",
   "nationality": "USA"
}'
echo -e "*************************\n"

echo -e "###         9.5.11) Test-17-CRUD add cast Daisy Ridley in the cast-db with fastapi-cast application deployed on the minikube cluster"
curl -X 'POST' \
 dm-jenkins.cpa:12347/api/v1/casts/  \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Daisy Ridley",
  "nationality": "USA"
}'
echo -e "*************************\n"

echo -e "###         9.5.12) Test-18-CRUD add cast Carrie FISHER in the cast-db with fastapi-cast application deployed on the minikube cluster"
curl -X 'POST' \
 dm-jenkins.cpa:12347/api/v1/casts/  \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Carrie FISHER",
  "nationality": "USA"
}'
echo -e "*************************\n"

echo -e "###         9.5.13) Test-19-CRUD add cast Mark HAMILL in the cast-db with fastapi-cast application deployed on the minikube cluster"
curl -X 'POST'  \
 dm-jenkins.cpa:12347/api/v1/casts/  \
  -H 'accept: application/json'  \
  -H 'Content-Type: application/json'  \
  -d '{
  "name": "Mark HAMILL",
  "nationality": "USA"
}'
echo -e "*************************\n"

echo -e "###         9.5.14) Test-20-CRUD add cast Harisson FORD in the cast-db with fastapi-cast application deployed on the minikube cluster"
curl -X 'POST'  \
 dm-jenkins.cpa:12347/api/v1/casts/  \
   -H 'accept: application/json' \
   -H 'Content-Type: application/json' \
   -d '{ 
  "name": "Harisson FORD",
  "nationality": "USA"
}'
echo -e "*************************\n"

echo -e "###         9.5.15)  Test-21-CRUD add List cast id=1 with fastapi-cast with cmd curl: "
curl -X GET dm-jenkins.cpa:12347/api/v1/casts/1/  -H 'Content-Type: application/json' -H 'accept: application/json'
echo -e "*************************\n"

echo -e "###         9.5.16)  Test-22-CRUD add List all casts with fastapi-cast with cmd curl: "
curl -X GET dm-jenkins.cpa:12347/api/v1/casts/  -H 'Content-Type: application/json' -H 'accept: application/json'
echo -e "*************************\n"

echo -e "###         9.5.17)  Test-23-CRUD delete cast id=1 with fastapi-cast with cmd curl: "
curl -X 'DELETE' dm-jenkins.cpa:12347/api/v1/casts/1  -H 'Content-Type: application/json' -H 'accept: application/json'
echo -e "*************************\n"

echo -e "###         9.5.16)  Test-24-CRUD add List all casts with fastapi-cast with cmd curl: "
curl -X GET dm-jenkins.cpa:12347/api/v1/casts/  -H 'Content-Type: application/json' -H 'accept: application/json'
echo -e "*************************\n"

echo -e "\n####        9.5.17) Backup and Restore cast-db "
echo -e "\n####        9.5.17.1) Prerequiesites: create directory backup and initiate variables"
# K8s/B18) How to Deploy Postgres to Kubernetes Cluster; Published on January 19, 2024; https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
url_rep_current=$(pwd)
echo $url_rep_current
cd $url_rep_backup
echo $url_rep_backup
url_rep_backup_castdb="$url_rep_backup/backup-cast-db"
pwd
ls -lha
mkdir -p $url_rep_backup_castdb
echo $url_rep_backup_castdb
cd $url_rep_backup_castdb
pwd
ls -lha
date_backup=$(date '+%Y%m%d.%H%M')
echo $date_backup
echo -e "*************************\n"

echo -e "\n####        9.5.17.2) List all Pods to find the name of your PostgreSQL Pod:"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -n dev"
echo -e "*************************\n"


echo -e "\n####        9.5.17.3) Backup database : use the kubectl exec command to run the pg_dump command inside the PostgreSQL Pod:"
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'select * from pg_database'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "pg_dump -U fastapi_user -d fastapi_db" > $date_backup"_castdb_backup.sql"
echo -e "*************************\n"

echo -e "\n####        9.5.17.4) Verify the creation of backup file : $date_backup'_castdb_backup.sql'"
pwd
ls -lha
cat $date_backup"_castdb_backup.sql"
echo -e "*************************\n"

echo -e "\n####        9.5.17.5) Copy backup file on  the pod casts-sts-0 with the kubectl cp command to copy the SQL dump file from PC deloper  into the PostgreSQL Pod of the minikube cluster : cast-db-sts-0 on namespace dev"
cd $url_rep_backup_castdb
pwd
ls -lha
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /tmp; cd /tmp; pwd; ls -lha"
scp -i $url_id_rsa "$date_backup"_castdb_backup.sql root@$ip_minikube:/tmp/db_backup.sql 
ssh -i $url_id_rsa root@$ip_minikube "cd /tmp; pwd; ls -lha | grep db_backup.sql; cat db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "mkdir -p /tmp; cd /tmp; pwd; ls -lha"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "rm -r /tmp/db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "mkdir -p /tmp"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl cp /tmp/db_backup.sql cast-db-sts-0:/tmp/ -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "ls -lha /tmp/ | grep db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec -it cast-db-sts-0 -n dev -- "cat /tmp/db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "mkdir -p /tmp; cd /tmp; pwd; ls -lha | grep db_backup.sql; cat db_backup.sql;"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.1) List rows of the table casts of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM casts;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM casts;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.2) Delete database fastapi_db (casts-db) with sql cmd : dropdb"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'DROP DATABASE fastapi_db WITH (FORCE);'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "dropdb --force -U fastapi_user fastapi_db"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.3) Create a new database fastapi-db on sts cast-db-0 with sql cmd : 'CREATE DATABASE fastapi_db;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "createdb -U fastapi_user -T template0 -O fastapi_user fastapi_db"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.4) Verify 1 &2  creation new database fastapi_db : SQL query database cast-db with sql cmd:  \'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
echo -e "*************************\n"


echo -e "\n####        9.5.17.6.5) List tables of fastapi_db with SQL query database cast-db with sql cmd :\"SELECT * FROM information_schema.tables WHERE table_schema='public';\""
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \"SELECT * FROM information_schema.tables WHERE table_schema='public';\""
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.6) List users of fastapi_db with SQL query database cast-db with sql cmd : \'SELECT * FROM pg_user;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'SELECT * FROM pg_user;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.7) List roles of users (from fastapi_db) of fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM pg_roles;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'SELECT * FROM pg_roles;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.8) List roles of users (from template1) of fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM pg_roles;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d template1 -c 'SELECT * FROM pg_roles;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.9) List rows of the table casts of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM casts;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM casts;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.10) Restore tables of fastapi_db with backup file and SQL query database cast-db with sql cmd : 'CREATE DATABASE fastapi_db;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl exec cast-db-sts-0 -n dev -- bash -c \"psql -U fastapi_user -d fastapi_db < /tmp/db_backup.sql\""
echo -e "*************************\n"

echo -e "\n####        9.5.17.6.11) List rows of the table casts of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM casts;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM casts;'"
echo -e "*************************\n"

echo -e "\n####        9.5.17.12) List publics tables with SQL query database cast-db with sql cmd : 'SELECT * FROM information_schema.tables WHERE table_schema='public'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec cast-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c \"SELECT * FROM information_schema.tables WHERE table_schema='public';\""
echo -e "*************************\n"

echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################





################################################################
echo -e "\n\n################################################################"
echo -e "## BEGIN 10) Tests with k8s manifest to deploy FASTAPI-MOVIES with a postgresql database, fastapi"
##########
###############
###############################
echo "####     10.1) test deployment of a postgresql movie-db on minikube cluster"
echo "\n###############################"
manifest_name="movie-db-deployment.yml"
echo "*************************"
echo -e "\n####        10.1.1) Create a directory on PC developper ./movie to save a $manifest_name to deploy movie-db postgresql with its secret, service, pvc and sts with file $manifest_name "

cd $url_rep_k8s
pwd
rm -r ./movie
mkdir -p ./movie

cd ./movie
pwd


cat <<EOF > ${manifest_name}
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dm-jenkins-cpa/movie-service/k8s/movie-deployment.yaml
### BIBLIO
#### DM-JENKINS-B62-3 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
---
# K8s/B18) How to Deploy Postgres to Kubernetes Cluster; Published on January 19, 2024; https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
apiVersion: v1
kind: PersistentVolume
metadata:
  name: movies-db-volume-pv
  labels:
    type: local
    app: movies-db
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /data/postgresql2
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: movies-db-pvc
  namespace: dev
  labels:
    app: movies-db
    namespace: dev
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Secret
metadata:
  name: movie-db-secret
  namespace: dev
type: Opaque
data:
  movie-db-username: ZmFzdGFwaV91c2Vy       # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
  movie-db-password: ZmFzdGFwaV9wYXNzd2Q=   # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
  movie-db-database: ZmFzdGFwaV9kYg==       # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db
---
apiVersion: v1
kind: Service
metadata:
  name: movie-db-service
  namespace: dev
spec:
  selector:
    app: movie-db
  ports:
    - name: movie-db-service
      port: 5432
      targetPort: 5432
---
apiVersion: apps/v1
#kind: Deployment
kind: StatefulSet
metadata:
  name: movie-db-sts
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: movie-db
  template:
    metadata:
      labels:
        app: movie-db
    spec:
      containers:
        - name: movie-db
          image: postgres
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  name: movie-db-secret
                  key: movie-db-username
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: movie-db-secret
                  key: movie-db-password
            - name: POSTGRES_DB
              valueFrom:
                secretKeyRef:
                  name: movie-db-secret
                  key: movie-db-database
          ports:
            - containerPort: 5432
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: movie-db-data
      volumes:
        - name: movie-db-data
          persistentVolumeClaim:
            claimName: movies-db-pvc
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "*************************\n"

echo -e "\n####        10.1.2) Create a directory on vm minikube srvr /app/movie to save a $manifest_name to deploy movie-db postgresql with its secret, service, pvc and sts"
ssh -i $url_id_rsa root@$ip_minikube 'mkdir -p /data/postgresql2'
ssh -i $url_id_rsa root@$ip_minikube 'cd /data/postgresql2; hostname -I; pwd'
ssh -i $url_id_rsa root@$ip_minikube 'ls -lha /data/postgresql2'
ssh -i $url_id_rsa root@$ip_minikube 'mkdir -p /app/movie'
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/movie/
ssh -i $url_id_rsa root@$ip_minikube 'ls -lha /app/movie/'${manifest_name}
ssh -i $url_id_rsa root@$ip_minikube 'cat /app/movie/'${manifest_name}
echo -e "*************************\n"

echo -e "\n####        10.1.3.1) Delete previous deployment on vm minikube srvr  with cmd : \n    $kubectl delete -f /app/movie/${manifest_name}"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/movie/${manifest_name}"
echo -e "*************************\n"

echo -e "\n####        10.1.3.2) Wait 10 seconds to deploy all elements : secret, service, pvc and sts with the file $manifest_name"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        10.1.4) Apply deployment on vm minikube srvr  with cmd : \n    $kubectl apply -f /app/movie/${manifest_name}"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/movie/${manifest_name}"
echo -e "*************************\n"

echo -e "\n####        10.1.5) Wait 10 seconds to deploy all elements : secret, service, pvc and sts with the file $manifest_name"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        10.1.6) List namespaces  on vm minikube srvr  with cmd : \n    $kubectl get ns -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get ns -o wide"
echo -e "*************************\n"

echo -e "\n####        10.1.7.1) List pv deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get pv -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pv -A -o wide -n dev"
echo -e "************************\n\n"

echo -e "\n####        10.1.7.2) List pvc deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get pvc -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pvc -A -o wide -n dev"
echo -e "************************\n\n"


echo -e "\n####        10.1.7.3) List secrets deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get secrets -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get secrets -A -o wide -n dev"
echo -e "************************\n\n"

echo -e "\n####        10.1.8) List statefullset deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get sts -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get sts -o wide -n dev"

echo -e "*************************\n"
echo -e "\n####        10.1.11) List pods deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get po-o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get po -o wide -n dev"
echo -e "*************************\n"

echo -e "\n####        10.1.12) List services deplopyed on ns dev on vm minikube srvr  with cmd : \n    $kubectl get svc -o wide"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide -n dev"
echo -e "*************************\n"

echo -e "\n####        10.1.13.1) Wait 10 seconds to deploy all elements : secret, service, pvc and sts with the file $manifest_name"
sleep 10 
echo -e "*************************\n"

echo -e "\n####       10.1.13.2) Query sql on pod movie-db-sts-0 to test the deployment of a postgresql moviet-db on minikube cluster on namesapace  dev with cmd :  kubectl exec movie-db-sts-0 -n dev -- \"psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \'select * from pg_database\'\""
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'select * from pg_database'"

# 
## K8S-kubctl-B06-Serach brave with kyeywords : create a pod to test access psql on postgresql sts
### https://search.brave.com/search?q=create+a+pod+to+test+access+psql+on+postgresql+sts&source=desktop&summary=1&conversation=37b6dc12548adece71b018
## kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=<your_password>" --command -- psql --host <postgresql_sts_service_name> -U postgres -d <your_database_name>
#### root@debian-pve:/app/cast# kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host 10.42.0.8 -U fastapi_user -d fastapi_db
##### => If you don't see a command prompt, try pressing enter.
##### => 
##### => fastapi_db=# 
echo -e "*************************\n"


echo -e "\n####        10.1.14) Deploy a testest pod with image dckr bitnami/postgresql and execute a query sql on this pod to test the deployment of a postgresql cast-db on minikube cluster on namesapace  dev with cmd : \n    $kubectl run postgresql-client -it --namespace dev --image bitnami/postgresql --env=\'PGPASSWORD=fastapi_passwd\' --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c \'select * from pg_database\'\""
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl run postgresql-client -it --namespace dev --image bitnami/postgresql --env='PGPASSWORD=fastapi_passwd' --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c 'select * from pg_database'"
##### => cpa@debianbu201$ ssh -i $url_id_rsa root@$ip_minikube 'kubectl run postgresql-client -it --namespace default --image bitnami/postgresql --env="PGPASSWORD=fastapi_passwd" --command -- psql --host cast-db-service -U fastapi_user -d fastapi_db -c "select * from pg_database"'
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
echo -e "*************************\n"

echo -e "\n####        10.1.15) List pods deployed on namesapace dev on the minikube cluister with cmd : \n    $kubectl get pods -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -n dev"
echo -e "*************************\n"

echo -e "\n####        10.1.16) Delete test pod deployed with image dckr bitnami/postgresql with cmd : \n    $kubectl delete pod postgresql-client -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete pod postgresql-client -n dev"
# $ cpa@debianbu201$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl delete pod postgresql-client'
##### => pod "postgresql-client" deleted
echo -e "*************************\n"

echo -e "\n####        10.1.17) Wait 10 seconds to delete pod deployed with image dckr bitnami/postgresql with cmd : sleep 10"
sleep 10 
echo -e "*************************\n"

echo -e "\n####        10.1.18) List pods deployed on namesapace dev on the minikube cluister with cmd : \n    $kubectl get pods -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -n dev"

# $cpa@debianbu201$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube 'kubectl get pods'
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
echo -e "*************************\n"

echo -e "\n####        10.1.19) Replace on the dirtectory $url_rep_current"
echo $url_rep_current
cd $url_rep_backup
echo $url_rep_backup
echo -e "###############"
echo -e "###############################\n" 
echo -e "*************************\n"

echo -e "\n####        10.1.20) Wait 10 seconds to delete pod deployed with image dckr bitnami/postgresql with cmd : sleep 10"
sleep 10 
echo -e "*************************\n"

###############
###############################




################################################################
echo -e "\n################################################################"
echo "####     10.2) Test deployment of fastapi-movie on minikube cluster"
echo -e "\n###############################"
echo -e "*************************\n"
echo -e "###         10.2.1) Delete and recreate directory ./fastapi-movie "

cd $url_rep_k8s
pwd
rm -r ./fastapi-movie
mkdir -p ./fastapi-movie

cd ./movie
pwd
echo -e "*************************\n"

echo -e "###         10.2.2) Create yaml manifest ./$name_dir_manifest/fastapi-movie-deployment.yml "
$name_dir_manifest="fastapi-movie"
manifest_name="fastapi-movie-deployment.yml"
cat <<EOF > ${manifest_name}
# # /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dm-jenkins-cpa/movie-service/k8s/fastapi-movie-deployment.yaml
##################
### BIBLIO
#### DM-JENKINS-B62-3 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
---
apiVersion: v1
kind: Secret
metadata:
  name: fastapi-movie-secret
  namespace: dev
  labels:
    app: fastapi-movie
data:
# export DATABASE_URL="postgresql://username:password@hostname/dbname"
# echo \$(echo -n "postgresql://fastapi_user:fastapi_passwd@movie-db-service/fastapi_db" | base64)
# => cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBtb3ZpZS1kYi1zZXJ2aWNlL2Zhc3RhcGlfZGI=
  URL: cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBtb3ZpZS1kYi1zZXJ2aWNlL2Zhc3RhcGlfZGI=
---
# fastapi-movie-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: fastapi-movie-service
  namespace: dev
spec:
  type: ClusterIP
  selector:
    app: fastapi-movie-deployment
  ports:
    - name: http2
      port: 5001
      targetPort: 5001
      protocol: TCP
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: fastapi-movie-configmap
  namespace: dev
data:
  database-url: movie-db-service
---
# fastapi-movie-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-movie-deployment
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fastapi-movie-deployment
  template:
    metadata:
      labels:
        app: fastapi-movie-deployment
    spec:
      containers:
        - name: fastapi-movie-ctnr
#          image: lahcenedergham/fastapi-image:latest
          image: cpa8876/movie-ds-fastapi:v.32.0
#          command: ["uvicorn", "app.main:app", "--reload", "--host 0.0.0.0", "--port 5000"] # uvicorn app.main:app --reload --host 0.0.0.0 --port 5000
          command: ["/bin/sh"]     # https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/
          args: ["-c", "while true; do cd /app; uvicorn app.main:app --reload --host 0.0.0.0 --port 5001; done"]
#          command: ["sleep", "3600"]  # kubectl get po -o wide; kubectl exec -it fastapi-movie-deployment-7b994c9bdf-h8zcn -- /bin/bash; uvicorn app.main:app --reload --host 0.0.0.0 --port 5000
          env:
            - name: DATABASE_URL
#             value: "postgresql://fastapi_user:fastapi_passwd@10.43.162.83:5432/fastapi_db" 
#              value: "postgresql://fastapi_user:fastapi_passwd@movie-db-service/fastapi_db"
              valueFrom:
                secretKeyRef:
                  name: fastapi-movie-secret
                  key: URL
          ports:
            - containerPort: 5001
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "\n############################### "
echo -e "*************************\n"

echo -e "##     10.2.3) Copy manifest ./$name_dir_manifest/$manifest_name from pc-cpa to minikube server"

echo -e "\n\n###         10.2.3.1) Delete and recreate directory /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "rm -r /app/$name_dir_manifest"
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /app/$name_dir_manifest"

echo -e "\n\n###         10.2.3.2) Copy ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server /app/fastapi-movie/${manifest_name}"
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/$name_dir_manifest/
ssh -i $url_id_rsa root@$ip_minikube "ls -lha /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "cat /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         10.2.3.3) Delete fastapi-movie pods with /app/fastapi-movie/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/$name_dir_manifest/${manifest_name}"

echo -e "\n\n###         10.2.3.4) Kubectl apply fastapi-movie pods with /app/fastapi-movie/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/$name_dir_manifest/${manifest_name}"
sleep 10 

echo -e "\n\n###         10.2.3.5) kubectl get sts -o wide from minikube server -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get sts -o wide"

echo -e "\n\n###         10.2.3.6) kubectl get po -o wide from minikube server -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get po -o wide"

echo -e "\n\n###         10.2.3.7) kubectl get svc -o wide from minikube server -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide"

echo -e "\n\n###         10.2.3.8) kubectl  get deployment -o wide from minikube server"
sleep 10 
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get deployment -A -o wide -n dev"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
###############
###############################





################################################################
echo -e "\n################################################################"
echo "####     10.4) Create Create an Ingress"
### MINIKUBE-B14 : Set up Ingress on Minikube with the NGINX Ingress Controller: https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
#### The following manifest defines an Ingress that sends traffic to your Service via hello-world.example.
#####    Create example-ingress.yaml from the following file:
###############

echo -e "*************************\n"
echo -e "###         10.4.1) Delete and recreate directory ./nginx "
name_dir_manifest="ingress"
manifest_name="ingress-fastapi-movie.yml"
cd $url_rep_k8s
url_rep_ci_cd
pwd
rm -r ./$name_dir_manifest
mkdir -p ./$name_dir_manifest

cd ./$name_dir_manifest
pwd

echo -e "*************************\n"
echo -e "###         10.4.2) Delete ingress path with the manifest ingress-fastapi-movie.yml"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete ingress -f $manifest_name"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "cd /app; pwd; ls -lha"

echo -e "*************************\n"
echo -e "###         10.4.3) Create yaml manifest ./$name_dir_manifest/$name_dir_manifest-deployment.yml "

cat <<EOF > ${manifest_name}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dm-jenkins-ingress
  namespace: dev
spec:
  ingressClassName: nginx
  rules:
    - host: dm-jenkins.cpa
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-cpa-svc
                port:
                  number: 80
          - path: /api/v1/casts/
            pathType: Prefix
            backend:
              service:
                name: fastapi-cast-service
                port:
                  number: 5000
          - path: /api/v1/movies/
            pathType: Prefix
            backend:
              service:
                name: fastapi-movie-service
                port:
                  number: 5001
---
EOF

pwd
ls -lha
cat $manifest_name
echo -e "\n############################### "

echo -e "*************************\n"
echo -e "##     10.4.4) Copy manifest ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server"
echo -e "\n\n###         10.4.4.1) Delete and recreate directory /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "rm -r /app/$name_dir_manifest"
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /app/$name_dir_manifest"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.2) Copy ./$name_dir_manifest/${manifest_name} from pc-cpa to minikube server /app/fastapi-movie/${manifest_name}"
scp -i $url_id_rsa ${manifest_name} root@$ip_minikube:/app/$name_dir_manifest/
ssh -i $url_id_rsa root@$ip_minikube "ls -lha /app/$name_dir_manifest/${manifest_name}"
ssh -i $url_id_rsa root@$ip_minikube "cat /app/$name_dir_manifest/${manifest_name}"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.3) Delete $name_dir_manifest pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl delete -f /app/$name_dir_manifest/${manifest_name}"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.4.1) Kubectl apply $name_dir_manifest pods with /app/fastapi-cast/${manifest_name} of minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl apply -f /app/$name_dir_manifest/${manifest_name}"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.4.2) Wait 6 seconds "
sleep 6
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.5) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get ingress -o wide -n dev"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.6) curl --resolve "dm-jenkins.cpa:8080:$( minikube ip )" -i http://dm-jenkins.cpa"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( minikube ip )" -i http://dm-jenkins.cpa
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.7) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube service  --url"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.8) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide -n dev"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.9) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -o wide -n dev"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.10) kubectl get ingress -A -o wide from minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get svc -o wide -n dev"
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.11) curl --resolve 'dm-jenkins.cpa:80:$( minikube ip )' -i http://dm-jenkins.cpa/ Ffrom minikube server"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip )" -i http://dm-jenkins.cpa/
### MINIKUBE-B14) : https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
####   curl --resolve "hello-world.example:80:$( minikube ip )" -i http://hello-world.example
####         $    curl --resolve 'dm-jenkins.cpa:80:192.168.49.2' -i http://dm-jenkins.cpa/
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.12) curl --resolve 'dm-jenkins.cpa:80:$( minikube ip )' -i http://dm-jenkins.cpa/api/v1/casts/docs from minikube server"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip )" -i http://dm-jenkins.cpa/api/v1/casts/docs
# curl --resolve 'dm-jenkins.cpa:80:192.168.49.2' -i http://dm-jenkins.cpa/api/v1/casts/docs
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.13) curl --resolve 'dm-jenkins.cpa:80:$( minikube ip )' -i http://dm-jenkins.cpa/api/v1/movies/docs from minikube server"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube curl --resolve "dm-jenkins.cpa:80:$( ssh -i $url_id_rsa_cpa cpa@$ip_minikube minikube ip )" -i http://dm-jenkins.cpa/api/v1/movies/docs
echo -e "*************************\n"


echo -e "\n\n###         10.4.4.14) From the PC developer, with ssh tunel ssdh -L 12345 with minikube cluster proxy : access metadata on svc fastapi-cast-servcice"
curl -Lk http://localhost:12345/api/v1/namespaces/dev/services/fastapi-cast-service/
echo -e "*************************\n"

echo -e "\n\n###         10.4.4.15) From the PC developer, with ssh tunel ssdh -L 12345 with minikube cluster proxy : access metadata on svc nginx-cpa-svc"
curl -Lk http://localhost:12345/api/v1/namespaces/dev/services/nginx-cpa-svc/
echo -e "*************************\n"


echo -e "\n\n###         10.4.4.16) From the PC developer, with ssh tunel ssdh -L 12345 with minikube cluster proxy : access metadata on svc nginx-cpa-svc"
curl -Lk http://localhost:12345/api/v1/namespaces/dev/services/fastapi-movie-service/
echo -e "*************************\n"

###############
###############################





################################################################
echo -e "\n################################################################"
echo "####     10.5) Configure /etc/hosts from the PC developper (192.168.1.100) and minikube server (192.168.1.83) to access with a ssh tunnel 3 applications : nginx-cpa fastapi-cast and fastapi-movie deployed on minikube server with minikube ip =192.168.49.2"
echo -e "*************************\n"

echo -e "###         10.5.1) Test application access  nginx-cpa with cmd ssh and curl   : curl -v http://dm-jenkins.cpa/"
ssh -i $url_id_rsa root@$ip_minikube "curl -v http://dm-jenkins.cpa/"
echo -e "*************************\n"

echo -e "###         10.5.2) Test application access fastapi-cast with cmd curl  : curl -v http://dm-jenkins.cpa/api/v1/casts/docs"
ssh -i $url_id_rsa root@$ip_minikube "curl -v http://dm-jenkins.cpa/api/v1/casts/docs"
echo -e "*************************\n"

echo -e "###         10.5.3) Test application access fastapi-movie with cmd curl  : curl -v http://dm-jenkins.cpa/api/v1/movies/docs"
ssh -i $url_id_rsa root@$ip_minikube "curl -v http://dm-jenkins.cpa/api/v1/movies/docs"
echo -e "*************************\n"

echo -e "###         10.5.4) Test application access  nginx-cpa directly with cmd : curl -v http://dm-jenkins.cpa:12347/"
curl -v "http://dm-jenkins.cpa:12347/"
echo -e "*************************\n"

echo -e "###         10.5.5) Test application access fastapi-cast with cmd curl with option -v  : curl -v http://dm-jenkins.cpa:12347/api/v1/casts/docs"
curl -v "http://dm-jenkins.cpa:12347/api/v1/casts/docs"
echo -e "*************************\n"

echo -e "###         10.5.6) Test2 application access fastapi-cast with cmd curl with option Lk : curl -Lk http://dm-jenkins.cpa:12347/api/v1/casts/docs"
curl -Lk dm-jenkins.cpa:12347/api/v1/casts/docs
echo -e "*************************\n"

echo -e "###         10.5.7) Test application access fastapi-movie with cmd curl with option -v  : curl -v http://dm-jenkins.cpa:12347/api/v1/movies/docs"
curl -v "http://dm-jenkins.cpa:12347/api/v1/movies/docs"
echo -e "*************************\n"

echo -e "###         10.5.8) Test application access fastapi-movie with cmd curl with option -Lk  : curl -Lk http://dm-jenkins.cpa:12347/api/v1/movies/docs"
curl -Lk "http://dm-jenkins.cpa:12347/api/v1/movies/docs"
echo -e "*************************\n"
echo -e "###         10.5.9) Test-10 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
curl -X 'GET' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'
echo -e "*************************\n"

echo -e "\n####       10.5.10) List rows of the table movies of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM movies;'"
echo -e "*************************\n"


echo -e "###         10.5.11) Test-07 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=1 Star wars IX"
curl -X 'POST' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'  \
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
   1,
   2,
   3,
   4,
   5
  ]
}'
echo -e "*************************\n"

echo -e "###         10.5.12) Test-08 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=2 Star wars VI"
curl -X 'POST' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'  \
   -d '{
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
echo -e "*************************\n"

echo -e "###         10.5.13) Test-09 : curl -X POST on ip-nginx:8080/api/v1/movies/ for id=3 Star wars V"
curl -X 'POST' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'  \
   -d '{
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
echo -e "*************************\n"


echo -e "###         10.5.14) Test-10 : curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
curl -X 'GET' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'
echo -e "*************************\n"

echo -e "\n####       10.5.15) List rows of the table movies of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM movies;'"
echo -e "*************************\n"

echo -e "###         10.5.16) Test-11 : curl -X GET id=1 on  dm-jenkins.cpa:12347/api/v1/movies/1/"
curl -X 'GET'  dm-jenkins.cpa:12347/api/v1/movies/1/  -H 'accept: application/json' 
echo -e "*************************\n"


echo -e "###        10.5.17) Test-12 : curl -X PUT update id=1 with on cast on  dm-jenkins.cpa:12347/api/v1/movies/1 "
curl -X 'PUT'  \
 dm-jenkins.cpa:12347/api/v1/movies/1  \
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
echo -e "*************************\n"


echo -e "###         10.5.18) Verify Test-12 : curl -X GET id=1 on  dm-jenkins.cpa:12347/api/v1/movies/1/"
curl -X 'GET'  dm-jenkins.cpa:12347/api/v1/movies/1/  -H 'accept: application/json' 
echo -e "*************************\n"

echo -e "###         10.5.19)  Test-14 : curl -X DELETE id=1 on ip-nginx:8080/api/v1/movies/1"
curl -X 'DELETE' dm-jenkins.cpa:12347/api/v1/movies/1 -H 'accept: application/json'
echo -e "*************************\n"

echo -e "###         10.5.20) Verify Test-14 : curl -X GET id=1 on  dm-jenkins.cpa:12347/api/v1/movies/1/"
curl -X 'GET'  dm-jenkins.cpa:12347/api/v1/movies/1/  -H 'accept: application/json' 
echo -e "*************************\n"


echo -e "###         10.5.21) List all movies stored on movies base: curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
curl -X 'GET' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'
echo -e "*************************\n"

echo -e "\n####       10.5.22) List rows of the table movies of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM movies;'"
echo -e "*************************\n"
echo -e "*************************\n"



echo -e "\n####        10.5.23) Backup and Restore movie-db "
echo -e "*************************\n"

echo -e "\n####        10.5.23.1) Prerequiesites: create directory backup and initiate variables"
# K8s/B18) How to Deploy Postgres to Kubernetes Cluster; Published on January 19, 2024; https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
url_rep_current=$(pwd)
echo $url_rep_current
cd $url_rep_backup
echo $url_rep_backup
url_rep_backup_moviedb="$url_rep_backup/backup-movie-db"
pwd
ls -lha
mkdir -p $url_rep_backup_moviedb
echo $url_rep_backup_moviedb
cd $url_rep_backup_moviedb
pwd
ls -lha
date_backup=$(date '+%Y%m%d.%H%M')
echo $date_backup
echo -e "*************************\n"

echo -e "\n####        10.5.23.2) List all Pods to find the name of your PostgreSQL Pod:"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl get pods -n dev"
echo -e "*************************\n"


echo -e "\n####        10.5.23.3) Backup database : use the kubectl exec command to run the pg_dump command inside the PostgreSQL Pod:"
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'select * from pg_database'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "pg_dump -U fastapi_user -d fastapi_db" > $date_backup"_moviedb_backup.sql"
echo -e "*************************\n"

echo -e "\n####        10.5.23.4) Verify the creation of backup file : $date_backup'_moviedb_backup.sql'"
pwd
ls -lha
cat $date_backup"_moviedb_backup.sql"
echo -e "*************************\n"

echo -e "\n####        10.5.23.5) Copy backup file on  the pod movies-sts-0 with the kubectl cp command to copy the SQL dump file from PC deloper  into the PostgreSQL Pod of the minikube cluster : movie-db-sts-0 on namespace dev"
cd $url_rep_backup_moviedb
pwd
ls -lha
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /tmp; cd /tmp; pwd; ls -lha"
scp -i $url_id_rsa "$date_backup"_moviedb_backup.sql root@$ip_minikube:/tmp/db_backup.sql 
ssh -i $url_id_rsa root@$ip_minikube "cd /tmp; pwd; ls -lha | grep db_backup.sql; cat db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec moivie-db-sts-0 -n dev -- "mkdir -p /tmp; cd /tmp; pwd; ls -lha"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "rm -r /tmp/db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "mkdir -p /tmp"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl cp /tmp/db_backup.sql movie-db-sts-0:/tmp/ -n dev"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "ls -lha /tmp/ | grep db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec -it movie-db-sts-0 -n dev -- "cat /tmp/db_backup.sql"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "mkdir -p /tmp; cd /tmp; pwd; ls -lha | grep db_backup.sql; cat db_backup.sql;"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.1) List rows of the table movies of de fastapi_db with SQL query database movie-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM movies;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.2) Delete database fastapi_db (movies-db) with sql cmd : dropdb"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'DROP DATABASE fastapi_db WITH (FORCE);'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "dropdb --force -U fastapi_user fastapi_db"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.3) Create a new database fastapi-db on sts movie-db-0 with sql cmd : 'CREATE DATABASE fastapi_db;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "createdb -U fastapi_user -T template0 -O fastapi_user fastapi_db"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.4) Verify 1 &2  creation new database fastapi_db : SQL query database movie-db with sql cmd:  \'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'SELECT * FROM pg_database;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d postgres -c 'SELECT * FROM pg_database;'"
echo -e "*************************\n"


echo -e "\n####        10.5.23.6.5) List tables of fastapi_db with SQL query database movie-db with sql cmd :\"SELECT * FROM information_schema.tables WHERE table_schema='public';\""
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c \"SELECT * FROM information_schema.tables WHERE table_schema='public';\""
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.6) List users of fastapi_db with SQL query database movie-db with sql cmd : \'SELECT * FROM pg_user;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'SELECT * FROM pg_user;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.7) List roles of users (from fastapi_db) of fastapi_db with SQL query database movie-db with sql cmd : 'SELECT * FROM pg_roles;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c 'SELECT * FROM pg_roles;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.8) List roles of users (from template1) of fastapi_db with SQL query database movie-db with sql cmd : 'SELECT * FROM pg_roles;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -h localhost -p 5432 -U fastapi_user -d template1 -c 'SELECT * FROM pg_roles;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.9) List rows of the table movies of de fastapi_db with SQL query database movie-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM movies;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.10) Restore tables of fastapi_db with backup file and SQL query database movie-db with sql cmd : 'CREATE DATABASE fastapi_db;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl exec movie-db-sts-0 -n dev -- bash -c \"psql -U fastapi_user -d fastapi_db < /tmp/db_backup.sql\""
echo -e "*************************\n"

echo -e "\n####        10.5.23.6.11) List rows of the table movies of de fastapi_db with SQL query database movie-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM cmovies;'"
echo -e "*************************\n"

echo -e "\n####        10.5.23.12) List publics tables with SQL query database movie-db with sql cmd : 'SELECT * FROM information_schema.tables WHERE table_schema='public'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c \"SELECT * FROM information_schema.tables WHERE table_schema='public';\""
echo -e "*************************\n"


echo -e "###         10.5.24) List all movies stored on movies base: curl -X GET ALL on ip-nginx:8080/api/v1/movies/"
curl -X 'GET' \
 dm-jenkins.cpa:12347/api/v1/movies/  \
   -H 'accept: application/json'  \
   -H 'Content-Type: application/json'
echo -e "*************************\n"

echo -e "\n####       10.5.25) List rows of the table movies of de fastapi_db with SQL query database cast-db with sql cmd : 'SELECT * FROM movies;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube kubectl exec movie-db-sts-0 -n dev -- "psql -U fastapi_user -d fastapi_db -c 'SELECT * FROM movies;'"
echo -e "*************************\n"
echo -e "*************************\n"

echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################





################################################################
echo -e "\n\n################################################################"
echo -e "## BEGIN 11) Test deployment with helm"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo "####     11.1) Create helm charts for fastapi-cast and fastapi-movie"
echo -e "*************************\n"

echo -e "\n\n###         11.1.1) Go to directory  and create directory to deploy 5 elements : fastapi -cast/movie, cast/movie-db and nginx : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/charts"
cd /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/charts
pwd
ls -la
echo -e "*************************\n"

echo -e "\n\n###         11.1.2) Create helm template files with cmd : helm create fastapi"
helm create fastapi
cd fastapi
pwd
ls -lha
tree
echo -e "*************************\n"

echo -e "\n\n###         11.1.3) Add 3 files with specifics parameters of each environment with cmd : touch configmap.dev.yaml touch configmap.dev.yaml values.dev.yaml"
cd fastapi
mkdir -p environments
cd environments
touch configmap.dev.yaml
touch secrets.dev.yaml
touch values.dev.yaml
pwd
ls -lha
cd ..
pwd
ls -lha
tree
echo -e "*************************\n"

echo -e "\n\n###         11.1.4) Copy directory fastapi created to fastapi-cast  with cmd : cp -r fastapi ./fastapi-cast"
cd ..
pwd
ls -lha
cp -r fastapi ./fastapi-cast
pwd 
ls -lha
cd fastapi-cast
pwd
ls -lha
tree
echo -e "*************************\n"

echo -e "\n\n###         11.1.5) Rename directory fastapi to fastapi-movie with command mv fastapi fastapi-movie"
cd ..
pwd
ls -lha
mv fastapi fastapi-movie
ls -lha
cd fastapi-movie
pwd
ls -lha
tree
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################

###############################################################
echo -e "\n################################################################"
echo "####     11.2) Create helm charts for cast-db and  movie-db postgres databases"
echo -e "*************************\n"

echo -e "\n\n###         11.2.1) Go to directory  and create directory to deploy 5 elements : fastapi -cast/movie, cast/movie-db and nginx : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/charts"
cd /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/charts
pwd
ls -la
echo -e "*************************\n"


echo -e "\n\n###         11.2.2) Create helm template files with cmd : helm create postgres"
helm create postgres
cd postgres
pwd
ls -lha
tree
echo -e "*************************\n"

echo -e "\n\n###         11.2.3) Add 3 files with specifics parameters of each environment with cmd : touch configmap.dev.yaml touch configmap.dev.yaml values.dev.yaml"
pwd
mkdir -p environments
cd environments
touch configmap.dev.yaml
touch secrets.dev.yaml
touch values.dev.yaml
pwd
ls -lha
cd ..
pwd
ls -lha
tree
echo -e "*************************\n"

echo -e "\n\n###         11.2.4) Copy directory postgres created to cast-db  with cmd : cp -r postgres./cast-db"
cd ..
pwd
ls -lha
cp -r postgres ./cast-db
pwd 
ls -lha
cd fastapi-cast
pwd
ls -lha
tree
echo -e "*************************\n"

echo -e "\n\n###         11.2.5) Rename directory postgres to movie-db with command mv postgres movie-db"
cd ..
pwd
ls -lha
mv postgres movie-db
ls -lha
cd movie-db
pwd
ls -lha
tree
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################

###############################################################
echo -e "\n################################################################"
echo "####     11.3) Create helm charts for cast-db and movie-db postgres databases"
echo -e "*************************\n"



echo -e "\n\n###         11.3.1) Create directories to deploy cast-db"
mkdir -p movie-db/environments
ls -lha cast-db/environments

mkdir -p movie-db/templates
ls -lha movie-db/templates
echo -e "*************************\n"

echo -e "\n\n###         11.3.2) Create diretories to deploy fastapi-cast"
mkdir -p fastapi-cast/environments
ls -lha fastapi-cast/environments

mkdir -p fastapi-cast/templates
ls -lha fastapi-cast/templates
echo -e "*************************\n"

echo -e "\n\n###         11.3.3) Create direectories to deploy fastapi-cast"
mkdir -p fastapi-movie/environments
ls -lha fastapi-movie/environments

mkdir -p fastapi-movie/templates
ls -lha fastapi-movie/templates
echo -e "*************************\n"


echo -e "\n\n###         11.3.4) Create directories to deploy nginx"
mkdir -p nginx/environments
ls -lha gninx/environments

mkdir -p nginxtemplates
ls -lha nginx/templates
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo "####     11.4) Go to ./fastapi-cast and create script deployment"


# Formation Datascientest / V - Helm
##  https://learn.datascientest.com/lesson/1309/4316
### b.2 - Installation de Helm
#### Il existe plusieurs façons d'installer Helm qui sont soigneusement décrites sur la page d'installation officielle de Helm. Le moyen le plus rapide d'installer helm sur Linux consiste à utiliser le script shell fourni. Installons à présent Helm :
#####    $  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#####    $  chmod 700 get_helm.sh
#####    $  ./get_helm.sh
### 
### b.3 - Création d'un chart
#### La première étape, bien sûr, serait de créer un nouveau chart avec un nom donné :
#####    $  helm create datascientest
#### Affichage en sortie:
#### Creating datascientest
#### Notons que le nom du chart fourni datascientest sera le nom du répertoire dans lequel le chart est créé et stocké.
#### Voyons rapidement la structure de répertoire créée pour nous :
#####    $  sudo apt-get install -y tree # Installation de  la commande tree
#####    $  tree datascientest
##### => datascientest
##### => ├──.helmignore
##### => ├── Chart.yaml
##### => ├── charts
##### => ├── templates
##### => │   ├── NOTES.txt
##### => │   ├── _helpers.tpl
##### => │   ├── deployment.yaml
##### => │   ├── hpa.yaml
##### => │   ├── ingress.yaml
##### => │   ├── service.yaml
##### => │   ├── serviceaccount.yaml
##### => │   └── tests
##### => │       └── test-connection.yaml
##### => └── values.yaml
####
####  Examinons chaque fichier et répertoire à l'intérieur d'un chart helm et comprenons son importance.
#####     .helmignore : Il est utilisé pour définir tous les fichiers que nous ne voulons pas inclure dans le chart helm. Ce fichier fonctionne de la même manière que le fichier.gitignore au sein de git.
#####     Chart.yaml: Il contient des informations sur le chart helm comme la version, le nom, la description, etc.
#####     values.yaml: dans ce fichier, nous définissons les valeurs des modèles YAML. Par exemple, le nom de l'image, le nombre de répliques, les valeurs HPA, etc. Comme nous l'avons expliqué précédemment, seul le values.yamlfichier change dans chaque environnement. De plus, vous pouvez remplacer ces valeurs dynamiquement ou au moment de l'installation du chart à l'aide de la commande --values ou --set.
#####     charts: nous pouvons ajouter la structure d'un autre chart dans ce répertoire si nos principaux charts dépendent des autres. Par défaut ce répertoire est vide.
#####     templates: ce répertoire contient tous les fichiers manifestes Kubernetes qui forment une application. Ces fichiers manifestes peuvent être modélisés pour accéder aux valeurs du fichier values.yaml. Helm crée des modèles par défaut pour les objets Kubernetes tels que deployment.yaml, service.yaml, etc., que nous pouvons utiliser directement, modifier ou remplacer avec nos fichiers.
#####     templates/NOTES.txt : il s'agit d'un fichier en texte brut qui est imprimé après le déploiement réussi du chart.
#####     templates/_helpers.tpl: ce fichier contient plusieurs méthodes et un sous-modèle de chart qui peuvent être adaptées et réutilisées selon les besoins.
#####     templates/tests/: Nous pouvons définir des tests dans nos charts pour valider que votre chart fonctionne comme prévu lors de son installation.
#####
#####
##### Pour modéliser une valeur, tout ce que nous avons à faire est d'ajouter le paramètre d'objet à l'intérieur des accolades comme indiqué ci-dessous. C'est ce qu'on appelle une directive de modèle et la syntaxe est spécifique au modèle Go :
##### {{.Object.Parameter }}
##### Commençons par comprendre ce qu'est un objet. Voici les trois objets que nous allons utiliser dans cet exemple.
#####         Release : Chaque chart helm sera déployée avec un nom de release. Si nous souhaitons utiliser le nom de la version ou accéder aux valeurs dynamiques liées à la version dans le template, nous pouvons utiliser l'objet release.
#####         chart : Si nous souhaitons utiliser les valeurs que vous avez mentionnées dans le chart.yaml , vous pouvez utiliser l'objet chart.
#####         Valeurs : Tous les paramètres du fichier values.yaml sont accessibles à l'aide de l'objet Values.
#####
##### Pour en savoir plus sur les objets pris en charge, consultez la documentation à l'adresse https://helm.sh/docs/chart_template_guide/builtin_objects/ 
###
### Déterminer quelles valeurs pourraient changer ou ce que nous souhaitons modéliser. Nous choisissons le nom, le nombre de réplicas, le nom du conteneur, l'image et l'imagePullPolicy dans le fichier YAML en gras :
#####         name: {{.Release.Name }}-datascientest : Nous devons changer le nom du service à chaque fois car Helm ne nous permet pas d'installer des versions portant le même nom. Nous allons donc modéliser le nom du déploiement avec le nom de la version et interpoler avec -datascientest. Maintenant, si nous créons une version en utilisant le nom frontend, le nom du déploiement sera frontend-datascientest. De cette façon, nous aurons des noms uniques garantis.
#####         type de service : {{.Values.service.type }} : Pour le type de service à utiliser, nous accéderons à la valeur de type de service dans le fichier values.yaml.
#####         numéro de port: {{.Values.service.port }} : Pour le numéro de port à utiliser afin d’exposer notre application, nous accéderons à la valeur de port de service dans le fichier values.yaml.
###
### Le fichier final datascientest/templates/service.yaml devrait donc ressembler à ce qui suit :
#####
##### apiVersion: v1
##### kind: Service
##### metadata:
#####   name: {{ .Release.Name }}-datascientest
#####   labels:
#####     app: {{ .Release.Name }}-datascientest
##### spec:
#####   type: {{ .Values.service.type }}
#####   ports:
#####     - port: {{ .Values.service.port }}
#####       targetPort: 8080
#####       protocol: TCP
#####       name: mario
#####   selector:
#####     app: {{ .Release.Name }}-datascientest
###
### Nous allons également créer le fichier datascientest/templates/deployment.yaml suivant :
##### apiVersion: apps/v1
##### kind: Deployment
##### metadata:
#####   name: {{ .Release.Name }}-datascientest
#####   labels:
#####     app: {{ .Release.Name }}-datascientest
##### spec:
#####   replicas: {{ .Values.replicaCount }}
#####   selector:
#####     matchLabels:
#####       app: {{ .Release.Name }}-datascientest
#####   template:
#####     metadata:
#####       labels:
#####         app: {{ .Release.Name }}-datascientest
#####     spec:
#####       containers:
#####         - name:     {{ .Release.Name }}
#####           image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
#####           ports:
#####             - name: mario
#####               containerPort: {{ .Values.service.port }}
#####               protocol: TCP
###
### Quelques explications :
#####     La fonction indent de Helm indente chaque ligne d'une chaîne donnée à la largeur d'indentation spécifiée. Ceci est utile lors de l'alignement de chaînes multilignes .
#####     {{ .Release.Name | nindent 8 }} par exemple nous permet de modéliser le nom du déploiement avec le nom de la version avec 08 indentations .
#####     {{ .Values.image.repository }} nous permet de variabiliser le dépôt pour notre image
#####     {{ .Values.image.tag | default .Chart.AppVersion }} nous permet de variabiliser le tag pour notre image en utilisant par défaut la version de notre Chart HELM.
###
### b.5 - Fournir des valeurs avec le values.yaml
##### Voyons maintenant comment nous pouvons transmettre des valeurs au moteur de rendu du modèle. Nous transmettons généralement des valeurs via des objets intégrés dans Helm.
##### Il existe de nombreux objets de ce type disponibles dans Helm, tels que Release, Values, Chart et Files.
##### Nous pouvons utiliser le fichier values.yaml dans notre chart pour transmettre des valeurs au moteur de rendu du modèle via les valeurs d'objet intégrées. Modifions le fichier datascientest/values.yaml et fournissons lui le contenu suivant :
###
##### replicaCount: 1
##### image:
#####   repository: "pengbai/docker-supermario"
#####   tag: "latest"
#####   pullPolicy: IfNotPresent
##### service:
#####   type: NodePort
#####   port: 8080
###
##### Nous avons utilisé le référentiel d'images pengbai/docker-supermario et le tag latest, ceci correspond à l'image docker que nous voulons utiliser pour notre application à savoir docker.io/pengbai/docker-supermario:latest.
###
###
### C - Gestion des charts
###     c.1 - Helm Lint
#####    $  helm lint ./datascientest
##### => Affichage en sortie:
##### => ==> Linting datascientest
##### => [INFO] Chart.yaml: icon is recommended
##### => 1 chart(s) linted, 0 chart(s) failed

###     c.2 - Helm template : Cette commande nous aide à avoir un aperçu du résultat que nous aurons une fois les valeur remplacée par Helm :
#####    $  helm template ./datascientest


####     c.3 - helm install
#####    $  mkdir ~/.kube # nous créons un répertoire.kube
#####    $  kubectl config view --raw > ~/.kube/config # nous exportons la configuration qu'utilisera helm pour se connecter au cluster kubernetes
#####    $  helm install  datascientest-chart ./datascientest --values=./datascientest/values.yaml # nous installation notre chart datascientest en lui donnant un nom datascientest-chart et en précisant le fichier à utiliser pour fournir les valeurs qui seront utilisées pour remplacer les variables dans les templates
#####
##### Si l'installation de la chart Helm renvoie une erreur, vous pouvez essayer les commandes suivantes en tant que root :
#####    $  sudo su
#####    $  kubectl config view --raw > ~/.kube/config
#####    $  helm install datascientest-chart ./datascientest --values=./datascientest/values.yaml
#####    $  exit #revenir sur l'utilisateur courant
##### => Affichage en sortie:
##### => NAME: datascientest-chart
##### => LAST DEPLOYED: Tue Jan  3 09:21:44 2023
##### => NAMESPACE: default
##### => STATUS: deployed
##### => REVISION: 1
###
### Nous pouvons à présent vérifier sur notre cluster ce qui s’est passé :
#####    $  kubectl get deploy
##### => Affichage en sortie:
##### => datascientest-chart-datascientest   1/1     1            1           17s
###
### Nous constatons que notre chart nous a bel et bien créé un déploiement nommé datascientest-chart.
###
### Vérifions à présent les services et les Pods :
#####    $  kubectl get svc,Pod | grep datascientest
#### => Affichage en sortie:
#### => service/datascientest-chart-datascientest   NodePort    10.43.86.141  <none>  80:31141/TCP      2m9s
#### => pod/datascientest-chart-datascientest-6849795c54-wl4jl   1/1     Running   0                    2m9s
###
###
###
### c.4 - Afficher la liste des Charts
### Maintenant, nous aimerions voir quels charts sont installés dans quelle version. Cette commande nous permet d'interroger les versions nommées :
#####    $ helm ls --all
##### => Affichage en sortie:
##### => NAME       NAMESPACE       REVISION     UPDATED   STATUS          CHART                   APP VERSION
##### => datascientest-chart   default    1  2024-09-07 20:17:22.360308081 +0000 UTC deployed     datascientest-0.1.0  1.16.0
###
###
### c.5 - Mettre à Jour des CHARTS
### Que se passe-t-il si nous avons modifié notre chart et nous devons installer la version mise à jour ? Cette commande nous aide pour la mise à niveau d'une version vers une version spécifiée ou actuelle du chart ou de la configuration. Modifions dans notre fichier datascientest/values.yaml le nom de l’image et remplaçons httpd par nginx et également le nombre de réplicas de la façon suivante :
###
##### replicaCount: 4
##### image:
#####   repository: nginx
#####   pullPolicy: IfNotPresent
#####   # Overrides the image tag whose default is the chart appVersion.
#####   tag: "latest"
##### service:
#####   type: NodePort
#####   port: 80
###
### Mettons présent à jour notre déploiement :
#####    $ helm upgrade datascientest-chart ./datascientest --values=./datascientest/values.yaml
##### => Affichage en sortie :
##### => Release "datascientest-chart" has been upgraded. Happy Helming!
##### => NAME: datascientest-chart
##### => LAST DEPLOYED: Tue Jan  3 09:44:12 2023
##### => NAMESPACE: default
##### => STATUS: deployed
##### => REVISION: 2
##### => NOTES:
###
### 1. Get the application URL by running these commands:
#####    $   export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services datascientest-chart)
#####    $   export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
#####    $   echo http://$NODE_IP:$NODE_PORT
#####
##### Notons qu'avec Helm 3, la mise à niveau de la version utilise un correctif de fusion stratégique à trois voies. Ici, il prend en compte l'ancien manifeste, l'état actif du cluster et le nouveau lors de la génération d'un correctif. Vérifions à présent les ressources au sein de notre cluster :
#####    $ kubectl get deploy  | grep datascientest
#### => Affichage en sortie:
#### => datascientest-chart   4/4     4            4           24m
###
### Nous pouvons constater que nous avons à présent 4 réplicas présents pour notre déploiement datascientest-chart. Vérifions à présent l’image utilisée pour ce déploiement :
#####    $ kubectl describe deploy datascientest-chart
echo -e "*************************\n"

echo -e "\n\n###         11.4.1) Go to directory  and create directory to deploy 5 elements : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/charts"
cd "/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dm-jenkins-cpa/charts/charts_cast_db"
pwd
ls -lha
echo -e "*************************\n"

echo -e "\n\n###         11.4.2) Tests pour s'assurer que le chart est bien écrit with cmd : Helm Lint"
helm lint
#### => ==> Linting .
#### => 1 chart(s) linted, 0 chart(s) failed

echo -e "*************************\n"

echo -e "\n\n###         11.4.3) Create a view of results once values are replaced by Helm with cmd : helm template ./datascientest "
cd ..
helm template ./charts_cast_db
## helm template .
echo -e "*************************\n"

echo -e "\n\n###         11.4.4) Copy directory /charts/charts_cast_db on minikube server: scp -i $url_id_rsa_cpa -r charts cpa@$ip_minikube:/app/"
ssh -i $url_id_rsa root@$ip_minikube "mkdir -p /app/charts; pwd; ls -lha"
scp -i $url_id_rsa -r charts_cast_db root@$ip_minikube:/app/charts/
ssh -i $url_id_rsa root@$ip_minikube "cd /app/charts/charts_cast_db; pwd; ls -lha"
echo -e "*************************\n"

echo -e "\n\n###         11.4.5) Copy the config cluster to pc developer in ../datas/.kube "
# nous créons un répertoire.kube;
url_rep_current=$(pwd)
echo $url_rep_current
cd ..
pwd
mkdir -p ./datas/.kube
cd ./datas/
pwd
ls -lha ./.kube
#"bash -c 'ssh -L 12347:dm-jenkins.cpa:80 -i /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa_cpa cpa@192.168.1.83; exec bash -i'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'mkdir -p ~/.kube; pwd; ls -lha; cd ~/.kube; pwd; ls -lha;'"
# nous exportons la configuration qu'utilisera helm pour se connecter au cluster kubernetes
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl config view --raw" > ./.kube/config; 
cd ./.kube; pwd; ls -lha; cat config;
echo -e "*************************\n"


echo -e "\n\n###         11.4.6) Copy the certficates of cluster to pc developer in ../datas/.kube./.minikube "
mkdir -p .minikube/profiles/minikube/
scp -i $url_id_rsa -r root@$ip_minikube:/home/cpa/.minikube/ca.crt ./.minikube/
scp -i $url_id_rsa -r root@$ip_minikube:/home/cpa/.minikube/profiles/minikube/client.crt ./.minikube/profiles/minikube/

scp -i $url_id_rsa -r root@$ip_minikube:/home/cpa/.minikube/profiles/minikube/client.key ./.minikube/profiles/minikube/
cd .minikube; pwd;  ls -lha ca.crt; cat ca.crt;
cd profiles/minikube/; pwd;  ls -lha client.crt; cat client.crt;
pwd;  ls -lha client.key; cat client.key;
echo -e "*************************\n"

echo -e "\n\n###         11.4.7.1)Uninstall previous chart helm deployment from pc developer with cmd executed on minikube server: helm uninstall cast-db-chart"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm uninstall cast-db-chart'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.7.2)Install from pc developer with cmd executed on minikube server: helm install  cast-db-chart /app/charts/charts_cast_db/ --values=/app/charts/charts_cast_db/values.yaml"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm install  cast-db-chart /app/charts/charts_cast_db/ --values=/app/charts/charts_cast_db/values.yaml'"
echo -e "*************************\n"


echo -e "\n\n###         11.4.8) List Pods deployed on the minikube cluster with cmd : kubectl get svc,Pod -o wide | grep cast-db"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get Pod -o wide | grep cast-db'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.9) List services deployed on the minikube cluster with cmd : kubectl get svc,Pod -o wide | grep cast-db"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get svc -o wide | grep cast-db'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.10) List sts deployed on the minikube cluster with cmd : kubectl get sts-o wide | grep cast-db"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get sts -o wide | grep cast-db'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.11) List charts helm deployed on the minikube cluster with cmd : helm ls --all'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm ls --all'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.12) List repositories charts helm present on the minikube cluster with cmd : helm repo list'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm repo list'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.13) Execute a SQL query on a postgres-chart-client deployed to test image of postgresql with the cmd: bash -c 'kubectl run cast-db-chart-postgresql-client  --rm -i  --restart='Never' --namespace default --image postgres --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host cast-db-chart-postgresql -U postgres -d postgres -p 5432 -c \"SELECT * FROM pg_roles; \"'"
POSTGRES_PASSWORD="postgres"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl run cast-db-chart-postgresql-client  --rm -i  --restart='Never' --namespace default --image postgres --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host cast-db-chart-postgresql -U postgres -d postgres -p 5432 -c \"SELECT * FROM pg_roles; \"'"
echo -e "*************************\n"


echo -e "\n\n###         11.4.14) Execute a SQL query on a cast-db-chart-postgresql-0 deployed to test image of postgresql with the cmd: \n'kubectl exec cast-db-chart-postgresql-0  -i  --namespace default --image postgres --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host cast-db-chart-postgresql-0 -U postgres -d postgres -p 5432 -c \"SELECT * FROM pg_roles; \"'"
POSTGRES_PASSWORD="postgres"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "kubectl exec cast-db-chart-postgresql-0  -i  --namespace default -- bash -c 'export PGPASSWORD=$POSTGRES_PASSWORD; psql --host cast-db-chart-postgresql-0 -U postgres -d postgres -p 5432 -c \"SELECT * FROM pg_roles;\"'"
echo -e "*************************\n"


echo -e "\n\n###         11.4.15) List repositories charts helm present on the minikube cluster with cmd : helm repo list'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm repo list'"
echo -e "*************************\n"

echo -e "\n\n###         11.4.12) List repositories charts helm present on the minikube cluster with cmd : helm repo list'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm repo list'"
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo "####     11.5) Create k8s manifests and charts bitanami deployment for postgresql cast-db"
echo -e "*************************\n"

echo -e "\n\n###         11.5.1) List charts helm deployed with cmd :  helm list"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm list'"
echo -e "*************************\n"

 echo -e "\n\n###         11.5.2) Obtain status charts helm deployed with cmd :  helm status Release-dep"
 ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm status psql-test'"
echo -e "*************************\n"

echo -e "\n\n###         11.5.3) Delete charts helm deployed with cmd :  helm uninstall psql-test"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm uninstall psql-test'"
echo -e "*************************\n"

echo -e "\n\n###         11.5.4) Delete all old secrets deployed with cmd : kubectl delete secret cast-db-secret"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get secrets -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl delete secret cast-db-secret'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get secrets -o wide'"
echo -e "*************************\n"

echo -e "\n\n###         11.5.5) Delete all old pvc deployed with cmd : kubectl delete secret cast-db-secret"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pvc -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl delete pvc data-psql-test-postgresql-0'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pvc -o wide'"
echo -e "*************************\n"

echo -e "\n\n###         11.5.6) Delete all old pv deployed with cmd : kubectl delete secret cast-db-secret"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pv -o wide'"
# ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl delete pv "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pv -o wide'"
echo -e "*************************\n"

echo -e "\n\n###         11.5.7) Create a directory on PC developper ./charts_cast_db/environements/dev with cmd : mkdir -p ./charts_cast_db/environements/dev "
# url_rep_charts="$url_rep_ci_cd/charts"
cd $ url_rep_charts
pwd
rm -r ./charts_cast_db
mkdir -p ./charts_cast_db/environements/dev
cd ./charts_cast_db/environements/dev
pwd
ls -lha
echo -e "*************************\n"

echo -e "\n\n###         11.5.8) Create k8s file ns.yaml to personalize deployment of cast-db with cmd : cat $url_rep_charts/charts_cast_db/namespace.yaml"
manifest_name="namespace-dev.yaml"
cat <<EOF > ${manifest_name}
# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dm-jenkins-cpa/cast-service/k8s/cast-deployment.yaml
### BIBLIO
#### DM-JENKIN§S-B623 -  DevOps Project — Part 4 / Dergham Lahcene /Dergham Lahcene; 8 min read; Feb 25, 2023
#####  https://medium.com/@l.dergham/devops-project-part-4-92d6641ed752
---
kind: Namespace
apiVersion: v1
metadata:
  name: dev
  labels:
    name: fastapi-dm-jenkins
---
EOF
pwd
ls -lha $manifest_name
cat $manifest_name
echo -e "*************************\n"

echo -e "\n\n###         11.5.9) Create k8s file pv.yaml to personalize deployment of cast-db with cmd : cat $url_rep_charts/charts_cast_db/pv.yaml"
manifest_name="pv-dev.yaml"
rm -r $manifest_name
cat <<EOF > ${manifest_name}
---
# K8s/B18) How to Deploy Postgres to Kubernetes Cluster; Published on January 19, 2024; https://www.digitalocean.com/community/tutorials/how-to-deploy-postgres-to-kubernetes-cluster
apiVersion: v1
kind: PersistentVolume
metadata:
  name: casts-db-volume-pv
  labels:
    type: local
    app: casts-db
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /data/postgresql
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "*************************\n"

echo -e "\n\n###         11.5.10) Create k8s file pvc.yaml to personalize deployment of cast-db with cmd : cat $url_rep_charts/charts_cast_db/pv.yaml"
manifest_name="pvc-cast-db-dev.yaml"
cat <<EOF > ${manifest_name}
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: casts-db-pvc
  namespace: dev
  labels:
    app: casts-db
    namespace: dev
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "*************************\n"

echo -e "\n\n###         11.5.11) Create k8s file pvc.yaml to personalize deployment of cast-db with cmd : cat $url_rep_charts/charts_cast_db/pv.yaml"
manifest_name="secret-cast-db-dev.yaml"
cat <<EOF > ${manifest_name}
---
apiVersion: v1
kind: Secret
metadata:
  name: cast-db-secret
  namespace: dev
type: Opaque
data:
  cast-db-username: ZmFzdGFwaV91c2Vy       # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
  cast-db-password: ZmFzdGFwaV9wYXNzd2Q=   # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
  cast-db-database: ZmFzdGFwaV9kYg==       # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "*************************\n"


echo -e "\n\n###         11.5.12) Create helm chart valuecast-db-dev.yaml to personalize deployment of  bitanami/postgres for with cmd : cat $url_rep_charts/charts_cast_db/pv.yaml"
# url_rep_charts="$url_rep_ci_cd/charts"
# cd $ url_rep_charts
manifest_name="values-charts-cast-db-dev.yaml"
cat <<EOF > ${manifest_name}
---
# https://search.brave.com/search?q=deploy+postgresql++with+helm+define+database+name+user+and+password&summary=1&conversation=dc22ae482ce1d03139eac3
auth:
  username: fastapi_user      # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
#  password: fastapi_passwd  # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
  database: fastapi_db      # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db
#   postgresPassword: postgres_passwd
# https://search.brave.com/search?q=deploy+postgresql++with+helm+define+database+name+user+and+password+secret&summary=1&conversation=110039d2dbb5f96f6df3bc
#auth:
  existingSecret: cast-db-secret
  secretKeys:
#    adminPasswordKey: postgres-password
    userPasswordKey: cast-db-password
#    password: cast-db-password # APP_DB_PASSWORD
  port: 5432
  # initdbArgs 
  # initdbWalDir
  dataDir: /var/lib/postgresql/data/pgdata

# https://search.brave.com/search?q=helm+--+create+namespace+example&summary=1&conversation=49770f42daf4f2e1b3ec9e
  namespace:
  name: baeldung-ops
  environment: dev
  app: cast-db
---
EOF
pwd
ls -lha
cat $manifest_name
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo "####     11.6) Test charts bitanami deployment postgresql"
echo -e "*************************\n"

echo -e "\n\n###         11.6.1) Copy from Pc developper to minikube server K8s manifest and charts helm for namespaces deployed with cmd :$ \n scp -i $url_id_rsa_cpa -r $url_rep_charts/charts_cast_db cpa@$ip_minikube:/home/cpa/charts/"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'rm -r /home/cpa/charts/charts_cast_db; mkdir -p /home/cpa/charts/; cd /home/cpa/charts/; pwd; ls -lha;'"
scp -i $url_id_rsa_cpa -r $url_rep_charts/charts_cast_db cpa@$ip_minikube:/home/cpa/charts/
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'tree /home/cpa/charts/charts_cast_db'"
echo -e "*************************\n"

echo -e "\n\n###         11.6.2) Deploy namespace from minikube server with cmd k8s : \n $: cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f namespace-dev.yaml"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f namespace-dev.yaml;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get ns -o wide'"
echo -e "*************************\n"



echo -e "\n\n###         11.6.3) Deploy pv with cmd k8s : \n $: cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f pv-dev.yaml"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f pv-dev.yaml;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pv -o wide'"
echo -e "*************************\n"

echo -e "\n\n###         11.6.4) Deploy pvc with cmd k8s : \n $: cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f pvc-dev.yaml"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f pvc-cast-db-dev.yaml;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pvc -o wide -n dev'"
echo -e "*************************\n"

echo -e "\n\n###         11.6.5) Deploy secret with cmd k8s :$ \n cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f pvc-dev.yaml"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f secret-cast-db-dev.yaml;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get secrets -o wide -n dev'"
echo -e "*************************\n"


echo -e "\n\n###         11.6.6) Add the Helm repository  and Update the Helm repository: :$ \n helm repo add bitnami https://charts.bitnami.com/bitnami; helm repo update;"
# https://search.brave.com/search?q=deploy+postgresql+chart+helm&summary=1&conversation=16b5594bb9c78f7c88e9f0
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'helm repo add bitnami https://charts.bitnami.com/bitnami;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'helm repo update'"
echo -e "*************************\n"

echo -e "\n\n###         11.6.7) Deploy a psql-test with the Helm chart: Use the helm install command to deploy the PostgreSQL chart. with cmd :$ \n helm install psql-test bitnami/postgresql --set persistence.existingClaim=postgresql-pv-claim --set volumePermissions.enabled=true"
# https://search.brave.com/search?q=deploy+postgresql+chart+helm&summary=1&conversation=16b5594bb9c78f7c88e9f0
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'cd /home/cpa/charts/charts_cast_db/environements/dev; helm install psql-test bitnami/postgresql --set persistence.existingClaim=postgresql-pv-claim --set volumePermissions.enabled=true --create-namespace --namespace dev -f values-charts-cast-db-dev.yaml;'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get all -n dev -o wide'"
sleep 10
echo -e "*************************\n"

echo -e "\n\n###         11.6.8) Test config deployment psql-test-postgresql-0 with cmd : \n $: kubectl -n dev exec psql-test-postgresql-0 --  env PGPASSWORD=fastapi_passwd psql -h psql-test-postgresql-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\""
fastapi_password=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get secrets -n dev cast-db-secret -o jsonpath="{.data.cast-db-password}" | base64 -d'")
# echo $fastapi_password
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl -n dev exec psql-test-postgresql-0 --  env PGPASSWORD=fastapi_passwd psql -h psql-test-postgresql-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\"'"
echo -e "*************************\n"

echo -e "\n\n###         11.6.9) Destruction de la VM de test psql-test-postgresql-0 with cmd : \n $: kubectl -n dev exec psql-test-postgresql-0 --  env PGPASSWORD=fastapi_passwd psql -h psql-test-postgresql-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\""
echo -e "\n####             11.6.9.1) List pods on namespace dev before delete pod \"psql-tes\" with cmd : \n $: kubectl get pods -n dev -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pods -n dev -o wide'"
echo -e "********"

echo -e "\n####             11.6.9.2) Delete pod on namespace dev before \"psql-tes\" with cmd : \n $: helm uninstall psql-test -n dev"
ssh -i $url_id_rsa_cpa  cpa@$ip_minikube "bash -c 'cd /home/cpa/charts/charts_cast_db/environements/dev; helm uninstall psql-test -n dev'"
echo -e "********"

echo -e "\n####             11.6.9.3)  List pods on namespace dev after deleting pod \"psql-tes\" with cmd : \n $: kubectl get pods -n dev -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get pods -n dev -o wide'"
echo -e "********"
echo -e "*************************\n"

echo -e "\n\n###         11.6.10) Test access cast-db after deploy chart helm with cmd : \n $: kubectl -n dev exec cast-db-sts-0 --  env PGPASSWORD=fastapi_passwd psql -h cast-db-sts-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\""
fastapi_password=$(ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl get secrets -n dev cast-db-secret -o jsonpath="{.data.cast-db-password}" | base64 -d'")
# echo $fastapi_password
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "bash -c 'kubectl -n dev exec cast-db-sts-0 --  env PGPASSWORD=fastapi_passwd psql -h cast-db-sts-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\"'"
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo "####     11.7) Test charts bitanami deployment postgresql from jenkins server"
echo -e "*************************\n"

echo -e "\n\n###         11.7.1) Copy from Pc developper to jenkins server K8s manifest and charts helm for namespaces deployed with cmd :$ \n scp -i $url_id_rsa -r $url_rep_charts/charts_cast_db root@$ip_jenkins:/app/charts/"
ssh -i $url_id_rsa  root@$ip_jenkins "bash -c 'rm -r /app/charts/charts_cast_db; mkdir -p /app/charts/; cd /app/charts/; pwd; ls -lha;'"
scp -i $url_id_rsa -r $url_rep_charts/charts_cast_db root@$ip_jenkins:/app/charts/
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'tree /app/charts/charts_cast_db'"
echo -e "*************************\n"


echo -e "\n\n###         11.7.2) Delete namespace dev on jenkins server with cmd k8s : \n $: cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f namespace-dev.yaml"
echo -e "********"

echo -e "\n####             11.7.2.1) List namespace dev on minikube srvr from jenkins servr before to have deleted ns dev with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa root@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide"
echo -e "********"

echo -e "\n####             11.7.2.2) Delete namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa root@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig delete ns dev"
sleep 15 

echo -e "\n####             11.7.2.3) List namespace dev on minikube srvr from jenkins servr after to have deleted namespace dev with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa root@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide"
echo -e "********"
echo -e "*************************\n"


echo -e "\n\n###          11.7.3) Deploy namespace from jenkins server on minikube server with cmd k8s : \n $: cd /app/charts/charts_cast_db/environements/dev; kubectl --kubeconfig $url_jenkins_kconfig apply -f namespace-dev.yaml"
echo -e "********"

echo -e "\n####             11.7.3.1)  Deploy namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig apply -f /app/charts/charts_cast_db/environements/dev/namespace-dev.yaml'"
sleep 6
echo -e "********"

echo -e "\n####             11.7.3.2) List namespace dev on minikube srvr from jenkins servr after to have deleted namespace dev with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide"
echo -e "********"
echo -e "*************************\n"


echo -e "\n\n###          11.7.4) Deploy secrets from jenkins server on minikube server with cmd k8s : \n $: cd /app/charts/charts_cast_db/environements/dev; kubectl --kubeconfig $url_jenkins_kconfig apply -f charts/cast-db/environments/secrets.dev.yaml"
echo -e "********"

echo -e "\n####             11.7.4.1)  List secrets deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get secrets -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get secrets -n dev'"
echo -e "********"

echo -e "\n####             11.7.4.2)  Delete secrets deployed on namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig delete secrets cast-db-secret'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig delete secrets cast-db-secret -n dev'"
echo -e "********"

echo -e "\n####             11.7.4.3)  Deploy secrets from jenkins server on namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig apply -f /app/charts/charts_cast_db/environements/dev/secret-cast-db-dev.yaml'"
# sleep 6
echo -e "********"

echo -e "\n####             11.7.4.4) List secrets from jenkins server on namespace dev on minikube srvr from jenkins servr after to have deleted namespace dev with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get secrets -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "kubectl --kubeconfig $url_jenkins_kconfig get secrets -n dev -A -o wide"
echo -e "********"
echo -e "*************************\n"


echo -e "\n\n###          11.7.5) Deploy pv from jenkins server on minikube server with cmd k8s : \n $: cd /app/charts/charts_cast_db/environements/dev; kubectl --kubeconfig $url_jenkins_kconfig apply -f charts/cast-db/environments/pv.dev.yaml"
echo -e "********"

echo -e "\n####             11.7.5.1)  List pv deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get  pv -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pv -n dev'"
echo -e "********"

echo -e "\n####             11.7.5.2)  Delete pv deployed on namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig delete pv casts-db-volume-pv -n dev; sleep 15"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig delete pv casts-db-volume-pv -n dev'"
sleep 15
echo -e "********"

echo -e "\n####             11.7.5.3)  List pv deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get  pv -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pv -n dev'"
echo -e "********"

echo -e "\n####             11.7.5.4)  Deploy pv from jenkins server on namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig apply -f /app/charts/charts_cast_db/environements/dev/pv-dev.yaml'"
# sleep 6
echo -e "********"

echo -e "\n####             11.7.5.5)  List pv deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get  pv -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pv -n dev'"
echo -e "********"
echo -e "*************************\n"


echo -e "\n\n###          11.7.6) Deploy pvc from jenkins server on minikube server with cmd k8s : \n $: cd /app/charts/charts_cast_db/environements/dev; kubectl --kubeconfig $url_jenkins_kconfig apply -f charts/cast-db/environments/pvc.dev.yaml"
echo -e "********"

echo -e "\n####             11.7.6.1)  List pvc deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get  pvc -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pvc -n dev -A -o wide'"
echo -e "********"

echo -e "\n####             11.7.6.2)  Delete pvc deployed on namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig delete pv casts-db-volume-pvc -n dev; sleep 15"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig delete pvc casts-db-volume-pv -n dev'"
sleep 15
echo -e "********"

echo -e "\n####             11.7.6.3)  List pvc deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get  pvc -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pvc -n dev'"
echo -e "********"

echo -e "\n####             11.7.6.4)  Deploy pvc from jenkins server on namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig apply -f /app/charts/charts_cast_db/environements/dev/pvc-cast-db-dev.yaml -n dev'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig apply -f /app/charts/charts_cast_db/environements/dev/pvc-cast-db-dev.yaml -n dev'"
sleep 6
echo -e "********"

echo -e "\n####             11.7.6.5)  List pvc deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get  pvc -n dev -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pvc -n dev'"
echo -e "********"
echo -e "*************************\n"



echo -e "\n\n###          11.7.7) Deploy cast-db from jenkins server on minikube server with cmd helm and charts : \n $: cd /home/cpa/charts/charts_cast_db/environements/dev; kubectl apply -f namespace-dev.yaml"
echo -e "********"

echo -e "\n####             11.7.7.1)  List helm charts deployed on namespace dev on minikube srvr from jenkins srvr with cmd : \n $: helm --kubeconfig $url_jenkins_kconfig ls''"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig ls'"
echo -e "********"
echo -e "*************************\n"

echo -e "\n####             11.7.7.2)  Add the Helm repository  and Update the Helm repository: :$ \n helm repo add bitnami https://charts.bitnami.com/bitnami; helm repo update;"
# https://search.brave.com/search?q=deploy+postgresql+chart+helm&summary=1&conversation=16b5594bb9c78f7c88e9f0
echo -e "********"

echo -e "\n####             11.7.7.2.1) Add repo bitnami with cmd : \n $: helm --kubeconfig $url_jenkins_kconfig repo add bitnami https://charts.bitnami.com/bitnami;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig repo add bitnami https://charts.bitnami.com/bitnami;'"
echo -e "********"

echo -e "\n####             11.7.7.2.2) Update repo bitnami with cmd : \n $: 'helm --kubeconfig $url_jenkins_kconfig repo update;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig repo update;'"
echo -e "********"

echo -e "\n####             11.7.7.2.3) List repo bitnami present on the jenkins servr with cmd : \n $: 'helm --kubeconfig $url_jenkins_kconfig repo ls;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig repo ls;'"
echo -e "********"
echo -e "*************************\n"



echo -e "\n####             11.7.8)  Deploy namespace dev on minikube srvr from jenkins servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
echo -e "********"

echo -e "\n####             11.7.7.8.1) List helm charts deployed from the jenkins server on minikube servr with cmd : \n $: 'helm --kubeconfig $url_jenkins_kconfig ls -A;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig ls -A;'"
echo -e "********"

echo -e "\n####             11.7.8.2) Deploy on namespace dev from the jenkins server on minikube srvr the cast-db-charts(dev postgrersql database uised by fastapi-cast with the cmd ) : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns -A -o wide'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'cd /app/charts/charts_cast_db/environements/dev; helm install --kubeconfig $url_jenkins_kconfig cast-db-charts-dev bitnami/postgresql --set persistence.existingClaim=postgresql-pv-claim --set volumePermissions.enabled=true --create-namespace --namespace dev -f values-charts-cast-db-dev.yaml'"
sleep 15 
echo -e "********"

echo -e "\n####             11.7.7.8.3) List helm charts deployed from the jenkins server on minikube servr with cmd : \n $: 'helm --kubeconfig $url_jenkins_kconfig ls -n dev;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig ls -n dev;'"
echo -e "********"
echo -e "*************************\n"


echo -e "\n\n###         11.7.9) Test config deployment cast-db-charts-dev-postgresql-0 with cmd : \n $: kubectl -n dev exec cast-db-charts-dev-postgresql-0--  env PGPASSWORD=fastapi_passwd psql -h cast-db-charts-dev-postgresql-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\""
echo -e "********"

echo -e "\n####             11.7.9.1) List pods deployed with helm charts deployed from the jenkins server on minikube servr with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get pods -n dev;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pods -n dev'"
echo -e "********"

echo -e "\n####             11.7.9.2)  Obtain the password database cast-db-chartts-dev-0 "
fastapi_password=""
fastapi_password=$(ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get secrets -n dev cast-db-secret -o jsonpath="{.data.cast-db-password}" | base64 -d'")
#echo $fastapi_password
echo -e "********"

echo -e "\n####             11.7.9.3) Sql query on cast-db-charts-dev deployed from jenkins server on minikube server with helm charts deployed from the jenkins server on minikube servr with cmd : \n "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig -n dev exec cast-db-charts-dev-postgresql-0 --  env PGPASSWORD=fastapi_passwd psql -h cast-db-charts-dev-postgresql-0 -U fastapi_user -d fastapi_db -c \"select * from pg_database;\"'"
echo -e "********"
echo -e "*************************\n"


echo -e "\n\n###         11.7.10) Delete all elements deployed"
echo -e "********"

echo -e "\n####             11.7.10.1) List ns dev from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns dev "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get ns dev'"
echo -e "********"


echo -e "\n####             11.7.10.2) Delete ns dev and all elements that is contained inside with cmd : kubectl --kubeconfig $url_jenkins_kconfig delete ns dev' "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig delete ns dev'"
echo -e "********"

echo -e "\n####             11.7.10.3) List ns dev from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get ns dev "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get ns dev'"
echo -e "********"

echo -e "\n####             11.7.10.4) List pvc on  ns dev from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get pvc -A -o wide "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pvc -A -o wide'"
echo -e "********"


echo -e "\n####             11.7.10.5) List pv on  ns dev from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get pv "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pv'"
echo -e "********"


echo -e "\n####             11.7.10.6) Delete pv on  ns dev from jenkins server deployed on minikube server with cmd : \n $:kubectl --kubeconfig $url_jenkins_kconfig delete pv casts-db-volume-pv"
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig delete pv casts-db-volume-pv'"
echo -e "********"


echo -e "\n####             11.7.10.7) List pv on  ns dev from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get pv "
ssh -i $url_id_rsa root@$ip_jenkins "bash -c 'kubectl --kubeconfig $url_jenkins_kconfig get pv'"
echo -e "********"

echo -e "\n####             11.7.10.8) Uninstall helm charts used to deploy on namespace dev from the jenkins server on minikube srvr the cast-db-charts(dev postgrersql database uised by fastapi-cast with the cmd ) : \n $: helm uninstall --kubeconfig $url_jenkins_kconfig cast-db-charts-dev'"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm uninstall --kubeconfig $url_jenkins_kconfig cast-db-charts-dev'"
sleep 15 
echo -e "********"

echo -e "\n####             11.7.7.10.9) List helm charts deployed from the jenkins server on minikube servr with cmd : \n $: 'helm --kubeconfig $url_jenkins_kconfig ls -n dev;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins "bash -c 'helm --kubeconfig $url_jenkins_kconfig ls -n dev;'"
echo -e "********"


echo -e "\n####             11.7.10.10) List all elements from jenkins server deployed on minikube server with cmd : \n $: kubectl --kubeconfig $url_jenkins_kconfig get all -A -o wide"
ssh -i $url_id_rsa root@$ip_jenkins "bash -c ' kubectl --kubeconfig $url_jenkins_kconfig get all -A -o wide'"
echo -e "********"
echo -e "*************************\n"
echo -e "*************************\n"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################



################################################################
echo -e "\n################################################################"
echo -e "## END 11) Test deployment with helm"
echo -e "###############"
echo -e "###############################\n" 
echo -e "\n################################################################"
###############
###############################
################################################################

################################################################
echo -e "\n################################################################"
echo "####     20) Quit properly"
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo -e "###         20.0) Delete all ctnr dckr on jenkins server with cmd : \n $: docker ps -a; docker rm -f $(docker ps -aq); docker ps -a;"
ssh -i $url_id_rsa_cpa cpa@$ip_jenkins 'bash -c "docker ps -a; docker rm -f $(docker ps -aq); docker ps -a;"'
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo -e "###         20.1) Delete minikube cluster "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube delete --all"
#### => cpa@pve$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube "minikube delete --all"
#### => * Suppression de "minikube" dans docker...
#### => * Suppression du répertoire /home/cpa/.minikube/machines/minikube…
#### => * Le cluster "minikube" a été supprimé.
#### => * Tous les profils ont été supprimés avec succès
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo -e "###         20.2) List all dckr ctnr on minikube "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "docker ps -a"
#### => cpa@pve$ ssh -i $url_id_rsa_cpa cpa@$ip_minikube "docker ps -a"
#### => CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
echo -e "###############"
echo -e "###############################\n"
###############
###############################


################################################################
echo -e "\n################################################################"
echo -e "###         20.3) List all dckr ctnr on minikube "
ssh -i $url_id_rsa_cpa cpa@$ip_minikube "docker ps -a"

sudo qm stop 122
#### => cpa@pve$ sudo qm stop 122
#### => [sudo] password for cpa: 

sudo qm stop 123
#### => cpa@pve$ sudo qm stop 123

sudo sudo qm list
#### => cpa@pve$ sudo qm list
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################




################################################################
echo -e "\n################################################################"
echo "####     21) CMD TO DEBUG 
### Minikube-B15) How to Fix Kubernetes ‘502 Bad Gateway’ Error; Nir Shtein; Nir Shtein, Software Engineer; 5 min read  April 19th, 2022; Kubernetes : https://komodor.com/learn/how-to-fix-kubernetes-502-bad-gateway-error/
# minikube service nginx-cpa-svc --url
# kubectl get pods

# kubectl describe pod nginx-cpa-dep-74d99f8b49-ms67w

# kubectl get svc
# kubectl describe svc nginx-cpa-svc
# kubectl get ingress
# kubectl describe ingress dm-jenkins-ingress
# kubectl get pods
# Test in pod nginx : https://alexcpn.medium.com/a-test-nginx-pod-with-pv-e50b4e7cdf1e
# kubectl exec -it nginx-cpa-dep-74d99f8b49-pg8cm -- /bin/bash
# curl localhost
# cd /usr/share/nginx/html

# kubectl cluster-info

# ls -lha
#cat index.html"
echo -e "###############"
echo -e "###############################"
echo -e "################################################################\n\n"
###############
###############################
################################################################



################################################################
################################################################
# END OF SCRIPT
#################################################################################################################################
#################################################################################################################################
