# 1. First we're going to want to deploy/update our security enforcement layer.
# TODO: Finish this module.
#module "open_policy_agent" {
#    source = "github.com/project-octal/terraform-kubernetes-opa-gatekeeper"
#    namespace = var.opa_namespace
#}

# 2. Next we need to deploy/update the clusters service mesh.
# TODO: Finish this module.
#module "linkerd" {
#    source = "github.com/project-octal/terraform-kubernetes-linkerd"
#    depends_on = [module.open_policy_agent]
#    namespace = var.linkerd_namespace
#}

# 3. Deploy the certificate manager so that we can generate valid certs for our ingresses
module "cert_manager" {
  source = "github.com/iamangus/terraform-kubernetes-cert-manager"
  count  = var.cert_manager == null ? 0 : 1

  certificate_issuers = {
    letsencrypt = {
      name              = var.cert_manager.certificate_issuers.letsencrypt.name
      server            = var.cert_manager.certificate_issuers.letsencrypt.server
      email             = var.cert_manager.certificate_issuers.letsencrypt.email
      secret_base64_key = var.cert_manager.certificate_issuers.letsencrypt.secret_base64_key
      default_issuer : var.cert_manager.certificate_issuers.letsencrypt.default_issuer,
      ingress_class = module.traefik[0].ingress_class
    }
    slvr_dns01_cf = {
        emailcf                 = var.cert_manager.certificate_issuers.slvr_dns01_cf.emailcf
        secret_base64_cfapikey  = var.cert_manager.certificate_issuers.slvr_dns01_cf.secret_base64_cfapikey
    }
    slvr_http01 = {
        ingress_class           = module.traefik[0].ingress_class
    }
  }
}

# 3. Now we deploy/update the clusters ingress controller.
# TODO: Pat myself on the back for getting this to work.
module "traefik" {
  source = "github.com/project-octal/terraform-kubernetes-traefik"
  count  = var.traefik == null ? 0 : 1
  # depends_on = [module.open_policy_agent, module.linkerd]

  image_tag                            = var.traefik.image_tag
  namespace                            = var.traefik.namespace
  log_level                            = var.traefik.log_level
  replicas                             = var.traefik.replicas
  rolling_update_max_surge             = var.traefik.rolling_update_max_surge
  rolling_update_max_unavailable       = var.traefik.rolling_update_max_unavailable
  pod_termination_grace_period_seconds = var.traefik.pod_termination_grace_period_seconds
  service_type                         = var.traefik.service_type
  preferred_node_selector              = var.traefik.preferred_node_selector
}

# 4. Lastly, deploy/update the CICD orchestrator.
# TODO: Pat myself on the back for getting this to work.
module "argocd" {
  source     = "github.com/project-octal/terraform-kubernetes-argocd"
  count      = var.argocd == null ? 0 : 1
  depends_on = [module.traefik]

  namespace              = var.argocd.namespace
  cluster_cert_issuer    = var.cert_manager == null ? "" : module.cert_manager[0].cert_issuer
  ingress_class          = var.traefik == null ? "" : module.traefik[0].ingress_class
  argocd_url             = var.argocd.url
  argocd_server_replicas = var.argocd.server_replicas
  argocd_repo_replicas   = var.argocd.repo_replicas
  enable_dex             = var.argocd.enable_dex
  enable_ha_redis        = var.argocd.enable_ha_redis
  oidc_config = {
    name                      = var.argocd.oidc_name,
    issuer                    = var.argocd.oidc_issuer,
    client_id                 = var.argocd.oidc_client_id,
    client_secret             = var.argocd.oidc_client_secret,
    requested_scopes          = var.argocd.oidc_requested_scopes,
    requested_id_token_claims = var.argocd.oidc_requested_id_token_claims
  }
}

# 5. Configure OIDC auth and cluster access.
module "oidc_rbac" {
  source = "github.com/project-octal/terraform-kubernetes-api-oidc-auth"
  count  = var.octal_oidc_config == null ? 0 : 1

  oidc_groups_prefix         = var.octal_oidc_config.oidc_groups_prefix
  oidc_cluster_role_bindings = var.octal_oidc_config.oidc_cluster_role_bindings
}
