#!/bin/bash
#################################################################################################################################
# URL script : /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/init-vm-proxmox.sh
# This script dcvonfigure the 2 vm proxmox based on debian 12 with :
###                 1) for the jenkins server :  (docker, helm, k3d) and 2 users root and cpa
###                 2) for the k3d server :  (docker, helm, k3d) and 2 users root and cpa
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
## 202505.15.1900 : Creation of script
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
###############################
################################################################


################################################################
## 2.) Connect to VMs proxmox jenkins and k3d servers
###############################


url_id_rsa="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-  C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa"
url_id_rsa_cpa="/home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/.ssh/vm-pve-alpine-0001/id_rsa_cpa"
ip_jenkins="192.168.1.82"
ip_k3d="192.168.1.83"

### 2.2) Access from host PC on vm-114-111-dmj-jenkins
gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa root@$ip_jenkins"
#gnome-terminal --tab --name="jenkins" --command "ssh -i $url_id_rsa_cpa cpa@$ip_jenkins"
###############

###############################
### 2.3) Access from host PC on vm-115-113-dmj-k3d
#gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa root@$ip_k3d"
gnome-terminal --tab --name="k3d" --command "ssh -i $url_id_rsa_cpa cpa@$ip_k3d"
###############
###############################
################################################################


################################################################
## 3) Configure vm-114 to add cpa user on the group sudo
###############

###############################
### 3.1) Install paquet sudo Debian 12 on the 2 vm,
ssh -i $url_id_rsa root@$ip_jenkins "apt update && apt install -y sudo"
ssh -i $url_id_rsa root@$ip_k3d "apt update && apt install -y sudo"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_jenkins "sudo --version"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d "sudo --version"
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.2) Add a user to the sudo group in Debian 12,
ssh -i $url_id_rsa root@$ip_jenkins usermod -aG sudo cpa
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d usermod -aG sudo cpa
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.3) Verify that they have been added to the sudo group by using the groups command:
ssh -i $url_id_rsa root@$ip_jenkins groups cpa
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d groups cpa
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.4) Read the /etc/sudoers file using the visudo command, which ensures that you do not make syntax errors that can lock you out of the system. Add the following line below the root ALL=(ALL:ALL) ALL line: username ALL=(ALL) ALL
ssh -i $url_id_rsa root@$ip_jenkins "cat /etc/sudoers"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d "cat /etc/sudoers"
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.5) Edit edit the /etc/sudoers file using the visudo command, which ensures that you do not make syntax errors that can lock you out of the system. Add the following line below the root ALL=(ALL:ALL) ALL line: username ALL=(ALL) ALL
ssh -i $url_id_rsa root@$ip_jenkins "echo 'cpa ALL=(ALL) ALL' >> /etc/sudoers"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d "echo 'cpa ALL=(ALL) ALL' >> /etc/sudoers"
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.6) Read the /etc/sudoers file using the visudo command, which ensures that you do not make syntax errors that can lock you out of the system. Add the following line below the root ALL=(ALL:ALL) ALL line: username ALL=(ALL) ALL
ssh -i $url_id_rsa root@$ip_jenkins "cat /etc/sudoers"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d "cat /etc/sudoers"
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.7) Verify that they have been added to the sudo group by using the groups command:
ssh -t -i $url_id_rsa_cpa cpa@$ip_jenkins "sudo apt update"
echo "########################################################"
echo "########################################################"
ssh -t -i $url_id_rsa_cpa cpa@$ip_k3d "sudo apt update"
echo "########################################################"
echo "########################################################"
###############

###############################
### 3.8) Verify which groups is linked cpa user
ssh -i $url_id_rsa root@$ip_jenkins id cpa
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d id cpa
echo "########################################################"
echo "########################################################"
###############
###############################


################################################################
## 4.) Installing the binaries kubectl , k3d and helm
###       B33-k3d-Rancher-supervision-Playing with Kubernetes using k3d and Rancher | by Prakhar Malviya | 47Billion | Medium:
####         https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23
###############

###############################
###     4.1) install docker
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_jenkins curl -fsSL https://get.docker.com -o get-docker.sh
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d curl -fsSL https://get.docker.com -o get-docker.sh
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_jenkins sh get-docker.sh
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d sh get-docker.sh
echo "########################################################"
echo "########################################################"
###############

###############################
###      4.2) install kubectl
####            B44-1) K8s Documentation / Tasks / Install Tools / Install and Set Up kubectl on Linux / Install and Set Up kubectl on Linux
#####                  https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/Install kubectl binary with curl on Linux
##########

####################
#####          4.2.1) Download the latest release with the command:
ssh -i $url_id_rsa root@$ip_jenkins curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo "########################################################"
echo "########################################################"
##########

####################
####          4.2.2) Validate the binary (optional)
#####                4.2.2.1) Download the kubectl checksum file:
ssh -i $url_id_rsa root@$ip_jenkins curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "########################################################"
echo "########################################################"
##########

