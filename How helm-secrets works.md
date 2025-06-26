#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
## How helm-secrets works
### https://securityboulevard.com/2023/10/how-to-handle-secrets-in-helm/
### 
### How helm-secrets works
### OK, now the long version.
### 
### Helm-secrets is a Helm plugin that manages secrets.
### 
### What's a Helm plugin, then? Good question.
### 
### Helm plugins are extensions that add additional functionalities and capabilities to Helm. These can be new commands, features, or integrations. Plugins can be used to perform various tasks, such as managing secrets, encrypting values, validating charts, etc. To use a Helm plugin, we typically install it using the helm plugin install command, and then we can invoke the plugin's commands just like any other native Helm command.
### 
### With helm-secrets, the values can be stored encrypted in Helm charts. However, the plugin does not handle the encryption/decryption operations itself; it offloads and delegates the cryptographic work to another tool: SOPS
### 
### SOPS, short for Secrets OPerationS, is an open-source text file editor by Mozilla that encrypts/decrypts files automatically. With SOPS, when we write a file, SOPS automatically encrypts the file before saving it to the disk. For that, it uses the encryption key of our choice: this can be a PGP key, an AWS KMS key, or many others. To learn more about SOPS and its possible integrations with different encryption key service providers, read my other blog here:
### 
### A Comprehensive Guide to SOPS: Managing Your Secrets Like A Visionary, Not a Functionary
### Have you heard about SOPS? If you have already been in a situation where you needed to share sensitive information with your teammates, this is for you.
### How to Handle Secrets in HelmGitGuardian Blog – Automated Secrets DetectionGuest Expert
### How to Handle Secrets in Helm
### 
### helm-secrets can also work in a "cloud" mode, where secrets are not stored in the Helm chart, but in a cloud secret manager. We then simply refer to the path of the secret in the cloud in the file, and the secret is automatically injected upon invoking helm install.
### 
### Example 1: Helm-secrets with SOPS
### In this example, we will store encrypted secrets in the Helm charts. Since this relies on SOPS, we first need to install it. The easiest way to install SOPS is via brew:
### 
### brew install sops
### For other OS users, refer to the official GitHub repo of SOPS.
### 
### Then, let's configure SOPS to use PGP keys for encryption:
### 
### brew install gnupg
### If you are using another OS, for example, Linux, you can use the corresponding package manager. Most likely, this would work:
### 
### sudo apt-get install gnupg
### 
### With GnuPG, Creating a key is as simple as the following (remember to put your name as the value of KEY_NAME):
### 
### export KEY_NAME="Tiexin Guo"
### export KEY_COMMENT="test key for sops"
### 
### gpg --batch --full-generate-key <<EOF
### %no-protection
### Key-Type: 1
### Key-Length: 4096
### Subkey-Type: 1
### Subkey-Length: 4096
### Expire-Date: 0
### Name-Comment: ${KEY_COMMENT}
### Name-Real: ${KEY_NAME}
### EOF
### Get the GPG key fingerprint:

### $ gpg --list-secret-keys "${KEY_NAME}"
### gpg: checking the trustdb
### gpg: marginals needed: 3  completes needed: 1  trust model: pgp
### gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
### sec   rsa4096 2023-10-17 [SCEAR]
###       BE574406FE117762E9F4C8B01CB98A820DCBA0FC
### uid           [ultimate] Tiexin Guo (test key for sops)
### ssb   rsa4096 2023-10-17 [SEAR]
### In the "pub" part of the output, you can get the GPG key fingerprint (in my case, it's "BE574406FE117762E9F4C8B01CB98A820DCBA0FC").

### Then we need to configure SOPS to use this PGP key for encryption/decryption. To do so, create a file named .sops.yaml under your $HOME directory with the following content:

### creation_rules:
###     - pgp: >-
###         BE574406FE117762E9F4C8B01CB98A820DCBA0FC

