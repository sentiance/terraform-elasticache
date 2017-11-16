resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.environment}-${var.project}-${var.name}"
  replication_group_description = "Redis cluster for ${var.environment}-${var.project}-${var.name}"
  engine                        = "redis"
  engine_version                = "${var.engine_version}"
  port                          = "${var.port}"
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.num_cache_nodes}"
  parameter_group_name          = "${var.parameter_group_name}"
  security_group_ids            = ["${aws_security_group.sg_redis.id}"]
  subnet_group_name             = "${aws_elasticache_subnet_group.elasticache.id}"
  availability_zones            = "${var.availability_zones}"
  automatic_failover_enabled    = "${var.automatic_failover_enabled}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.environment}.${var.project}.${var.name}",
      "service", "${var.name}",
      "environment", "${var.environment}",
      "stack", "${var.project}"))
  }"

}

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.project}-${var.environment}-redis"
  description = "Our main group of subnets"
  subnet_ids  = ["${var.subnets}"]
}