####################
######                4.2.2.2) Validate the kubectl binary against the checksum file:
ssh -i $url_id_rsa root@$ip_jenkins 'echo "$(cat /root/kubectl.sha256)  kubectl" | sha256sum --check'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d  'echo "$(cat /root/kubectl.sha256)  kubectl" | sha256sum --check'
echo "########################################################"
echo "########################################################"
##########
#######                       If valid, the output is:
####### =>  kubectl: OK/Réussi

#######                       If the check fails, sha256 exits with nonzero status and prints output similar to:
####### => kubectl: FAILED
####### => sha256sum: WARNING: 1 computed checksum did NOT match
##########

####################
######               4.2.2.3) Install kubectl
ssh -i $url_id_rsa root@$ip_jenkins 'install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d  'install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl'
echo "########################################################"
echo "########################################################"
##########

####################
######               4.2.2.4) Test 1 to ensure the version you installed is up-to-date:
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl version --client'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d  'kubectl version --client'
echo "########################################################"
echo "########################################################"
##########

####################
######              4.2.2..5) Test 1 to ensure the version you installed is up-to-date:
ssh -i $url_id_rsa root@$ip_jenkins 'kubectl version --client --output=yaml'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d  'kubectl version --client --output=yaml'
echo "########################################################"
echo "########################################################"
##########

####################
######              4.2.2.6)  Delete file imported and unusefull
ssh -i $url_id_rsa root@$ip_jenkins 'cd /root && rm kubectl kubectl.sha256 && ls -lha'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'cd /root && rm kubectl kubectl.sha256 && ls -lha'
echo "########################################################"
echo "########################################################"
##########
####################


########################################
###      4.3) install helm (this one takes some time)
####            B44-2+3) Installing Helm From the Binary Releases
#####                      https://helm.sh/docs/intro/install/
##########
####################
#####          4.3.1)  Download and install release version with one cmd
######                  curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# ssh -i $url_id_rsa root@$ip_jenkins 'curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash'
echo "########################################################"
echo "########################################################"
# ssh -i $url_id_rsa root@$ip_k3d 'curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.3.2) Download release version
######                 curl -LO https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz
ssh -i $url_id_rsa root@$ip_jenkins 'curl -LO https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'curl -LO https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.3.3) Validate the binary (optional)
##########
####################
######                4.3.3.1) Download the kubectl checksum file:
######                 curl -LO "https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz.sha256sum"
ssh -i $url_id_rsa root@$ip_jenkins 'curl -LO "https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz.sha256sum"'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'curl -LO "https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz.sha256sum"'
echo "########################################################"
echo "########################################################"
##########

####################
######                4.3.3.2) Validate the kubectl binary against the checksum file:
######                 echo "$(cat helm-v3.17.3-linux-amd64.tar.gz.sha256sum)" | sha256sum --check
ssh -i $url_id_rsa root@$ip_jenkins 'echo "$(cat helm-v3.17.3-linux-amd64.tar.gz.sha256sum)" | sha256sum --check'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'echo "$(cat helm-v3.17.3-linux-amd64.tar.gz.sha256sum)" | sha256sum --check'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.3.4)  Unpack it (tar -zxvf helm-v3.0.0-linux-amd64.tar.gz)
######                 tar -zxvf helm-v3.17.3-linux-amd64.tar.gz
ssh -i $url_id_rsa root@$ip_jenkins 'tar -zxvf helm-v3.17.3-linux-amd64.tar.gz'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'tar -zxvf helm-v3.17.3-linux-amd64.tar.gz'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.3.5) Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)
######                 sudo mv linux-amd64/helm /usr/local/bin/helm
ssh -i $url_id_rsa root@$ip_jenkins 'mv /root/linux-amd64/helm /usr/local/bin/helm'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'mv /root/linux-amd64/helm /usr/local/bin/helm'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.3.6) Test 1 to ensure the version you installed is up-to-date:
######                 sudo helm version
##### => version.BuildInfo{Version:"v3.17.3", GitCommit:"e4da49785aa6e6ee2b86efd5dd9e43400318262b", GitTreeState:"clean", GoVersion:"go1.23.7"}
ssh -i $url_id_rsa root@$ip_jenkins 'helm version'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'helm version'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.3.7) Delete file imported and unusefull
######                 sudo rm helm-v3.17.3-linux-amd64.tar.gz helm-v3.17.3-linux-amd64.tar.gz.sha256sum
ssh -i $url_id_rsa root@$ip_jenkins 'cd /root && rm helm-v3.17.3-linux-amd64.tar.gz helm-v3.17.3-linux-amd64.tar.gz.sha256sum && ls -lha'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'cd /root && rm helm-v3.17.3-linux-amd64.tar.gz helm-v3.17.3-linux-amd64.tar.gz.sha256sum && ls -lha'
echo "########################################################"
echo "########################################################"
##########
####################


