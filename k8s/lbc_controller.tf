resource "kubernetes_service_account" "lbc_service_account" {
  provider = kubernetes.aws

  metadata {
    name = "aws-load-balancer-controller"
    annotations = {
      "eks.amazonaws.com/role-arn" = data.tfe_outputs.aws.outputs.elb_controller_iam_role
      // eksctl create iamserviceaccount --cluster=<clusterName> --name=<serviceAccountName> --attach-role-arn=<customRoleARN>
    }
  }
} 

resource "helm_release" "lbc_controller" {
  provider = helm.aws

  name = "aws-load-balancer-controller"

  repository       = "https://aws.github.io/eks-charts"
  chart            = "eks/aws-load-balancer-controller"
  version          = "1.7.2"
  namespace        = "kube-system"

  set {
    name  = "clusterName"
    value = data.tfe_outputs.aws.outputs.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.lbc_service_account.metadata.name
  }
}