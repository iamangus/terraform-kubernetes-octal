locals {

  # object({
  #   certificate_issuers = object({
  #     letsencrypt = object({
  #     name : string,
  #     server : string,
  #     email : string,
  #     default_issuer : bool,
  #     secret_base64_key : string
  #     })
  #   })
  # })
  cert_manager = defaults(var.cert_manager, {
    certificate_issuers = {}
  })

  # object({
  #   namespace : string,
  #   log_level : string,
  #   replicas : number,
  #   rolling_update_max_surge : number,
  #   rolling_update_max_unavailable : number,
  #   pod_termination_grace_period_seconds : number
  # })
  traefik = defaults(var.traefik, {
    namespace = "kube-traefik"
    log_level = "error"
    replicas = 1
  })

  # object({
  #   url : string,
  #   namespace : string,
  #   server_replicas : number,
  #   repo_replicas : number,
  #   enable_dex : optional(bool),
  #   enable_ha_redis : optional(bool),
  #   oidc_name : string,
  #   oidc_issuer : string,
  #   oidc_client_id : string,
  #   oidc_client_secret : string,
  #   oidc_requested_scopes : list(string),
  #   oidc_requested_id_token_claims : map(any)
  # })
  argocd = defaults(var.argocd, {
    namespace = "kube-argocd"
    server_replicas = "1"
  })
}