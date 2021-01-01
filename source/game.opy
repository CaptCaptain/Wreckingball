#!mainFile "settings.opy"

globalvar ROUND_RESULT

subroutine DISABLE_ABILITIES
subroutine ENABLE_ABILITIES

def DISABLE_ABILITIES():
    getAllPlayers().exclude(WRECKING_BALLS).disallowButton(Button.PRIMARY_FIRE)
    getAllPlayers().exclude(WRECKING_BALLS).setSecondaryFireEnabled(false)
    getAllPlayers().exclude(WRECKING_BALLS).setAbility1Enabled(false)
    getAllPlayers().exclude(WRECKING_BALLS).setAbility2Enabled(false)
    getAllPlayers().exclude(WRECKING_BALLS).disallowButton(Button.ULTIMATE)

def ENABLE_ABILITIES():
    getAllPlayers().exclude(WRECKING_BALLS).allowButton(Button.PRIMARY_FIRE)
    getAllPlayers().exclude(WRECKING_BALLS).setSecondaryFireEnabled(true)
    getAllPlayers().exclude(WRECKING_BALLS).setAbility1Enabled(true)
    getAllPlayers().exclude(WRECKING_BALLS).setAbility2Enabled(true)
    getAllPlayers().exclude(WRECKING_BALLS).allowButton(Button.ULTIMATE)

rule "Waiting for Players":
    @Condition CURRENT_GAME_STATE == GAME_STATE.WAITING_FOR_PLAYERS
    @Condition len(getPlayers(Team.1).exclude(WRECKING_BALLS)) > 0 and len(getPlayers(Team.2).exclude(WRECKING_BALLS)) > 0

    waitUntil(all([player.hasSpawned() for player in getAllPlayers()]) and not BALL_RESETTING, 9999)

    wait(1)

    # Reset ultimate charge for everyone and begin game
    CURRENT_GAME_STATE = GAME_STATE.SETUP
    getAllPlayers().setUltCharge(0)

rule "Spawn Ball":
    CREATE_BALL()

rule "Reset Ball":
    @Condition (distance(WRECKING_BALLS[Team1].getPosition(), TEAM_2_GOAL[0]) < TEAM_2_GOAL[1] or distance(WRECKING_BALLS[Team2].getPosition(), TEAM_1_GOAL[0]) < TEAM_1_GOAL[1]) or (WRECKING_BALLS[Team1].isDead() and WRECKING_BALLS[Team2].isDead())
    @Condition CURRENT_GAME_STATE == GAME_STATE.WAITING_FOR_PLAYERS
    
    KILL_BALL()
    wait(1, Wait.ABORT_WHEN_FALSE)
    TEAM_PHYSICS_OWNERSHIP = getOppositeTeam(TEAM_PHYSICS_OWNERSHIP)
    RESET_BALL()

rule "Setup":
    @Condition CURRENT_GAME_STATE == GAME_STATE.SETUP
    @Condition BALL_RESETTING == false
    
    ROUND_NUMBER += 1

    # Teleport players to their goals
    getAllPlayers().exclude(WRECKING_BALLS).setStatusEffect(null, Status.ROOTED, 9999)
    getAllPlayers().exclude(WRECKING_BALLS).cancelPrimaryAction()
    getAllPlayers().exclude(WRECKING_BALLS).respawn()
    getPlayers(Team.1).exclude(WRECKING_BALLS).setFacing(directionTowards(TEAM_1_GOAL[0], TEAM_2_GOAL[0]), Relativity.TO_WORLD)
    getPlayers(Team.2).exclude(WRECKING_BALLS).setFacing(directionTowards(TEAM_2_GOAL[0], TEAM_1_GOAL[0]), Relativity.TO_WORLD)
    getPlayers(Team.1).exclude(WRECKING_BALLS).teleport(TEAM_1_GOAL[0])
    getPlayers(Team.2).exclude(WRECKING_BALLS).teleport(TEAM_2_GOAL[0])
    DISABLE_ABILITIES()
    
    TEAM_PHYSICS_OWNERSHIP = getOppositeTeam(TEAM_PHYSICS_OWNERSHIP)
    LAST_PUSHED_PLAYER = null

    bigMessage(getAllPlayers(), "ROUND {}".format(ROUND_NUMBER))

    RESET_BALL()

    CURRENT_GAME_STATE = GAME_STATE.ROUND

