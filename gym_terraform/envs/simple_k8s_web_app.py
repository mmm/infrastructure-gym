import logging
import gym
from gym import spaces
import time
from .. import terraform_graph


class SimpleK8sWebApp(gym.Env):
    metadata = {'render.modes': ['human']}

    def __init__(self):
        self.log = logging.getLogger(type(self).__name__)
        self.log.info("init")

        self.sleep_between_steps = 120  # enough to generate some load
        self.sleep_default = 10  # probably not needed
        self.action_space = spaces.Discrete(2)  # add or remove a node per step

        self.graph = terraform_graph.TerraformGraph(project='simple',
                                                    environment='demo',
                                                    project_dir='..')

        # assumes k8s cluster is running
        # and tiller and prometheus are installed
        self.graph.add_layer("k8s/core")

        self.log.debug("sleep %d" % self.sleep_default)
        time.sleep(self.sleep_default)

    def __del__(self):
        self.graph.remove_layer("k8s/siege-engine")
        self.graph.remove_layer("k8s/heater")
        self.graph.remove_layer("k8s/core")

    def step(self, action):
        self.log.info("step")

        ob = self.graph.get_layer_nodes("k8s/heater")
        # self._take_action(action)
        self.graph.update_layer("k8s/heater")
        # self.status = self.env.step()
        reward = 0.0
        # reward = self._get_reward()
        episode_over = False

        self.log.debug("sleep %d" % self.sleep_between_steps)
        time.sleep(self.sleep_between_steps)

        return ob, reward, episode_over, {}

    def reset(self):
        """ reset or create k8s/heater and k8s/siege layers
        """
        self.log.info("reset")

        self.graph.remove_layer("k8s/siege-engine")
        self.graph.remove_layer("k8s/heater")

        self.log.debug("sleep %d" % self.sleep_default)
        time.sleep(self.sleep_default)

        self.graph.add_layer("k8s/heater")
        self.graph.add_layer("k8s/siege-engine")

        self.log.debug("sleep %d" % self.sleep_between_steps)
        time.sleep(self.sleep_between_steps)

        # need to return an observation
        # something like...
        # self.graph.get_layer_nodes("k8s/heater")
        return None

    def render(self, mode='human', close=False):
        self.log.debug("render")
        # self.graph.get_layer_nodes("k8s/heater")
        return self
