param name string
param dnsName string
param reverse bool = false
param userCA string
param serverKey string {
  secure: true
}
param serverCert string {
  secure: true
}

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
            '/app/chisel'
            'server'
            '-v'
            '--port'
            '443'
            '--tls-key'
            '/mnt/server_cert/key.pem'
            '--tls-cert'
            '/mnt/server_cert/cert.pem'
            '--tls-ca'
            '/mnt/user_ca'
            '${reverse ? '--reverse' : ''}'
          ]
          ports: [
            {
              port: 443
              protocol: 'TCP'
            }
          ]
          volumeMounts: [
            {
              name: 'server-cert'
              mountPath: '/mnt/server_cert'
              readOnly: true
            }
            {
              name: 'user-ca'
              mountPath: '/mnt/user_ca'
              readOnly: true
            }
          ]
        }
      }
    ]
    volumes: [
      {
        name: 'server-cert'
        secret: {
          'cert.pem': serverCert
          'key.pem': serverKey
        }
      }
      {
        name: 'user-ca'
        secret: {
          'aplqo_ca.pem': userCA
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      ports: [
        {
          port: 443
          protocol: 'TCP'
        }
      ]
      type: 'Public'
      dnsNameLabel: dnsName
    }
    restartPolicy: 'OnFailure'
  }
}