variable "istio_system_namespace_tolerations" {
    default = "[]"
}
variable "istio_system_namespace_node_selector" {
    default = "priority=regular"
}
variable "istio_gateway_namespace_tolerations" {
    default = "[]"
}
variable "istio_gateway_namespace_node_selector" {
    default = "priority=regular"
}
variable "istio_discovery_node_selector_priority" {
    default = "regular"
}
variable "resource_group_name" {}
variable "location" {}
variable "ingress_subnet_id" {}
variable "private_gateway_reserved_ip" {}