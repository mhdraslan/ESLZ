
Connect-AzAccount

New-AzResourceGroupDeployment -ResourceGroupName AZ700RGlod44488798 -Name BuildLz -TemplateFile .\template.json -TemplateParameterFile .\parameters.json -Verbose
