Helm Chart for PostgreSQL

CircleCI License version test
T h i s   p r o j e c t   i s   n o t   m a i n t a i n e d   a n y m o r e .

If you are interested in maintaining a fork of this project, you can advertise it in the dedicated issue.
Introduction

This Helm chart installs postgreSQL in a Kubernetes cluster.
Prerequisites

    Kubernetes cluster 1.10+
    Helm 3.0.0+
    PV provisioner support in the underlying infrastructure.

Installation
Add Helm repository

helm repo add cetic https://cetic.github.io/helm-charts
helm repo update

Configure the chart

The following items can be set via --set flag during installation or configured by editing the values.yaml directly (need to download the chart first).
Configure the way how to expose postgreSQL service:

    ClusterIP: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster.
    NodePort: Exposes the service on each Node’s IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting NodeIP:NodePort.
    LoadBalancer: Exposes the service externally using a cloud provider’s load balancer.

Configure the way how to persistent data:

    Disable: The data does not survive the termination of a pod.
    Persistent Volume Claim(default): A default StorageClass is needed in the Kubernetes cluster to dynamic provision the volumes. Specify another StorageClass in the storageClass or set existingClaim if you have already existing persistent volumes to use.

How to use LDAP:

LDAP is used only to validate the user name/password pairs. Therefore the user must already exist in the database before LDAP can be used for authentication. If you enable ldap a CronJob will be activated, it will run the tool pg-ldap-sync that will copy users from your ldap server to your database.
Install the chart

Install the postgresql helm chart with a release name my-release:

helm install my-release cetic/postgresql

Uninstallation

To uninstall/delete the my-release deployment:

helm delete --purge my-release

Configuration

The following table lists the configurable parameters of the postgresql chart and the default values.
Parameter 	Description 	Default
Image 		
image.repository 	postgresql Image name 	postgres
image.tag 	postgresql Image tag 	11.5
image.pullPolicy 	postgresql Image pull policy 	IfNotPresent
image.pullSecret 	postgresql Image pull secret 	nil
postgresql properties 		
postgresql.username 	postgresql username 	postgres
postgresql.password 	postgresql password 	postgres
postgresql.database 	postgresql database 	postgres
postgresql.port 	postgresql port 	5432
postgresql.dataDir 	PostgreSQL data dir folder 	/var/lib/postgresql/data/pgdata
postgresql.config 	Runtime Config Parameters 	nil
postgresql.pghba 	Content of pg_hba.conf 	nil (do not create pg_hba.conf)
postgresql.initdbscripts 	Content of initdbscripts.sh ( commands to be executed at the start of postgres ) 	nil (do not create initdbscripts.sh)
postgresql.configMap 	ConfigMap with the PostgreSQL configuration files (Note: Overrides postgresqlConfiguration and pgHbaConfiguration). The value is evaluated as a template. 	nil
extraEnv 	Any extra environment variables you would like to pass on to the pod. The value is evaluated as a template. 	{}
Service 		
service.type 	Type of service for postgresql frontend 	CusterIP
service.loadBalancerIP 	LoadBalancerIP if service type is LoadBalancer 	nil
service.clusterIP 	ClusterIP if service type is ClusterIP 	nil
service.loadBalancerSourceRanges 	Address that are allowed when svc is LoadBalancer 	[]
service.annotations 	Service annotations 	{}
Volume Permissions 		
volumePermissions.image.registry 	Init container volume-permissions image registry 	docker.io
volumePermissions.image.repository 	Init container volume-permissions image name 	debian
volumePermissions.image.tag 	Init container volume-permissions image tag 	buster-slim
volumePermissions.image.pullPolicy 	Init container volume-permissions image pull policy 	Always
volumePermissions.securityContext.runAsUser 	User ID for the init container 	0
Security Context 		
securityContext.enabled 	Enable security context 	true
securityContext.fsGroup 	Group ID for the container 	1001
securityContext.runAsUser 	User ID for the container 	1001
LDAP 		
ldap.enabled 	Use ldap authentication 	false
ldap.pgldapconfig 	pgldap config file 	``
ldap.cron.schedule 	Cron job schedule 	""
ldap.cron.repo 	Cron job Docker image 	ceticasbl/pg-ldap-sync
ldap.cron.tag 	Cron job Docker image tag 	latest
ldap.cron.restartPolicy 	Restart policy of the cron job 	Never
ldap.cron.mountPath 	Path to mount the volume at 	``
ldap.cron.subPath 	Subdirectory of the volume to mount at 	``
Persistence 		
persistence.enabled 	Use persistent volume to store data 	false
persistence.mountPath 	Path to mount the volume at 	/var/lib/postgresql
persistence.subPath 	Subdirectory of the volume to mount at 	""
persistence.storageClass 	Storage class name of PVCs 	standard
persistence.accessMode 	ReadWriteOnce or ReadOnly 	[ReadWriteOnce]
persistence.size 	Size of persistent volume claim 	10Gi
ReadinessProbe 		
readinessProbe 	Rediness Probe settings 	nil
LivenessProbe 		
livenessProbe 	Liveness Probe settings 	nil
Resources 		
resources 	Pod resource requests and limits for logs 	{}
nodeSelector 		
nodeSelector 	Node labels for pod assignment 	{}
tolerations 		
tolerations 	Tolerations for pod assignment 	[]
priorityClass 		
priorityClassName 	PriorityClassName for pod assignment 	nil
Why this PostgreSQL Helm Chart?

    use postgres official Docker Image.
    needed LDAP support for the FADI project.
    use this Chart for other architecture (ARM, ...).
    ...

Contributing

Feel free to contribute by making a pull request.

Please read the official Contribution Guide from Helm for more information on how you can contribute to this Chart.
License

Apache License 2.0