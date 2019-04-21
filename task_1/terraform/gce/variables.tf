variable "zones" {
  type        = "list"
  description = "Up to 3 GCP availability zones to create VM instances (as HCL list)"
}

variable "env" {
  default = "dev"
}

variable "image_filter" {
  default = "apache-1555587131"
}

variable "instance_type" {
  description = "GCE instance type"
  default     = "n1-standard-1"
}

# Health checks parameters
variable "initial_delay" {
  description = "Period during which the instance to be initializing, sec"
  default     = 300
}

variable "readiness_timeout" {
  description = "Readiness health check timeout sec"
  default     = 5
}

variable "readiness_check_interval" {
  description = "Readiness health check interval sec"
  default     = 5
}

variable "readiness_healthy_threshold" {
  description = "Readiness consecutive successes required"
  default     = 2
}

variable "readiness_unhealthy_threshold" {
  description = "Readiness consecutive failures required"
  default     = 2
}

variable "liveness_timeout" {
  description = "Liveness health check timeout sec"
  default     = 5
}

variable "liveness_check_interval" {
  description = "Liveness health check interval sec"
  default     = 20
}

variable "liveness_healthy_threshold" {
  description = "Liveness consecutive successes required"
  default     = 2
}

variable "liveness_unhealthy_threshold" {
  description = "Liveness consecutive failures required"
  default     = 3
}

# Auto-scaling parameters
variable "min_instances" {
  description = "Number of instances"
  default     = 1
}

variable "max_instances" {
  description = "Max number of instances"
  default     = 5
}

variable "max_surge_percent" {
  description = "The maximum number of instances that can be created above the specified targetSize during the update process, percentage"
  default     = 33
}

variable "cooldown_period" {
  description = "Period to wait between changes"
  default     = 300
}

variable "cpu_utilization" {
  description = "Scalesen the cluster's average CPU is above or below a given threshold"
  default     = 0.75
}

# Application properties
variable "app_name" {
  default = "httpd"
}

variable "app_port" {
  default = "80"
}
