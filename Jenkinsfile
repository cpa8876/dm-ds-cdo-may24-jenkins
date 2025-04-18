  //# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/DM-SP04-C04-JENKINS-CPA-MAY2024/dm-ds-cdo-may24-jenkins/Jenkinsfile
pipeline {
  environment { // Declaration of environment variables
    DOCKER_ID = "cpa8876" // replace this with your docker-id
    DOCKER_IMAGE = "ds-fastapi"
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
            docker build -t $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG .
            sleep 6
          '''
        }
      }
    }

    stage('Docker run'){ // run container from our builded image
      steps {
        script {
          sh '''
            docker run --network=dm-jenkins-cpa-infra_my-net -d -p 80:80 --name my-ctnr-ds-fastapi $DOCKER_ID/$DOCKER_IMAGE:$DOCKER_TAG
            sleep 10
          '''
        }
      }
    }

    stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
      steps {
        script {//curl localhost or curl 127.0.0.1:8480 "curl -svo /dev/null http://localhost" or docker exec -it my-ctnr-ds-fastapi curl localhost
          sh '''
            curl my-ctnr-ds-fastapi
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
          sh '''
            rm -Rf .kube
            mkdir .kube
            ls
            cat $KUBECONFIG > .kube/config
            cp fastapi/values.yaml values.yml
            cat values.yml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
            helm upgrade --install app fastapi --values=values.yml --namespace dev
          '''
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
            cp fastapi/values.yaml values.yml
            cat values.yml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
            helm upgrade --install app fastapi --values=values.yml --namespace staging
          '''
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
            cp fastapi/values.yaml values.yml
            cat values.yml
            sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
            helm upgrade --install app fastapi --values=values.yml --namespace prod
          '''
        }
      }
    }
  }
  post { // send email when the job has failed
  // ..
    failure {
      echo "This will run if the job failed"
      mail to: "fall-lewis.y@datascientest.com",
        subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
        body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    }
  // ..
  }
}
