#!mainFile "settings.opy"


globalvar ROUND_RESULT

rule "Waiting for Players":
    @Condition CURRENT_GAME_STATE == GAME_STATE.WAITING_FOR_PLAYERS
    @Condition len(getPlayers(Team.1).exclude(WRECKING_BALLS)) > 0 and len(getPlayers(Team.2).exclude(WRECKING_BALLS)) > 0

    # Reset ultimate charge for everyone and begin game
    CURRENT_GAME_STATE = GAME_STATE.SETUP
    getAllPlayers().setUltCharge(0)

rule "Spawn Ball":
    CREATE_BALL()
    RESET_BALL()

rule "Reset Ball":
    @Condition (distance(WRECKING_BALLS[Team1].getPosition(), TEAM_2_GOAL[0]) < TEAM_2_GOAL[1] or distance(WRECKING_BALLS[Team2].getPosition(), TEAM_1_GOAL[0]) < TEAM_1_GOAL[1]) or (WRECKING_BALLS[Team1].isDead() and WRECKING_BALLS[Team2].isDead())
    @Condition CURRENT_GAME_STATE == GAME_STATE.WAITING_FOR_PLAYERS

    KILL_BALL()
    wait(1, Wait.ABORT_WHEN_FALSE)
    RESET_BALL()

rule "Setup":
    @Condition CURRENT_GAME_STATE == GAME_STATE.SETUP
    @Condition BALL_RESETTING == false

    # Kill any hero duplicating, and remove any Symmetra teleporters
    kill([player for player in getPlayersOnHero(Hero.ECHO, Team.ALL) if player.isDuplicatingAHero()], null)
    [player for player in getPlayersOnHero(Hero.SYMMETRA, Team.ALL) if player.isUsingAbility2()].forceButtonPress(Button.ABILITY_2)
    
    ROUND_NUMBER += 1

    # Teleport players to their goals
    getPlayers(Team.ALL).exclude(WRECKING_BALLS).setStatusEffect(null, Status.ROOTED, 9999)
    getPlayers(Team.ALL).exclude(WRECKING_BALLS).cancelPrimaryAction()
    getAllPlayers().exclude(WRECKING_BALLS).respawn()
    getPlayers(Team.1).exclude(WRECKING_BALLS).setFacing(directionTowards(TEAM_1_GOAL[0], TEAM_2_GOAL[0]), Relativity.TO_WORLD)
    getPlayers(Team.2).exclude(WRECKING_BALLS).setFacing(directionTowards(TEAM_2_GOAL[0], TEAM_1_GOAL[0]), Relativity.TO_WORLD)
    getPlayers(Team.1).exclude(WRECKING_BALLS).teleport(TEAM_1_GOAL[0])
    getPlayers(Team.2).exclude(WRECKING_BALLS).teleport(TEAM_2_GOAL[0])
    TEAM_PHYSICS_OWNERSHIP = getOppositeTeam(TEAM_PHYSICS_OWNERSHIP)
    LAST_PUSHED_PLAYER = null

    bigMessage(getAllPlayers(), "ROUND {}".format(ROUND_NUMBER))

    RESET_BALL()

    CURRENT_GAME_STATE = GAME_STATE.ROUND

rule "Round":
    @Condition CURRENT_GAME_STATE == GAME_STATE.ROUND

    getPlayers(Team.ALL).exclude(WRECKING_BALLS).clearStatusEffect(Status.ROOTED)
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

    CURRENT_GAME_STATE = GAME_STATE.RESULT

rule "Results":
    @Condition CURRENT_GAME_STATE == GAME_STATE.RESULT

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
    wait(1)
    setSlowMotion(100)
    LAST_PUSHED_PLAYER = null
    CURRENT_GAME_STATE = GAME_STATE.SETUP

rule "Time Ran Out":
    @Condition CURRENT_GAME_STATE == GAME_STATE.ROUND
    @Condition TIME_REMAINING == 0

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