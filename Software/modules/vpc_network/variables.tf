# GCP project name
variable "project" {
  description = "ProjectID"
  default = ""
}

# Tag to uniquely name resources
variable "tag" {
  description = "A prefix to make resource names unique"
  default=""
}

# firewall target network tags for vm
variable "network_tags" {
  default = ["waps"]
  description = "Target Network tags"
}

# WAPS port
variable "waps_port" {
  type=string
  description = "Web App Server port receiving requests"
}

# Client IPs
# change this to the range specific to your organization
variable "allowclientip" {
  type = list(string)
  description = "Add IP Ranges that would connect/submit job"
}

# (c) 2022 MathWorks, Inc.
