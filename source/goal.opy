#!mainFile "settings.opy"

globalvar GOAL_EFFECTS

subroutine CREATE_GOAL_EFFECTS
subroutine CLEAR_GOAL_EFFECTS

def CREATE_GOAL_EFFECTS():
    # Team 1
    # Bottom
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

    # Top
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(-TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(-TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(-TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + (Vector.UP * TEAM_1_GOAL[1]) + vect(-TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

    # Connecting bottom to top
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1] * 1.01, TEAM_1_GOAL[1], TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1], 0, TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1] * 1.01, TEAM_1_GOAL[1], TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(TEAM_1_GOAL[1] * 1.01, TEAM_1_GOAL[1], -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1], 0, -TEAM_1_GOAL[1]), TEAM_1_GOAL[0] + vect(-TEAM_1_GOAL[1] * 1.01, TEAM_1_GOAL[1], -TEAM_1_GOAL[1]), Color.TEAM_1, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

    # Team 1 Labels
    createInWorldText(getPlayers(Team.1), "Team Goal", TEAM_1_GOAL[0] + vect(0, TEAM_1_GOAL[1], 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_COLOR, Color.TEAM_1, SpecVisibility.DEFAULT)
    GOAL_EFFECTS.append(getLastCreatedText())
    createInWorldText(getPlayers(Team.1), "Enemy Goal", TEAM_2_GOAL[0] + vect(0, TEAM_2_GOAL[1], 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_COLOR, Color.TEAM_2, SpecVisibility.DEFAULT)
    GOAL_EFFECTS.append(getLastCreatedText())

    # Team 2
    # Bottom
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

    # Top
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(-TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(-TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(-TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + (Vector.UP * TEAM_2_GOAL[1]) + vect(-TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

    # Connecting bottom to top
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1] * 1.01, TEAM_2_GOAL[1], TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1], 0, TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1] * 1.01, TEAM_2_GOAL[1], TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(TEAM_2_GOAL[1] * 1.01, TEAM_2_GOAL[1], -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.GOOD, TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1], 0, -TEAM_2_GOAL[1]), TEAM_2_GOAL[0] + vect(-TEAM_2_GOAL[1] * 1.01, TEAM_2_GOAL[1], -TEAM_2_GOAL[1]), Color.TEAM_2, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

    # Team 2 Labels
    createInWorldText(getPlayers(Team.2), "Team Goal", TEAM_2_GOAL[0] + vect(0, TEAM_2_GOAL[1], 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_COLOR, Color.TEAM_2, SpecVisibility.DEFAULT)
    GOAL_EFFECTS.append(getLastCreatedText())
    createInWorldText(getPlayers(Team.2), "Enemy Goal", TEAM_1_GOAL[0] + vect(0, TEAM_1_GOAL[1], 0), 2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_COLOR, Color.TEAM_1, SpecVisibility.DEFAULT)
    GOAL_EFFECTS.append(getLastCreatedText())

    # Arena
    createBeam(getAllPlayers(), Beam.BAD, ARENA[0] + vect(ARENA[1], 0, ARENA[1]), ARENA[0] + vect(-ARENA[1], 0, ARENA[1]), Color.ROSE, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, ARENA[0] + vect(ARENA[1], 0, ARENA[1]), ARENA[0] + vect(ARENA[1], 0, -ARENA[1]), Color.ROSE, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, ARENA[0] + vect(-ARENA[1], 0, ARENA[1]), ARENA[0] + vect(-ARENA[1], 0, -ARENA[1]), Color.ROSE, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, ARENA[0] + vect(ARENA[1], 0, -ARENA[1]), ARENA[0] + vect(-ARENA[1], 0, -ARENA[1]), Color.ROSE, EffectReeval.VISIBILITY_AND_COLOR)
    GOAL_EFFECTS.append(getLastCreatedEntity())

def CLEAR_GOAL_EFFECTS():
    for GLOBAL_INDEX in range(0, len(GOAL_EFFECTS)):
        destroyEffect(GOAL_EFFECTS[GLOBAL_INDEX])
        destroyInWorldText(GOAL_EFFECTS[GLOBAL_INDEX])
    GOAL_EFFECTS = []

rule "Create Goals":
    CREATE_GOAL_EFFECTS()

rule "Keep in Arena":
    @Event eachPlayer
    @Condition not eventPlayer.isInSpawnRoom()
    @Condition eventPlayer.getPosition().x > (ARENA[0] + vect(ARENA[1], 0, 0)).x or eventPlayer.getPosition().x < (ARENA[0] + vect(-ARENA[1], 0, 0)).x or eventPlayer.getPosition().z < (ARENA[0] + vect(0, 0, -ARENA[1])).z or eventPlayer.getPosition().z > (ARENA[0] + vect(0, 0, ARENA[1])).z

    if eventPlayer in WRECKING_BALLS == false and (eventPlayer.getCurrentHero() == Hero.REINHARDT and eventPlayer.isUsingAbility1()): eventPlayer.cancelPrimaryAction()

    # Accelerate players toward the goal whose team has ownership of the ball
    eventPlayer.startAcceleration(directionTowards(vect(eventPlayer.getPosition().x, [TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.1, Team.2].index(TEAM_PHYSICS_OWNERSHIP)].y, eventPlayer.getPosition().z), [TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.1, Team.2].index(TEAM_PHYSICS_OWNERSHIP)]), 500, 1000, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)

    if not eventPlayer in WRECKING_BALLS and distance(vect(eventPlayer.getPosition().x, ARENA[0].y, eventPlayer.getPosition().z), ARENA[0]) > ARENA[1] + 13:
        eventPlayer.teleport(eventPlayer.getPosition() + directionTowards(vect(eventPlayer.getPosition().x, ARENA[0].y, eventPlayer.getPosition().z), ARENA[0]))
    wait()
    if RULE_CONDITION: goto RULE_START
    eventPlayer.stopAcceleration()
    eventPlayer.applyImpulse(directionTowards(Vector.DOWN, Vector.UP), 0.01, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)