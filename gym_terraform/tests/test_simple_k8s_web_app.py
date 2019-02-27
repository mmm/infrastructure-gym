#!/usr/bin/python
import sys; sys.path.append('../..')
import datetime
import gym_terraform
import gym
import logging

test_env = 'SimpleK8sWebApp-v0'

log = logging.getLogger(test_env)
logging.basicConfig(filename="%s.log" % test_env, level=logging.DEBUG)


def timestamp():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def test_simple_k8s_web_app():
    env = gym.make('SimpleK8sWebApp-v0',
                   project='simple',
                   environment='test',
                   project_dir='../..',
                   time_between_commands=1,
                   time_between_steps=1,
                   dry_run=True)

    observation = env.reset()
    action = env.action_space.sample()
    observation, reward, done, info = env.step(action)
    assert isinstance(done, bool), "Expected {} to be a boolean".format(done)
    env.render()
    env.close()

# def test_env(spec):
    # # Capture warnings
    # with pytest.warns(None) as warnings:
        # env = spec.make()

    # # Check that dtype is explicitly declared for gym.Box spaces
    # for warning_msg in warnings:
        # assert not 'autodetected dtype' in str(warning_msg.message)

    # ob_space = env.observation_space
    # act_space = env.action_space
    # ob = env.reset()
    # assert ob_space.contains(ob), 'Reset observation: {!r} not in space'.format(ob)
    # a = act_space.sample()
    # observation, reward, done, _info = env.step(a)
    # assert ob_space.contains(observation), 'Step observation: {!r} not in space'.format(observation)
    # assert np.isscalar(reward), "{} is not a scalar for {}".format(reward, env)
    # assert isinstance(done, bool), "Expected {} to be a boolean".format(done)

    # for mode in env.metadata.get('render.modes', []):
        # env.render(mode=mode)

    # # Make sure we can render the environment after close.
    # for mode in env.metadata.get('render.modes', []):
        # env.render(mode=mode)

    # env.close()


if __name__ == '__main__':
    log.info("starting %s test at %s" % (test_env, timestamp()))
    test_simple_k8s_web_app()
    log.info("test done at %s" % timestamp())
