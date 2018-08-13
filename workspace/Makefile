default: tarball

tarball: ansible.tar.gz

ansible.tar.gz:
	tar czf ansible.tar.gz --exclude=tmp ../ansible

publish: ansible.tar.gz
	. ./.envrc
	s3cmd --access_key="${TF_VAR_aws_access_key_id}" --secret_key="${TF_VAR_aws_secret_access_key}" --host="${TF_VAR_region}.digitaloceanspaces.com" --host-bucket="%(bucket)s.${TF_VAR_region}.digitaloceanspaces.com" rm s3://${TF_VAR_stack_state_bucket}/ansible/ansible.tar.gz
	s3cmd --access_key="${TF_VAR_aws_access_key_id}" --secret_key="${TF_VAR_aws_secret_access_key}" --host="${TF_VAR_region}.digitaloceanspaces.com" --host-bucket="%(bucket)s.${TF_VAR_region}.digitaloceanspaces.com" put ansible.tar.gz s3://${TF_VAR_stack_state_bucket}/ansible/ansible.tar.gz

clean:
	rm -f ansible.tar.gz

distclean: clean
