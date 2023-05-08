terraform {
    required_version = ">= 0.15"
    required_providers {
        linode = {
            source = "linode/linode"
        }
    }
}

provider "linode" {
    token = var.token
}
/*
locals {
    root_dir = "${dirname(abspath(path.root))}"
    k8s_config_dir = "${local.root_dir}/.kube/"
    k8s_config_file = "${local.root_dir}/.kube/kubeconfig.yaml"
}
*/
resource "linode_lke_cluster" "terraform_k8s" {
    k8s_version="1.25"
    label=var.k8s_label
    region=var.k8s_region
    tags=var.tags
    dynamic "pool" {
        for_each = var.pools
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
}

resource "local_file" "k8s_config" {
    content = "${nonsensitive(base64decode(linode_lke_cluster.terraform_k8s.kubeconfig))}"
    filename = ".kube/kubeconfig.yaml"
    file_permission = "0600"
}

output "kubeconfig" {
  value = linode_lke_cluster.terraform_k8s.kubeconfig
  sensitive = true
}

output "api_endpoints" {
  value = linode_lke_cluster.terraform_k8s.api_endpoints
}

output "status" {
  value = linode_lke_cluster.terraform_k8s.status
}

output "id" {
  value = linode_lke_cluster.terraform_k8s.id
}

output "pool" {
  value = linode_lke_cluster.terraform_k8s.pool
}
