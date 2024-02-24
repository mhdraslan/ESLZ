$subscriptionId = "67236ec4-f453-4086-b4d1-78a6a93fad71"

$assignments = Get-AzPolicyAssignment -Scope "/subscriptions/$subscriptionId"
foreach($assignment in $assignments){
    $assignment | Select-Object -ExpandProperty Properties | Select-Object -Property scope,displayName,Parameters

}