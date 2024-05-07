module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.base_cidr_block
  networks = [
    {
      name     = "public-${var.region}a"
      new_bits = 4
    },
    {
      name     = "public-${var.region}b"
      new_bits = 4
    },
    {
      name     = "private-${var.region}a"
      new_bits = 4
    },
    {
      name     = "private-${var.region}b"
      new_bits = 4
    },
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${terraform.workspace}_vpc"
  cidr = var.base_cidr_block

  azs              = ["${var.region}a", "${var.region}b"]
  public_subnets   = slice(module.subnets.networks[*].cidr_block, 0, 2)
  private_subnets  = slice(module.subnets.networks[*].cidr_block, 2, 4)

  enable_nat_gateway                     = true
  one_nat_gateway_per_az                 = true
  enable_dns_hostnames                   = true
  enable_dns_support                     = true

  public_subnet_tags = {
    "Type" = "public"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = ""
  }

  private_subnet_tags = {
    "Type" = "private"
  }
}