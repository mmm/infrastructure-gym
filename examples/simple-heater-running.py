#!/usr/bin/python
import sys; sys.path.append('..')
import gym_terraform
import gym
import logging

log = logging.getLogger('SimpleK8sWebApp-v0')

# INFO just covers the basics of progress
# DEBUG lets you watch terraform output
logging.basicConfig(level=logging.INFO)

log.info("starting training")

env = gym.make('SimpleK8sWebApp-v0',
               project='simple',
               environment='example',
               project_dir='..',
               dry_run=True)

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

env.close()
