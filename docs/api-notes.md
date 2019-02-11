
# API

Need `gym`-like behavior...

Each environment needs the equivalent of

    init
    step
    reset
    render
    

## init


## step


## reset


## render


--- 

# What Would OpenAI Do?

in `gym/envs`, there're lots of core envs like `mujoco`.

To use a particular environment with that core, do

    from gym.envs import mujoco
    mujoco.AntEnv

They recommend:

    gym-foo/
      README.md
      setup.py
      gym_foo/
        __init__.py
        envs/
          __init__.py
          foo_env.py
          foo_extrahard_env.py

with `gym-foo/gym_foo/envs/foo_env.py` that looks something like

    import gym
    from gym import error, spaces, utils
    from gym.utils import seeding

    class FooEnv(gym.Env):
      metadata = {'render.modes': ['human']}

      def __init__(self):
        ...
      def step(self, action):
        ...
      def reset(self):
        ...
      def render(self, mode='human', close=False):

so maybe it's enough to just provide shell scripts for now that implement each
of these.
