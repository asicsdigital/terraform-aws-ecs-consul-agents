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
- `ecs_cluster` - EC2 Container Service cluster in which the service will be deployed (must already exist, the module will not create it).


#### Optional

- `consul_image` - Image to use when deploying consul, defaults to the hashicorp consul image
- `consul_memory_reservation` - The soft limit (in MiB) of memory to reserve for the container, (defaults 32)
- `definitions` - List of Consul Service and Health Check Definitions
- `sidecar_image` - Image to use when deploying health check agent, defaults to fitnesskeeper/consul-sidecar:latest image
- `sidecar_memory_reservation` - The soft limit (in MiB) of memory to reserve for the container, defaults 32
- `iam_path` - IAM path, this is useful when creating resources with the same name across multiple regions. (Defaults to /)
- `registrator_image` - Image to use when deploying registrator agent, defaults to the gliderlabs registrator:latest image
- `registrator_memory_reservation` The soft limit (in MiB) of memory to reserve for the container, defaults 32

Usage
-----

```hcl

module "consul-infra-svc-pub" {
  source      = "../modules/terraform-aws-ecs-consul-agents"
  ecs_cluster = "${module.infra-svc-pub.cluster_name}"
  definitions = ["ecs-cluster"]
}

```

Outputs
=======


Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)

License
=======


[MIT License](LICENSE)
