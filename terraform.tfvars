principal_id = "PsU8Q~1BFwrccVBglxnShGdJwlr3UCBPJnJA3alW"
location            = "southcentralus"
resource_group_name = "candidate"
tags = {
  terraform = "true"
  team      = "cloudops"
  app       = "interview"
}
#VNet
net_name = "Healthcare_bluebook_network"
net_add_space = ["10.0.0.0/16"]
subnet_name = "Healthcare_bluebook_subnet"
add_prefixes = ["10.0.1.0/24"] 
route_table_id = "/subscriptions/001c2e7e-e94e-4804-a374-ce90121a8c3a/resourceGroups/candidate/providers/Microsoft.Network/routeTables/Healthcare_bluebook_route_table"
pip_name = "Hb_public_ip"
allocation_method = "Static"
domain_name_label = "myhealthcarebluebook"
subnet_id = "/subscriptions/001c2e7e-e94e-4804-a374-ce90121a8c3a/resourceGroups/candidate/providers/Microsoft.Network/virtualNetworks/Healthcare_bluebook_network/subnets/Healthcare_bluebook_subnet"

#VM
vm_name = "Hb-vm"
vm_size = "Standard_B1ms"
admin_username = "anthony"
offer = "UbuntuServer"
publisher = "Canonical"

#Network_Security_Group
security_rules = [
  {
    name                        = "allow-http"
    description                 = "Allow HTTP traffic"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    // Leave the lists empty or omit if not used
    destination_port_ranges     = []
    source_address_prefixes     = []
    destination_address_prefixes = []
  },
  {
   name                        = "allow-https"
    description                 = "Allow HTTPS traffic"
    priority                    = 110
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    // Leave the lists empty or omit if not used
    destination_port_ranges     = []
    source_address_prefixes     = []
    destination_address_prefixes = [] 
  }
]

#LoadBalancer
public_ip_address_id = "/subscriptions/001c2e7e-e94e-4804-a374-ce90121a8c3a/resourceGroups/candidate/providers/Microsoft.Network/publicIPAddresses/Hb_public_ip"
backend_address_pools_id = ["/subscriptions/001c2e7e-e94e-4804-a374-ce90121a8c3a/resourceGroups/candidate/providers/Microsoft.Network/loadBalancers/Hb-load-balancer/backendAddressPools/hb-backend"]

#Frontdoor
frontdoor_name = "hb-frontdoor"
response_timeout_seconds = 100
frontdoor_endpoint_name = "Hb-Frontdoor-Endpoint"
origin_group_name_fe = "Hb-frontdoor-fe-origin-group"
origin_name_fe = "frontdoor-frontend-origin"
route_name_fe = "frontdoor-frontend-route"
#frontdoor_custom_domain_ids = ["/subscriptions/001c2e7e-e94e-4804-a374-ce90121a8c3a/resourceGroups/candidate/providers/Microsoft.Cdn/profiles/hb-frontdoor/customDomains/myhealthcarebluebook.southcentralus.cloudapp.azure.com",]

#Storage Account
storage_account_name = "hbstorageacct"
account_replication_type = "GRS"
account_kind = "StorageV2"
host_name_fe = "hbstorageacct.blob.core.windows.net"
container_name = "hb-frontend"
container_access_type = "private"
