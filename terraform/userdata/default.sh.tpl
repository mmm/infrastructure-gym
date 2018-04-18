#!/bin/bash
#
# vim: ft=sh

apt-get -qqy update
apt-get -qqy install s3cmd ansible

stacks_dir="/tmp/stacks"
rm -Rf $${stacks_dir}
mkdir -p $${stacks_dir}
s3cmd \
  --access_key="${access_key}" \
  --secret_key="${secret_key}" \
  --host="${region}.digitaloceanspaces.com" \
  --host-bucket="%(bucket)s.${region}.digitaloceanspaces.com" \
  get s3://${bucket}/ansible/ansible.tar.gz - | tar xz -C $${stacks_dir}

export ANSIBLE_VAULT_PASSWORD="${ansible_vault_password}"
$${stacks_dir}/ansible/bin/provision "$@"
