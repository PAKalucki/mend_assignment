resource "kubernetes_service_account" "lbc_service_account" {
  provider = kubernetes.aws

  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.tfe_outputs.aws.values.elb_controller_iam_role
    }
  }
} 

resource "helm_release" "lbc_controller" {
  provider = helm.aws

  name = "aws-load-balancer-controller"
  version = "1.7.2"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"

  set {
    name  = "clusterName"
    value = data.tfe_outputs.aws.values.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.lbc_service_account.metadata[0].name
  }
}
