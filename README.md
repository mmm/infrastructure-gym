
(Disclaimers: Not an officially supported DigitalOcean project, don't fly
planes with this, still WIP, etc.)


# Infrastructure Gym

Train RL models to understand and control cloud infrastructure.

Created in the spirit of openai.org/gym but we want to train RL models to use
cloud APIs to manage infrastructure intelligently.

Here, we represent an environment in terms of (Terraform) infrastructure
graphs.  We include various ways to generate load and then measure response via
prometheus queries.  Reward is minimizing cloud infrastructure cost.


There's more info in [docs](docs/)

---

# Current Project Status

This is all under active development.  Trying to open-first as much as
possible, but please be patient.  I'll update status here as things become
stable enough to train external models.

## Agents

[Examples](examples/) are still WIP and mostly internal for now.


## Environment

### API

A gym-like API for training agents is still WIP.

### Providers

The current environment works against the following providers

- do
- k8s and helm

other providers can be added as needed.

### Layers

Infrastructure components are organized into [terraform layers](docs/terraform_layers.md):

#### For the `k8s` provider

- `heater` (simple web-app cluster used to generate load)
- `siege-engine` (simple web-client cluster used to generate load)
- `prometheus` (uses the helm provider to install prometheus-operator)
- `postgresql` (uses the helm provider)
- `core` (namespaces, helm/tiller, etc)

#### For the `do` provider

- `k8s-control-plane` and k8s-minions (roll your own k8s cluster)
- `nomad` (roll your own nomad cluster)
- `swarm-manager` and swarm-worker (roll your own docker swarm cluster)
- `support` (bastions, consul cluster, etc)
- `core` do setup bits (tags, subnetting/firewalls, etc)

### Backends

- do spaces
- s3

other state backends can be added as needed.

