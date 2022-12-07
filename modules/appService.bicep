param location string = resourceGroup().location
param appServiceAppName string
param appServicePlanName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
  kind: 'app'
  properties: {
    reserved: false
    isXenon: false
  }
}

resource appServiceApp 'Microsoft.Web/sites@2018-02-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName