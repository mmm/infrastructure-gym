import logging
import gym
from gym import spaces
import time
from .. import terraform_graph


class SimpleK8sWebApp(gym.Env):
    """
    Description:
        A simple web-based application ("heater") under load from a very active
        client ("siege-engine").

    Observation:
        Type: Box(4)
        Num	Observation                 Min         Max
        0	Cart Position             -4.8            4.8
        1	Cart Velocity             -Inf            Inf
        2	Pole Angle                 -24 deg        24 deg
        3	Pole Velocity At Tip      -Inf            Inf

    Actions:
        Type: Discrete(2)
        Num	Action
        0	Remove a heater replica
        1	Add a heater replica

    Reward:
        Reward is TODO... 1 for every step taken, including the termination step

    Starting State:
        All observations are TODO... assigned a uniform random value in [-0.05..0.05]

    Episode Termination:
        TODO...
        Pole Angle is more than 12 degrees
        Cart Position is more than 2.4 (center of the cart reaches the edge of the display)
        Episode length is greater than 200
        Solved Requirements
        Considered solved when the average reward is greater than or equal to 195.0 over 100 consecutive trials.
    """

    metadata = {
        'render.modes': ['human']
    }

    def __init__(self,
                 project,
                 environment,
                 project_dir,
                 time_between_commands,
                 time_between_steps,
                 dry_run):
        self.log = logging.getLogger(type(self).__name__)
        self.log.info("init env")

        self.time_between_commands = time_between_commands
        self.time_between_steps = time_between_steps

        self.graph = terraform_graph.TerraformGraph(project,
                                                    environment,
                                                    project_dir,
                                                    dry_run)

        self.action_space = spaces.Discrete(2)  # add or remove a node per step

        # assumes k8s cluster is running
        # and tiller and prometheus are installed
        self.graph.add_layer("k8s/core")

        self.log.debug("sleep %d between commands" % self.time_between_commands)
        time.sleep(self.time_between_commands)

    #def __del__(self):
    def close(self):
        self.graph.remove_layer("k8s/siege-engine")
        self.graph.remove_layer("k8s/heater")
        self.graph.remove_layer("k8s/core")
        self.log.info("env closed")

    def step(self, action):
        self.log.info("step")

        # self._take_action(action)
        # action should be the new graph to apply
        # in this case, it's heater replicas
        replicas=5
        self.graph.update_layer("k8s/heater",
                                "--var heater_replicas=%d" % replicas)

        self.log.debug("sleep %d during step" % self.time_between_steps)
        time.sleep(self.time_between_steps)

        ob = self.graph.get_layer_nodes("k8s/heater")
        # self.status = self.env.step()
        reward = 0.0
        # reward = self._get_reward()
        episode_over = False

        return ob, reward, episode_over, {}

    def reset(self):
        """ reset or create k8s/heater and k8s/siege layers
        """
        self.log.info("reset")

        self.graph.remove_layer("k8s/siege-engine")
        self.graph.remove_layer("k8s/heater")

        self.log.debug("sleep %d between commands" % self.time_between_commands)
        time.sleep(self.time_between_commands)

        self.graph.add_layer("k8s/heater")
        self.graph.add_layer("k8s/siege-engine")

        self.log.debug("sleep %d after reset" % self.time_between_steps)
        time.sleep(self.time_between_steps)

        # need to return an observation
        # something like...
        # self.graph.get_layer_nodes("k8s/heater")
        return None

    def render(self, mode='human', close=False):
        self.log.debug("render")
        # self.graph.get_layer_nodes("k8s/heater")
        return None
