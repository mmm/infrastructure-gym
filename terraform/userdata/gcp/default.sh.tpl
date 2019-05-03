#!/bin/bash
#
# vim: ft=sh

export DEBIAN_FRONTEND=noninteractive
apt-get -qqy update
apt-get -qqy install ansible

stacks_dir="/tmp/stacks"
rm -Rf $${stacks_dir}
mkdir -p $${stacks_dir}
gsutil cp gs://${bucket}/infrastructure/${project}/${environment}/ansible/ansible.tar.gz - | tar xz -C $${stacks_dir}

$${stacks_dir}/ansible/bin/provision \
  -p"${project}" \
  -e"${environment}" \
  -o"${ansible_role}" \
  -r"${region}" \
  -v"${ansible_vault_password}"
