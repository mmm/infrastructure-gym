
# Stacks of Services

This is a user framework for assembling (and automating) DO resources into
cloud-based applications that follow enterprise-class requirements and
best-practices for availability, redundancy, security, manageability, etc.

The primary purpose of this atm is to provide a set of building blocks to
create realistic user infrastructure graphs of varying complexity against the
DO API.

These graphs are then analyzed (used to train ML algs) in hopes of better
understanding the behavior of infrastructure topology and configuration under
various loads and constraints.

This framework also serves as a sort of control plane by which user
infrastructure graphs can be automatically manipulated to better handle those
loads and constraints.

Examples are provided here to automate the buildout of
- web-servers / web-services at scale
- docker swarm
- k8s
- ...?


# Layers

It's best-practice to separate Terraform templates into separate layers each
with independent state storage/locking.

- core (account, state buckets, infrastructure buckets, tags, network config,
  project config, etc)
- support (jump boxes, dns/service discovery, auth, key mgmt, cert mgmt, etc)
- app (servers / workers)
- edge (lb, firewalls, network config)
- etc...


# TODO

This is all still WIP.

Development's roughly following:

- Terraform layers common to any applications
- Ansible roles common to any applications
- specialized Terraform layers needed for examples
- specialized Ansible roles needed for examples


## Tools

Need to simplify the `tf` utility.

Maybe break it up into what looks like subcommands?

specifically, a `layer` tool

    terraform layer <layer> <action>

or something more ideomatic than

    tf [-p <project>] [-e <environment>] [-u] <layer> <action>

and treat it more like a terraform plugin.
