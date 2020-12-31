resource "helm_release" "jx-git-operator" {
  name             = "jx-git-operator"
  chart            = "jx-git-operator"
  namespace        = "jx-git-operator"
  repository       = "https://storage.googleapis.com/jenkinsxio/charts"
  create_namespace = true

  set {
    name  = "bootServiceAccount.enabled"
    value = true
  }
  set {
    name  = "env.NO_RESOURCE_APPLY"
    value = true
  }
  set {
    name  = "url"
    value = var.jx_git_url
  }
  set {
    name  = "username"
    value = var.jx_bot_username
  }
  set_sensitive {
    name  = "password"
    value = var.jx_bot_token
  }

}

module "jx-health" {
  source              = "github.com/jenkins-x/terraform-jx-health?ref=main"
  jx_git_url          = var.jx_git_url
  jx_bot_username     = var.jx_bot_username
  jx_bot_token        = var.jx_bot_token
  tf_drift_secret_map = var.terraform_drift_secret_map
}
