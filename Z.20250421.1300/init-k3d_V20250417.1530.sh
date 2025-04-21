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

ip_k3s_srvr=$(sudo docker exec k3d-mycluster-server-0 hostname -i)
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


# 3.) Creating the cluster : one master and 2 workers k3S
##    3.1) This will create a cluster named “mycluster” with 3 ports exposed 30080, 30081 and 30082.
### These ports will map to ports 8900, 8901 and 8902 of your localhost respectively.
### The cluster will have 1 master node and 2 worker nodes. You can adjust these settings using the p and the agent flags as you wish.
# sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=172.30.0.6"@server:*
sudo k3d cluster create mycluster --network "dm-jenkins-cpa-infra_my-net" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--tls-san=${ip_jenkins}"@server:*

##    3.2) configure access kubectl-cli on  k3d-mycluster-server-0 from jenkins ctr dckr
rm -r ./datas/data-k3d
mkdir -p ./datas/data-k3d
sudo docker exec -it k3d-mycluster-server-0 cat /etc/rancher/k3s/k3s.yaml >./datas/data-k3d/k3s.yaml
cat ./datas/data-k3d/k3s.yaml
#sed -i "s|server: https://127.0.0.1:6443|server: https://$ip_jenkins:6443|g" ./datas/data-k3d/k3s.yaml
# sed -i 's/'$ip_source'\b/'$ip_jenkins'/g' ./datas/data-k3d/k3s.yaml
# sed -E 's~(https?://)[^ :;]+(:?\d*)~\1'$ip_jenkins2'\2~' -i ./datas/data-k3d/k3s.yaml
sed -i 's+127.0.0.1+'$ip_k3s_srvr'+g' ./datas/data-k3d/k3s.yaml
cat ./datas/data-k3d/k3s.yaml
#sudo docker exec -it jenkins export KUBECONFIG=/datas/data-k3d/k3s.yaml
sudo docker cp ./datas/data-k3d/k3s.yaml jenkins:/datas/data-k3d/k3s.yaml


##    3.2)  You can check the nodes using
sudo kubectl get nodes
sudo docker exec -it jenkins kubectl get nodes

# 4.) Deploying Rancher
##    4.1) Cmd to deploy
sudo helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

##      4.2) Then install it using -
sudo helm install rancher rancher-latest/rancher \
   --namespace cattle-system \
   --create-namespace \
   --set ingress.enabled=false \
   --set tls=external \
   --set replicas=1
   
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

#    5.2) Then apply it using
sudo kubectl apply -f rancher.yaml




### 7.) Verification
#      6.1) Display all VM docker
sudo docker images
sudo docker volume ls -a
sudo docker ps -a


#      7.2) Display all nodes of the k3s cluster
sudo kubectl get nodes -o wide
sudo kubectl get all -A

#      7.3) Display the password rancher monitoring k3s cluster
#kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'

