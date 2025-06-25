How helm-secrets works
https://securityboulevard.com/2023/10/how-to-handle-secrets-in-helm/

How helm-secrets works
OK, now the long version.

Helm-secrets is a Helm plugin that manages secrets.

What's a Helm plugin, then? Good question.

Helm plugins are extensions that add additional functionalities and capabilities to Helm. These can be new commands, features, or integrations. Plugins can be used to perform various tasks, such as managing secrets, encrypting values, validating charts, etc. To use a Helm plugin, we typically install it using the helm plugin install command, and then we can invoke the plugin's commands just like any other native Helm command.

With helm-secrets, the values can be stored encrypted in Helm charts. However, the plugin does not handle the encryption/decryption operations itself; it offloads and delegates the cryptographic work to another tool: SOPS

SOPS, short for Secrets OPerationS, is an open-source text file editor by Mozilla that encrypts/decrypts files automatically. With SOPS, when we write a file, SOPS automatically encrypts the file before saving it to the disk. For that, it uses the encryption key of our choice: this can be a PGP key, an AWS KMS key, or many others. To learn more about SOPS and its possible integrations with different encryption key service providers, read my other blog here:

A Comprehensive Guide to SOPS: Managing Your Secrets Like A Visionary, Not a Functionary
Have you heard about SOPS? If you have already been in a situation where you needed to share sensitive information with your teammates, this is for you.
How to Handle Secrets in HelmGitGuardian Blog – Automated Secrets DetectionGuest Expert
How to Handle Secrets in Helm

helm-secrets can also work in a "cloud" mode, where secrets are not stored in the Helm chart, but in a cloud secret manager. We then simply refer to the path of the secret in the cloud in the file, and the secret is automatically injected upon invoking helm install.

Example 1: Helm-secrets with SOPS
In this example, we will store encrypted secrets in the Helm charts. Since this relies on SOPS, we first need to install it. The easiest way to install SOPS is via brew:

brew install sops
For other OS users, refer to the official GitHub repo of SOPS.

Then, let's configure SOPS to use PGP keys for encryption:

brew install gnupg
If you are using another OS, for example, Linux, you can use the corresponding package manager. Most likely, this would work:

sudo apt-get install gnupg

With GnuPG, Creating a key is as simple as the following (remember to put your name as the value of KEY_NAME):

export KEY_NAME="Tiexin Guo"
export KEY_COMMENT="test key for sops"

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
Get the GPG key fingerprint:

$ gpg --list-secret-keys "${KEY_NAME}"
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
sec   rsa4096 2023-10-17 [SCEAR]
      BE574406FE117762E9F4C8B01CB98A820DCBA0FC
uid           [ultimate] Tiexin Guo (test key for sops)
ssb   rsa4096 2023-10-17 [SEAR]
In the "pub" part of the output, you can get the GPG key fingerprint (in my case, it's "BE574406FE117762E9F4C8B01CB98A820DCBA0FC").

Then we need to configure SOPS to use this PGP key for encryption/decryption. To do so, create a file named .sops.yaml under your $HOME directory with the following content:

creation_rules:
    - pgp: >-
        BE574406FE117762E9F4C8B01CB98A820DCBA0FC