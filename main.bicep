@minLength(3)
@maxLength(22)
@description('Name of the resulting storage account and derived resource names')
param storageName string = 'mystorageaccount'
@description('Target region name for deployment, for example: westeurope')
param targetRegion string = 'westeurope'
@maxLength(2)
@description('Abbreviation of target region to use as resource suffix')
param targetRegionShortName string = 'we'
@description('A unique name to track deployment activity, default storage-stack-deployment-<utcNow()>')
param stackDeploymentName string = 'storage-stack-deployment-${utcNow()}'

//The targetScope is set for a subscription-wide deployment in order to later switch to rg scope
targetScope = 'subscription'

var rgName = '${storageName}-${targetRegionShortName}'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01'={
  name: rgName
  location: targetRegion

}

module stack 'storage-stack.bicep' ={
  name: stackDeploymentName
  scope: rg
  params:{
    storageName: storageName
    targetRegion: targetRegion
    targetRegionShortName: targetRegionShortName
  }
}
