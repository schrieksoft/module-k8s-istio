
resource "azurerm_public_ip" "public_gateway" {
  name                = "istio-public-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_network_interface" "private_gateway" {
  name                = "istio-private-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.ingress_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_gateway_reserved_ip
  }
}

module istio {
  source = "github.com/schrieksoft/module-kustomization.git?ref=main"
  absolute_paths = [
    "${path.root}/manifests/istio-base",
    "${path.root}/manifests/istio-discovery",
    "${path.root}/manifests/istio-gateway",
    "${path.root}/manifests/istio-gateway-private"
    ]
  patches = [
    {
      patch = templatefile("${path.module}/patches/istio-base/namespace.yaml.tftpl",{
        namespace_tolerations = jsonencode(var.istio_system_namespace_tolerations)
        namespace_node_selector = jsonencode(var.istio_system_namespace_node_selector)
      })
    },

    // public gateway
    {
      patch = templatefile("${path.module}/patches/istio-gateway/namespace.yaml.tftpl",{
        namespace_tolerations = jsonencode(var.istio_gateway_namespace_tolerations)
        namespace_node_selector = jsonencode(var.istio_gateway_namespace_node_selector)
      })
    },

    {
      patch = templatefile("${path.module}/patches/istio-gateway/service.yaml.tftpl",{
        resource_group_name = var.resource_group_name
        public_ip = azurerm_public_ip.public_gateway.ip_address
      })
    },
    

    // private gateway
    {
      patch = templatefile("${path.module}/patches/istio-gateway-private/namespace.yaml.tftpl",{
        namespace_tolerations = jsonencode(var.istio_gateway_namespace_tolerations)
        namespace_node_selector = jsonencode(var.istio_gateway_namespace_node_selector)
      })
    },
    {
      patch = templatefile("${path.module}/patches/istio-gateway-private/service.yaml.tftpl",{
        private_ip = var.private_gateway_reserved_ip
      })
    },
  ]
}