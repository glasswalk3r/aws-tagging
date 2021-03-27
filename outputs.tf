locals {
  project_name = lower(trimspace(var.project_name))
  new_name     = var.name == "not informed" ? local.project_name : lower(trimspace(var.name))

  tags = var.add_name_tag ? { "Name" = local.new_name } : {}
  # The argument "asg_tags" was already set at
  # ../../../modules/tags/outputs.tf. Each argument may be set only once.

  project_name_tag      = "${var.tag_prefix}:projectName"
  environment_tag       = "${var.tag_prefix}:environment"
  owner_tag             = "${var.tag_prefix}:infrastructureOwner"
  commit_id_tag         = "${var.tag_prefix}:commitID"
  terraform_version_tag = "${var.tag_prefix}:terraformVersion"
  cost_center_tag       = "${var.tag_prefix}:costCenter"
  repository_tag        = "${var.tag_prefix}:repo"

  tmp_asg_tags = [
    { "key" = local.project_name_tag, "value" = local.project_name, propagate_at_launch = var.asg_propagate_at_launch },
    { "key" = local.environment_tag, "value" = var.environment, propagate_at_launch = var.asg_propagate_at_launch },
    { "key" = local.owner_tag, "value" = var.owner, propagate_at_launch = var.asg_propagate_at_launch },
    { "key" = local.cost_center_tag, "value" = var.cost_center, propagate_at_launch = var.asg_propagate_at_launch }
  ]
  asg_tags = var.add_name_tag ? concat(local.tmp_asg_tags, [
    { "key" = "Name", "value" = local.new_name, propagate_at_launch = var.asg_propagate_at_launch }
  ]) : local.tmp_asg_tags
}

output "tags" {
  description = "All the tags defined with the passed parameters, as a map"
  value = merge(local.tags,
    { (local.project_name_tag)      = local.project_name,
      (local.environment_tag)       = var.environment,
      (local.owner_tag)             = var.owner,
      (local.repository_tag)        = var.repository,
      (local.cost_center_tag)       = var.cost_center,
      (local.commit_id_tag)         = var.commit_id,
      (local.terraform_version_tag) = var.terraform_version
    }
  )
}

output "asg_tags" {
  description = "All the tags defined with the passed parameters, as required by a ASG (list of maps)"
  value       = local.asg_tags
}
