# Azure Infrastructure

variable "resource_group" {
  type        = string
  description = "Azure resource group name"
}

variable "webapp_name" {
  type        = string
  description = "Name of the Azure Web App"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name (must be globally unique)"
}

# PostgreSQL

variable "pg_port" {
  type        = number
  description = "PostgreSQL database port"
}

variable "pg_name" {
  type        = string
  description = "PostgreSQL database name"
}

variable "pg_admin" {
  type        = string
  description = "PostgreSQL admin username"
}

variable "pg_password" {
  type        = string
  description = "PostgreSQL admin password"
  sensitive   = true
}

# Redis

variable "redis_name" {
  type        = string
  description = "Redis Cache name"
}
