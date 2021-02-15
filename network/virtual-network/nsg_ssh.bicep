param name string

resource createdNSG 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${name}_NSG'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          access: 'Allow'
          destinationPortRange: '22'
          protocol: 'Tcp'
          direction: 'Inbound'
        }
      }
    ]
  }
}

output nsg object = createdNSG