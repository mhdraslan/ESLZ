This template is for provisioning the base components that makes up a Project environment.
To use this template, create a paramters file and reference it in the Main.json template

The Template creates the following:
1. Resource Group
2. Virtual network
3. Subnets (Application Gateway subnet, and a 2 Virtual Routing Function (VRF) subnets)
4. One or more virtual machines connected to the VRF subnets
5. Application Gateway + WAF


TODO
- Create an Environment Function to connect On-Premises network to Hub network
