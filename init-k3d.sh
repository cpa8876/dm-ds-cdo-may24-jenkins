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
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
###############

###############################
### 2.3) Access from host PC on vm-114-111-dmj-k3d
gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_k3d"
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
ssh -i $url_id_rsa root@$ip_k3d 'docker network ls'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls'
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
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
# sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${$ip_jenkins}"@server:*
#  ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=localhost"@server:*'
# ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${$ip_jenkins}"@server:*'

ssh -i $url_id_rsa root@$ip_k3d  'k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${ip_k3d}"@server:* --api-port 192.168.1.83:6443'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
###############

###############################
###    4.3) List dckr components
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'kubectl cluster-info'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get nodes'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get ns'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pv -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pc -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get -all -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get pods -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get svc -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get networks -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get deployement -A'
echo "########################################################"
echo "########################################################"

ssh -i $url_id_rsa root@$ip_k3d 'kubectl get statefulset -A'
echo "########################################################"
echo "########################################################"
###############

###############################
###    4.4) Verify the creation of the cluster k3s [my-cluster] composed with one loadbalancer, one ctl master and 2 workers
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo docker ps -a
##### => CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                  NAMES
##### => e84a8bbebb9d   ghcr.io/k3d-io/k3d-proxy:5.8.3   "/bin/sh -c nginx-pr…"   28 seconds ago   Up 22 seconds   80/tcp, 0.0.0.0:46673->6443/tcp, 0.0.0.0:8900->30080/tcp, :::8900->30080/tcp, 0.0.0.0:8901->30081/tcp, :::8901->30081/tcp, 0.0.0.0:8902->30082/tcp, :::8902->30082/tcp   k3d-mycluster-serverlb
##### 624fb3e19301   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-1
##### 7599073a5501   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-0
##### 959371b1b206   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 27 seconds                                                                                                                                                                            k3d-mycluster-server-0
##### 371040630af2   jenkins/jenkins:lts              "/usr/bin/tini -- /u…"   2 hours ago      Up 2 hours      0.0.0.0:50000->50000/tcp, :::50000->50000/tcp, 0.0.0.0:8280->8080/tcp, :::8280->8080/tcp                                                                                 jenkins
###############

###############################
###    4.5) Consult information about cluster k3s [my-cluster] composed with one loadbalancer, one ctl master and 2 workers
ssh -i $url_id_rsa root@$ip_k3d 'kubectl cluster-info'

####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo kubectl cluster-info
##### => Kubernetes control plane is running at https://0.0.0.0:46673
##### => CoreDNS is running at https://0.0.0.0:46673/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
##### => Metrics-server is running at https://0.0.0.0:46673/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy
##### =>
##### => To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
###############

###############################
###    4.6) List the 3 nodes of cluster k3s [my-cluster] composed with one ctl master and 2 workers
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get nodes'
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo kubectl get nodes -o wide
##### => NAME                     STATUS   ROLES                  AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE           KERNEL-##### => VERSION   CONTAINER-RUNTIME
##### => k3d-mycluster-agent-0    Ready    <none>                 13m   v1.31.5+k3s1   172.21.0.5    <none>        K3s v1.31.5+k3s1   6.8.12-9-pve     containerd://1.7.23-k3s2
##### => k3d-mycluster-agent-1    Ready    <none>                 13m   v1.31.5+k3s1   172.21.0.4    <none>        K3s v1.31.5+k3s1   6.8.12-9-pve     containerd://1.7.23-k3s2
##### => k3d-mycluster-server-0   Ready    control-plane,master   13m   v1.31.5+k3s1   172.21.0.3    <none>        K3s v1.31.5+k3s1   6.8.12-9-pve     containerd://1.7.23-k3s2
###############

