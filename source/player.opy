#!mainFile "settings.opy"

#!define halfAbilityCooldown(button) eventPlayer.setAbilityCooldown(button, eventPlayer.getAbilityCooldown(button) / 1.5)

playervar HUDS = []
globalvar HeroRoster = getAllHeroes().exclude([Hero.HAMMOND, Hero.TORBJORN, Hero.ASHE, Hero.BASTION, Hero.SYMMETRA])

subroutine DESTROY_HUDS
subroutine DESTROY_CONSTRUCTION
subroutine RESTRICT_ABILITIES

def DESTROY_CONSTRUCTION():
    eventPlayer.forceButtonPress(Button.INTERACT)
    wait(0.125)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.125)
    if RULE_CONDITION: goto RULE_START

def DESTROY_HUDS():
    for eventPlayer.PLAYER_INDEX in range(0, len(eventPlayer.HUDS)):
        destroyHudText(eventPlayer.HUDS[GLOBAL_INDEX])
    eventPlayer.HUDS = []
def RESTRICT_ABILITIES():
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    switch eventPlayer.getCurrentHero():
        case Hero.BAPTISTE:
            eventPlayer.setAbility2Enabled(false)
            break

rule "Player Hud":
    @Event playerJoined
    @Condition not eventPlayer.isDummy()

    DESTROY_HUDS()

    wait()

    hudSubtext(eventPlayer if distance(eventPlayer.getPosition(), [TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.1, Team.2].index(eventPlayer.getTeam())]) < [TEAM_1_GOAL[1], TEAM_2_GOAL[1]][[Team.1, Team.2].index(eventPlayer.getTeam())] else null," {}{}".format(evalOnce("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"), "PRESS {} TO SWITCH HEROES".format(buttonString(Button.INTERACT)) if CURRENT_GAME_STATE != GAME_STATE.ROUND else "YOU CANNOT SWITCH HEROES DURING THE ROUND"), HudPosition.TOP, 2, Color.YELLOW if CURRENT_GAME_STATE != GAME_STATE.ROUND else Color.RED, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    eventPlayer.HUDS.append(getLastCreatedText())

    hudText(eventPlayer if CURRENT_GAME_STATE != GAME_STATE.WAITING_FOR_PLAYERS else null, "Score: {} to {}".format([TEAM_1_SCORE, TEAM_2_SCORE][[Team.1, Team.2].index(eventPlayer.getTeam())], [TEAM_1_SCORE, TEAM_2_SCORE][[Team.2, Team.1].index(eventPlayer.getTeam())]), "", "Time Remaining:\n{}:{}".format(floor(((TIME_REMAINING % 86400) % 3600) / 60), floor(((TIME_REMAINING % 86400) % 3600) % 60)) if TIME_REMAINING > 60 else "Time Remaining:\n{}".format(TIME_REMAINING), HudPosition.TOP, 0, Color.TURQUOISE, Color.ROSE, Color.ROSE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HUDS.append(getLastCreatedText())

    hudHeader(eventPlayer if CURRENT_GAME_STATE == GAME_STATE.WAITING_FOR_PLAYERS else null, "WAITING FOR PLAYERS", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HUDS.append(getLastCreatedText())

    hudSubtext(eventPlayer, "{} Wreckingball Soccer by CaptCaptain#11421".format(abilityIconString(Hero.HAMMOND, Button.ULTIMATE)), HudPosition.RIGHT, 1, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HUDS.append(getLastCreatedText())

    hudSubheader(eventPlayer, "Current Version: {}".format(CURRENT_VERSION), HudPosition.RIGHT, 2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HUDS.append(getLastCreatedText())

    hudSubheader(eventPlayer, "https://workshop.codes/ball-soccer".format(abilityIconString(Hero.HAMMOND, Button.ABILITY_1)), HudPosition.RIGHT, 2, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HUDS.append(getLastCreatedText())

rule "Destroy Player Hud":
    @Event playerLeft

    DESTROY_HUDS()

rule "Player Setup":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer in WRECKING_BALLS == false
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    eventPlayer.disableScoreboard()
    eventPlayer.disableKillFeed()
    eventPlayer.disableGamemodeHud()
    eventPlayer.setMoveSpeed(SETTING_SPEED_SCALAR * 100)
    eventPlayer.setJumpVerticalSpeed(100 + ((SETTING_SPEED_SCALAR * 100) / 4))

rule "Player Hero Roster":
    @Event eachPlayer
    @Condition eventPlayer in WRECKING_BALLS == false

    eventPlayer.setAllowedHeroes(HeroRoster)

rule "Teleport to Goal":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isInSpawnRoom()
    @Condition eventPlayer in WRECKING_BALLS == false

    eventPlayer.teleport([TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.1, Team.2].index(eventPlayer.getTeam())])
    eventPlayer.setFacing(directionTowards([TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.1, Team.2].index(eventPlayer.getTeam())], [TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.2, Team.1].index(eventPlayer.getTeam())]), Relativity.TO_WORLD)

rule "Switch Heroes":
    @Event eachPlayer
    @Hero all
    @Condition CURRENT_GAME_STATE != GAME_STATE.ROUND
    @Condition distance(eventPlayer.getPosition(), [TEAM_1_GOAL[0], TEAM_2_GOAL[0]][[Team.1, Team.2].index(eventPlayer.getTeam())]) < [TEAM_1_GOAL[1], TEAM_2_GOAL[1]][[Team.1, Team.2].index(eventPlayer.getTeam())]
    @Condition eventPlayer in WRECKING_BALLS == false
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(eventPlayer.getCurrentHero()))
    wait(0.25)
    eventPlayer.setAllowedHeroes(HeroRoster)

rule "Allow Primary: Reinhardt":
    @Event eachPlayer
    @Hero reinhardt

    eventPlayer.setPrimaryFireEnabled(true)

rule "Allow Primary: Brigitte":
    @Event eachPlayer
    @Hero brigitte

    eventPlayer.setPrimaryFireEnabled(true)

rule "Allow Primary: Moira":
    @Event eachPlayer
    @Hero moira

    eventPlayer.setPrimaryFireEnabled(true)

rule "Allow Primary: Mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition not eventPlayer.isInAlternateForm()

    eventPlayer.setPrimaryFireEnabled(true)
    waitUntil(eventPlayer.isInAlternateForm(), 9999)
    eventPlayer.setPrimaryFireEnabled(false)

rule "Allow Sentry: Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()

    eventPlayer.setPrimaryFireEnabled(true)
    waitUntil(not eventPlayer.isInAlternateForm(), 9999)
    eventPlayer.setPrimaryFireEnabled(false)

rule "Bind Melee: Primary":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    if eventPlayer.isFiringPrimaryFire() or (eventPlayer.getCurrentHero() == Hero.HANZO and eventPlayer.isUsingAbility2()): return
    eventPlayer.forceButtonPress(Button.MELEE)

rule "Allow Ultimate Confirmation":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition any([eventPlayer.getCurrentHero() == hero for hero in [Hero.ECHO, Hero.ANA]])
      
    if eventPlayer.getUltCharge() == 100:
        eventPlayer.setPrimaryFireEnabled(true)
        waitUntil(any([i == true for i in [eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), eventPlayer.getUltCharge() == 0]]), 3)
        eventPlayer.setPrimaryFireEnabled(false)

