data "aws_region" "current" {
  current = true
}

data "aws_ecs_cluster" "current" {
  cluster_name = "${var.ecs_cluster}"
}

data "template_file" "consul" {
  template = "${file("${path.module}/templates/consul.json")}"

  vars {
    env                            = "${var.ecs_cluster}"
    definitions                    = "${join(" ", var.definitions)}"
    image                          = "${var.consul_image}"
    registrator_image              = "${var.registrator_image}"
    sidecar_image              = "${var.sidecar_image}"
    consul_memory_reservation      = "${var.consul_memory_reservation}"
    registrator_memory_reservation = "${var.registrator_memory_reservation}"
    sidecar_memory_reservation = "${var.sidecar_memory_reservation}"
    awslogs_group                  = "consul-agent-${var.ecs_cluster}"
    awslogs_stream_prefix          = "consul-agent-${var.ecs_cluster}"
    awslogs_region                 = "${data.aws_region.current.name}"
  }
}

# IAM Resources for Consul and Registrator Agents

data "aws_iam_policy_document" "consul_task_policy" {
  statement {
    actions = [
      "ec2:Describe*",
      "autoscaling:Describe*",
      "cloudwatch:PutMetricData",
      "ecs:DescribeClusters",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role_consul_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# End Data block

resource "aws_iam_role" "consul_task" {
  name_prefix        = "${replace(format("%.32s", replace("tf-agentTaskRole-${var.ecs_cluster}-", "_", "-")), "/\\s/", "-")}"
  path               = "${var.iam_path}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_consul_task.json}"
}

resource "aws_iam_role_policy" "consul_ecs_task" {
  name_prefix = "${replace(format("%.102s", replace("tf-agentTaskPol-${var.ecs_cluster}-", "_", "-")), "/\\s/", "-")}"
  role        = "${aws_iam_role.consul_task.id}"
  policy      = "${data.aws_iam_policy_document.consul_task_policy.json}"
}

resource "aws_ecs_task_definition" "consul" {
  family                = "consul-agent-${var.ecs_cluster}"
  container_definitions = "${data.template_file.consul.rendered}"
  network_mode          = "host"
  task_role_arn         = "${aws_iam_role.consul_task.arn}"

  volume {
    name      = "consul-config-dir"
    host_path = "/etc/consul"
  }

  volume {
    name      = "docker-sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "consul-check-definitions"
    host_path = "/consul_check_definitions"
  }
}

resource "aws_cloudwatch_log_group" "consul" {
  name = "${aws_ecs_task_definition.consul.family}"

  tags {
    Application = "${aws_ecs_task_definition.consul.family}"
  }
}

resource "aws_ecs_service" "consul" {
  name                               = "consul-agent-${var.ecs_cluster}"
  cluster                            = "${data.aws_ecs_cluster.current.arn}"
  task_definition                    = "${aws_ecs_task_definition.consul.arn}"
  desired_count                      = "${data.aws_ecs_cluster.current.registered_container_instances_count}"
  deployment_minimum_healthy_percent = "60"

  placement_constraints {
    type = "distinctInstance"
  }
}
