$deploymentName = ""
$templateUri = ""
$resourceGroupName = ""
New-AzSubscriptionDeployment -Name $deploymentName `
                             -Location uaenorth `
                             -TemplateUri $templateUri `
                             -resourceGroupName $resourceGroupName `
                             -Verbose