## On Jenkins server : cpa@debian-pve:~$
### Brave : install sops debian 12: https://search.brave.com/search?q=install+sops+debian+12&summary=1&conversation=a1477ca545af70c1995d15
sudo apt update
sudo apt install golang
sudo apt upgrade
sudo go install github.com/mozilla/sops/v3@latest
sudo apt-get install gnupg
sudo apt-get upgrade

export KEY_NAME="Tiexin Guo"
# => export KEY_COMMENT="test key for sops"



gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF
# => gpg: répertoire « /home/cpa/.gnupg » créé
# => gpg: le trousseau local « /home/cpa/.gnupg/pubring.kbx » a été créé
# => gpg: /home/cpa/.gnupg/trustdb.gpg : base de confiance créée
# => gpg: répertoire « /home/cpa/.gnupg/openpgp-revocs.d » créé
# => gpg: revocation certificate stored as '/home/cpa/.gnupg/openpgp-revocs.d/4BB31BFDBCB09D237F7FDD9BF622305AAE526DE7.rev'


gpg --list-secret-keys "${KEY_NAME}"
# => gpg: vérification de la base de confiance
# => # => gpg: marginals needed: 3  completes needed: 1  trust model: pgp
# => gpg: profondeur : 0  valables :   1  signées :   0
# =>      confiance : 0 i., 0 n.d., 0 j., 0 m., 0 t., 1 u.
# => sec   rsa4096 2025-06-25 [SCEA]
# =>       4BB31BFDBCB09D237F7FDD9BF622305AAE526DE7
# => uid          [  ultime ] Tiexin Guo (test key for sops)
# => ssb   rsa4096 2025-06-25 [SEA]

vim ~/.sops.yaml
creation_rules:
    - pgp: >-
        4BB31BFDBCB09D237F7FDD9BF622305AAE526DE7
cat ~/.sops.yaml 
# =>  creation_rules:
# =>      - pgp: >-
# =>          4BB31BFDBCB09D237F7FDD9BF622305AAE526DE7


### Remember to replace the key fingerprint generated in the previous step.
### Installing and configuring SOPS with PGP keys is not simple; refer to my blog on SOPS for more details.
### 
### Finally, we can install helm-secrets. Click here to get the latest version (at the time of writing, the latest version is v4.5.1). Then, run the following command to install:

helm plugin install https://github.com/jkroepke/helm-secrets --version v4.5.1
# =>  cpa@debian-pve:~$ helm plugin install https://github.com/jkroepke/helm-secrets --version v4.5.1
# =>  Installed plugin: secrets

# $URL_REP_HELM_FAT_CAST_DB/environments/dev/secrets.k8s.cast.db.dev.yaml
# => cpa@debian-pve:/var/lib/jenkins/workspace/dm-jenkins/charts/cast-db/environments/dev$ cat $URL_REP_HELM_FAT_CAST_DB/environments/dev/secrets.k8s.cast.db.dev.yaml
# => apiVersion: v1
# => kind: Secret
# => metadata:
# =>   name: cast-db-secret
# =>   namespace: dev
# => type: Opaque
# => data:
# =>   cast-db-username: ZmFzdGFwaV91c2Vy       # echo $(echo -n "ZmFzdGFwaV91c2Vy" | base64 -d)  :=> fastapi_user
# =>   cast-db-password: ZmFzdGFwaV9wYXNzd2Q=   # echo $(echo -n "ZmFzdGFwaV9wYXNzd2Q=" | base64 -d)  :=> fastapi_passwd
# =>   cast-db-database: ZmFzdGFwaV9kYg==       # echo $(echo -n "ZmFzdGFwaV9kYg==" | base64 -d)  :=> fastapi_db

cd /var/lib/jenkins/workspace/dm-jenkins/charts/cast-db/environments/dev/

### Let's create a secret file and name it as credentials.yaml.dec with the following content:
### password: test
sudo vim credentials.yaml
cast-db-username: fastapi_user
cast-db-password: fastapi_passwd
cast-db-database: fastapi_db
# =>   cpa@debian-pve:/var/lib/jenkins/workspace/dm-jenkins/charts/cast-db/environments/dev$ cat credentials.yaml
# =>   cast-db-username: fastapi_user
# =>   cast-db-password: fastapi_passwd
# =>   cast-db-database: fastapi_db

