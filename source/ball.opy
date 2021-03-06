#!mainFile "settings.opy"

globalvar WRECKING_BALLS
globalvar WRECKING_BALL_EFFECTS
globalvar ATTACHING_ALLOWED
globalvar TEAM_PHYSICS_OWNERSHIP
globalvar LAST_PUSHED_PLAYER
globalvar BALL_RESETTING = false

#!define Team1 0
#!define Team2 1

subroutine APPLY_IMPULSE
subroutine CREATE_BALL
subroutine REMOVE_BALL
subroutine RESET_BALL
subroutine KILL_BALL
subroutine SET_PHYSICS_OWNERSHIP_START
subroutine SET_PHYSICS_OWNERSHIP_END

def CREATE_BALL():
    # Create Wrecking Ball Dummies
    WRECKING_BALLS = []
    createDummy(Hero.HAMMOND, Team.1, 5, vect(0, 0, 0), vect(0, 0, 0))
    WRECKING_BALLS.append(getLastCreatedEntity())
    createDummy(Hero.HAMMOND, Team.2, 5, vect(0, 0, 0), vect(0, 0, 0))
    WRECKING_BALLS.append(getLastCreatedEntity())

    # Heal and give them the unkillable status so they can't die
    WRECKING_BALLS.startHoT(null, 9999, 600)
    WRECKING_BALLS.setStatusEffect(null, Status.UNKILLABLE, 9999)

    # Set ownership to a random team
    TEAM_PHYSICS_OWNERSHIP = random.choice([Team.1, Team.2])
    ATTACHING_ALLOWED = true

    # Label and scale ball
    createInWorldText([getAllPlayers()], "{}\nBALL".format(abilityIconString(Hero.HAMMOND, Button.ULTIMATE)), WRECKING_BALLS[Team1], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, Color.YELLOW, SpecVisibility.DEFAULT)
    WRECKING_BALL_EFFECTS.append(getLastCreatedText())
    WRECKING_BALLS.startForcingButton(Button.INTERACT)
    startDamageModification(WRECKING_BALLS, getPlayersOnHero(Hero.BRIGITTE, Team.ALL), 150, DamageReeval.RECEIVERS_AND_DAMAGERS)
    startHealingModification(WRECKING_BALLS, getPlayersOnHero(Hero.MERCY, Team.ALL), 150, HealingReeval.RECEIVERS_AND_HEALERS)
    startHealingModification(WRECKING_BALLS, getPlayersOnHero(Hero.MOIRA, Team.ALL), 150, HealingReeval.RECEIVERS_AND_HEALERS)
    WRECKING_BALLS.startScalingSize(SETTING_HAMMOND_SIZE, true)
    startDamageModification(WRECKING_BALLS, getPlayersOnHero(Hero.REINHARDT, Team.ALL), 150, DamageReeval.RECEIVERS_AND_DAMAGERS)
    WRECKING_BALLS.startScalingSize(SETTING_HAMMOND_SIZE, true)
    createEffect(getAllPlayers() if WRECKING_BALLS.getAltitude() < 100 else null, Effect.RING, Color.YELLOW, updateEveryTick(raycast(WRECKING_BALLS.getEyePosition(), WRECKING_BALLS.getEyePosition() + (Vector.DOWN * 1000), null, null, false).getHitPosition()), SETTING_HAMMOND_SIZE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    WRECKING_BALL_EFFECTS.append(getLastCreatedEntity())
    createBeam(getAllPlayers() if WRECKING_BALLS.getAltitude() < 100 else null, Beam.GOOD, updateEveryTick((WRECKING_BALLS.getEyePosition() + WRECKING_BALLS.getPosition()) / 2), updateEveryTick(raycast(WRECKING_BALLS.getEyePosition(), WRECKING_BALLS.getEyePosition() + (Vector.DOWN * 1000), null, null, false).getHitPosition()), Color.YELLOW, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    WRECKING_BALL_EFFECTS.append(getLastCreatedEntity())

def RESET_BALL():
    BALL_RESETTING = true
    WRECKING_BALLS.resurrect()
    WRECKING_BALLS[[Team.2, Team.1].index(TEAM_PHYSICS_OWNERSHIP)].startForcingPosition(vect(0, 100000, 0), false)
    WRECKING_BALLS[[Team.1, Team.2].index(TEAM_PHYSICS_OWNERSHIP)].setStatusEffect(null, Status.PHASED_OUT, 9999)
    WRECKING_BALLS.setStatusEffect(null, Status.UNKILLABLE, 9999)
    wait(1)
    WRECKING_BALLS.communicate(Comms.COUNTDOWN)
    wait(3.5)
    WRECKING_BALLS[[Team.2, Team.1].index(TEAM_PHYSICS_OWNERSHIP)].startForcingPosition(random.choice(SPAWNPOINTS), false)
    wait(0.25)
    WRECKING_BALLS.communicate(Comms.GO)
    WRECKING_BALLS.stopForcingPosition()
    WRECKING_BALLS[[Team.1, Team.2].index(TEAM_PHYSICS_OWNERSHIP)].clearStatusEffect(Status.PHASED_OUT)
    BALL_RESETTING = false

def REMOVE_BALL():
    # Remove Wrecking Ball Dummies
    destroyDummy(Team.1, 5)
    destroyDummy(Team.2, 5)

    WRECKING_BALLS = []

    # Remove Wrecking Ball Effects
    for GLOBAL_INDEX in range(0, len(WRECKING_BALL_EFFECTS)):
        destroyInWorldText(WRECKING_BALL_EFFECTS[GLOBAL_INDEX])
    WRECKING_BALL_EFFECTS = []

def KILL_BALL():
    # Clears any invulnerability effects
    WRECKING_BALLS.clearStatusEffect(Status.INVINCIBLE)
    WRECKING_BALLS.clearStatusEffect(Status.UNKILLABLE)
    WRECKING_BALLS.clearStatusEffect(Status.PHASED_OUT)

    # Hides the kill message temporarily and kills the Wrecking Ball dummies
    getAllPlayers().disableMessages()
    wait(0.032)
    kill(WRECKING_BALLS, LAST_PUSHED_PLAYER if LAST_PUSHED_PLAYER.getTeam() == Team.1 and distance(WRECKING_BALLS[Team1].getPosition(), TEAM_2_GOAL[0]) < TEAM_2_GOAL[1] or LAST_PUSHED_PLAYER.getTeam() == Team.2 and distance(WRECKING_BALLS[Team2].getPosition(), TEAM_1_GOAL[0]) < TEAM_1_GOAL[1] else null)
    wait(0.032)
    getAllPlayers().enableMessages()

def APPLY_IMPULSE():
    victim.applyImpulse(vect(eventDirection.x, 0, eventDirection.z) if eventPlayer.getCurrentHero() != Hero.REINHARDT else directionTowards(vect(attacker.getPosition().x, WRECKING_BALLS.getPosition().y, attacker.getPosition().z), victim.getPosition()), eventDamage * SETTING_LAUNCH_RATE if eventAbility == Button.MELEE or (eventAbility == Button.SECONDARY_FIRE and eventPlayer.getCurrentHero() == Hero.LUCIO) or (eventAbility == Button.ABILITY_2 and eventPlayer.getCurrentHero() == Hero.WIDOWMAKER) else (eventDamage / 8) * SETTING_LAUNCH_RATE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

def SET_PHYSICS_OWNERSHIP_START():
    WRECKING_BALLS.disablePlayerCollision()
    WRECKING_BALLS.detach()
    wait(0.032)

rule "Force Into Ball Form":
    @Event global
    @Condition any([not ball.isInAlternateForm() for ball in WRECKING_BALLS])
    
    [ball for ball in WRECKING_BALLS if not ball.isInAlternateForm()].forceButtonPress(Button.ABILITY_1)
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START

rule "Force Half Health Ball":
    @Event global
    @Condition any([ball.getNormalizedHealth() == 1 for ball in WRECKING_BALLS])

    damage([ball for ball in WRECKING_BALLS if ball.getNormalizedHealth() == 1], null, 100)
    wait()
    if RULE_CONDITION:
        goto RULE_START
    

rule "Enforce Ball Attachment":
    @Event global
    @Condition distance(WRECKING_BALLS[Team1].getPosition(), WRECKING_BALLS[Team2].getPosition()) > 1

    # If the Wrecking Ball Dummies are too far apart, re-attach them.
    
    if TEAM_PHYSICS_OWNERSHIP == Team.1:
        TEAM_PHYSICS_OWNERSHIP = Team.2
        wait(0.125)
        TEAM_PHYSICS_OWNERSHIP = Team.1
    elif TEAM_PHYSICS_OWNERSHIP == Team.2:
        TEAM_PHYSICS_OWNERSHIP = Team.1
        wait(0.125)
        TEAM_PHYSICS_OWNERSHIP = Team.2
    wait(0.125)
    if RULE_CONDITION:
        goto RULE_START

rule "Set Physics Ownership to Team 1":
    @Event global
    @Condition TEAM_PHYSICS_OWNERSHIP == Team.1
    
    SET_PHYSICS_OWNERSHIP_START()
    WRECKING_BALLS[Team1].attachTo(WRECKING_BALLS[Team2], vect(0, 0, 0))
    WRECKING_BALLS[Team1].setInvisibility(Invis.ALL)
    WRECKING_BALLS[Team2].setInvisibility(Invis.NONE)
    WRECKING_BALLS.enablePlayerCollision()

rule "Set Physics Ownership to Team 2":
    @Event global
    @Condition TEAM_PHYSICS_OWNERSHIP == Team.2
    
    SET_PHYSICS_OWNERSHIP_START()
    WRECKING_BALLS[Team2].attachTo(WRECKING_BALLS[Team1], vect(0, 0, 0))
    WRECKING_BALLS[Team1].setInvisibility(Invis.NONE)
    WRECKING_BALLS[Team2].setInvisibility(Invis.ALL)
    WRECKING_BALLS.enablePlayerCollision()

rule "Set Physics Ownership (Damage)":
    @Event playerDealtDamage
    @Hero all
    @Condition not attacker in WRECKING_BALLS
    @Condition victim in WRECKING_BALLS
    @Condition ATTACHING_ALLOWED == true
    @Condition TEAM_PHYSICS_OWNERSHIP != eventPlayer.getTeam()
    @Condition all([not ball.hasStatusEffect(Status.HACKED) for ball in WRECKING_BALLS])
    
    ATTACHING_ALLOWED = false
    TEAM_PHYSICS_OWNERSHIP = eventPlayer.getTeam()
    wait(0.032)
    APPLY_IMPULSE()
    ATTACHING_ALLOWED = true

rule "Set Physics Ownership (Knockback)":
    @Event playerDealtKnockback
    @Hero all
    @Condition not attacker in WRECKING_BALLS
    @Condition victim in WRECKING_BALLS
    @Condition ATTACHING_ALLOWED == true
    @Condition TEAM_PHYSICS_OWNERSHIP != eventPlayer.getTeam()
    @Condition all([not ball.hasStatusEffect(Status.HACKED) for ball in WRECKING_BALLS])
    
    ATTACHING_ALLOWED = false
    TEAM_PHYSICS_OWNERSHIP = eventPlayer.getTeam()
    wait(0.032)
    victim.applyImpulse(eventDirection, SETTING_LAUNCH_RATE * 25, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    ATTACHING_ALLOWED = true

rule "Set Last Pushed Player (Damage)":
    @Event playerDealtDamage
    @Hero all
    @Condition not attacker in WRECKING_BALLS
    @Condition victim in WRECKING_BALLS

    LAST_PUSHED_PLAYER = eventPlayer

rule "Set Last Pushed Player (Knockback)":
    @Event playerDealtKnockback
    @Hero all
    @Condition not attacker in WRECKING_BALLS
    @Condition victim in WRECKING_BALLS

    LAST_PUSHED_PLAYER = eventPlayer

rule "Set Last Pushed Player (Healing)":
    @Event playerDealtHealing
    @Hero all
    @Condition not healer in WRECKING_BALLS
    @Condition healee in WRECKING_BALLS

    if healer.getCurrentHero() == Hero.LUCIO: return
    LAST_PUSHED_PLAYER = eventPlayer
    wait(1)

rule "Apply Impulse":
    @Event playerDealtDamage
    @Hero all
    @Condition not attacker in WRECKING_BALLS
    @Condition victim in WRECKING_BALLS
    
    APPLY_IMPULSE()
    
    if eventAbility == Button.MELEE: eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 5)

rule "Apply Healing Impulse":
    @Event playerDealtHealing
    @Hero all
    @Condition not healer in WRECKING_BALLS
    @Condition healee in WRECKING_BALLS
    
    WRECKING_BALLS.applyImpulse(vect(eventDirection.x, 0, eventDirection.z), (eventHealing / 5) * SETTING_LAUNCH_RATE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

rule "Set Ball Outlines":
    @Event eachPlayer
    @Condition entityExists(WRECKING_BALLS)

    wait(0.032)
    WRECKING_BALLS.disableNameplatesFor(eventPlayer)
    WRECKING_BALLS.startForcingOutlineFor(eventPlayer, true, Color.WHITE, OutlineVisibility.ALWAYS)

rule "Set Team Ownership When Reinhardt Pins Ball":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()
    @Condition ATTACHING_ALLOWED
    @Condition raycast((eventPlayer.getEyePosition() + eventPlayer.getPosition()) / 2, ((eventPlayer.getEyePosition() + eventPlayer.getPosition()) / 2) + worldVector(vect(0, 0, 5), eventPlayer, Transform.ROTATION_AND_TRANSLATION), WRECKING_BALLS, eventPlayer, false).getPlayerHit() != null

    ATTACHING_ALLOWED = false
    TEAM_PHYSICS_OWNERSHIP = eventPlayer.getTeam()
    LAST_PUSHED_PLAYER = eventPlayer
    WRECKING_BALLS.setStatusEffect(null, Status.INVINCIBLE, 3)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    WRECKING_BALLS.clearStatusEffect(Status.INVINCIBLE)
    ATTACHING_ALLOWED = true
rule "Zarya Bubble Disappearing":
    @Condition any([ball.hasStatusEffect(Status.INVINCIBLE) for ball in WRECKING_BALLS])

    damage(WRECKING_BALLS, null, 400)

rule "Set Team Ownership When Sombra Hacks Ball":
    @Condition any([ball.hasStatusEffect(Status.HACKED) for ball in WRECKING_BALLS])

    if (WRECKING_BALLS[Team1].hasStatusEffect(Status.HACKED) and TEAM_PHYSICS_OWNERSHIP == Team.1) or (WRECKING_BALLS[Team2].hasStatusEffect(Status.HACKED) and TEAM_PHYSICS_OWNERSHIP == Team.2):
        TEAM_PHYSICS_OWNERSHIP = getOppositeTeam(TEAM_PHYSICS_OWNERSHIP)

rule "Lower Ball Health for Echo Beam":
    @Event playerDealtDamage
    @Hero echo
    @Condition not eventPlayer.isDuplicatingAHero()
    @Condition eventPlayer.isUsingAbility2()
    @Condition not attacker in WRECKING_BALLS
    @Condition victim in WRECKING_BALLS
    @Condition ATTACHING_ALLOWED

    damage(victim, null, victim.getMaxHealthOfType(Health.NORMAL))
    wait(0.5)