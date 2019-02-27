import logging
from gym.envs.registration import register

logger = logging.getLogger(__name__)

register(
    id='SimpleK8sWebApp-v0',
    entry_point='gym_terraform.envs:SimpleK8sWebApp',
    timestep_limit=1000,
    reward_threshold=1.0,
    nondeterministic = True,
)

# register(
    # id='SoccerEmptyGoal-v0',
    # entry_point='gym_soccer.envs:SoccerEmptyGoalEnv',
    # timestep_limit=1000,
    # reward_threshold=10.0,
    # nondeterministic = True,
# )

# register(
    # id='SoccerAgainstKeeper-v0',
    # entry_point='gym.envs:SoccerAgainstKeeperEnv',
    # timestep_limit=1000,
    # reward_threshold=8.0,
    # nondeterministic = True,
# )
