param name string
param publicKey array

module vnet './network/virtual-network/virtualNetwork.bicep' = {
  name: '${name}_vnet_deploy'
  params: {
    name: name
  }
}
module nsg './network/virtual-network/nsg_ssh.bicep' = {
  name: '${name}_nsg_deploy'
  params: {
    name: name
  }
}
module nic './network/virtual-network/nic_ip.bicep' = {
  name: '${name}_nic_deploy'
  params: {
    name: name
    subnetId: vnet.outputs.vnet.properties.subnets[0].id
    nsgId: nsg.outputs.nsg.id
  }
}
module vm './compute/vm/linux.bicep' = {
  name: '${name}_vm_deploy'
  params: {
    name: name
    nicId: nic.outputs.nic.id
    publicKey: publicKey
  }
}