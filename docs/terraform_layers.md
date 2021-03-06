
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


## Providers

- do
- k8s

## Layers

It's best-practice to separate Terraform templates into separate layers
organized by provider.  Each layer has independent state storage/locking.

- `do/core` (account, state buckets, infrastructure buckets, tags, network config,
  project config, etc)
- `do/support` (jump boxes, dns/service discovery, auth, key mgmt, cert mgmt, etc)
- `do/k8s-control-plane`
- `do/k8s-minions`
- `do/app` (servers / workers)
- `do/edge` (lb, firewalls, network config)
- etc...

and

- `k8s/core` (namespace)
- `k8s/prometheus` (monitoring)
- `k8s/heater`
- `k8s/siege`
- ...

## Tools

There's a `tf` utility... think of it as a missing `layer` subcommand

    # doesn't run, just for the idea
    terraform layer <provider>/<layer> <action>

or plugin.  In reality, use it like this

    tf [-p <project>] [-e <environment>] [-u] <provider>/<layer> <action>

