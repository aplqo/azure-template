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

resource createdNIC 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${name}_NIC'
  location: resourceGroup().location
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
      {
        properties: {
          primary: true
          publicIPAddress: {
            properties: {
              publicIPAllocationMethod: ipAllocation
              publicIPAddressVersion: ipAddrVersion
            }
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