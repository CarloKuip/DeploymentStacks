param storageId string
param managedIdentityId string
param keyVaultName string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing={
  name: keyVaultName
}

var roledefinitionId = 'e147488a-f6f5-4113-8e2d-b22465e65bf6' //key vault crypto svc encryption user
var roleAssignmentName = guid(storageId, managedIdentityId, roledefinitionId)

resource ra 'Microsoft.Authorization/roleAssignments@2022-04-01' ={
  name: roleAssignmentName
  scope: kv
  properties:{
    principalId: managedIdentityId
    roleDefinitionId: roledefinitionId
    principalType: 'ServicePrincipal'
  }
}
