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



################################################################
## 1.) Installing the binaries kubectl , k3d and helm
###       B33-k3d-Rancher-supervision-Playing with Kubernetes using k3d and Rancher | by Prakhar Malviya | 47Billion | Medium:
####         https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23
###############################


###############################
###     1.0.) install docker
#### curl -fsSL https://get.docker.com -o get-docker.sh
#### sh get-docker.sh
###############################


###############################
###      1.1.) install kubectl
####            B44-1) K8s Documentation / Tasks / Install Tools / Install and Set Up kubectl on Linux / Install and Set Up kubectl on Linux
#####                  https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/Install kubectl binary with curl on Linux
###############
#####          1.1.1) Download the latest release with the command:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
###############

####          1.1.2) Validate the binary (optional)
#####                1.1.2.1) Download the kubectl checksum file:
 curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
###############

######                1.1.2.1) Validate the kubectl binary against the checksum file:
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

#######                       If valid, the output is:
####### =>  kubectl: OK/Réussi

#######                       If the check fails, sha256 exits with nonzero status and prints output similar to:
####### => kubectl: FAILED
####### => sha256sum: WARNING: 1 computed checksum did NOT match
###############

#####          1.1.3) Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
###############

#####          1.1.4) Test 1 to ensure the version you installed is up-to-date:
sudo kubectl version --client
###############

#####          1.1.5) Test 1 to ensure the version you installed is up-to-date:
sudo kubectl version --client --output=yaml
###############

#####          1.1.6) Deploy docker compose jenkins servesudor
sudo docker compose up -d

sleep 6
#ip_jenkins=$(sudo docker exec -it jenkins hostname -i)
# echo $ip_jenkins
#sudo docker exec -it jenkins hostname -i > foo && sed -e 's/^M//g' foo && ip_jenkins=`cat foo` && echo $ip_jenkins && rm foo

###############################


###############################
###      1.2) install helm (this one takes some time)
####            B44-2+3) Installing Helm From the Binary Releases
#####                      https://helm.sh/docs/intro/install/

#####          1.2.0) Download and install release version with one cmd
######                  curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

#####          1.2.1) Download release version
curl -LO https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz

#####          1.2.2) Validate the binary (optional)
######                1.2.2.1) Download the kubectl checksum file:
curl -LO "https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz.sha256sum"

######                1.2.2.2) Validate the kubectl binary against the checksum file:
echo "$(cat helm-v3.17.3-linux-amd64.tar.gz.sha256sum)" | sha256sum --check

#####          1.2.3)  Unpack it (tar -zxvf helm-v3.0.0-linux-amd64.tar.gz)
tar -zxvf helm-v3.17.3-linux-amd64.tar.gz

#####          1.2.4)  Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)
sudo mv linux-amd64/helm /usr/local/bin/helm


#####          1.2.5) Test 1 to ensure the version you installed is up-to-date:
sudo helm version
##### => version.BuildInfo{Version:"v3.17.3", GitCommit:"e4da49785aa6e6ee2b86efd5dd9e43400318262b", GitTreeState:"clean", GoVersion:"go1.23.7"}
###############################


###############################
###      1.3) install k3d
####          B44-4+5) Installing Helm From the Binary Releases
#####                  B44-4) What is k3d?¶ : https://k3d.io/stable/#requirements
#####                  B44-5) Github Download Release latest version : https://github.com/k3d-io/k3d/releases
###############

#####          1.3.0) Download and install release version with one cmd
######                   curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
###############

#####          1.3.1) Download release version
curl -LO "https://github.com/k3d-io/k3d/releases/download/v5.8.3/k3d-linux-amd64"
###############

#####          1.3.2) Validate the binary (optional)
######                1.3.2.1) Download the kubectl checksum file:
curl -LO "https://github.com/k3d-io/k3d/releases/download/v5.8.3/checksums.txt"
###############

######                1.3.2.2) Validate the kubectl binary against the checksum file:
echo "$(cat checksums.txt | grep k3d-linux-amd | awk '{ print $1 }') k3d-linux-amd64" | sha256sum --check
###### => k3d-linux-amd64: Réussi
###############

#####          1.3.3)  Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)
sudo mv k3d-linux-amd64 /usr/local/bin/k3d
sudo chmod 744 /usr/local/bin/k3d
ls -lha /usr/local/bin/k3d
##### => -rwx------ 1 cpa cpa 24M 17 avril 17:29 /usr/local/bin/k3d
###############

#####          1.3.4) Test 1 to ensure the version you installed is up-to-date:
sudo k3d version
###### cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins3$ sudo k3d --version
####### => k3d version v5.8.3
####### => k3s version v1.31.5-k3s1 (default)
################################################################




