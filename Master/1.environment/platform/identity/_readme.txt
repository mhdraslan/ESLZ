This template is for provisioning the base components that makes up a Routing Hub environment.
To use this template, create a paramters file and reference it in the Main.json template

The Template creates the following:
1. Identity Resource Group
2. Virtual network + Subnets (DcSubnet,CsSubnet,AadConnectSubnet,PrivEndpointSubnet)
3. Peering with Hub VNet
4. 2x DC virtual machines
5. Routing Tables linked to all subnets
6. NSG linked to all subnets



TODO
- 
