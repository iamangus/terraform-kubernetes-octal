provider "kubernetes" {
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
provider "k8s" {

  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}