################################################################
## 2.) Creating the cluster : one master and 2 workers k3S
###       B33-k3d-Rancher-supervision-Playing with Kubernetes using k3d and Rancher | by Prakhar Malviya | 47Billion | Medium:
####         https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23
###############################


###############################
###    2.1) This will create a cluster named “mycluster” with 3 ports exposed 30080, 30081 and 30082.
###############
####        B33-2) k3d-create --tls-san : doc1 doc officielle k3s / configuration / k3s server
#####                  https://docs.k3s.io/cli/server
######                    -tls-san value	N/A	Add additional hostnames or IPv4/IPv6 addresses as Subject Alternative Names on the TLS cert
###############

###############
####        B33-3) k3d KUBECONFIG option --tls-san : doc1 doc officielle k3s / configuration / Configuration File
#####            / https://docs.k3s.io/installation/configuration
######                /etc/rancher/k3s/config.yaml, and drop-in files are loaded from /etc/rancher/k3s/config.yaml.d/*.yaml in alphabetical order. This path is configurable via the --config CLI flag or K3S_CONFIG_FILE env var. When overriding the default config file name, the drop-in directory path is also modified.
###############

###############
####        B33-4) k3s.yaml-tls-san parameter won't change · Issue #4149 · k3s-io/k3s
#####                  https://github.com/k3s-io/k3s/issues/4149
######                     Make a /etc/rancher/k3s/config.yaml file with your settings. I have:
#######                      write-kubeconfig-mode: "0644"
#######                      token: hoolabaloosecrettoken
#######                      tls-san:
#######                        - 192.168.10.4
#######                        - 192.168.10.10
###############

###############
####          These ports will map to ports 8900, 8901 and 8902 of your localhost respectively.
####          The cluster will have 1 master node and 2 worker nodes. You can adjust these settings using the p and the agent flags as you wish.
#####             sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=172.30.0.6"@server:*
sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${ip_jenkins}"@server:*
###############################


###############################
###    2.2) Verify the creation of the cluster k3s [my-cluster] composed with one loadbalancer, one ctl master and 2 workers
sudo docker ps -a
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo docker ps -a
##### => CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                  NAMES
##### => e84a8bbebb9d   ghcr.io/k3d-io/k3d-proxy:5.8.3   "/bin/sh -c nginx-pr…"   28 seconds ago   Up 22 seconds   80/tcp, 0.0.0.0:46673->6443/tcp, 0.0.0.0:8900->30080/tcp, :::8900->30080/tcp, 0.0.0.0:8901->30081/tcp, :::8901->30081/tcp, 0.0.0.0:8902->30082/tcp, :::8902->30082/tcp   k3d-mycluster-serverlb
##### 624fb3e19301   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-1
##### 7599073a5501   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 24 seconds                                                                                                                                                                            k3d-mycluster-agent-0
##### 959371b1b206   rancher/k3s:v1.31.5-k3s1         "/bin/k3d-entrypoint…"   30 seconds ago   Up 27 seconds                                                                                                                                                                            k3d-mycluster-server-0
##### 371040630af2   jenkins/jenkins:lts              "/usr/bin/tini -- /u…"   2 hours ago      Up 2 hours      0.0.0.0:50000->50000/tcp, :::50000->50000/tcp, 0.0.0.0:8280->8080/tcp, :::8280->8080/tcp                                                                                 jenkins
###############################


###############################
###    2.3) Consult information about cluster k3s [my-cluster] composed with one loadbalancer, one ctl master and 2 workers
sudo kubectl cluster-info

####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo kubectl cluster-info
##### => Kubernetes control plane is running at https://0.0.0.0:46673
##### => CoreDNS is running at https://0.0.0.0:46673/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
##### => Metrics-server is running at https://0.0.0.0:46673/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy
##### =>
##### => To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
###############################


###############################
###    2.4) List the 3 nodes of cluster k3s [my-cluster] composed with one ctl master and 2 workers
sudo kubectl get nodes
####  cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ sudo kubectl get nodes -o wide
##### => NAME                     STATUS   ROLES                  AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE           KERNEL-##### => VERSION   CONTAINER-RUNTIME
##### => k3d-mycluster-agent-0    Ready    <none>                 13m   v1.31.5+k3s1   172.21.0.5    <none>        K3s v1.31.5+k3s1   6.8.12-9-pve     containerd://1.7.23-k3s2
##### => k3d-mycluster-agent-1    Ready    <none>                 13m   v1.31.5+k3s1   172.21.0.4    <none>        K3s v1.31.5+k3s1   6.8.12-9-pve     containerd://1.7.23-k3s2
##### => k3d-mycluster-server-0   Ready    control-plane,master   13m   v1.31.5+k3s1   172.21.0.3    <none>        K3s v1.31.5+k3s1   6.8.12-9-pve     containerd://1.7.23-k3s2
###############################


