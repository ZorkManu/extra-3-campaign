CONST_ARMY_INDEX = 0
Armies = {}
Ghosttypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4},{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,4}}
NVTypes = {{Entities.CU_Evil_LeaderBearman1,20},{Entities.CU_Evil_LeaderSkirmisher1,20}}
NECROID = 0
NECROPOS = {}

function InitSpawner()
    for i = 1, 12 do
        createRegularSpawnerGhostDefend("sp" .. i,"spp" .. i)
    end
    for i = 1, 8 do
        createRegularSpawnerGhostDefend("mt" .. i,"mtp" .. i)
    end
    for i = 1, 5 do
        createRegularSpawnerGhostDefend("mtb" .. i,"mtbp" .. i)
    end
    for i = 1, 4 do
        createRegularSpawnerNVDefend("nv" .. i, "nvp" .. i)
    end
    for i = 1, 2 do
        createRegularSpawnerNVDefend("reeinfSpawner" .. i, "reeinfSpawn" .. i)
    end
    createRegularSpawnerNVDefend("abandonedVillage","vcarmy")
    for i = 1, 2 do
        createRegularSpawnerGhostAdvance("sp" .. i,"spp" .. i)
    end
    for i = 9, 10 do
        createRegularSpawnerGhostAdvance("sp" .. i,"spp" .. i)
    end

    createGhostHeroArmy()
    for i = 1, Difficulty do
        createMountainNecro()
    end
    Counter.Tick2("Timeline", 3600)
    StartSimpleJob("Timeline")
end

function Timeline()
    Counter.Tick("Timeline")
    local tick = Counter.GetTick("Timeline")
    tick = tick + Difficulty * 120
    if tick == 5100 then
        return true
    end

    --SpawnerActivation
    if tick == 1300 then
         --main Enemy
        createRegularSpawnerGhostAdvance("sp3","spp3")
        createRegularSpawnerGhostAdvance("sp8","spp8")
        --mountainbase
        createRegularSpawnerGhostAdvance("mtb1","mtbp1")
    end
    if tick == 1900 then
         --main Enemy
        createRegularSpawnerNVAdvance("nv1","nvp1")
        createRegularSpawnerNVAdvance("nv2","nvp2")
    end
    if tick == 2200 then
         --main Enemy
        createRegularSpawnerGhostAdvance("sp4","spp4")
        createRegularSpawnerGhostAdvance("sp4","spp4")
        --mountainbase
        createRegularSpawnerGhostAdvance("mtb2","mtbp2")
    end
    if tick == 2600 then
         --main Enemy
        createRegularSpawnerNVAdvance("nv3","nvp3")
    end
    if tick == 3100 then
         --main Enemy
        createRegularSpawnerGhostAdvance("sp5","spp5")
        createRegularSpawnerGhostAdvance("sp7","spp7")
        --mountainbase
        createRegularSpawnerGhostAdvance("mtb3","mtbp3")
    end
    if tick == 3900 then
         --main Enemy
        createRegularSpawnerNVAdvance("nv3","nvp3")
        --mountainbase
        createRegularSpawnerGhostAdvance("mtb4","mtbp4")
        createRegularSpawnerNVAdvance("reeinfSpawner1","reeinfSpawn1")
    end
    if tick == 4100 then
         --main Enemy
        createRegularSpawnerGhostAdvance("sp6","spp6")
        --mountainbase
        createRegularSpawnerGhostAdvance("mtb5","mtbp5")
        createRegularSpawnerNVAdvance("reeinfSpawner2","reeinfSpawn2")
    end

    --enemyupgrades
    if tick == 4600 then
        ResearchTechnology(Technologies.T_EvilArmor1,5)
        ResearchTechnology(Technologies.T_EvilSpears1,5)
    end
    if tick == 5000 then
        ResearchTechnology(Technologies.T_BloodRush,5)
        ResearchTechnology(Technologies.T_HeroicShoes,5)
        ResearchTechnology(Technologies.T_HeroicArmor,5)
    end
    if tick == 1700 then
        ResearchTechnology(Technologies.T_BetterTrainingArchery,6)
        ResearchTechnology(Technologies.T_BetterTrainingBarracks,6)
        ResearchTechnology(Technologies.T_LeatherArcherArmor,6)
        ResearchTechnology(Technologies.T_LeatherMailArmor,6)
        ResearchTechnology(Technologies.T_HeroicShoes,6)
        ResearchTechnology(Technologies.T_HeroicArmor,6)
        ResearchTechnology(Technologies.T_HeroicWeapon,6)
    end
    if tick == 3000 then
        ResearchTechnology(Technologies.T_MasterOfSmithery,6)
        ResearchTechnology(Technologies.T_Fletching,6)
        ResearchTechnology(Technologies.T_FleeceArmor,6)
        ResearchTechnology(Technologies.T_ChainMailArmor,6)
        ResearchTechnology(Technologies.T_SoftArcherArmor,6)
        ResearchTechnology(Technologies.T_WoodAging,6)
        ResearchTechnology(Technologies.T_LeadShot,6)
    end
    if tick == 3400 then
        ResearchTechnology(Technologies.T_IronCasting,6)
        ResearchTechnology(Technologies.T_BodkinArrow,6)
        ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,6)
        ResearchTechnology(Technologies.T_PlateMailArmor,6)
        ResearchTechnology(Technologies.T_PaddedArcherArmor,6)
        ResearchTechnology(Technologies.T_Turnery,6)
        ResearchTechnology(Technologies.T_Sights,6)
    end
    if tick == 4200 then
        ResearchTechnology(Technologies.T_SilverSwords,6)
        ResearchTechnology(Technologies.T_SilverPlateArmor,6)
        ResearchTechnology(Technologies.T_SilverLance,6)
        ResearchTechnology(Technologies.T_SilverBullets,6)
        ResearchTechnology(Technologies.T_SilverArrows,6)
        ResearchTechnology(Technologies.T_SilverArcherArmor,6)
    end