###############################
###   4.7) List all components of kubectl server
ssh -i $url_id_rsa root@$ip_k3d 'kubectl get all -A'
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo kubectl get all -A
##### => NAMESPACE     NAME                                          READY   STATUS      RESTARTS   AGE
##### => kube-system   pod/coredns-ccb96694c-8dxxh                   1/1     Running     0          17m
##### => kube-system   pod/helm-install-traefik-crd-tm6dz            0/1     Completed   0          17m
##### => kube-system   pod/helm-install-traefik-qlhdm                0/1     Completed   0          17m
##### => kube-system   pod/local-path-provisioner-5cf85fd84d-xzrxv   1/1     Running     0          17m
##### => kube-system   pod/metrics-server-5985cbc9d7-4vsfg           1/1     Running     0          17m
##### => kube-system   pod/svclb-traefik-745790f4-qjn67              2/2     Running     0          16m
##### => kube-system   pod/svclb-traefik-745790f4-r2h78              2/2     Running     0          16m
##### => kube-system   pod/svclb-traefik-745790f4-zq7q9              2/2     Running     0          16m
##### => kube-system   pod/traefik-5d45fc8cc9-hvlmb                  1/1     Running     0          16m
##### =>
##### => NAMESPACE     NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP                        PORT(S)                      AGE
##### => default       service/kubernetes       ClusterIP      10.43.0.1      <none>                             443/TCP                      17m
##### => kube-system   service/kube-dns         ClusterIP      10.43.0.10     <none>                             53/UDP,53/TCP,9153/TCP       17m
##### => kube-system   service/metrics-server   ClusterIP      10.43.85.172   <none>                             443/TCP                      17m
##### => kube-system   service/traefik          LoadBalancer   10.43.54.116   172.21.0.3,172.21.0.4,172.21.0.5   80:31953/TCP,443:31849/TCP   16m
##### =>
##### => NAMESPACE     NAME                                    DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
##### => kube-system   daemonset.apps/svclb-traefik-745790f4   3         3         3       3            3           <none>          16m
##### =>
##### => NAMESPACE     NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
##### => kube-system   deployment.apps/coredns                  1/1     1            1           17m
##### => kube-system   deployment.apps/local-path-provisioner   1/1     1            1           17m
##### => kube-system   deployment.apps/metrics-server           1/1     1            1           17m
##### => kube-system   deployment.apps/traefik                  1/1     1            1           16m
##### =>
##### => NAMESPACE     NAME                                                DESIRED   CURRENT   READY   AGE
##### => kube-system   replicaset.apps/coredns-ccb96694c                   1         1         1       17m
##### => kube-system   replicaset.apps/local-path-provisioner-5cf85fd84d   1         1         1       17m
##### => kube-system   replicaset.apps/metrics-server-5985cbc9d7           1         1         1       17m
##### => kube-system   replicaset.apps/traefik-5d45fc8cc9                  1         1         1       16m
##### =>
##### => NAMESPACE     NAME                                 STATUS     COMPLETIONS   DURATION   AGE
##### => kube-system   job.batch/helm-install-traefik       Complete   1/1           12s        17m
##### => kube-system   job.batch/helm-install-traefik-crd   Complete   1/1           9s         17m
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
sleep 15
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
###############

###############################
## 7.3) Verify copy on the vm jenkins server
###                           sudo docker exec -it jenkins cat /usr/local/k3s.yaml
ssh -i $url_id_rsa root@$ip_jenkins 'cat /usr/local/k3s.yaml'
###############

###############################
## 7.3) Update environment KUBECONFIG on vm jenkins server
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
## 7.1) Excute script ./docker-compose.yml script to build container docker Jenkins server
# sudo docker compose up -d

# sudo docker compose up -d
ssh -i $url_id_rsa root@$ip_jenkins ' rm -r /app'
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app'
ssh -i $url_id_rsa root@$ip_jenkins 'mkdir -p /app'
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app'
ssh -i $url_id_rsa root@$ip_jenkins 'groupadd docker'
ssh -i $url_id_rsa root@$ip_jenkins 'usermod -aG docker jenkins'
ssh -i $url_id_rsa root@$ip_jenkins 'reboot'
sleep 2
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
ssh -i $url_id_rsa root@$ip_jenkins 'newgrp docker'
ssh -i $url_id_rsa root@$ip_jenkins 'systemctl restart docker.service'

scp -r -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/cast-service root@$ip_jenkins:/app/
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/cast-service/'

scp -r -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/movie-service root@$ip_jenkins:/app/movie-service
ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/movie-service/'

###############



###############################
# 7.2) Verification
##########
####################
####          7.2.1) Display all VM docker
echo " 7.2.1) ############################### "
ssh -i $url_id_rsa root@$ip_k3d 'docker images'
ssh -i $url_id_rsa root@$ip_k3d 'docker volume ls -a'
ssh -i $url_id_rsa root@$ip_k3d 'docker ps -a'
##########

####################
####          7.2.2) Display all nodes of the k3d cluster
echo " 7.2.2) ############################### "
ssh -i $url_id_rsa root@$ip_k3d 'docker exec -it jenkins kubectl --kubeconfig /usr/local/k3s.yaml get all -A -o wide'
##########

####################
####          7.2.3) Display all nodes of the k3d cluster
echo " 7.2.3) ############################### "
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get pods -A -o wide'
##########

####################
####          7.4.4) Display all namerspaces of the k3d cluster
echo " 7.2.4) ############################### "
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get ns -A -o wide'
##########

####################
####          7.4.5) Display all pods of the k3d cluster
echo " 7.2.5) ############################### "
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get pods -A -o wide'
##########

####################
####           7.4.6) Display the password rancher monitoring k3s cluster
#kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
################################################################

################################################################
# END OF SCRIPT
#################################################################################################################################
#################################################################################################################################
