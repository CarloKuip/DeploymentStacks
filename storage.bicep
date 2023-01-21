param storageName string
param targetRegion string
param managedIdentityName string
param keyVaultUri string
param keyEncryptionKeyName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing={
  name: managedIdentityName
}

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' ={
  name: storageName
  kind: 'StorageV2'
  location: targetRegion
  sku: {
    name: 'Standard_LRS'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities:{
      '${managedIdentity.id}' : {}
    }
  }
  properties:{
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Enabled'
    encryption:{
      identity: {
        userAssignedIdentity: managedIdentity.id
      }
      keySource:'Microsoft.Keyvault'
      keyvaultproperties:{
        keyname: keyEncryptionKeyName
        keyvaulturi: keyVaultUri
      }
    }
  }
}

output storageResourceId string = storage.id
