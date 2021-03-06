param name string
param ipAllocation string {
  allowed: [
    'Static'
    'Dynamic'
  ]
  default: 'Static'
}
param ipAddrVersion string {
  allowed: [
    'IPv4'
    'IPv6'
  ]
  default: 'IPv4'
}
param subnetId string
param nsgId string

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: '${name}_IP'
  location: resourceGroup().location
  properties: {
    publicIPAddressVersion: ipAddrVersion
    publicIPAllocationMethod: ipAllocation
  }
}
resource createdNIC 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
      {
        name: '${name}_config'
        properties: {
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

output nic object = createdNIC