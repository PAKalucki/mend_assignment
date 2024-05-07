output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_cert" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "elb_controller_iam_role" {
  value = aws_iam_role.elb_controller.arn
}