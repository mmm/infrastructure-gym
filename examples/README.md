
# Simple Example

This is a characteristic test case / example mostly used to guide development.
This'll be a simple autoscaling scenario.

The _agent_ for this initial example is overly simplistic, but good enough to
get the gym plumbed end-to-end.  We'll iterate on scenario/model complexity
over time.  Yeah, autoscaling is a simple control problem... the point here is
bootstrapping the gym for now.

## Setup

- CI spins up environment mgmt
- environment uses terraform templates and provisioners/images to create:
    - gameplay infrastructure (web app in this example)
    - agent instance(s)
    - siege cluster (instantiation starts training gameplay)

## Game Steps

- ten-minute time steps (?)
- siege cluster generates continuous load throughout the entire scenario
- load balanced app deployment responds
- this app really just generates heat (it's even named `heater`)
- agent reads current topology from terraform state (graph)
- agent augments that graph via prometheus queries at the end of each time step
- agent adjusts topology (via terraform) to maximize rewards while respecting
  constraints
- repeat

## Rewards / Constraints

- minimize cost (simplified cost calculations for now)
- minimize average response time
- minimize average load levels for particular parts of the topology (app
  servers here)
- constraint: keep at least two app servers, etc to encode some practical
  limitations
- constraint: add/remove a single app server per turn (no sweeping topology
  changes)

can probably characterize everything for now in a simple reward function that
includes _lower_ thresholds on load as well as _upper_ ones too.  I.e., include
"minimal cost" as simply "no idle app servers"

## Teardown

- environment persists scenario metadata and agent's model implementation
- environment tears everything down

--- 

# Variations

There're lots of places to take this once the basics are working:
- add degrees of freedom to let the agent adjust size as well as number of app
  servers
- adjust the topology to include a persistence layer
- adjust the topology to let the agent change the number/size of k8s minions
- change siege profiles
- change app load response
- etc etc

