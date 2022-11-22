<# 
 .SYNOPSIS 
    Build Azure Environment using pre-defined ARM templates 
 .DESCRIPTION 
    This script is launcher for a series of ARM templates which will build predefined set of resource groups, 
    virtual networks, VPN gateway and connections, and number of virtual machines.
 .NOTES 
    Author  : Muhammad Raslan (mraslan@microsoft.com) 
    Requires: Az Module
#>


#region Global Variables
$AADTenantId = "9def2203-d472-4e2e-af0d-19db3f40aac6"
$DeploymentSubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$ConnectivitySubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$IdentitySubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$ManagementSubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$TemplatesRGName = "buildrg"
$TemplatesSGName = "cnxgaenbuildsg5" # must be globally unique name
$Deploymentlocation = "eastus"
$environmentName = "CloudNXG" # Only upper and lower characters and space
$EnvironmentCode = "cnxg"
$EnvironmentlocationCode = "ae"

#endregion

#region Functions
function Replace-Tag ($SubTable, $TemplatePath)
{
	For ($index=0;  $index -lt $SubTable.Count)
	{
		$SearchFor = $SubTable[$index][0]
		$ReplaceBy = $SubTable[$index][1]
		(Get-Content $TemplatePath) -replace $SearchFor, $ReplaceBy | Set-Content $TemplatePath
		$index++
	}
}
#endregion

# ////////////////////////////////////////////////////////////////////////
#region Substitution Table
$RGBaseName = "$EnvironmentlocationCode-$EnvironmentCode"
$SubstitutionTable = @()
$SubstitutionTable += ,("<<location>>",$Deploymentlocation)
$SubstitutionTable += ,("<<connectivitySubscriptionId>>",$ConnectivitySubscriptionId)
$SubstitutionTable += ,("<<identitySubscriptionId>>",$IdentitySubscriptionId)
$SubstitutionTable += ,("<<managementSubscriptionId>>",$ManagementSubscriptionId)



#endregion
# ////////////////////////////////////////////////////////////////////////

# Record Start Time
$Now = Get-Date
[datetime]$Start = $Now
Write-Host "Starting operation at $Now" -ForegroundColor Yellow -BackgroundColor Black


# Create Param Files
$WorkingFolderExists = Test-Path -Path ".\Working"
if(!$WorkingFolderExists){
    New-Item -Name "Working" -ItemType Directory
}
Write-Host "Copying master ARM templates to working ditectory..." -ForegroundColor Yellow -BackgroundColor Black
Copy-Item -Path ".\Master\*" -Destination ".\Working" -Force -Recurse

# Connect to Azure
Write-Host "Connecting to Azure..." -ForegroundColor Yellow -BackgroundColor Black
$AzContext = Get-AzContext
if($AzContext.Tenant.Id){
    Write-Host "Using existing Azure connection context: $($AzContext.Account.Id)" -ForegroundColor Yellow -BackgroundColor Black
}else{
    Login-AzAccount -TenantId $AADTenantId
}

Write-Host "Selecting subscription..." -ForegroundColor Yellow -BackgroundColor Black
Select-AzSubscription -SubscriptionName $DeploymentSubscriptionId

$BuildRG = Get-AzResourceGroup -Name $TemplatesRGName -ErrorAction SilentlyContinue
if(!$BuildRG){
    Write-Host "Creating a new resource group for ARM templates..." -ForegroundColor Yellow -BackgroundColor Black
    New-AzResourceGroup -Name $TemplatesRGName -location $Deploymentlocation
}

# Create Storage Account Container
$DeploymentContainer = "$environmentName-Templates-$($Now.ToString("yyyyMMddHHmmss"))"
$DeploymentContainer = $($($DeploymentContainer.ToLower()).Replace(' ',''))
$TemplatesStorageAccount = Get-AzStorageAccount -resourceGroupName $TemplatesRGName

if(!$TemplatesStorageAccount){
    Write-Host "Creating a new storage account for ARM templates..." -ForegroundColor Yellow -BackgroundColor Black
    New-AzStorageAccount -resourceGroupName $TemplatesRGName -location $Deploymentlocation -Name $TemplatesSGName -SkuName Standard_LRS -EnableHttpsTrafficOnly $true -MinimumTlsVersion TLS1_2
    $TemplatesStorageAccount = Get-AzStorageAccount -resourceGroupName $TemplatesRGName
}

try{
    Write-Host "Creating a new storage container for ARM templates..." -ForegroundColor Yellow -BackgroundColor Black
    New-AzStorageContainer -Name $DeploymentContainer -Permission Blob -Context $TemplatesStorageAccount.Context -ErrorAction Continue
}
catch{
   Write-Host $Error 
   exit
}

# Update Templates Base URI and setup templates
$TemplateBaseUri = "https://" + $TemplatesStorageAccount.StorageAccountName + ".blob.core.windows.net/" + $DeploymentContainer.ToLower()
$SubstitutionTable += ,("<<TemplatesBase>>",$TemplateBaseUri)

$Templates = Get-ChildItem -Path ".\Working" -Recurse -File

# Create Param Files
Write-Host "Replacing tags in ARM templates..." -ForegroundColor Yellow -BackgroundColor Black
ForEach ($Template in $Templates){
	Replace-Tag $SubstitutionTable $Template.FullName
}

# Upload templates to Azure Storage Account
Write-Host "Uploading ARM templates to storage container..." -ForegroundColor Yellow -BackgroundColor Black
$currentDir = Get-Item "./"

ForEach ($Template in $Templates){
    $blobName = $Template.FullName.Substring($currentDir.FullName.Length+9)

    Set-AzStorageBlobContent -File $Template.FullName`
    -Container $DeploymentContainer.ToLower()`
    -Blob $BlobName `
    -Context $TemplatesStorageAccount.Context -Force
}

# Create Resource Groups
$Now = Get-Date


Write-Host "Initiating deployment..." -ForegroundColor Yellow -BackgroundColor Black
$DeploymentName = $environmentName + " -Environment-Deployment-" + $Now.ToString("yyyyMMddHHmmss")
$MainTemplateUri = $TemplateBaseUri + "/main.json"
$MainParamsUri = $TemplateBaseUri + "/main.param.json"
$rgDeployment = New-AzSubscriptionDeployment -Name $DeploymentName.Replace(" ","") -location $Deploymentlocation -TemplateUri $MainTemplateUri -TemplateParameterUri $MainParamsUri -verbose
$rgDeployment.Outputs.rgName.Value


[datetime]$Finish = Get-Date
Write-Host "Operation completed at $Now" -ForegroundColor Yellow -BackgroundColor Black
$Total = $Finish - $Start
$Total

