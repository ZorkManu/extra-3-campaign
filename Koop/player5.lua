function InitPlayer5SideHustle()
    initPlayerFiveTroops()
    initCaveTrolls()
    createCaveDef()
    createSulfurDef()
    createSilverDef()
    createCaveArmy()
    StartSimpleJob("checkForBootsChest")
    StartSimpleJob("checkForPlayerFiveHQ")
    StartSimpleJob("checkForCaveExit")
end

function initPlayerFiveTroops()
    for i = 1, 2 do
        CreateMilitaryGroup(5, Entities.CU_BlackKnight_LeaderMace1, 4, GetPosition("bk" .. i))
        CreateMilitaryGroup(5, Entities.PU_LeaderBow4, 10, GetPosition("bow"  .. i))
    end
    CreateMilitaryGroup(5, Entities.CU_BlackKnight_LeaderSword3, 8, GetPosition("blackswords"))
end

function initCaveTrolls()
    for i = 1, 2 do
        CreateMilitaryGroup(8, Entities.CU_Evil_Troll1, 0, GetPosition("trollspawn" .. i), "troll" .. i)
        SetEntitySize(GetEntityId("troll" .. i), 5)
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "caveTrollSleep" , 1, {}, {i})
    end
end

function caveTrollSleep(_id)
    if AreEntitiesInArea( 5, 0, GetPosition("troll".. _id), 1000, 1) then
        Message("Ihr habt einen Troll geweckt!")
        setupAggressiveTroll(_id)
        return true
    end
    Logic.GroupStand(GetEntityId("troll" .. _id))
end

function setupAggressiveTroll(_id)
    ChangePlayer("troll" .. _id, 7)
    Armies[CONST_ARMY_INDEX] = {
        player = 7,
        id = GetFirstFreeArmySlot(7),
        strength = 8,
        position = GetPosition("trollspawn" .. _id),
        rodeLength = 30000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("troll".._id),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createCaveDef()
    Armies[CONST_ARMY_INDEX] = {
        player = 7,
        id = GetFirstFreeArmySlot(7),
        strength = 8,
        position = GetPosition("nvdef"),
        rodeLength = 1000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4 + Difficulties[5]*2
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for j = 1, Difficulties[5] do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSulfurDef()
    Armies[CONST_ARMY_INDEX] = {
        player = 7,
        id = GetFirstFreeArmySlot(7),
        strength = 8,
        position = GetPosition("nvsulfurdef"),
        rodeLength = 1000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4 + Difficulties[5]*2
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for j = 1, Difficulties[5] do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSilverDef()
    if IsDead("spawnersilvermine") then
        return
    end
    Armies[CONST_ARMY_INDEX] = {
        player = 7,
        id = GetFirstFreeArmySlot(7),
        strength = 8,
        position = GetPosition("spawnsilvermine"),
        rodeLength = 4000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4 + Difficulties[5]*2
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for j = 1, Difficulties[5] do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawnerCave" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyDefendSpawnerCave(_id)
    if IsDead(Armies[_id]) then
        StartSimpleJob("waitForRespawnSpawnerCave")
        return true
    end
    Defend(Armies[_id])
end

function waitForRespawnSpawnerCave()
    if Counter.Tick2("waitForRespawnSpawnerCave", 30) then
        createSilverDef()
    end
end

function createCaveArmy()
    for i = 1, 4 do
        Armies[CONST_ARMY_INDEX] = {
            player = 7,
            id = GetFirstFreeArmySlot(7),
            strength = 8,
            position = GetPosition("nvcavespawn" .. i),
            rodeLength = 3400
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4 + Difficulties[5]*4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

        troopDescription.leaderType = Entities.CU_Evil_LeaderSpearman1

        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function checkForBootsChest()
    if IsNear("Kerberos","chestBoots",200) then
        local chestPos = GetPosition("chestBoots")
        Logic.CreateEntity( Entities.XD_ChestOpen, chestPos.X, chestPos.Y, 260, 0 )
        Logic.DestroyEntity( GetEntityId("chestBoots") )
        ResearchTechnology( Technologies.T_HeroicShoes, 5)
        return true
    end
end

function checkForPlayerFiveHQ()
    if IsDead("nvtowerhq5") then
        ChangePlayer("hq5", 5)
        Tools.GiveResouces(5,3000,1500,1700,1200,1500)
        return true
    end
end

function checkForCaveExit()
    if IsNear("Kerberos","CaveExit", 200) then
        SetPosition(GetEntityId("Kerberos"),GetPosition("CrawlerExit"))
        local pos = GetPosition("CaveExit")
        Logic.CreateEntity( Entities.XD_RockDarkEvelance7, pos.X, pos.Y, 0, 0 )
        return true
    end
end