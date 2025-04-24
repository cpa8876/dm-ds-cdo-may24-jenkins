# dm-ds-cdo-may24-jenkins

## Prequies

### Step 1)  Create a directory for the homework
  1.1) `mkdir -p DM-SP04-C04-JENKINS-CPA-MAY2024`
  
  1.2)  `cd   ./DM-SP04-C04-JENKINS-CPA-MAY2024`
  
### Step 2) Create Github account and a repository for homework
  2.1) Url  repo github of homework : https://github.com/cpa8876/ 
  
  2.2) Url to clone this repo  : 
  
`git clone https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git`

  2.3) sshgen a pair of ssh keys to connect to the Github account and save this pair on the ./.ssh/ssh-key-github-cpa8876 and ssh-key-github-cpa8876.pub`

### Step 3) Create Dockerhub account
   3.1) ` docker push dmcpa8876/dm-jenkins-cpa8876-fastapi:tagname
https://hub.docker.com/repositories/dmcpa8876 `

### Step 4) Clone repo github jenkins datascientest homeworks
  4.1) `git  clone https://github.com/DataScientest/Jenkins_devops_exams.git`

### Step 5) Clone personnal Github repo for homework
  5.1)   `ssh-add ../.ssh/ssh-key-github-cpa8876`
  
  5.2) `cd ./DM-SP04-C04-JENKINS-CPA-MAY2024`
  
  5.3) `git clone https://github.com/cpa8876/dm-ds-cdo-may24-jenkins.git` 
  
  5.4)   `ls      -lha`
  
 ````md
total  20K
drwxr-xr-x  5 cpa cpa 4,0K 24 avril 16:05 .
drwxr-xr-x 16 cpa cpa 4,0K 24 avril 16:04 ..
drwxr-xr-x  7 cpa cpa 4,0K 24 avril 16:06 dm-ds-cdo-may24-jenkins
drwxr-xr-x  6 cpa cpa 4,0K 15 avril 23:24 Jenkins_devops_exams
drwxr-xr-x  5 cpa cpa 4,0K 25 mars  22:00 .ssh
```

####  Step 6)  Create the first version of README.md to test Github cpa8876/dm-ds-cdo-may24-jenkins
 `git  status  `
 
 `git  add README.md `

 `git commit -m "Create README to explain architecture of my homework Jenkins version  1" `
 
 `git push origin main `


####  Step 7)  Delete all docker containers and images 
 ````md
sudo  docker compose down

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
 ```
