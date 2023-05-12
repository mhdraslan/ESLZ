This template is for provisioning the base components that makes up the Hub environment.

To use this template, create a paramters file and reference it in the Main.json template

The Template creates the following:
1. Connectivity Resource Groups
1.1 Hub RG
1.2 Private DNS Zones RG
2. Virtual network + Subnets (Gateway subnet, Shared Services subnet, Azure Firewall subnet, Azure Bastion subnet)
3. 2x DNS virtual machines connected to the main Hub VNet
4. VPN Gateway
5. Routing Tables linked to the Gateway and SharedServices subnet
6. NSG linked to SharedServices subnet
7. Azure Firewall
8. Azure Bastion

TODO
- 