#!/usr/bin/python
import sys; sys.path.append('..')
import gym_terraform
import gym
import logging

log = logging.getLogger('SimpleK8sWebApp-v0')
logging.basicConfig(level=logging.DEBUG)
#logging.basicConfig(filename='simple-k8s-webapp-v0.log', level=logging.DEBUG)

log.info("starting training")

env = gym.make('SimpleK8sWebApp-v0')

for i_episode in range(1):
    observation = env.reset()
    for t in range(2):
        env.render()
        log.info("observation: %s" % observation)
        action = env.action_space.sample()
        observation, reward, done, info = env.step(action)
        if done:
            log.info("Episode finished after {} timesteps".format(t+1))
            break
