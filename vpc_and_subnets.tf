data "aws_vpc" "this" {
  count = var.redis_enabled || var.rds_enabled ? 1 : 0

  tags = var.vpc_tag_filter
}

data "aws_subnet_ids" "redis" {
  count = var.redis_enabled ? 1 : 0

  vpc_id = data.aws_vpc.this[0].id

  tags = var.redis_subnet_tag_filter
}

data "aws_subnet_ids" "rds" {
  count = var.rds_enabled ? 1 : 0

  vpc_id = data.aws_vpc.this[0].id

  tags = var.rds_subnet_tag_filter
}

data "aws_security_groups" "for_rds" {
  count = var.rds_enabled && length(var.additional_sg_names_for_rds) >= 1 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this[0].id]
  }

  filter {
    name   = "group-name"
    values = [for sg in var.additional_sg_names_for_rds : sg]
  }
}
