Armies = {}
CONST_ARMY_INDEX = 0
ATTACKER_KILLED = 0
GHOST_SPAWNER_TIMER = 0
GHOSTHQ1DEAD = false
GhostArmies = {}
Ghosttypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4},{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,3}}

function createArmyMine()
    for i = 1, 3 do
        Armies[CONST_ARMY_INDEX] = {
            player = 2,
            id = GetFirstFreeArmySlot(2),
            strength = 8,
            position = GetPosition("minedef" .. i),
            rodeLength = 3000
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 8
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.PU_LeaderSword3

        for j = 1, 1 + Difficulty do
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        troopDescription.leaderType = Entities.PU_LeaderBow3

        for j = 1, Difficulty - 1 do
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function initDefenderArmies()
    for i = 1, 8 do
        if (i > 2 and i < 7) or ((i == 2 or i == 7) and (Difficulty >= 2)) or ((i == 1 or i == 8) and (Difficulty == 3)) then
            Armies[CONST_ARMY_INDEX] = {
                player = 2,
                id = GetFirstFreeArmySlot(2),
                strength = 8,
                position = GetPosition("def" .. i),
                rodeLength = 100
            }
        
            SetupArmy(Armies[CONST_ARMY_INDEX])
        
            local troopDescription = {}
            troopDescription.maxNumberOfSoldiers = 8
            troopDescription.minNumberOfSoldiers = 1
            troopDescription.experiencePoints = HIGH_EXPERIENCE
            troopDescription.leaderType = Entities.PU_LeaderSword3

            --local enlarge = 1
           -- if Modulo(i, 2) and i ~= 8 and i ~= 2 and Difficulty >= 2 then
                --enlarge = 2
            --end
        
            --for j = 1, enlarge do
                EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
            --end
        
            troopDescription.leaderType = Entities.PU_LeaderBow3
        
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyNevassaDefender" , 1, {}, {CONST_ARMY_INDEX})
            CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
        end
    end
    ARMYYUKI = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 8,
        position = GetPosition("defYuki"),
        rodeLength = 10000
    }
    
    SetupArmy(ARMYYUKI)
    
    ConnectLeaderWithArmy(GetEntityId("Yuki"),ARMYYUKI)
    
    StartSimpleJob("ControlYuki")
end

function controlArmyNevassaDefender(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    if NEVASSA_REACHED then
        Advance(Armies[_id])
        return false
    end
end

function initGhostSpawnerIsland()
    for i = 1, 6 do
        initGhostAttackIsland(i)
    end
end

function initGhostAttackIsland(_id)
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("ghostreeinf" .. _id),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 15 - gvDiffLVL*2
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyGhostAdvanceIsland" , 1, {}, {CONST_ARMY_INDEX, _id})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyGhostAdvanceIsland(_id, _spawnId)
    if IsDead(Armies[_id]) then
        if Counter.Tick2("ghostrespawnislandattack".._spawnId,60) then
            if DAYORNIGHT == "night" then
                initGhostAttackIsland(_spawnId)
            end
            return true
        end
        return false
    end
    Advance(Armies[_id])
end


function createTownAttacker()
    for i = 1, 4 do
        Armies[CONST_ARMY_INDEX] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = GetPosition("ghostattack" .. i),
            rodeLength = 10000
        }
        
        SetupArmy(Armies[CONST_ARMY_INDEX])
        
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 8
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        
        for j = 1, 4 + Difficulty*2 do
            troopDescription.leaderType = getRandomGhostTroop()
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end
        
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceAttacker" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function controlArmyAdvanceAttacker(_id)
    if IsDead(Armies[_id])then
        ATTACKER_KILLED = ATTACKER_KILLED + 1
        return true
    end
    Advance(Armies[_id])
end

