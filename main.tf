


module istio {
  source = "github.com/schrieksoft/module-kustomization.git?ref=main"
  absolute_paths = [
    "${path.root}/manifests/istio-base",
    "${path.root}/manifests/istio-discovery",
    "${path.root}/manifests/istio-gateway"
    
    ]
  patches = [
    {
      patch = templatefile("${path.module}/patches/istio-base/namespace.yaml.tftpl",{
        namespace_tolerations = jsonencode(var.istio_system_namespace_tolerations)
        namespace_node_selector = jsonencode(var.istio_system_namespace_node_selector)
      })
    },
    {
      patch = templatefile("${path.module}/patches/istio-gateway/namespace.yaml.tftpl",{
        namespace_tolerations = jsonencode(var.istio_gateway_namespace_tolerations)
        namespace_node_selector = jsonencode(var.istio_gateway_namespace_node_selector)
      })
    },
  ]
}