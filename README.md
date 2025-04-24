# dm-ds-cdo-may24-jenkins

## Prequies

### Step 1)  Create a directory for the homework
  3.1) mkdir -p DM-SP04-C04-JENKINS-CPA-MAY2024
  3.2) cd   ./DM-SP04-C04-JENKINS-CPA-MAY2024
  
### Step 2) Create Github account and a repository for homework
  1.1) Url  repo github of homework : https://github.com/cpa8876/ 
  1.2) Url to clone this repo  : 
git clone https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git 
  1.3) sshgen a pair of ssh keys to connect to the Github account and save this pair on the ./.ssh/ssh-key-github-cpa8876 and ssh-key-github-cpa8876.pub

### Step 3) Create Dockerhub account
   2.1) docker push dmcpa8876/dm-jenkins-cpa8876-fastapi:tagname
https://hub.docker.com/repositories/dmcpa8876 

### Step 4) Clone repo github jenkins datascientest homeworks
  4.1) git  clone https://github.com/DataScientest/Jenkins_devops_exams.git

### Step 5) Clone personnal Github repo for homework
  5.1)   ssh-add ../.ssh/ssh-key-github-cpa8876'''
  5.2) cd ./DM-SP04-C04-JENKINS-CPA-MAY2024$ 
  5.3) git clone https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git 
  5.4) '''ls   -lha
total 20K
drwxr-xr-x  5 cpa cpa 4,0K 24 avril 16:05 .
drwxr-xr-x 16 cpa cpa 4,0K 24 avril 16:04 ..
drwxr-xr-x  7 cpa cpa 4,0K 24 avril 16:06 dm-ds-cdo-may24-jenkins
drwxr-xr-x  6 cpa cpa 4,0K 15 avril 23:24 Jenkins_devops_exams
drwxr-xr-x  5 cpa cpa 4,0K 25 mars  22:00 .ssh'''

####  Step 6)  Create the first version of README.md to test Github cpa8876/dm-ds-cdo-may24-jenkins
 

####  Step 7)  Delete all docker containers and images 
'''sudo docker compose down

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
sudo docker ps -a'''


Git clone https://github.com/paurakhsharma/python-m
cd /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/
icroservice-fastapi.git 
### dispose a ssh access to Dockerhup cpa8876/
'''cpa@debiana8:~/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins6$
