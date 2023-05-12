This template is for provisioning the base components that makes up a Routing Hub environment.
To use this template, create a paramters file and reference it in the Main.json template

The Template creates the following:
1. Management Resource Groups
1.1 Monitor RG
1.1.1 Monitor LAW
1.2 Recovery RG
1.3 Automation RG
1.3.1 Automation Account
1.4 Storage RG
1.4.1 Platform Data SA
1.4.2 Cloud Shell SA
1.5 Security RG
1.5.1 Security LAW
1.5.2 Platform Key Vault
1.6 Templates RG
2. Virtual network + Subnets (PrivateEndpointSubnet)
3. Peering with Hub VNet
4. 
5. Routing Tables linked to all subnets
6. NSG linked to all subnets

TODO
- Create a Management deployment template that calls the base LZ template then a Management specific ARM template which deployes services such as SA and LAW
- 
