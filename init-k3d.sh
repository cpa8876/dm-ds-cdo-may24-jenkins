#!/bin/bash
# URL script : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/Jenkins_devops_exams/init-k3d.sh
# This script create a cluster of 1 one master ands two workers of a cluster k3s

### BIBLIO
# B33) Playing with Kubernetes using k3d and Rancher ; Prakhar Malviya ; 47Billion ; Prakhar Malviya ;Published in May 28, 2022
#   • https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23 

### VERSIONS
# 20250413.1530 : Creation of script


### BEGIN OF SCRIPT
#
### 0.) Erase all vm dckr 
sudo docker compose down

sudo docker ps -a
sudo docker rm -f $(sudo docker ps -aq)

sudo docker images
sudo docker image rmi -f $(sudo docker images -q) 

sudo docker volume ls
sudo docker volume rm -f $(sudo docker volume ls -q) 

sudo docker volume ls
sudo docker images
sudo docker ps -a



### 1.) Installing the binaries
#      1.1.) install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#      1.2) install helm (this one takes some time)
curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

#      1.3) install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

### 2.) Creating the cluster : one master and 2 workers k3S
#         2.1) This will create a cluster named “mycluster” with 3 ports exposed 30080, 30081 and 30082. 
#These ports will map to ports 8900, 8901 and 8902 of your localhost respectively. 
# The cluster will have 1 master node and 2 worker nodes. You can adjust these settings using the p and the agent flags as you wish.
sudo k3d cluster create mycluster -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2

#         2.2)  You can check the nodes using
sudo kubectl get nodes

### 3.) Deploying Rancher
#      3.1) Cmd to deploy
sudo helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

#      3.2) Then install it using -
sudo helm install rancher rancher-latest/rancher \
   --namespace cattle-system \
   --create-namespace \
   --set ingress.enabled=false \
   --set tls=external \
   --set replicas=1
   
### 4. Creating the nodeport
#     4.1) Create a file called rancher.yaml -
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

#    4.2) Then apply it using 
sudo kubectl apply -f rancher.yaml


### 5) Deploy docker compose jenkins server
sudo docker compose up -d 


### 6.) Verification 
#      6.1) Display all VM docker
sudo docker images
sudo docker volume ls -a
sudo docker ps -a


#      6.2) Display all nodes of the k3s cluster 
sudo kubectl get nodes -o wide 
sudo kubectl get all -A 

#      6.3) Display the password rancher monitoring k3s cluster
#sudo kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'

