# Endpoint for http REST endpoint
output "waps-http-endpoint" {
 value = "http://${module.waps_node.waps_node_public_ip}:${var.waps_port}" 
}

# Hostname for Web App server node
output "waps-node-hostname" {
  value = module.waps_node.name
}

# (c) 2022 MathWorks, Inc.
