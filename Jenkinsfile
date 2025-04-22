  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  environment { // Declaration of environment variables
    DOCKER_ID = "cpa8876" // replace this with your docker-id
    DOCKER_IMAGE = "ds-fastapi"
    DOCKER_IMAGE1 = "movie-ds-fastapi"
    DOCKER_IMAGE2 = "casts-ds-fastapi"
    DOCKER_TAG = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build
    //DOCKER_TAG="latest"
}
  agent any // Jenkins will be able to select all available agents
  stages {
    stage('Docker Build'){ // docker build image stage
      steps {
        script {
          sh '''
            docker rm -f my-ctnr-ds-fastapi
            docker network rm dm-jenkins-cpa-infra_my-net
            docker network create dm-jenkins-cpa-infra_my-net
            docker build -t $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG .
            sleep 6
          '''
        }
      }
    }
// sudo docker network create dm-jenkins-cpa-infra_my-net
// sudo docker network ls
// ssh-add /home/cpa/Documents/.ssh/ssh-key-github-cpa8876
    stage('Docker run'){ // run container from our builded image
      steps {
        script {
          sh '''
            docker run --network=dm-jenkins-cpa-infra_my-net -d -p 8800:8000 --name my-ctnr-ds-fastapi $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
            sleep 10
          '''
        }
      }
    }

    stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
      steps {
        script {//curl localhost or curl 127.0.0.1:8480 "curl -svo /dev/null http://localhost" or docker exec -it my-ctnr-ds-fastapi curl localhost
          sh '''
            apt update -y && apt full-upgrade-y && apt install curl -y
            curl my-ctnr-ds-fastapi:8000/api/v1/checkapi
          '''
        }
      }
    }

    stage('Docker Push'){ //we pass the built image to our docker hub account
      environment
        {
          DOCKER_PASS = credentials("DOCKER_HUB_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
        }
      steps {
        script {
          sh '''
            docker login -u $DOCKER_ID -p $DOCKER_PASS
            docker push $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
          '''
        }
      }
    }

    stage('Deploiement en dev'){
      environment {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
      }
      steps {
        script {
          // withKubeConfig(caCertificate: '', clusterName: 'k3d-mycluster', contextName: 'k3d-mycluster', credentialsId: 'k8s-jenkins-secret', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://0.0.0.0:41521') {
    // some block
                // helm upgrade --install app fastapi --values=values.yml --namespace dev
                // cf B52 helm --kubeconfig : https://helm.sh/docs/helm/helm/
          sh '''
            rm -Rf .kube
            mkdir .kube
            ls
            cat $KUBECONFIG > .kube/config
            cp /fastapi/values-dev.yaml /fastapiapp/values.yaml
            cat /fastapiapp/values.yaml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml

            helm upgrade --kubeconfig /usr/local/k3s.yaml --install fastapi-dev /fastapiapp --namespace dev --create-namespace
          '''
          // kubectl --kubeconfig /usr/local/k3s.yaml delete namespace dev
        //}
        }
      }
    }

    stage('Deploiement en staging'){
      environment {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
      }
      steps {
        script {
          sh '''
            rm -Rf .kube
            mkdir .kube
            ls
            cat $KUBECONFIG > .kube/config
            cp /fastapi/values-staging.yaml /fastapiapp/values.yaml
            cat /fastapiapp/values.yaml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml

            helm upgrade --kubeconfig /usr/local/k3s.yaml --install fastapi-staging /fastapiapp --namespace staging --create-namespace
          '''
          //kubectl --kubeconfig /usr/local/k3s.yaml delete namespace staging
        }
      }
    }

    stage('Deploiement en prod'){
      environment {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
      }
      steps {
      // Create an Approval Button with a timeout of 15minutes.
      // this require a manuel validation in order to deploy on production environment
        timeout(time: 15, unit: "MINUTES") {
        input message: 'Do you want to deploy in production ?', ok: 'Yes'
      }

        script {
          sh '''
            rm -Rf .kube
            mkdir .kube
            ls
            cat $KUBECONFIG > .kube/config
            cp /fastapi/values-prod.yaml /fastapiapp/values.yaml
            cat /fastapiapp/values.yaml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
            helm upgrade --kubeconfig /usr/local/k3s.yaml --install fastapi-prod /fastapiapp --namespace prod --create-namespace
          '''
          //kubectl --kubeconfig /usr/local/k3s.yaml delete namespace prod
        }
      }
    }
  }
  post { // send email when the job has failed
  // ..
    failure {
      echo "This will run if the job failed"
      mail to: "cristofe.pascale@gmail.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
        body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    }
  // ..
  }
}
