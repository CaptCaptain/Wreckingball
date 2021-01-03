settings {
    "main": {
        "description": "In this fast-paced 4v4 brawl, there is one ball and a goal for each team. In order to score, the team must push the ball into the opposing team's goal. The ball can be pushed through dealing damage or healing it.\n[Created by CaptCaptain#11421] [https://workshop.codes/ball-soccer]"
    },
    "lobby": {
        "team1Slots": 4,
        "team2Slots": 4,
        "mapRotation": "afterGame",
        "returnToLobby": "never",
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "workshopExpanseNight"
            ]
        }
    }
}

globalvar GLOBAL_INDEX = 0
playervar PLAYER_INDEX = 0

enum MAP_DATA:
    WORKSHOP_ISLAND_TEAM_1 = [vect(13, 0, 0), 3],
    WORKSHOP_ISLAND_TEAM_2 = [vect(-13, 0, 0), 3],
    WORKSHOP_ISLAND_ARENA = [vect(0, 1, 0), 20],
    WORKSHOP_ISLAND_SPAWNS = [vect(0, 0, 0)],
    WORKSHOP_EXPANSE_TEAM_1 = [vect(25, 0, 0), 4],
    WORKSHOP_EXPANSE_TEAM_2 = [vect(-25, 0, 0), 4],
    WORKSHOP_EXPANSE_ARENA = [vect(0, 1, 0), 30],
    WORKSHOP_EXPANSE_SPAWNS = [vect(0, 0, 0)],
    PARIS_TEAM_1 = [vect(-128, 13, -90.80), 3],
    PARIS_TEAM_2 = [vect(-83.24, 13, -113.22), 3],
    PARIS_ARENA = [vect(-99.45, 14, -91.20), 30],
    PARIS_SPAWNS = [vect(-99.45, 12, -85)],
    HAVANA_TEAM_1 = [vect(40.398, 6, -51.491), 2],
    HAVANA_TEAM_2 = [vect(-2.061, 6, -51.491), 2],
    HAVANA_ARENA = [vect(19.701, 6.455, -51.491), 30],
    HAVANA_SPAWNS = [vect(19.701, 6.455, -51.491)]

enum GAME_STATE:
    WAITING_FOR_PLAYERS,
    SETUP,
    ROUND,
    RESULT,
    END

globalvar TEAM_1_GOAL = [MAP_DATA.WORKSHOP_ISLAND_TEAM_1, MAP_DATA.PARIS_TEAM_1, MAP_DATA.HAVANA_TEAM_1, MAP_DATA.WORKSHOP_EXPANSE_TEAM_1, MAP_DATA.WORKSHOP_EXPANSE_TEAM_1][[Map.WORKSHOP_ISLAND, Map.PARIS, Map.HAVANA, Map.WORKSHOP_EXPANSE, Map.WORKSHOP_EXPANSE_NIGHT].index(getCurrentMap())]
globalvar TEAM_2_GOAL = [MAP_DATA.WORKSHOP_ISLAND_TEAM_2, MAP_DATA.PARIS_TEAM_2, MAP_DATA.HAVANA_TEAM_2, MAP_DATA.WORKSHOP_EXPANSE_TEAM_2, MAP_DATA.WORKSHOP_EXPANSE_TEAM_2][[Map.WORKSHOP_ISLAND, Map.PARIS, Map.HAVANA, Map.WORKSHOP_EXPANSE, Map.WORKSHOP_EXPANSE_NIGHT].index(getCurrentMap())]
globalvar ARENA = [MAP_DATA.WORKSHOP_ISLAND_ARENA, MAP_DATA.PARIS_ARENA, MAP_DATA.HAVANA_ARENA, MAP_DATA.WORKSHOP_EXPANSE_ARENA, MAP_DATA.WORKSHOP_EXPANSE_ARENA][[Map.WORKSHOP_ISLAND, Map.PARIS, Map.HAVANA, Map.WORKSHOP_EXPANSE, Map.WORKSHOP_EXPANSE_NIGHT].index(getCurrentMap())]
globalvar SPAWNPOINTS = [MAP_DATA.WORKSHOP_ISLAND_SPAWNS, MAP_DATA.PARIS_SPAWNS, MAP_DATA.HAVANA_SPAWNS, MAP_DATA.WORKSHOP_EXPANSE_SPAWNS, MAP_DATA.WORKSHOP_EXPANSE_SPAWNS][[Map.WORKSHOP_ISLAND, Map.PARIS, Map.HAVANA, Map.WORKSHOP_EXPANSE, Map.WORKSHOP_EXPANSE_NIGHT].index(getCurrentMap())]

globalvar SETTING_SCORE_NEEDED = createWorkshopSetting(int[2:10], "Ruleset", "Score to Win", 6, 0)
globalvar SETTING_END_BEHAVIOR_RAW = createWorkshopSetting(enum["Skip End Game Screen", "Skip POTG", "Do Nothing"], "Ruleset", "When Match is Complete", 0, 2)
globalvar SETTING_END_BEHAVIOR = [25.9, 8, 9999][SETTING_END_BEHAVIOR_RAW]
globalvar SETTING_TIME_RAW = createWorkshopSetting(enum["3:00", "2:30", "2:00", "1:30", "1:00"], "Ruleset", "Time Remaining", 0, 1)
globalvar SETTING_WHILE_YOU_WAIT = createWorkshopSetting(bool, "Ruleset", "Enable While You Wait", false, 2)

globalvar SETTING_LAUNCH_RATE = createWorkshopSetting(float[0.1:2], "Advanced", "Launch Rate", 1, 0)
globalvar SETTING_HAMMOND_SIZE = createWorkshopSetting(float[0.1:5], "Advanced", "Wrecking Ball Size Scalar", 1.25, 0)
globalvar SETTING_SPEED_SCALAR = createWorkshopSetting(float[1:2], "Advanced", "Player Speed Scalar", 2, 1)

globalvar TEAM_1_SCORE = 0
globalvar TEAM_2_SCORE = 0
globalvar ROUND_NUMBER = 0
globalvar TIME_REMAINING = [180, 150, 120, 90, 60][SETTING_TIME_RAW]

globalvar CURRENT_GAME_STATE = GAME_STATE.WAITING_FOR_PLAYERS

#!include "ball.opy"
#!include "player.opy"
#!include "goal.opy"
#!include "game.opy"