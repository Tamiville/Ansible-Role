locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "Devops"
    Owner       = "Tamiville"
    environment = "Development"
    Company     = "Elitesolutionsit"
    ManagedWith = "Terraform"
  }
  buildregion             = lower("CENTRALUS")
  server                  = "elite"
  elite_general_resources = "elite-vm-dev"
}