function createTownDefender()
    for i = 11, 14 do
        Armies[CONST_ARMY_INDEX] = {
            player = 2,
            id = GetFirstFreeArmySlot(2),
            strength = 8,
            position = GetPosition("def" .. i),
            rodeLength = 10000
        }
        
        SetupArmy(Armies[CONST_ARMY_INDEX])
        
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 8
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.PU_LeaderSword3
        
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        
        troopDescription.leaderType = Entities.PU_LeaderBow3
        
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
    ARMYYUKI = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 8,
        position = GetPosition("Yuki"),
        rodeLength = 10000
    }
    
    SetupArmy(ARMYYUKI)
    
    ConnectLeaderWithArmy(GetEntityId("Yuki"),ARMYYUKI)
    
    StartSimpleJob("ControlYuki")
end

function controlYuki()
    if IsDead(ARMYYUKI) then
        return true
    end
    Advance(ARMYYUKI)
end

function initEnemyDefenderArmies()
    createOneTimeGhostDefender()
    createOneTimeNVDefender()
    initGhostDefenseSpawner(1)
    initGhostDefenseSpawner(2)
    initNVDefenseSpawner(1, "nv1")
end

function initGhostDefenseSpawner(_id)
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("gdefspawn" .. _id),
        rodeLength = 4000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.PU_LeaderPoleArm3

    local amount = Difficulty*2
        
    for j = 1, amount do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.PU_LeaderBow3

    for j = 1, amount do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX, _id})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyGhostDefenseSpawner(_id, _spawnId)
    if IsDead(Armies[_id]) then
        if Counter.Tick2("ghostrespawn".._spawnId,900-Difficulty*30) then
            initGhostDefenseSpawner(_spawnId)
            return true
        end
        return false
    end
    Defend(Armies[_id])
end

function initNVDefenseSpawner(_id, _spawner)
    if IsDead(_spawner) then
        return true
    end
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("nvspawn" .. _id),
        rodeLength = 5000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty * 3 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyNVDevenseSpawner" , 1, {}, {CONST_ARMY_INDEX, _id, _spawner})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyNVDefenseSpawner(_id, _spawnId, _spawner)
    if IsDead(Armies[_id]) then
        if Counter.Tick2("nvrespawn".._spawner,30) then
            initNVDefenseSpawner(_spawnId, _spawner)
            return true
        end
        return false
    end
    Defend(Armies[_id])
end

function createOneTimeGhostDefender()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("oneTimeDef1"),
        rodeLength = 4000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.PU_LeaderPoleArm3

    for j = 1, Difficulty do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.PU_LeaderBow3

    for j = 1, Difficulty do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createOneTimeNVDefender()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("nventrance"),
        rodeLength = 2500
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*2 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createOneTimeGhostAttacker()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("oneTimeDef2"),
        rodeLength = 2800
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, 6 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function initPlayerThreeAndFourSpawner()
    for i = 1, 10 do
        initGhostAttackSpawner(i, "g" .. i)
    end
    initGhostHQSpawner()
end

function initGhostAttackSpawner(_id, _spawner)
    local pid = 4
    if _id > 4 and _id < 8 then
        pid = 3
    end
    if IsDead(_spawner) or DAYORNIGHT == "day" then
        return true
    end
    GhostArmies[_spawner] = {
        player = pid,
        id = GetFirstFreeArmySlot(pid),
        strength = 8,
        position = GetPosition("gspawn" .. _id),
        rodeLength = 10000
    }
        
    SetupArmy(GhostArmies[_spawner])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    local amount = Difficulty
    if Modulo(_id,2) == 0 then
        amount = amount - 1
    end
    if amount == 0 then
        return true
    end

    amount = amount + math.ceil(GHOST_SPAWNER_TIMER/9*gvDiffLVL)
    if pid == 3 then
        amount = Difficulty
    end
        
    for j = 1, amount do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(GhostArmies[_spawner], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyGhostAdvanceSpawner" , 1, {}, { _id, _spawner})
end

function initGhostHQSpawner()

    if IsDead("ghosthq1") or DAYORNIGHT == "day" then
        return true
    end
    GhostArmies["ghosthq1"] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("ghqspawn1"),
        rodeLength = 10000
    }
        
    SetupArmy(GhostArmies["ghosthq1"])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 15 - gvDiffLVL * 3
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    
    troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
    EnlargeArmy(GhostArmies["ghosthq1"], troopDescription)
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyGhostAdvanceSpawner" , 1, {}, { "ghosthq1", "ghosthq1"})
end

