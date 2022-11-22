This template is for provisioning the base components that makes up a Routing Hub environment.
To use this template, create a paramters file and reference it in the Main.json template

The Template creates the following:
1. Resource Group
2. 3x Virtual network
2.1. Hub VNet (Gateway subnet + Virtual Machines subnet)
2.2. Firewall VNet ( Azure Firewall subnet)
2.3. Routing VNet (Routing subnet)
3. One or more virtual machines connected to the main Hub VNet
4. VPN Gateway
5. Routing Table linked to the Gateway subnet
6. Azure Firewall deployed into the Firewall VNet



TODO
- 
