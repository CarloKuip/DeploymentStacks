param storageName string
param targetRegion string
param targetRegionShortName string

var keyVaultName = '${storageName}-kv-${targetRegionShortName}'

resource kv 'Microsoft.KeyVault/vaults@2022-07-01'={
  name: keyVaultName
  location: targetRegion
  properties:{
    sku:{
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
  }
}

var keyName = '${storageName}-encryption-key'

resource keyEncryptionKey 'Microsoft.KeyVault/vaults/keys@2022-07-01' ={
  name: keyName
  parent: kv
  properties:{
    attributes:{
      enabled: true
      exp: 1705851748  // use Pws DateTime.AddDays(365) %u or on Mac date -v +365d +%s
      exportable: false
    }
    curveName: 'P-256K'
    keySize: 4096
    keyOps: [
      'wrapKey'
      'unwrapKey'
    ]
    kty: 'RSA'
    rotationPolicy: {
      attributes:{
        expiryTime: 'P11M'
      }
      lifetimeActions: [
        {
          action: {
            type: 'rotate'
          }
          trigger: {
            timeBeforeExpiry: 'P1D'
          }
        }
      ]
    }
  }
}

output keyVaultName string = kv.name
output keyVaultUri string = kv.properties.vaultUri
output keyEncryptionKeyName string = keyEncryptionKey.name
