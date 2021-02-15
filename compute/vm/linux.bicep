param name string
param image object
param size string = 'Standard_F8s_v2'
param nicId string
param publicKey array

resource linuxVM 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: '${name}_VM'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: size
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
          properties: {
            primary: true
          }
        }
      ]
    }
    osProfile: {
      adminUsername: 'aplqo'
      computerName: name
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: publicKey
        }
      }
    }
    storageProfile: {
      imageReference: image
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
        diskSizeGB: 32
        osType: 'Linux'
      }
    }
  }
}

output vm object = linuxVM