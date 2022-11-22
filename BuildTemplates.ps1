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
$DeploymentSubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$ConnectivitySubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$IdentitySubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$ManagementSubscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"
$Deploymentlocation = "eastus"
$TemplateBaseUri = "https://raw.githubusercontent.com/mhdraslan/ESLZ/main/Working"

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
$SubstitutionTable = @()
$SubstitutionTable += ,("<<location>>",$Deploymentlocation)
$SubstitutionTable += ,("<<connectivitySubscriptionId>>",$ConnectivitySubscriptionId)
$SubstitutionTable += ,("<<identitySubscriptionId>>",$IdentitySubscriptionId)
$SubstitutionTable += ,("<<managementSubscriptionId>>",$ManagementSubscriptionId)
$SubstitutionTable += ,("<<TemplatesBase>>",$TemplateBaseUri)
#endregion
# ////////////////////////////////////////////////////////////////////////

# Create Param Files
$WorkingFolderExists = Test-Path -Path ".\Working"
if(!$WorkingFolderExists){
    New-Item -Name "Working" -ItemType Directory
}
Write-Host "Copying master ARM templates to working ditectory..." -ForegroundColor Yellow -BackgroundColor Black
Copy-Item -Path ".\Master\*" -Destination ".\Working" -Force -Recurse

# Update Templates Base URI and setup templates
$Templates = Get-ChildItem -Path ".\Working" -Recurse -File

# Create Param Files
Write-Host "Replacing tags in ARM templates..." -ForegroundColor Yellow -BackgroundColor Black
ForEach ($Template in $Templates){
	Replace-Tag $SubstitutionTable $Template.FullName
}
