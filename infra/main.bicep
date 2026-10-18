// Everything this site needs in Azure. Deployed by .github/workflows/infra.yml.

@description('Static Web Apps is only offered in a few regions; content is served globally either way.')
param location string = 'westus2'

param name string = 'swa-portfolio'

@description('Leave empty until the DNS record exists (build step 6), or the deployment waits and fails.')
param customDomain string = ''

resource site 'Microsoft.Web/staticSites@2023-12-01' = {
  name: name
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  // No repository link here: the site workflow pushes content with a deployment token.
  properties: {}
}

resource domain 'Microsoft.Web/staticSites/customDomains@2023-12-01' = if (!empty(customDomain)) {
  parent: site
  name: customDomain
  properties: {}
}

output defaultHostname string = site.properties.defaultHostname