end

function createGhostHeroArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("HeroArmy"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE


    troopDescription.leaderType = Entities.PU_Hero2_Spectral
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    if Difficulty >= 1 then
        troopDescription.leaderType = Entities.PU_Hero5_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    if Difficulty >= 2 then
        troopDescription.leaderType = Entities.PU_Hero4_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    if Difficulty >= 2 then
        troopDescription.leaderType = Entities.PU_Hero10_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createMountainNecro()
    local necroId = NECROID
    NECROID = NECROID + 1
    local pos = GetPosition("mtbp5")
    pos.X = pos.X + math.random(-50,50)
    pos.Y = pos.Y + math.random(-50,50)
    CreateMilitaryGroup(5,Entities.CU_Evil_Queen,0,pos, "necro" .. necroId)
    NECROPOS[necroId] = "destroyedVillage"
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlNecro" , 1, {}, {necroId})
    StartCountdown(1, function ()
        local id = GetEntityId("necro" .. necroId)
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Nekromant")
    end, false)
end

function controlNecro(_necroId)
    local name = "necro" .. _necroId
    if IsDead(name) then
        Logic.DestroyEntity(GetEntityId(name))
        if IsDead("mtb5") == false then
            createMountainNecro()
        end
        return true
    end
    if AreEnemiesInArea(5,GetPosition(name),600) then
        UseNecroAbility(name)
        if UseNecroAbility(name) == true then
            return false
        end
    end
    if IsNear(name,NECROPOS[_necroId],300) then
        NECROPOS[_necroId] = "mtbp5"
    end
    Move(name,GetPosition(NECROPOS[_necroId]))
end

function createRegularSpawnerGhostAdvance(_spawnerName, _spawnpoint)
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = math.ceil(Difficulty) + 1,
        position = GetPosition(_spawnpoint),
        rodeLength = 10000,
        respawnTime = 120,
        spawnGenerator = GetEntityId(_spawnerName),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator(_spawnerName .. "Advance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, _spawnerName})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createRegularSpawnerGhostDefend(_spawnerName, _spawnpoint)
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = Difficulty*2,
        position = GetPosition(_spawnpoint),
        rodeLength = 3000,
        respawnTime = 60,
        spawnGenerator = GetEntityId(_spawnerName),
        spawnTypes = Ghosttypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator(_spawnerName .. "Defend",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, _spawnerName})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createRegularSpawnerNVAdvance(_spawnerName, _spawnpoint)
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = math.ceil(Difficulty),
        position = GetPosition(_spawnpoint),
        rodeLength = 10000,
        respawnTime = 120,
        spawnGenerator = GetEntityId(_spawnerName),
        spawnTypes = NVTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator(_spawnerName .. "Advance",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, _spawnerName})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createRegularSpawnerNVDefend(_spawnerName, _spawnpoint)
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = math.ceil(Difficulty),
        position = GetPosition(_spawnpoint),
        rodeLength = 3000,
        respawnTime = 60,
        spawnGenerator = GetEntityId(_spawnerName),
        spawnTypes = NVTypes,
        endless = true,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator(_spawnerName .. "Defend",Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, _spawnerName})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyAdvanceSpawner(_id, _spawner)
    if Counter.Tick2("controlArmyAdvanceSpawner" .. _id, 2) then
        if IsDead(Armies[_id]) then
            if IsDead(_spawner) then
                return true
            end
            return false
        end
        Advance(Armies[_id])
    end
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

function controlArmyDefend(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Defend(Armies[_id])
end