###############################
###   2.5) List all compoenent of kubectl server
sudo kubectl get all -A
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
################################################################




################################################################
## 3) Create the file .kube/config to access kubectl command  from the server Jenkins

###############################
###    3.1) configure access kubectl-cli on  k3d-mycluster-server-0 from jenkins ctr dckr
###############

#####          3.1.1) Delete and recreate directory [./datas/data-k3d] to restart without existant file [./datas/data-k3d/k3s.yaml]
rm -r ./datas/data-k3d
mkdir -p ./datas/data-k3d
ls -lha ./datas/data-k3d
###### cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins2$ ls -lha ./datas/data-k3d
###### # => total 8,0K
###### # => drwxr-xr-x 2 cpa cpa 4,0K 17 avril 18:59 .
###### # => drwxr-xr-x 3 cpa cpa 4,0K 17 avril 18:59 ..
###############

#####          3.1.2) Recreate the file [./datas/data-k3d/k3s.yaml] from the ctl master [k3d-mycluster-server-0] of the k3s cluster
sudo docker exec -it k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml >./datas/data-k3d/k3s.yaml
cat ./datas/data-k3d/k3s.yaml

###############

#####          3.1.3) From the existant file [./datas/data-k3d/k3s.yaml], create a second file [./datas/data-k3d/k3s_v2.yaml] with the configuration which be able to connect the kubectl server from jenkins server.
#sed -i "s|server: https://127.0.0.1:6443|server: https://$ip_jenkins:6443|g" ./datas/data-k3d/k3s.yaml
# sed -i 's/'$ip_source'\b/'$ip_jenkins'/g' ./datas/data-k3d/k3s.yaml
# sed -E 's~(https?://)[^ :;]+(:?\d*)~\1'$ip_jenkins2'\2~' -i ./datas/data-k3d/k3s.yaml
ip_source="127\\.0\\.0\\.1"
echo "ip_source: " $ip_source
#ip_jenkins2="https://$ip_jenkins"
ip_jenkins=$(sudo docker exec jenkins hostname -i)
echo "ip_jenkins: " $ip_jenkins

ip_k3s_srvr=$(sudo docker exec k3d-mycluster-server-0 hostname -i)
echo "ip_k3s_srvr: " $ip_k3s_srvr

ls -lha ./datas/data-k3d
cp ./datas/data-k3d/k3s.yaml ./datas/data-k3d/k3s_v2.yaml
sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s_v2.yaml
ls -lha ./datas/data-k3d
cat ./datas/data-k3d/k3s_v2.yaml
#sudo docker exec -it jenkins export KUBECONFIG=/datas/data-k3d/k3s.yaml

###############

#####          3.1.4) git commit -m "update Jenkinsfile to deploy the fastapi on the k3s cluster from the ./datas/Data-k3d/k"s_v2.yaml"
###### sudo docker cp ./datas/data-k3d/k3s_v2.yaml jenkins:/datas/data-k3d/k3s.yaml
###############################


###############################

##    3.2)  You can check the nodes using
### sudo kubectl get nodes
### sudo docker exec -it jenkins kubectl get nodes
################################################################




################################################################
# 4.) Deploying Rancher
##    4.1) Cmd to deploy
sudo helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
###############################

###############################
##      4.2) Then install it using -
sudo helm install rancher rancher-latest/rancher \
   --namespace cattle-system \
   --create-namespace \
   --set ingress.enabled=false \
   --set tls=external \
   --set replicas=1
################################################################




################################################################
# 5. Creating the nodeport
##     5.1) Create a file called rancher.yaml -
cat <<EOF > rancher.yaml 
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
EOF
###############################

###############################
#    5.2) Then apply it using
sudo kubectl apply -f rancher.yaml
################################################################


################################################################
### 6.) Verification
#      6.1) Display all VM docker
sudo docker images
sudo docker volume ls -a
sudo docker ps -a
###############################

###############################
#      6.2) Display all nodes of the k3s cluster
sudo kubectl get nodes -o wide
sudo kubectl get all -A
###############################

###############################
#      6.3) Display the password rancher monitoring k3s cluster
#kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
################################################################

################################################################
# END OF SCRIPT
#################################################################################################################################
#################################################################################################################################