########################################
###      4.4) Install git
####            Git-B04) Install Git on Debian 12
#####                      https://search.brave.com/search?q=install+git+on+debian+12&source=desktop&summary=1&conversation=48aff895b685edb96eb546
##########
####################
#####          4.4.1)  To install Git on Debian 12, you can use the APT package manager. First, update your system to ensure you have the latest package lists and dependencies:
######                 sudo apt-get update && sudo apt-get upgrade -y
ssh -i $url_id_rsa root@$ip_jenkins 'apt-get update && sudo apt-get upgrade -y'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'apt-get update && sudo apt-get upgrade -y'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.4.2) After updating, install Git with the following command:
######                 sudo apt install git
ssh -i $url_id_rsa root@$ip_jenkins 'apt install git'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'apt install git'
echo "########################################################"
echo "########################################################"
##########

####################
#####          4.4.3) To verify that Git has been successfully installed, check its version with:
######                 git --version
ssh -i $url_id_rsa root@$ip_jenkins 'git --version'
echo "########################################################"
echo "########################################################"
ssh -i $url_id_rsa root@$ip_k3d 'git --version'
echo "########################################################"
echo "########################################################"
##########
##########
####################
########################################


################################################################
## 5.) Installing k3d on the vml k3d
###       B33-k3d-Rancher-supervision-Playing with Kubernetes using k3d and Rancher | by Prakhar Malviya | 47Billion | Medium:
####         https://medium.com/47billion/playing-with-kubernetes-using-k3d-and-rancher-78126d341d23
###############
###      5.1) install k3d
####          B44-4+5) Installing Helm From the Binary Releases
#####                  B44-4) What is k3d?¶ : https://k3d.io/stable/#requirements
#####                  B44-5) Github Download Release latest version : https://github.com/k3d-io/k3d/releases
##########

####################
#####          5.1.1) Download and install release version with one cmd
######                   curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
# ssh -i $url_id_rsa root@$ip_k3d 'curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash'
echo "########################################################"
echo "########################################################"
##########

####################
#####          5.1.2)  Download release version
######                   curl -LO "https://github.com/k3d-io/k3d/releases/download/v5.8.3/k3d-linux-amd64"
ssh -i $url_id_rsa root@$ip_k3d 'curl -LO "https://github.com/k3d-io/k3d/releases/download/v5.8.3/k3d-linux-amd64"'
echo "########################################################"
echo "########################################################"
##########

####################
#####          5.1.3)  Validate the binary (optional)
##########
####################
######                5.1.3.1) Download the kubectl checksum file:
######                   curl -LO "https://github.com/k3d-io/k3d/releases/download/v5.8.3/checksums.txt"
ssh -i $url_id_rsa root@$ip_k3d 'curl -LO "https://github.com/k3d-io/k3d/releases/download/v5.8.3/checksums.txt"'
echo "########################################################"
echo "########################################################"
##########

####################
######                5.1.3.2) Validate the kubectl binary against the checksum file:
######                   echo "$(cat checksums.txt | grep k3d-linux-amd | awk '{ print $1 }') k3d-linux-amd64" | sha256sum --check
###### => k3d-linux-amd64: Réussi
var=$(ssh -i $url_id_rsa root@$ip_k3d echo "\$(cat /root/checksums.txt | grep k3d-linux-amd | awk '{ print $1 }')")
ssh -i $url_id_rsa root@$ip_k3d echo "$(echo $var | awk '{ print $1 }') k3d-linux-amd64" |  sha256sum --check
echo "########################################################"
echo "########################################################"
##########

####################
#####          5.1.4)  Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)
######                   sudo mv k3d-linux-amd64 /usr/local/bin/k3d
######                   sudo chmod 744 /usr/local/bin/k3d
######                   ls -lha /usr/local/bin/k3d
ssh -i $url_id_rsa root@$ip_k3d 'mv k3d-linux-amd64 /usr/local/bin/k3d && chmod 744 /usr/local/bin/k3d && ls -lha /usr/local/bin/k3d'
##### => -rwx------ 1 cpa cpa 24M 17 avril 17:29 /usr/local/bin/k3d
##########

####################
#####          5.1.5)  Test 1 to ensure the version you installed is up-to-date:
######                   sudo k3d version
###### cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins3$ sudo k3d --version
####### => k3d version v5.8.3
####### => k3s version v1.31.5-k3s1 (default)
ssh -i $url_id_rsa root@$ip_k3d 'k3d version'
##########

####################
#####          5.1.6)  Delete file imported and unusefull
######                   sudo rm checksums.txt
ssh -i $url_id_rsa root@$ip_k3d 'rm checksums.txt && ls -lha'
##########
################################################################


################################################################
