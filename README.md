# aws-tagging

A Terraform module to apply AWS tagging in a standardized way.

## Introduction

Tagging resources at AWS sometimes is a feature put aside compared to other
duties to be carried out. But tagging not only makes your resources easier to
understand, but also allow you to make much better automation by making usage
of the metadata or help you to have better cost reports.

This Terraform modules tries to applies best practices and make it easier to
tagging in a standardized way.

## Features

* Make uses of a prefix to build all tags keys.
* Exports tags as outputs for usage.
* Flexible `Name` tag generation.
* Validation of input variables.
* Generate tags as a `map` and also tags (`asg_tags`) that can be consumed by
Auto Scaling Groups.

## Requirements

Terraform v0.14 or higher.

## How to use it

1. `git clone` this repository, and edit the `variables.tf` and `outputs.tf`
files as required to implement your own tags.
2. Import the module into your other resource modules.
3. Pass all required input variables.
4. Use the module outputs (`tags` and `asg_tags`).
5. [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).

### Example

For an EC2 instance module:

```terraform
module "common_tags" {
  source       = "../../..modules/tags"
  environment  = var.environment
  project_name = var.project_name
  owner        = var.my_team
  add_name_tag = false
  tag_prefix   = var.my_company
  repository   = var.my_git_repo
}

# latter
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.jenkins.id
  instance_type = "t2.small"
  key_name      = var.key_pair_name
  tags          = merge(module.common_tags.tags, {Name = "LittleJenkins"})
}
```

### `name` and `add_name_tag` input variables

One can use those variables combined in order to enable/disable adding a `Name`
tag on the resource.

* if `name` is informed, a `Name` tag with the informed value will be added to
the resource only if `add_name_tag` is `true`.
* if `name` is not informed, the `project_name` value will be used instead, if
`add_name_tag` is `true`, with the `Name` tag.

## References

* [Tagging AWS resources](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html)
* [Tagging Best Practices](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.pdf)
