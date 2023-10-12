$deploymentName = "SBC-Core-Deployment"
$templateUri = "https://raw.githubusercontent.com/mhdraslan/ESLZ/main/SBC/SBC.json"
$resourceGroupName = "rg-MS_Teams_DR-uaen-Prod-01"
New-AzSubscriptionDeployment -Name $deploymentName `
                             -Location uaenorth `
                             -TemplateUri $templateUri `
                             -resourceGroupName $resourceGroupName `
                             -Verbose
