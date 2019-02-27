import logging
from gym.envs.registration import register

logger = logging.getLogger(__name__)

register(
    id='SimpleK8sWebApp-v0',
    entry_point='gym_terraform.envs:SimpleK8sWebApp',
    kwargs={
        'project': 'simple',
        'environment': 'demo',
        'project_dir': '..',
        'time_between_commands': 10,
        'time_between_steps': 120,
        'dry_run': False},
    timestep_limit=1000,
    reward_threshold=1.0,
    nondeterministic = True,
)
