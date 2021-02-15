param name string
param port int {
  minValue: 1
  maxValue: 65536
  default: 80
}
param auth string
param reverse bool = false

var exposedPort = [
  {
    port: 80
    protocol: 'TCP'
  }
  {
    port: 443
    protocol: 'TCP'
  }
]

resource chisel 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: 'chisel'
        properties: {
          image: 'jpillora/chisel'
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          command: [
            'server'
            '--port'
            port
            '--auth'
            auth
            '${reverse ? '--reverse' : ''}'
          ]
          ports: exposedPort
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      ports: exposedPort
      type: 'Public'
    }
  }
}