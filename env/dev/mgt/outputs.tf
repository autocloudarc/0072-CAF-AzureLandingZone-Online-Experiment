output "rnd_str" {
  value       = random_string.rnd.result
  description = "Random string value for resource infix."
}

output "ipconfig_list" {
  value = module.net.ip_config_list 
  description = "Show list of NIC IP configurations."
}