variable "cert_manager" {
  type = object({
    certificate_issuers = object({
      letsencrypt = object({
        name : string,
        server : string,
        email : string,
        default_issuer : bool,
        secret_base64_key : string
      })
    })
  })
  default = null
}

variable "traefik" {
  type = object({
    namespace : string,
    log_level : string,
    replicas : number,
    rolling_update_max_surge : number,
    rolling_update_max_unavailable : number,
    pod_termination_grace_period_seconds : number
    service_type : string,
    preferred_node_selector : list(object({
      weight   = number,
      key      = string,
      operator = string,
      values   = list(string)
    }))
  })
  default = null
}

variable "argocd" {
  type = object({
    url : string,
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

variable "oidc_groups_prefix" {
  type        = string
  description = "The prefix attached to OIDC groups bound to cluster roles. Needs to match the value given to the kube-api-server argument `--oidc-groups-prefix`"
  default     = "oidc:"
}

variable "oidc_cluster_role_bindings" {
  type = set(object({
    cluster_role_name = string
    oidc_group_name   = string
  }))
  description = "The name of the OIDC groups to bind to the builtin `cluster-admin` cluster role."
  default     = []
}