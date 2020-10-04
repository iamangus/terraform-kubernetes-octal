provider "kubernetes" {
  load_config_file       = false
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = var.cluster_ca_certificate
}
provider "k8s" {
  load_config_file       = false
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = var.cluster_ca_certificate
}