#output "ingress_loadbalancer_ip_list" {
#  value = var.traefik == null ? [] : module.traefik.0.ingress_loadbalancer_ip_list
#}
output "cluster_cert_issuer" {
  value = var.cert_manager == null ? "" : module.cert_manager[0].cert_issuer
}
output "cluster_ingress_class" {
  value = var.traefik == null ? "" : module.traefik[0].ingress_class
}

output "argocd_namespace" {
  value = var.argocd == null ? "" : module.argocd[0].namespace
}