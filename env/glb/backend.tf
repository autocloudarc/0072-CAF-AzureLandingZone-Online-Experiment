// backend state file
/*
terraform {
  backend "azurerm" {
      resource_group_name = "tf-<rnd>-rgp-01"
      storage_account_name = "1tfm<rnd>"
      container_name = "dev-tfstate"
      key = "dev.tfstate"
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "autocloudarc"
    workspaces {
      name = "cli-azr-dev-0072-all"
    }
  }
}
*/
