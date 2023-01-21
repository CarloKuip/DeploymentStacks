@maxLength(14)
@description('Name of the resulting storage account and derived resource names')
param storageName string = 'mystorageaccountwe'
@description('Target region name for deployment, for example: westeurope')
param targetRegion string = 'westeurope'
@description('Abbreviation of target region to use as resource suffix')
param targetRegionShortName string = 'we'

//The targetScope is set for a subscription-wide deployment
targetScope = 'subscription'

var rgName = '${storageName}-${targetRegionShortName}}'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01'={
  name: rgName
  location: targetRegion

}

module stack 'storage-stack.bicep' ={
  name: 'storage-stack-deployment'
  scope: rg
  params:{
    storageName: storageName
    targetRegion: targetRegion
    targetRegionShortName: targetRegionShortName
  }
}
