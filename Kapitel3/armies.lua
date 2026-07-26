Armies = {}
CONST_ARMY_INDEX = 0
Ghosttypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4},{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,3}}
NVTypes = {{Entities.CU_Evil_LeaderBearman1,20},{Entities.CU_Evil_LeaderSkirmisher1,20}}
NVMeeleTypes = {{Entities.CU_Evil_LeaderBearman1,20},{Entities.CU_Evil_LeaderSpearman1,20},{Entities.CU_Evil_LeaderCavalry1,8}}
GhostMeeleTypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4}}

function createInitialArmies()
    StartCountdown(60, createAttackingArmies,false)
    createArmyStartP1HQ()
    createSpawnerClaymine()
    createSpawnerNearBase()
    createSpawnerStone()
    createSpawnerSulfurBarracks()
    createSpawnerSulfurArchery()
    createSpawnerSulfurBarracksAdvance()
    --createSpawnerSulfurArcheryAdvance()
    createSpawnerGhostIsland()
    createSpawnerGhostIslandAdvance()
    createSpawnerBlackKnights()
    createSpawnerCaveMiddleCav()
    createSpawnerDefTop()
    createSpawnerDefBottom()
    createSpawnerDefTop2()
    createSpawnerDefBottom2()
end

function createAttackingArmies()
    createSpawnerCaveTopGhostAdvance()
    createSpawnerCaveTopNVAdvance()
    createSpawnerCaveMiddleGhostAdvance()
    createSpawnerCaveMiddleNVAdvance()
    createSpawnerCaveMiddleCavAdvance()
    createSpawnerBlackKnightsAdvance()
end

