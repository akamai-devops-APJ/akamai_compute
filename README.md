# Akamai Compute

This repo contains code examples on Akamai Compute (Linode).

## Goal

I created this project to fill a personal need to provide users with easy way to accomplish onboarding and management tasks on Akamai compute. While there are advance options they are optional and the project should be as simple as possible so that the barrier for entry is super duper low.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://www.mockofun.com/wp-content/uploads/2020/05/buy-me-a-coffee-logo-6100.jpg">
</picture>

## Quick start

- You must have a Linode account and personal access token
- For instructions on running the project code, please consult the README in each folder

### [01-k38s-nginx-secure](https://github.com/akamai-devops-APJ/akamai_compute/tree/main/01-k38s-nginx-secure#-akamai-compute-k38s-secure)

Akamai computer K38s secure is a Kubernetes cluster deployed using Linode terraform provider. This terraform project creates a Kubernetes cluster, obtain valid DV certificates, creates NodeBalancer, service mesh and secure it (HTTPS). Pretty cool, huh!