function controlArmyGhostAdvanceSpawner(_spawnId, _spawner)
    if IsDead(GhostArmies[_spawner]) then
        if DAYORNIGHT == "night" then
            if _spawnId == "ghosthq1" then
                initGhostHQSpawner()
            else
                initGhostAttackSpawner(_spawnId,_spawner)
            end
        end
        return true
    end
    Advance(GhostArmies[_spawner])
end

function initPlayerFiveSpawner()
    for i = 2, 3 do
        initNVAttackSpawner(i, "nv" .. i)
    end
    for i = 2, 9 do
        initNVDefenseSpawner(i, "nv" .. i)
    end
end

function initNVAttackSpawner(_id, _spawner)
    if IsDead(_spawner) then
        return true
    end
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("nvspawn" .. _id),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    if GHOSTHQ1DEAD then
        troopDescription.maxNumberOfSoldiers = 20
    end
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyNVAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, _id, _spawner})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyNVAdvanceSpawner(_id, _spawnId, _spawner)
    if IsDead(Armies[_id]) then
        if Counter.Tick2("NVrespawn".._spawner,300) then
            initNVAttackSpawner(_spawnId, _spawner)
            return true
        end
        return false
    end
    Advance(Armies[_id])
end

function summonFirstWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])


    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*2 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonSecondWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*2 + 1 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty + 1 do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonThirdWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*3 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty*2 do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonFourthWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*3 +3 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty*2 do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonFifthWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*3 +2 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty*2 do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonSixthWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*3 +5 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.CU_Evil_Troll1
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonSeventhWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*3 +7 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty do
        troopDescription.leaderType = Entities.CU_Evil_Troll1
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonEighthWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*4 +1 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty*2 do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonNinthWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, Difficulty +3 do
        troopDescription.leaderType = Entities.CU_Evil_Troll1
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function summonTenthWave()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("enemyWaveSpawn"),
        rodeLength = 10000
    }
        
    local troopDescription = {}
    SetupArmy(Armies[CONST_ARMY_INDEX])
        
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
        
    for j = 1, Difficulty*4 +5 do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, Difficulty*3 do
        troopDescription.leaderType = getRandomSkorpion()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
        
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createArmyUprising()
    for i  = 1, 2 do
        Armies[CONST_ARMY_INDEX] = {
            player = 6,
            id = GetFirstFreeArmySlot(6),
            strength = 8,
            position = GetPosition("armySpawnUprising" .. i),
            rodeLength = 10000
        }
        
        SetupArmy(Armies[CONST_ARMY_INDEX])
        
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        
        troopDescription.leaderType = Entities["PU_LeaderPoleArm" .. Difficulty]
        for j = 1, 5 do
           EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end
        
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function controlArmyAdvance(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Advance(Armies[_id])
end

function controlArmyDefend(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Defend(Armies[_id])
end

function controlArmyDefendSpawner(_id, _spawner)
    if IsDead(Armies[_id]) then
        initSpawner(_id, _spawner)
        return true
    end
    Advance(Armies[_id])
end


function getRandomGhostTroop()
    local randomGenerator = math.random()
    if randomGenerator < 0.25 then
        return Entities.PU_LeaderSword1_Spectral
    elseif randomGenerator < 0.50 then
        return Entities.PU_LeaderPoleArm1_Spectral
    elseif randomGenerator < 0.75 then
        return Entities.PU_LeaderBow1_Spectral
    else
        return Entities.PU_LeaderRifle1_Spectral
    end
end

function getRandomNVTroop()
    local randomGenerator = math.random()
    if randomGenerator < 0.5 then
        return Entities.CU_Evil_LeaderBearman1
    else
        return Entities.CU_Evil_LeaderSkirmisher1
    end
end

function getRandomSkorpion()
    local randomGenerator = math.random()
    if randomGenerator < 33 then
        return Entities.CU_AggressiveScorpion1
    elseif randomGenerator < 66 then
        return Entities.CU_AggressiveScorpion2
    else
        return Entities.CU_AggressiveScorpion3
    end
end