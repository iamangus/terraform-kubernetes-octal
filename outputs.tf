output "traefik_ingress_loadbalancer_ip_list" {
  value = var.traefik == null ? null : module.traefik.ingress_loadbalancer_ip_list
}