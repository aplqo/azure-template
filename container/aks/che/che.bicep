param name string
param dnsName string

resource cheCluster 'Microsoft.ContainerService/managedClusters@2020-11-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    agentPoolProfiles: [
      {
        count: 1
        name: 'agentpool'
        osDiskSizeGB: 64
        osType: 'Linux'
        vmSize: 'Standard_F8s_v2'
      }
    ]
  }
}
resource dnsZone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: dnsName
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}
resource dnsRecord 'Microsoft.Network/dnszones/A@2018-05-01' = {
  name: '${dnsName}/*'
  properties: {
    TTL: 86400
    targetResource: {
      id: cheCluster.properties.networkProfile.loadBalancerProfile.effectiveOutboundIPs[0].id
    }
  }
}