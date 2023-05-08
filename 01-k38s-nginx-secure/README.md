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

### Clone github repo on your local

``` git clone https://github.com/akamai-devops-APJ/akamai_compute.git```

changedir to ```cd akamai_compute/01-k38s-nginx-secure/```

### Update configuration values as per your requirement

> **Note**
> the template is defaulted to production certificate validation settings. Suggest to first test it with Lets Encrypt staging.

Edit and save the following values `commonName`, `dnsNames` in certificate-production.yaml to your hostname.
e.g.
  ```
  commonName: www.alakhani.net
  dnsNames:
  - www.alakhani.net
```