### To encrypt this file using helm-secrets, run the following command:
helm secrets encrypt credentials.yaml.dec > credentials2.yaml
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### 
####         PAUSE     ## How helm-secrets works :https://github.com/getsops/sops/releases
#### 
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### Install cosign on debian 12
## url download .deb : https://github.com/sigstore/cosign/releases
wget "https://github.com/sigstore/cosign/releases/download/v2.5.2/cosign_2.5.2_amd64.deb"
##
## For Ubuntu and Debian distributions, check the releases page and download the latest .deb package. At the time of this writing, this would be version 2.5.0. To install the .deb file, run:
### https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary
### sh sudo dpkg -i ~/Downloads/cosign_2.5.0_amd64.deb

ls -lha
# =>  cpa@debian-pve:~/.credentials_cpa_dmjenkins_helm_castdb$ ls -lha
# =>  ...
# =>  -rw-r--r--  1 cpa cpa  53M 17 juin  22:36 cosign_2.5.2_amd64.deb

# =>  cpa@debian-pve:~/.credentials_cpa_dmjenkins_helm_castdb$ sudo dpkg -i cosign_2.5.2_amd64.deb 
# =>  Sélection du paquet cosign précédemment désélectionné.
# =>  (Lecture de la base de données... 73927 fichiers et répertoires déjà installés.)
# =>  Préparation du dépaquetage de cosign_2.5.2_amd64.deb ...
# =>  Dépaquetage de cosign (2.5.2) ...
# =>  Paramétrage de cosign (2.5.2) ...

cosign version
# =>  cpa@debian-pve:~/.credentials_cpa_dmjenkins_helm_castdb$ cosign version
# =>  
# =>    ______   ______        _______. __    _______ .__   __.
# =>   /      | /  __  \      /       ||  |  /  _____||  \ |  |
# =>  |  ,----'|  |  |  |    |   (----`|  | |  |  __  |   \|  |
# =>  |  |     |  |  |  |     \   \    |  | |  | |_ | |  . `  |
# =>  |  `----.|  `--'  | .----)   |   |  | |  |__| | |  |\   |
# =>   \______| \______/  |_______/    |__|  \______| |__| \__|
# =>  cosign: A tool for Container Signing, Verification and Storage in an OCI registry.
# =>  
# =>  GitVersion:    v2.5.2
# =>  GitCommit:     af5a988bb15a03919ccaac7a2ddcad7a9d006f38
# =>  GitTreeState:  clean
# =>  BuildDate:     2025-06-17T20:03:14Z
# =>  GoVersion:     go1.24.4
# =>  Compiler:      gc
# =>  Platform:      linux/amd64
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####



#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### 
####        REPRISE     ## How helm-secrets works :https://github.com/getsops/sops/releases
#### 
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

## Verify checksums file signature
### The checksums file provided within the artifacts attached to this release is signed using Cosign with GitHub OIDC. To validate the signature of this file, run the ### following commands:

# Download the checksums file, certificate and signature
curl -LO https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.checksums.txt
curl -LO https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.checksums.pem
curl -LO https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.checksums.sig

#### Verify the checksums file
cosign verify-blob sops-v3.10.2.checksums.txt \
  --certificate sops-v3.10.2.checksums.pem \
  --signature sops-v3.10.2.checksums.sig \
  --certificate-identity-regexp=https://github.com/getsops \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com
# => cpa@debian-pve:~/.credentials_cpa_dmjenkins_helm_castdb$ cosign verify-blob sops-v3.10.2.checksums.txt \
# =>   --certificate sops-v3.10.2.checksums.pem \
# =>   --signature sops-v3.10.2.checksums.sig \
# =>   --certificate-identity-regexp=https://github.com/getsops \
# =>   --certificate-oidc-issuer=https://token.actions.githubusercontent.com
# => Verified OK



#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### 
####         FIN     ## How helm-secrets works :https://github.com/getsops/sops/releases
#### 
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####