function createArmyStartP1HQ()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("sp1hqspawn"),
        rodeLength = 3500
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.PU_LeaderSword1_Spectral

    for i = 1, 1 + Difficulty * 2 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.PU_LeaderRifle1_Spectral

    for i = 1, 1 + Difficulty * 2 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})

    ARMYINDEXP1HQ = CONST_ARMY_INDEX

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerClaymine()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 4 + 2,
        position = GetPosition("startingGhostSpawn"),
        rodeLength = 3500,
        respawnTime = 120,
        spawnGenerator = GetEntityId("startingGhostSpawner"),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("startingClaymineGhostSpawn",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "startingGhostSpawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerNearBase()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3 + 8,
        position = GetPosition("nearbasespawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("nearbasespawner"),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("nearbySpawn",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "nearbasespawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerNearBaseAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 2,
        position = GetPosition("nearbasespawn"),
        rodeLength = 3500,
        respawnTime = 180,
        spawnGenerator = GetEntityId("nearbasespawner"),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("nearbySpawnAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "nearbasespawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerStone()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = Difficulty + 2,
        position = GetPosition("stonespawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("stonespawner"),
        spawnTypes = NVTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("stoneMineSpawn",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "stonespawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerStoneAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = Difficulty,
        position = GetPosition("stonespawn"),
        rodeLength = 3500,
        respawnTime = 500,
        spawnGenerator = GetEntityId("stonespawner"),
        spawnTypes = NVTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("stoneMineSpawnAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "stonespawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerSulfurBarracks()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3,
        position = GetPosition("barracksghostsulfurspawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("barracksghostsulfur"),
        spawnTypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("barracksghostsulfurspawn",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "barracksghostsulfur"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerSulfurBarracksAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 5 + 6,
        position = GetPosition("barracksghostsulfurspawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("barracksghostsulfur"),
        spawnTypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("barracksghostsulfurspawnAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "barracksghostsulfur"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerSulfurArchery()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3,
        position = GetPosition("archeryghostsulfurspawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("archeryghostsulfur"),
        spawnTypes = {{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("archeryghostsulfurspawn",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "archeryghostsulfur"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerSulfurArcheryAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 4 + 2,
        position = GetPosition("archeryghostsulfurspawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("archeryghostsulfur"),
        spawnTypes = {{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("archeryghostsulfurspawnAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "archeryghostsulfur"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerGhostIsland()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3 + 8,
        position = GetPosition("barracksghostislandspawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("barracksghostisland"),
        spawnTypes = {{Entities.PU_LeaderSword4_Spectral,12}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("barracksghostislandspawn",Armies[CONST_ARMY_INDEX])

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("islandghostdef"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "barracksghostisland"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerGhostIslandAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 2,
        position = GetPosition("barracksghostislandspawn"),
        rodeLength = 3500,
        respawnTime = 180,
        spawnGenerator = GetEntityId("barracksghostisland"),
        spawnTypes = {{Entities.PU_LeaderSword4_Spectral,12}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("barracksghostislandspawnAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "barracksghostisland"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveTopGhostAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 6 + 20,
        position = GetPosition("cavespawntop"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp5"),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("createSpawnerCaveTopGhostAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp5"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveTopGhostAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 6 + 20,
        position = GetPosition("cavespawntop"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp5"),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerCaveTopGhostAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp5"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveTopNVAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = Difficulty * 3 + 5,
        position = GetPosition("cavespawntop"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp6"),
        spawnTypes = NVTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerCaveTopNVAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp6"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveTopGhostAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 6 + 15,
        position = GetPosition("cavespawntop"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp5"),
        spawnTypes = GhostMeeleTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerCaveTopGhostAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp5"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveTopNVAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = Difficulty * 3 + 3,
        position = GetPosition("cavespawntop"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp6"),
        spawnTypes = NVMeeleTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerCaveTopNVAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp6"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveMiddleGhostAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 6 + 12,
        position = GetPosition("cavespawnmiddle"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp5"),
        spawnTypes = GhostMeeleTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerCaveMiddleGhostAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp5"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveMiddleNVAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = Difficulty * 3 + 2,
        position = GetPosition("cavespawnmiddle"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("spawnerp6"),
        spawnTypes = NVMeeleTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerCaveMiddleNVAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "spawnerp6"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveMiddleCav()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3 + 4,
        position = GetPosition("middlecavspawn"),
        rodeLength = 4000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("middlecavspawner"),
        spawnTypes = {{Entities.PU_LeaderHeavyCavalry2,4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("middlecavspawner",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "middlecavspawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerCaveMiddleCavAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3 + 2,
        position = GetPosition("middlecavspawn"),
        rodeLength = 40000,
        respawnTime = 60,
        spawnGenerator = GetEntityId("middlecavspawner"),
        spawnTypes = {{Entities.PU_LeaderHeavyCavalry2,4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("middlecavspawneradvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "middlecavspawner"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerBlackKnights()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3,
        position = GetPosition("bkspawn"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("bk6"),
        spawnTypes ={{Entities.CU_BlackKnight_LeaderMace1,4},{Entities.CU_BlackKnight_LeaderMace2,4},{Entities.CU_BlackKnight_LeaderSword3,6},{Entities.CU_VeteranCaptain,0},{Entities.CU_VeteranMajor,2}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("bkspawndef",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "bk6"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerBlackKnightsAdvance()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty * 3,
        position = GetPosition("bkspawn"),
        rodeLength = 3500,
        respawnTime = 180,
        spawnGenerator = GetEntityId("bk6"),
        spawnTypes = {{Entities.CU_BlackKnight_LeaderMace1,4},{Entities.CU_BlackKnight_LeaderMace2,4},{Entities.CU_BlackKnight_LeaderSword3,6},{Entities.CU_VeteranCaptain,0},{Entities.CU_VeteranMajor,2}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("bkspawndefAdvance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, "bk6"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end


function createSpawnerDefTop()
    Armies[CONST_ARMY_INDEX] = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 1,
        position = GetPosition("upperwallsdeftop"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("archerytop"),
        spawnTypes = {{Entities.PU_LeaderBow4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerDefTop",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "archerytop"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerDefBottom()
    Armies[CONST_ARMY_INDEX] = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 1,
        position = GetPosition("upperwallsdefbottom"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("archerytop"),
        spawnTypes = {{Entities.PU_LeaderBow4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerDefBottom",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "archerytop"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerDefTop2()
    Armies[CONST_ARMY_INDEX] = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 1,
        position = GetPosition("lowerwalldeftop"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("archerybottom"),
        spawnTypes = {{Entities.PU_LeaderBow4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerDefTop2",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "archerybottom"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpawnerDefBottom2()
    Armies[CONST_ARMY_INDEX] = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 1,
        position = GetPosition("lowerdefwallbottom"),
        rodeLength = 3500,
        respawnTime = 60,
        spawnGenerator = GetEntityId("archerybottom"),
        spawnTypes = {{Entities.PU_LeaderBow4}},
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator("SpawnerDefBottom2",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, "archerybottom"})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyDefendSpawner(_id, _spawner)
    if Counter.Tick2("controlArmyDefendSpawner" .. _id, 2) then
        if IsDead(Armies[_id]) then
            if IsDead(_spawner) then
                return true
            end
            return false
        end
        Defend(Armies[_id])
    end
end

function controlArmyAdvanceSpawner(_id, _spawner)
    if Counter.Tick2("controlArmyDefendSpawner" .. _id, 2) then
        if IsDead(Armies[_id]) then
            if IsDead(_spawner) then
                return true
            end
            return false
        end
        Advance(Armies[_id])
    end
end

function controlArmyDefend(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Defend(Armies[_id])
end