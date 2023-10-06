$searchCriteria = "cnt*"

$mgs = Get-AzManagementGroup
foreach($mg in $mgs){
    Get-AzManagementGroupDeployment -ManagementGroupId $mg.Name | Remove-AzManagementGroupDeployment -AsJob
}


$subs = Get-AzSubscription
foreach($sub in $subs){
    Select-AzSubscription $sub.Id
    Get-AzSubscriptionDeployment | Remove-AzSubscriptionDeployment -AsJob
    Get-AzResourceGroup | ?{$_.ResourceGroupName -like $searchCriteria} | Remove-AzResourceGroup -AsJob -Force
}
