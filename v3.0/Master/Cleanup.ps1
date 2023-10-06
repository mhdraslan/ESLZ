$searchCriteria = "cnt*"


$mgs = Get-AzManagementGroup
foreach($mg in $mgs){
    Get-AzManagementGroupDeployment -ManagementGroupId $mg.Name | Remove-AzManagementGroupDeployment -AsJob
}


$subs = Get-AzSubscription
foreach($sub in $subs){
    Get-AzSubscriptionDeployment -Id $sub.Id | Remove-AzSubscriptionDeployment -AsJob
    Get-AzResourceGroup | ?{$_.ResourceGroupName -like $searchCriteria} | Remove-AzResourceGroup -AsJob -Force
}



