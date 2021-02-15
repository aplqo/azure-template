param name string
param size string = 'Standard_F8s_v2'
param publicKey array

var resourceIdPrefix = '${subscription().id}/resourceGroups/${resourceGroup().name}/providers'

module vnet './network/virtual-network/virtualNetwork.bicep' = {
  name: '${name}_vnet_deploy'
  params: {
    name: '${name}_vnet'
  }
}
module nsg './network/virtual-network/nsg_ssh.bicep' = {
  name: '${name}_nsg_deploy'
  params: {
    name: '${name}_NSG'
  }
}
module nic './network/virtual-network/nic_ip.bicep' = {
  name: '${name}_nic_deploy'
  params: {
    name: '${name}_NIC'
    subnetId: '${resourceIdPrefix}/${vnet.outputs.vnet.resourceId}/subnets/${vnet.outputs.vnet.properties.subnets[0].name}'
    nsgId: '${resourceIdPrefix}/${nsg.outputs.nsg.resourceId}'
  }
}
module vm './compute/vm/linux.bicep' = {
  name: '${name}_vm_deploy'
  params: {
    name: name
    size: size
    nicId: '${resourceIdPrefix}/${nic.outputs.nic.resourceId}'
    publicKey: publicKey
  }
}
