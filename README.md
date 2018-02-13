# terraform-aws-ecs-consul-agents
Terraform Module to Deploy Consul and Helper agents
===========

A terraform module for deploying Docker Images for a Consul agent, a Registrator agent, and a sidecar health check container that Consul can use to run health checks.

This module is designed to be used in conjunction with the [ECS Module](https://github.com/terraform-community-modules/tf_aws_ecs/)

This module

- deploys consul containers on top of an existing ECS cluster
- Deploys registrator
- Deploys a health check container that Consul can use to mount and execute health checks using the Docker exec API. https://www.consul.io/docs/agent/checks.html

----------------------
#### Required
- `alb_log_bucket` - s3 bucket to send ALB Logs

#### Optional

- `cluster_size`  - Consul cluster size. This must be greater the 3, defaults to 3

Usage
-----

```hcl

```

Outputs
=======


Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)

License
=======


[MIT License](LICENSE)