rule "Allow Ultimate Confirmation for Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setPrimaryFireEnabled(true)
    waitUntil(not eventPlayer.isUsingUltimate(), 4)
    eventPlayer.setPrimaryFireEnabled(false)

rule "Prevent Primary Fire bypass with Ultimate Confirmation":
    @Event eachPlayer
    @Hero all
    @Condition any([eventPlayer.getCurrentHero() == hero or eventPlayer.getHeroOfDuplication() == hero for hero in [Hero.ECHO, Hero.ANA]])

    eventPlayer.setAmmo(0, 0)
    eventPlayer.setMaxAmmo(0, 0)

rule "Switch out of Ball Form":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getCurrentHero() == Hero.HAMMOND or eventPlayer.getHeroOfDuplication() == Hero.HAMMOND
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isInAlternateForm()

    eventPlayer.cancelPrimaryAction()

rule "Reduce Ability 1 Cooldown":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    if (eventPlayer.getCurrentHero() == Hero.ROADHOG or eventPlayer.getHeroOfDuplication() == Hero.ROADHOG) or (eventPlayer.getCurrentHero() == Hero.ZARYA or eventPlayer.getHeroOfDuplication() == Hero.ZARYA): return
    halfAbilityCooldown(Button.ABILITY_1)

rule "Reduce Ability 2 Cooldown":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    if (eventPlayer.getCurrentHero() == Hero.SOMBRA or eventPlayer.getHeroOfDuplication() == Hero.SOMBRA) or (eventPlayer.getCurrentHero() == Hero.MEI or eventPlayer.getHeroOfDuplication() == Hero.MEI) or (eventPlayer.getCurrentHero() == Hero.ZARYA or eventPlayer.getHeroOfDuplication() == Hero.ZARYA): return
    halfAbilityCooldown(Button.ABILITY_2)

rule "Reduce Secondary Cooldown":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    if eventPlayer.getCurrentHero() == Hero.SOMBRA or eventPlayer.getHeroOfDuplication() == Hero.SOMBRA: return
    halfAbilityCooldown(Button.SECONDARY_FIRE)

rule "Destroy Symmetra Teleporter":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isUsingAbility2()
    @Condition CURRENT_GAME_STATE == GAME_STATE.SETUP or CURRENT_GAME_STATE == GAME_STATE.RESULT

    DESTROY_CONSTRUCTION()

rule "Destroy Torb Turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility1()
    @Condition CURRENT_GAME_STATE == GAME_STATE.SETUP or CURRENT_GAME_STATE == GAME_STATE.RESULT

    DESTROY_CONSTRUCTION()

rule "Destroy Sombra Translocator":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isUsingAbility2()
    @Condition CURRENT_GAME_STATE == GAME_STATE.SETUP or CURRENT_GAME_STATE == GAME_STATE.RESULT

    DESTROY_CONSTRUCTION()