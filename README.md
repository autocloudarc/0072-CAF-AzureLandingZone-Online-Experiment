# Introduction

This project is an experiment to deploy an IaaS based Online application to the online subscription of a Cloud Adoption Framework Azure Landing Zone using Terraform

## Project Objectives

This is really just an experiment for us which aims to establish a basic framework based on my current perception of Terraform best practices (Personally, I just started learning Terraform in December 2021, so as I learn of other or better best practices, our experiment here will evolve based on the principles of continuous improvement ('kaizen', 'kanban', and 'ikigai' for my Japanese or DevOps oriented readers!) ;-).

## Getting Started

To start using this project, we recommend cloning it to your local system, set up your Terraform directory structure, create your backend state file out-of-band (i.e. in an Azure storage account and container), and set your logging environment variables for the log level and path.

## How to execute Terraform Plans with CLI variable override values

Due to the sensitivity of the tenant id and KeyVault resource id values, use the following example to override and specify your own custom values for your environment

1. terraform apply -var tenant_id="<your-actual-tenant-id>" -var kvt_res_id="<your-actual-keyvault-resource-id>"

## Target State Diagram

![_Figure: Target State Diagram_](./doc/images/0072-tsd-diagram.png "TSD")

## Contribute

Please feel free to get involved by reporting problems, suggest ideas or improve this project by making the code better.
To report problems and suggest ideas, please create an issue for this script, which will ensure that it is properly addressed.
For contributing to this project, please follow the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/) for coding/testing practices and pull request requirements.
This project is released under the [MIT license](https://mit-license.org/).

## References

1. [Terraform Intro] (<https://www.terraform.io/intro/>)
2. [Terraform Tutorials] (<https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/azure-get-started>)
3. [stackoverflow] (<https://stackoverflow.com/questions/66024950/how-to-organize-terraform-modules-for-multiple-environments/>)
4. [Terraform Best Practices - Jack Roper](<https://medium.com/codex/terraform-best-practices-how-to-structure-your-terraform-projects-b5b050eab554/>)