rule "Round":
    @Condition CURRENT_GAME_STATE == GAME_STATE.ROUND

    getAllPlayers().exclude(WRECKING_BALLS).clearStatusEffect(Status.ROOTED)
    ENABLE_ABILITIES()
    chase(TIME_REMAINING, 0, rate=1, ChaseReeval.NONE)

rule "Score":
    @Condition CURRENT_GAME_STATE == GAME_STATE.ROUND
    @Condition distance(WRECKING_BALLS[Team1].getPosition(), TEAM_2_GOAL[0]) < TEAM_2_GOAL[1] or distance(WRECKING_BALLS[Team2].getPosition(), TEAM_1_GOAL[0]) < TEAM_1_GOAL[1]

    # The round result is determined by which goal the ball is in.
    ROUND_RESULT = [Team.1, Team.2][[distance(WRECKING_BALLS[Team1].getPosition(), TEAM_2_GOAL[0]) < TEAM_2_GOAL[1], distance(WRECKING_BALLS[Team2].getPosition(), TEAM_1_GOAL[0]) < TEAM_1_GOAL[1]].index(true)]

    # Remove ball and award score to player
    KILL_BALL()
    stopChasingVariable(TIME_REMAINING)
    setSlowMotion(30)
    bigMessage(getAllPlayers() if (LAST_PUSHED_PLAYER.getTeam() == Team.1 and distance(WRECKING_BALLS[Team1].getPosition(), TEAM_2_GOAL[0]) < TEAM_2_GOAL[1]) or (LAST_PUSHED_PLAYER.getTeam() == Team.2 and distance(WRECKING_BALLS[Team2].getPosition(), TEAM_1_GOAL[0]) < TEAM_1_GOAL[1]) else null, "{} scored!".format(LAST_PUSHED_PLAYER))

    # Kill any hero duplicating, and remove any Symmetra teleporters
    kill([player for player in getPlayersOnHero(Hero.ECHO, Team.ALL) if player.isDuplicatingAHero()], null)

    DISABLE_ABILITIES()

    CURRENT_GAME_STATE = GAME_STATE.RESULT

rule "Results":
    @Condition CURRENT_GAME_STATE == GAME_STATE.RESULT

    if SETTING_WHILE_YOU_WAIT == true: goto skip_scoring
    switch ROUND_RESULT:
        case Team.1:
            TEAM_1_SCORE += 1

            if TEAM_1_SCORE >= SETTING_SCORE_NEEDED:
                declareTeamVictory(Team.1)
                CURRENT_GAME_STATE = GAME_STATE.END
                return
            break
        case Team.2:
            TEAM_2_SCORE += 1

            if TEAM_2_SCORE >= SETTING_SCORE_NEEDED:
                declareTeamVictory(Team.2)
                CURRENT_GAME_STATE = GAME_STATE.END
                return
            break
    skip_scoring:
    wait(1)
    setSlowMotion(100)
    LAST_PUSHED_PLAYER = null
    CURRENT_GAME_STATE = GAME_STATE.SETUP

rule "Time Ran Out":
    @Condition CURRENT_GAME_STATE == GAME_STATE.ROUND
    @Condition TIME_REMAINING == 0

    if SETTING_WHILE_YOU_WAIT == true: setMatchTime(0)

    if TEAM_1_SCORE > TEAM_2_SCORE:
        declareTeamVictory(Team.1)
        CURRENT_GAME_STATE = GAME_STATE.END
    elif TEAM_2_SCORE > TEAM_1_SCORE:
        declareTeamVictory(Team.2)
        CURRENT_GAME_STATE = GAME_STATE.END
    else:
        declareDraw()


rule "End Game":
    @Condition CURRENT_GAME_STATE == GAME_STATE.END

    REMOVE_BALL()

    wait(SETTING_END_BEHAVIOR)

    setMatchTime(0)