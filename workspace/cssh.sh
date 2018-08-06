#!/bin/bash

usage() {
  echo "Usage: $0 <terraform_output_name>"
}
[ $# -ne 1 ] && usage && exit 1
terraform_output_name=$1

ssh_targets_for() {
  local terraform_output_name=$1
  terraform output -json spacestest_ipv4_address_list | jq -r '.value|.[]' | sed 's/^/root@/'
}

cssh $(ssh_targets_for $terraform_output_name)

#cssh_as_root_to() {
  #local terraform_output_name=$1
  #ip_addresses=$(ips_for $terraform_output_name)
  #echo $ip_addresses
#}

#cssh_as_root_to_list() {
  #ip_address_list=( $(list_ips_for spacestest_ipv4_address_list) )
  #echo ${ip_address_list[@]}
#}

#droplet_ipv4_address_list=$(terraform output -json spacestest_ipv4_address_list | jq -r '.value|.[]')

#droplet_ipv4_address_list=$(terraform output -json spacestest_ipv4_address_list | jq -r '.value|.[]' | sed 's/^/root@/')
#echo $(list_ips_for spacestest_ipv4_address_list)
#cssh ${droplet_ipv4_address_list[@]}

#terraform output -json spacestest_ipv4_address_list | jq -r '.value|.[]' | sed 's/^/root@/' | xargs cssh

#droplet_ipv4_address_list=(
    #206.189.77.253
    #167.99.171.227
    #206.189.67.135
    #206.189.77.20
    #206.189.78.220
    #206.189.67.150
    #206.189.67.145
    #206.189.67.171
    #206.189.75.8
    #206.189.75.7
#)
  #terraform output -json spacestest_ipv4_address_list | jq -r '.value|.[]' | sed 's/^/root@/'
