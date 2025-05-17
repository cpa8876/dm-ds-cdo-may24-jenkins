#!/bin/bash
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


################################################################
## 3) Erase all vm dckr and launch the creation of ctnr docker
###############

###############################
### 3.1) Delete namaespace dev
ssh -i $url_id_rsa root@$ip_k3d 'sudo kubectl delete ns dev'
###############

###############################
### 3.2) Delete dckr compose deployment
ssh -i $url_id_rsa root@$ip_k3d 'mkdir -p /app && cd /app && ls -lha /app docker compose down'
###############

###############################
### 3.3)  List then delete all ctnr dckr
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
ssh -i $url_id_rsa root@$ip_k3d 'docker rm -f $(sudo docker ps -aq)'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
###############

###############################
### 3.4) List and delete all dckr images
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
ssh -i $url_id_rsa root@$ip_k3d 'docker image rmi -f $(sudo docker images -q)'
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
###############

###############################
### 3.5) List and delete all dckr volumes
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume rm -f $(sudo docker volume ls -q)'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls'
###############

###############################
### 3.6) List and delete all dckr networks
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
ssh -i $url_id_rsa root@$ip_k3d 'docker network rm $(sudo docker network ls -q)'
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
###############

###############################
### 3.7) List and verify all dckr components are well deleted =
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
ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster delete mycluster'
ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${ip_k3d}"@server:* --api-port 192.168.1.83:6443'

###############

###############################
###    4.3) List dckr components
echo "########################################################"
echo "*************************"
echo "kubctl cluster-info : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl cluster-info'
echo "########################################################"

echo "*************************"
echo "kubctl get nodes : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get nodes'
echo "########################################################"

echo "*************************"
echo "kubctl namespaces: on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get ns'
echo "########################################################"


echo "*************************"
echo "kubctl get pv :  persitent volumes : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pv -A'
echo "########################################################"

echo "*************************"
echo "kubctl get pvc : persitent volumes claim :on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pc -A'
echo "########################################################"

echo "*************************"
echo "kubctl get -all -A : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get -all -A'
echo "########################################################"

echo "*************************"
echo "kubctl get pods :on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pods -A'
echo "########################################################"

echo "*************************"
echo "kubctl get svc : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -A'
echo "########################################################"

echo "*************************"
echo "kubctl get netwoRks: on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get networks -A'
echo "########################################################"

echo "*************************"
echo "kubctl get deployment : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get deployement -A'
echo "########################################################"

echo "*************************"
echo "kubctl get statefullset : on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get statefulset -A'
echo "########################################################"
echo "########################################################"
###############

###############################
###    4.4) Verify the creation of the cluster k3s [my-cluster] composed with one loadbalancer, one ctl master and 2 workers
echo "########################################################"
echo "*************************"
echo "docker ps -a on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
echo "########################################################"
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo docker ps -a
##### => CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                  NAMES
##### => e84a8bbebb9d   ghcr.io/k3d-io/k3d-proxy:5.8.3   "/bin/sh -c nginx-pr…"   28 seconds ago   Up 22 seconds   80/tcp, 0.0.0.0:46673->6443/tcp, 0.0.0.0:8900->30080/tcp, :::8900->30080/tcp, 0.0.0.0:8901->30081/tcp, :::8901->30081/tcp, 0.0.0.0:8902->30082/tcp, :::8902->30082/tcp   k3d-mycluster-serverlb
##### 624fb3e19301   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-1
##### 7599073a5501   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-0
##### 959371b1b206   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 27 seconds                                                                                                                                                                            k3d-mycluster-server-0
##### 371040630af2   jenkins/jenkins:lts              "/usr/bin/tini -- /u…"   2 hours ago      Up 2 hours      0.0.0.0:50000->50000/tcp, :::50000->50000/tcp, 0.0.0.0:8280->8080/tcp, :::8280->8080/tcp                                                                                 jenkins
###############
###############################
################################################################


################################################################
## 5) Create the file .kube/config to access kubectl command  from the server Jenkins
###############
####        B33-3) k3d KUBECONFIG option --tls-san : doc1 doc officielle k3s / configuration / Configuration File
#####            / https://docs.k3s.io/installation/configuration
######                /etc/rancher/k3s/config.yaml, and drop-in files are loaded from /etc/rancher/k3s/config.yaml.d/*.yaml in alphabetical order. This path is configurable via the --config CLI flag or K3S_CONFIG_FILE env var. When overriding the default config file name, the drop-in directory path is also modified.
#########################################
###    5.1) configure access kubectl-cli on  k3d-mycluster-server-0 from jenkins ctr dckr
##########

####################
####          5.1.1) Delete and recreate directory [./datas/data-k3d] to restart without existant file [./datas/data-k3d/k3s.yaml]
rm -r ./datas/data-k3d
mkdir -p ./datas/data-k3d
ls -lha ./datas/data-k3d
###### cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ ls -lha ./datas/data-k3d
###### # => total 8,0K
###### # => drwxr-xr-x 2 cpa cpa 4,0K 17 avril 18:59 .
###### # => drwxr-xr-x 3 cpa cpa 4,0K 17 avril 18:59 ..
##########

####################
####          5.1.2) Recreate the file [./datas/data-k3d/k3s.yaml] from the ctl master [k3d-mycluster-server-0] of the k3s cluster
# ssh -i $url_id_rsa root@$ip_k3d 'docker exec -it k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml' | tee ./datas/data-k3d/k3s.yaml

