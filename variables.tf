variable "environment" {
  type        = string
  description = "The AWS account this module is deployed to"

  validation {
    condition     = contains(["prod", "qa", "dev"], var.environment)
    error_message = "A valid environment name must be 'prod', 'qa' or 'dev'!"
  }
}

variable "cost_center" {
  type        = string
  description = "The cost center to associate with the resource"
  default     = "123456789"

  validation {
    condition     = can(regex("^\\d+$", var.cost_center))
    error_message = "A cost center must be formed only by digits!"
  }
}

variable "tag_prefix" {
  type        = string
  description = "The prefix to add to all the tags."
}

variable "repository" {
  type        = string
  description = "The URI to the Git repository of this project"
}

variable "terraform_version" {
  type        = string
  description = "The version of the Terraform used to apply this resource"

  validation {
    condition     = can(regex("^v\\d+\\.\\d+\\.\\d+$", var.terraform_version))
    error_message = "You must pass a Terraform version as retrieved from the CLI!"
  }
}

variable "commit_id" {
  type        = string
  description = "The commit ID of the Git repository which relates to current resource state"

  validation {
    condition     = can(regex("^[0-9A-Za-z]+$", var.commit_id))
    error_message = "The commit hash must be alphanumeric!"
  }
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "owner" {
  type        = string
  description = "The squad that is owner of the source"
}

variable "asg_propagate_at_launch" {
  type        = bool
  default     = true
  description = "Enables propagation of the tag to Amazon EC2 instances launched via this ASG"
}

variable "name" {
  type        = string
  description = "A fallback value to define the Name tag of the calling module. If no tag is provided, it will use project_name"
  default     = "not informed"
}

variable "add_name_tag" {
  type        = bool
  description = "Defines if a Name tag should be added or not. If true and you don't provide a value for var.name, it will use it's default value."
}
