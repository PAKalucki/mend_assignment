resource "helm_release" "hello_world_aws" {
  provider = helm.aws

  name = "hello-world"
  chart      = "./hello-world"

  set {
    name = "ingress.className"
    value = "alb"
  }

  set {
    name = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  }

  set {
    name = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }
}

resource "helm_release" "hello_world_azure" {
  provider = helm.azure

  name = "hello-world"
  chart      = "./hello-world"

  set {
    name = "ingress.className"
    value = "azure-application-gateway"
  }

  set {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "azure/application-gateway"
  }
}