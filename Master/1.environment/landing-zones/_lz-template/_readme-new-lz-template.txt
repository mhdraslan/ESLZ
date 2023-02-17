This template is for provisioning the base components that makes up a landing zone environment.
To use this template, create a paramters file and reference it in the new-lz-template.json template

The Template creates the following:
1. Virtual network resource group and resource
2. Subnets (Application Gateway subnet, and a 2 Virtual Routing Function (VRF) subnets)
3. Azure Monitor resource group and log analytics workspace (and DCR + DCE)
4. Key Vault resource group and resource
5. Recovery Services Vault resource group and resource
6. One or more virtual machines connected to the VRF subnets (optional)


TODO
- 
