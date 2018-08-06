# Setup

## Environment

In the `workspace` directory, copy `envrc.template` to `.envrc` and fill in
your own info.  Git will ignore this new file to keep your credentials safe.

## Slurp in the new environment

If you use `direnv`, you might have to cd out and back into the workspace
directory.  Alternatively, you should be able to always

    source .envrc


## SSH config

Add ssh public keys to your account via the cloud management console.  Then, in
the workspace directory, copy `terraform.tfvars.template` to `terraform.tfvars`
and add the fingerprints to your keys in place of the examples shown.  Git will
ignore this new file.


# Create some test droplets

## create a tarball for ansible

    make
    make publish

## init and run terraform

### setup `core`

    bin/tf -l core -a plan
    bin/tf -l core -a apply

### build the `support` layer

    bin/tf -l support -a plan
    bin/tf -l support -a apply

## check out your droplets

ssh to the "jump" droplet's IP addresses listed in the outputs of the `apply`
command for the `support` layer above.

## tear it all down

Reverse out your layers

    bin/tf -l support -a destroy
    bin/tf -l core -a destroy

