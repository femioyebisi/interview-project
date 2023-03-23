resource "kubernetes_secret" "image_pull_secret" {
  metadata {
    name      = "image-pull-secret"
    namespace = local.deployment_namespace
  }

  data = {
    ".dockerconfigjson" = "${file("~/.docker/config.json")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = local.deployment_name
    namespace = local.deployment_namespace
    labels = {
      app = local.label_app
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = local.label_app
      }
    }

    template {
      metadata {
        labels = {
          app = local.label_app
        }
      }

      spec {
        container {
          image = "${var.image_name}:${var.tag}"
          name  = local.deployment_name
          port {
            container_port = 8080
          }
        }
        image_pull_secrets {
          name = kubernetes_secret.image_pull_secret.metadata[0].name
        }
        restart_policy = "Always"
      }
    }
  }
  wait_for_rollout = false
}

# resource "kubernetes_job" "k8s_job" {
#   metadata {
#     name = local.deployment_name
#     namespace = local.deployment_namespace
#   }
#   spec {
#     template {
#       metadata {}
#       spec {
#         container {
#           name    = local.deployment_name
#           image   = "nginx"
#         }
#         # image_pull_secrets {
#         #   name = kubernetes_secret.image_pull_secret.metadata[0].name
#         # }
#         restart_policy = "OnFailure"
#       }
#     }
#     backoff_limit = 4
#   }
#   wait_for_completion = false
# }