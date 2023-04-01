param storageName string
param targetRegion string
param targetRegionShortName string

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' ={
  name: '${storageName}-${targetRegionShortName}-Identity'
  location: targetRegion
}

module kv 'keyvault.bicep' = {
  name: '${storageName}-KeyVault-deployment'
  params:{
    storageName: storageName
    targetRegion: targetRegion
    targetRegionShortName: targetRegionShortName
  }
}

module storage 'storage.bicep'={
  name: 'storage-deployment'
  params:{
    storageName: storageName
    targetRegion: targetRegion
    targetRegionShortName: targetRegionShortName
    keyVaultUri: kv.outputs.keyVaultUri
    keyEncryptionKeyName: kv.outputs.keyEncryptionKeyName
    managedIdentityName: mi.name
  }
}

module roleassignment 'role-assignment.bicep' ={
  name: 'key-vault-mi-role-assignemnt-deployment'
  params:{
    keyVaultName: kv.outputs.keyVaultName
    storageId: storage.outputs.storageResourceId
    managedIdentityId: mi.id
  }
}



