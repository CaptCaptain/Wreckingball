let availableMapData = {
    WORKSHOP_ISLAND: {
        TEAM_1_SPAWN: '[vect(13, 0, 0), 3]',
        TEAM_2_SPAWN: '[vect(-13, 0, 0), 3]',
        ARENA: '[vect(0, 1, 0), 20]',
        BALL_SPAWNS: '[vect(0, 0, 0), vect(0, 0, 12), vect(0, 0, -12)]'
    },
    WORKSHOP_EXPANSE: {
        TEAM_1_SPAWN: '[vect(25, 0, 0), 4]',
        TEAM_2_SPAWN:'[vect(-25, 0, 0), 4]',
        ARENA: '[vect(0, 1, 0), 30]',
        BALL_SPAWNS: '[vect(0, 0, 0), vect(0, 0, 24), vect(0, 0, -24)]',
    },
    BUSAN: {
        TEAM_1_SPAWN: '[getObjectivePosition(1) + vect(30, 1.75, 0), 2]',
        TEAM_2_SPAWN:'[getObjectivePosition(1) + vect(-30, 1.75, 0), 2]',
        ARENA: '[getObjectivePosition(1) + vect(0, 3, 0), 35]',
        BALL_SPAWNS: '[nearestWalkablePosition(getObjectivePosition(1))]',
    },
    NEPAL: {
        TEAM_1_SPAWN: '[getObjectivePosition(0) + vect(2, -0.25, 16), 3]',
        TEAM_2_SPAWN:'[getObjectivePosition(0) + vect(2, -0.25, -16), 3]',
        ARENA: '[getObjectivePosition(0) + vect(0, 2, 0), 20]',
        BALL_SPAWNS: '[nearestWalkablePosition(getObjectivePosition(0))]',
    }
}

// Some maps are the same but take place in a different setting
availableMapData.WORKSHOP_ISLAND_NIGHT = availableMapData.WORKSHOP_ISLAND
availableMapData.WORKSHOP_CHAMBER = availableMapData.WORKSHOP_ISLAND
availableMapData.WORKSHOP_EXPANSE_NIGHT = availableMapData.WORKSHOP_EXPANSE
availableMapData.WORKSHOP_GREEN_SCREEN = availableMapData.WORKSHOP_EXPANSE

const dataType = {
    TEAM_1_SPAWN: 0,
    TEAM_2_SPAWN: 1,
    ARENA: 2,
    BALL_SPAWNS: 3
}


let maps = ''
let team_1_spawn = ''
let team_2_spawn = ''
let arena = ''
let ball_spawns = ''

result = ''

for (var mapData in availableMapData) {
    maps += 'Map.'+mapData+', '
    for (var data in mapData) {
        if (data == dataType.TEAM_1_SPAWN) {
            team_1_spawn += availableMapData[mapData].TEAM_1_SPAWN+', '
        } else if (data == dataType.TEAM_2_SPAWN) {
            team_2_spawn += availableMapData[mapData].TEAM_2_SPAWN+', '
        } else if (data == dataType.ARENA) {
            arena += availableMapData[mapData].ARENA+', '
        } else if (data == dataType.BALL_SPAWNS) {
            ball_spawns += availableMapData[mapData].BALL_SPAWNS+', '
        }
    }
}

result += 'globalvar TEAM_1_GOAL = '+'['+team_1_spawn+']'+'[['+maps+'].index(getCurrentMap())]\n'
result += 'globalvar TEAM_2_GOAL = '+'['+team_2_spawn+']'+'[['+maps+'].index(getCurrentMap())]\n'
result += 'globalvar ARENA = '+'['+arena+']'+'[['+maps+'].index(getCurrentMap())]\n'
result += 'globalvar SPAWNPOINTS = '+'['+ball_spawns+']'+'[['+maps+'].index(getCurrentMap())]\n'