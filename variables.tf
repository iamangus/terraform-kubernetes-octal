variable "cluster_endpoint" {
  type = string
}
variable "cluster_token" {
  type = string
}
variable "cluster_ca_certificate" {
  type = string
}
variable "cluster_cert_issuer" {
  type        = string
  description = "The cluster certificate issuer to use when creating a TLS certificate for the ingress"
}
variable "cluster_ingress_class" {
  type        = string
  description = "The ingress class that the ingress records should reference."
}
variable "traefik" {
  type = object({
    namespace : string,
    log_level : string,
    replicas : number,
    rolling_update_max_surge : number,
    rolling_update_max_unavailable : number,
    pod_termination_grace_period_seconds : number
  })
  default = null
}
variable "argocd" {
  type = object({
    namespace : string,
    server_replicas : number,
    repo_replicas : number,
    enable_dex : bool,
    enable_ha_redis : bool,
    oidc_name : string,
    oidc_issuer : string,
    oidc_client_id : string,
    oidc_client_secret : string,
    oidc_requested_scopes : list(string),
    oidc_requested_id_token_claims : map(any)
  })
  default = null
}