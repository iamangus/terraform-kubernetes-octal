variable "octal_oidc_config" {
  type = object({
    oidc_groups_prefix = optional(string),
    oidc_cluster_role_bindings = optional(list(object({
      cluster_role_name = string
      oidc_group_name   = string
    })))
  })
  description = "`oidc_groups_prefix` is the prefix attached to OIDC groups bound to cluster roles. Needs to match the value given to the kube-api-server argument `--oidc-groups-prefix`. `oidc_cluster_role_bindings` is a set of OIDC group and cluster role names to map to one another."
  default     = null
}

variable "octal_extras" {
  type = object({
    namespace = optional(string),
    enabled_extras = object({
      kubedb = optional(object({
        enabled   = bool
        namespace = optional(string)
      }))
      rookio = optional(object({
        enabled   = bool
        namespace = optional(string)
      }))
    })
  })
  description = "`namespace` is the namespace the extras will be deployed to, and enabled extras is a map(bool) of extras to enable."
  default     = null
}

variable "cert_manager" {
  type = object({
    certificate_issuers = object({
      letsencrypt = object({
        name : string,
        server : string,
        email : string,
        secret_base64_key : string,
        solvers : object({
          http01 : optional(object({
            default_issuer : bool,
            ingress_class : string
          })),
          dns01 : optional(object({
            cloudflare : optional(object({
              default_issuer : bool,
              email : string,
              base64_api_key : string
            })),
            digitalocean : optional(object({
              default_issuer : bool,
              base64_access_token : string
            }))
          }))
        })
      })

variable "traefik" {
  type = object({
    image_tag: optional(string),
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
