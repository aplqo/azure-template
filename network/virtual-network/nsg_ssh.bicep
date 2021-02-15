param name string

resource createdNSG 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '22'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          direction: 'Inbound'
          priority: 100
        }
      }
    ]
  }
}

output nsg object = createdNSG