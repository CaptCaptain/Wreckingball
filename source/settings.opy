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
                "workshopExpanse", "workshopIsland", "workshopIslandNight", "workshopExpanseNight", "busan", "nepal"
            ]
        },
        "general": {
            "setValidControlPoints": "first"
        }
    }
}

globalvar GLOBAL_INDEX = 0
playervar PLAYER_INDEX = 0
globalvar CURRENT_VERSION = '1.3.0'

enum GAME_STATE:
    WAITING_FOR_PLAYERS,
    SETUP,
    ROUND,
    RESULT,
    END

#!define GetMapData() __script__("mapData.js")
GetMapData()

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