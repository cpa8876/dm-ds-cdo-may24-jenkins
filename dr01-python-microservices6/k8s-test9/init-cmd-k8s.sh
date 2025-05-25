ssh -i $url_id_rsa root@$ip_jenkins 'rm -r /app/fastapiapp'

scp -r -i $url_id_rsa /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/dr01-python-microservices6/k8s-test9/ root@$ip_jenkins:/app/fastapiapp


ssh -i $url_id_rsa root@$ip_jenkins 'ls -lha /app/fastapiapp'

ssh -i $url_id_rsa root@$ip_jenkins 'kubectl  --kubeconfig /usr/local/k3s.yaml apply -f /app/fastapiapp/cast-fastapi.yaml'

ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml delete ns dev'


ssh -i $url_id_rsa root@$ip_jenkins 'kubectl --kubeconfig /usr/local/k3s.yaml get pods -o wide'

# On k3d servezr : kubectl exec -it fastapi-65bbcd8b65-74glr -- /bin/bash
kubectl exec -it fastapi-65bbcd8b65-74glr -- /bin/bash

# psql -h localhost -p 5432 -U cast_db_cpa_username -d cast_db_cpa -c "select * from pg_database"

echo -n "fastapi_user" | base64
# => ZmFzdGFwaV91c2Vy

echo -n "ZmFzdGFwaV91c2Vy" | base64 -d
# => fastapi_user

 echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d
fastapi_passwd

cho -n "ZmFzdGFwaV9kYg==" | base64 -d
fastapi_db
psql -h localhost -p 5432 -U fastapi_user -d fastapi_db -c "select * from pg_database"
#### root@postgres-765b745db6-qjxzr:/# psql -h localhost -p 5432 -U fastapi_user -d fastapi_db
#### => psql (17.5 (Debian 17.5-1.pgdg120+1))
#### => Type "help" for help.
####
#### fastapi_db=# \q
#### => root@postgres-765b745db6-qjxzr:/#




echo -n "cG9zdGdyZXNxbDovL2Zhc3RhcGlfdXNlcjpmYXN0YXBpX3Bhc3N3ZEBwb3N0Z3Jlcy1zZXJ2aWNlOjU0MzIvZmFzdGFwaV9kYg==" | base64 -d
#=> DATABASE_URL=postgresql://fastapi_user:fastapi_passwd@postgres-service:5432/fastapi_db

# DevOps Project — Part 3; Dergham Lahcene; Dergham Lahcene; Follow 6 min read; Feb 20, 2023 :
## https://medium.com/@l.dergham/devops-project-part-3-9e4eb8bfa291
### Start the application
#### CMD ["uvicorn", "--host", "0.0.0.0", "--port", "5000", "main:app"]
##### I have no name!@fastapi-65bbcd8b65-74glr:/app
######  $ uvicorn main:app --host 0.0.0.0 --port 5000

#### docker run -p 5000:5000 your-image-name
curl -k http://localhost:5000/

kubectl get pods -o wide
kubectl get nodes -o wide


# On k3d - postgresql ctnr dockerroot@debian-pve:~#
kubectl exec -it postgres-765b745db6-qjxzr  -- /bin/bash
root@postgres-765b745db6-qjxzr:/#
####################################
# DM-Jenkins-B93) Kubernetes; Kubernetes Ingress with NGINX Ingress Controller Example; Flavius Dinu, Jack Roper; Updated 04 Sep 2024; 14 min read
## https://spacelift.io/blog/kubernetes-ingress

### Setting up Ingress with NGINX - step by step

#### 1.) Connect to the k8s cluster
##### using the kubectl CLI

#### 2.) Install the NGINX Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml
##### Note you can also use Helm to install if you have it installed (you don’t need to run this if you have already installed using the previous command):
###### helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

#### 3.) Check the Ingress controller pod is running
#####To check if the Ingress controller pod is running correctly, use the following command:

kubectl get pods --namespace ingress-nginx
#### root@debian-pve:~# kubectl get pods --namespace ingress-nginx
#### => NAME                                        READY   STATUS      RESTARTS   AGE
#### => ingress-nginx-admission-create-qqrm9        0/1     Completed   0          4m1s
#### => ingress-nginx-admission-patch-gh5wj         0/1     Completed   2          4m1s
#### => ingress-nginx-controller-56ff6b49cf-ws24p   1/1     Running     0          4m1s
#### => root@debian-pve:~#

#### 4.) Check the NGINX Ingress controller has been assigned a public IP address
##### The command below will let you check if the NGINX Ingress controller has a public IP address already assigned to it.
kubectl get service ingress-nginx-controller --namespace=ingress-nginx

#### 4.2) Consult log
 kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
#### root@debian-pve:~# kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
#### => I0518 19:33:25.468317       7 controller.go:195] "Initial sync, sleeping for 1 second"
#### => I0518 19:33:25.468393       7 event.go:285] Event(v1.ObjectReference{Kind:"Pod", Namespace:"ingress-nginx", Name:"ingress-nginx-controller-56ff6b49cf-ws24p", UID:"5073d902-5a2b-4ff4-8e4c-127d87a20ee5", APIVersion:"v1", ResourceVersion:"76114", FieldPath:""}): type: 'Normal' reason: 'RELOAD' NGINX reload triggered due to a change in configuration
kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec": {"type": "NodePort"}}'

kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml
#### => root@debian-pve:~# kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml

kubectl delete ns ingress-nginx
#### => root@debian-pve:~# kubectl delete ns ingress-nginx


# DM-Jenkins-B93-03) kubectl restart service
## https://search.brave.com/search?q=kubectl+restart+service&source=desktop&summary=1&conversation=f41d3bf3524f6108f43ec0
### There is no direct kubectl restart service command in Kubernetes. Services in Kubernetes are not directly restartable because they are not the smallest units of deployment. Instead, services manage endpoints, which are typically managed by pods. To effectively "restart" a service, you would need to restart the pods that the service manages. Here are several methods to achieve this:
###
### Rolling Restart: Use kubectl rollout restart deployment <deployment_name> to perform a rolling restart of pods managed by a deployment. This method ensures zero downtime as Kubernetes gradually replaces old pods with new ones.
kubectl rollout restart deployment <deployment_name>
### Scaling Down and Up: Scale the deployment down to zero replicas and then scale it back up to the desired number. This forces Kubernetes to recreate all pods:
kubectl scale deployment <deployment_name> --replicas=0
kubectl scale deployment <deployment_name> --replicas=<desired_number>
### Update Environment Variables: Modify an environment variable in the deployment's pod template, causing Kubernetes to create new pods with the updated configuration:
kubectl set env deployment/<deployment_name> RESTART_DATE="$(date)"
### Force Delete Pods: Delete a specific pod to force Kubernetes to recreate it:
kubectl delete pod <pod_name>
### Forcing a new image pull or resolving resource contention issues may also require restarting pods. Always ensure you have the necessary access and tools to interact with the Kubernetes cluster before attempting these operations.

#### 5. Set up a basic web app for testing
#### kubectl create ingress demo --class=nginx --rule [DNS_NAME]/=demo:80
kubectl create ingress demo --class=nginx --rule www.k3dcpa.io/=demo:80
#### root@debian-pve:~# kubectl create ingress demo --class=nginx --rule www.k3dcpa.io/=demo:80
#### => ingress.networking.k8s.io/demo created

#### 5.2) k3d cluster delete -a
k3d cluster delete -a


########################################################################
