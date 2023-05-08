# <img src="https://user-images.githubusercontent.com/25181517/183345121-36788a6e-5462-424a-be67-af1ebeda79a2.png" width="35" height="35"> Akamai compute K38s secure

Akamai computer K38s secure is a Kubernetes cluster deployed using Linode terraform provider. This project is able to create a Kubernetes cluster and obtain valid certificates for your Kubernetes Cluster by using Nginx ingress controller + Cert-Manager + LetsEncrypt.

## Before you begin

- Sign up for Linode and create a [Personal Access Token](https://www.linode.com/docs/products/tools/api/guides/manage-api-tokens/) with read and write access. [New accounts get a $$$ credit.](https://linode.com/cfe)  *
- Install the Kubernetes command-line tool `kubectl` with the [official install guide](https://kubernetes.io/docs/tasks/tools/) *
- [Install Linode CLi](https://www.linode.com/docs/products/tools/api/guides/manage-api-tokens/).
- Install Terraform with the [official install guide](https://developer.hashicorp.com/terraform/downloads) *
- A registered domain name. This tutorial will use `your_domain`. *
- DNS set up for your domain name. *
- Setup VSCode
- Install Git

## What does this tempalate do?

1. Creates a K38 cluster with 3 pods on Linode
2. Creates a service mesh with Linode Node balancer
3. Deploy's a web-app
4. Setup cert manager
5. Deploys Lets Encrypt staging and prod cert issuers
6. Deploys certificates
7. deploys ingress controller
 
Thereafter, Update DNS A records with your hostname with Linode NodeBalancer external IP and access your web application running on Linode Kubernetes.

## Setup

## PART I
> This section explains steps for setting up K38s cluster on Linode using terraform and setting up all the configuration changes.

### Clone github repo on your local

``` git clone https://github.com/akamai-devops-APJ/akamai_compute.git```

changedir to ```cd akamai_compute/01-k38s-nginx-secure/```

### Update configuration values as per your requirement

> **Note**
> the template is defaulted to production certificate validation settings. Suggest to first test it with Lets Encrypt staging.

**certificate-production.yaml**

Edit and save the following values `commonName`, `dnsNames` in certificate-production.yaml to your hostname.
e.g.
  ```
  commonName: www.alakhani.net
  dnsNames:
  - www.alakhani.net
```

**cluster-issuer-production.yaml**

Before you begin issuing certificates, you must configure at least one `Issuer` or `ClusterIssuer` resource in your cluster. Note when you are running cert related steps, It may take a minute or so for the TLS assets required for the webhook to function to be provisioned.

Update correct email address and validate the name set to staging/production. Enter valid email as this is required for the system to send expiry notifications.
```
    email: <YOUR EMAIL ID>
    privateKeySecretRef:
      name: letsencrypt-production
```      

**my-new-ingress.yaml**

Ingress Controller (NGINX) is an entry point that sits in front of multiple services in the cluster. It can be defined as a collection of routing rules that govern how external users access services running inside a Kubernetes cluster.

Update the hostnames. E.g.

```
  tls:
  - hosts:
      - www.alakhani.net
    secretName : ssl-cert-production
  rules:
  - host: www.alakhani.net
  ```

  **terraform.tfvars**

  Update `token=""` with a valid linode access token.

  **Initialise, Plan and Apply Terraform**

  On your root folder terminal, run

  ```terraform init ```

  And then run

  ```terraform plan```

  Execute terraform apply to deploy and initialise K38s Cluster on Linode

  ```terraform apply -auto-approve```

  Output e.g.

  ```
  linode_lke_cluster.terraform_k8s: Still creating... [1m20s elapsed]
linode_lke_cluster.terraform_k8s: Still creating... [1m30s elapsed]
linode_lke_cluster.terraform_k8s: Creation complete after 1m33s [id=107028]
local_file.k8s_config: Creating...
local_file.k8s_config: Creation complete after 0s [id=310aa4a665abfce76ebc9531333095282f49837d]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

  ## PART II
> Until now, you will have a K38s cluster running on Linode. Next steps involve deploying web-app and create a bunch of services to make the application running securely with valid production DV certificate.

**Kube config**

At this stage, you will see a `kubeconfig.yaml` generated under .kube folder. 

setup local variable `export KUBECONFIG=.kube/kubeconfig.yaml` and run
`kubectl config get-contexts` you should see e.g.
```
nlakhani@sin-mpse4 022-linode-doc-k38s % kubectl config get-contexts
CURRENT   NAME            CLUSTER     AUTHINFO          NAMESPACE
*         lke107028-ctx   lke107028   lke107028-admin   default
```
this validates you have a cluster running and kubeconfig file is valid.

```kubectl get nodes```
```kubectl create -f hello-one.yaml // deploy hello-one web application```
```kubectl get svc // validate service is running```
Install the NGINX Ingress Controller using helm (skip if you already have)
```helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx```
Install the NGINX Ingress Controller. This installation will result in a Linode NodeBalancer being created.
```helm install ingress-nginx ingress-nginx/ingress-nginx```
Find NodeBalancer External IP
```kubectl --namespace default get services -o wide -w ingress-nginx-controller```

Once your Ingress Controller is installed and DNS records have been created pointing to your NodeBalancer, you need to create a manifest file to create a new Ingress resource. This resource will define how traffic coming from the LoadBalancer service we deployed earlier is handled. In this case, NGINX will accept these connections over port 80, diverting traffic to both of our services via their `hostname` or domain names:

Create an Ingress resource manifest file named `my-new-ingress.yaml`
```kubectl create -f my-new-ingress.yaml```