ssh -i $url_id_rsa root@$ip_k3d 'docker exec k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml'
ssh -i $url_id_rsa root@$ip_k3d 'docker exec k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml' > ./datas/data-k3d/k3s.yaml
cat ./datas/data-k3d/k3s.yaml
sleep 3
##########

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

ls -lha ./datas/data-k3d
cp ./datas/data-k3d/k3s.yaml ./datas/data-k3d/k3s_v2.yaml
####              sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s_v2.yaml
sed -i 's+127.0.0.1+'$ip_k3d'+g' ./datas/data-k3d/k3s_v2.yaml
ls -lha ./datas/data-k3d
cat ./datas/data-k3d/k3s_v2.yaml
#sudo docker exec -it jenkins export KUBECONFIG=/datas/data-k3d/k3s_v2.yaml
##########

###############################
##    5.2) Copy ./datas/data-k3d/k3s_v2.yaml jenkins:/usr/local/k3s.yaml to permitt acces of kubectl command from Jenkins server
###                           sudo docker cp ./datas/data-k3d/k3s_v2.yaml jenkins:/usr/local/k3s.yaml
cat ./datas/data-k3d/k3s_v2.yaml
scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/datas/data-k3d/k3s_v2.yaml root@$ip_jenkins:/usr/local/k3s.yaml
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /usr/local/k3s.yaml'
###############

###############################
##    5.3) Verify copy on the vm jenkins server
###                           sudo docker exec -it jenkins cat /usr/local/k3s.yaml
ssh -i $url_id_rsa root@$ip_jenkins 'cat /usr/local/k3s.yaml'
###############

###############################
##    5.4) Update environment KUBECONFIG on vm jenkins server
###                          sudo docker exec -it jenkins /bin/sh -c "export KUBECONFIG='/usr/local/k3s.yaml' && kubectl get pods --all-namespaces"
###                          export KUBECONFIG="/usr/local/k3s.yaml"'
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
## 6) Deploying Rancher
##    6.1) Cmd to deploy
###                          sudo helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
ssh -i $url_id_rsa root@$ip_k3d 'helm repo add rancher-latest https://releases.rancher.com/server-charts/latest'
###############

###############################
##     6.2) Then install it using -

###                          sudo helm install rancher rancher-latest/rancher --namespace cattle-system --create-namespace --set ingress.enabled=false --set tls=external --set replicas=1
ssh -i $url_id_rsa root@$ip_k3d 'helm install rancher rancher-latest/rancher --namespace cattle-system --create-namespace --set ingress.enabled=false --set tls=external --set replicas=1'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
sleep 6
###############

###############################
## 6.3) Creating the nodeport
##########
####################
####           6.3.1) Create a file called rancher.yaml -
ssh -i $url_id_rsa root@$ip_k3d 'cat <<EOF > rancher.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: rancher
  name: ranchernp
  namespace: cattle-system
spec:
  ports:
  - name: http
    nodePort: 30080
    port: 80
    protocol: TCP
    targetPort: 80
  - name: https-internal
    nodePort: 30081
    port: 443
    protocol: TCP
    targetPort: 443  
  selector:
    app: rancher 
  type: NodePort 
EOF'

ssh -i $url_id_rsa root@$ip_k3d 'cat rancher.yaml'
##########

####################
####          6.3.2) Then apply it using
###                          sudo kubectl apply -f rancher.yaml
ssh -i $url_id_rsa root@$ip_k3d 'kubectl apply -f rancher.yaml'
sleep 15
###############

###############################
## 6.4) Configure rancher k3d monitoring
##########

####################
####          6.4.1) Connect with your internet navigator on url : https://192.168.1.83:8901
##########

####################
####          6.4.2) on the terminal of vm pve k3d server execute the command :
####             kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
echo "########################################################"
echo "*************************"
echo "execute cmd  on gnome-terminal k3d :"
echo "kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}'"
echo "########################################################"
sleep 6
echo "########################################################"
echo "*************************"
echo "docker ps -a on  k3d servr : "
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
echo "########################################################"
###############################
################################################################


################################################################
## 7) configure jenkins server toi permitt to access to vm k3d cluster
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
####          7.1.2) Update access on the jenkins server : replacxe the port 8080 by the port 8280
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
curl $ip_jenkins:8082
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

scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/docker-compose.yml root@$ip_jenkins:/app/

scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/nginx_config.conf root@$ip_jenkins:/app/

scp -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/README.md root@$ip_jenkins:/app/


ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/'
##########


###############################
### 7.2)  List then delete all ctnr dckr
echo "########################################################"
echo "*************************"
echo "docker ps -a  on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker ps -a'
ssh -i $url_id_rsa root@$ip_jenkins 'docker rm -f $(sudo docker ps -aq)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker ps -a'
###############

###############################
### 7.3) List and delete all dckr images
echo "########################################################"
echo "*************************"
echo "docker images on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker images'
ssh -i $url_id_rsa root@$ip_jenkins 'docker image rmi -f $(sudo docker images -q)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker images'
###############

###############################
### 7.4) List and delete all dckr volumes
echo "########################################################"
echo "*************************"
echo "docker volume ls  on gnome-terminal jenkins :"
ssh -i $url_id_rsa root@$ip_jenkins 'docker volume ls'
ssh -i $url_id_rsa root@$ip_jenkins 'docker volume rm -f $(sudo docker volume ls -q)'
ssh -i $url_id_rsa root@$ip_jenkins 'docker volume ls'
###############

###############################
### 7.5) List and delete all dckr networks
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
####   8.4) Display all namerspaces of the k3d cluster
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
################################################################

################################################################
# END OF SCRIPT
#################################################################################################################################
#################################################################################################################################
