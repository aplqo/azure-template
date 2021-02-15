param name string
param image object
param publicKey array

resource virtNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: '${name}_vnet'
  location: resourceGroup().location
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
    subnetId: virtNetwork.properties.subnets[0].id
    nsgId: nsg.outputs.nsg.id
  }
}
module vm './compute/vm/linux.bicep' = {
  name: '${name}_vm_deploy'
  params: {
    name: name
    image: image
    nicId: nic.outputs.nic.id
    publicKey: publicKey
  }
}