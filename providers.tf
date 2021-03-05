provider "kubernetes" {
   load_config_file = true
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
provider "k8s" {

  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}