Armies = {}
BKArmies = {}

CONST_ARMY_INDEX = 0

Ghosttypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4},{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,3}}
NVTypes = {{Entities.CU_Evil_LeaderBearman1,20},{Entities.CU_Evil_LeaderSkirmisher1,20}}
NVMeeleTypes = {{Entities.CU_Evil_LeaderBearman1,20},{Entities.CU_Evil_LeaderSpearman1,20},{Entities.CU_Evil_LeaderCavalry1,8}}
GhostMeeleTypes = {{Entities.PU_LeaderSword1_Spectral,4},{Entities.PU_LeaderPoleArm1_Spectral,4}}
GhostArcheryTypes = {{Entities.PU_LeaderBow1_Spectral,4},{Entities.PU_LeaderRifle1_Spectral,4}}
GhostSword4Types = {{Entities.PU_LeaderSword4_Spectral,12}}
BlackKnightTypes = {{Entities.CU_BlackKnight_LeaderMace1,4},{Entities.CU_BlackKnight_LeaderMace2,4},{Entities.CU_BlackKnight_LeaderSword3,6},{Entities.CU_VeteranCaptain,0},{Entities.CU_VeteranMajor,2}}
BowTypes = {{Entities.PU_LeaderBow4,12}}
HeavyCavTypes = {{Entities.PU_LeaderHeavyCavalry2,4}}
RangedTypes = {{Entities.PU_LeaderBow4,12},{Entities.PU_LeaderRifle2,8}}
MeleeTypes = {{Entities.PU_LeaderSword4,12},{Entities.PU_LeaderPoleArm4,12}}

function createInitialArmies()
    StartCountdown(120, createAttackingArmies, false)

    createArmyStartP1HQ()

    createTreeTrollDefender()

    for i = 1, 2 do
        createGeneralSpawner(5, Difficulty * 4, "ghostvargspawn" .. i, 3800, 60, "ghostvargspawner" .. i, Ghosttypes, true, false, "ghostvargspawn" .. i)
        createGeneralSpawner(5, Difficulty * 4, "ghostvargspawn" .. i, 3800, 600, "ghostvargspawner" .. i, Ghosttypes, true, true, "ghostvargspawnAdvance" .. i)
    end

    createGeneralSpawner(5, Difficulty * 4 + 2, "startingGhostSpawn", 3800, 120, "startingGhostSpawner", Ghosttypes, true, false, "startingClaymineGhostSpawn")
    createGeneralSpawner(5, Difficulty * 3 + 4, "nearbasespawn", 3800, 60, "nearbasespawner", Ghosttypes, true, false, "nearbySpawn")
    createGeneralSpawner(6, Difficulty + 2, "stonespawn", 3800, 60, "stonespawner", NVTypes, true, false, "stoneMineSpawn")
    --createGeneralSpawner(5, Difficulty * 3, "barracksghostsulfurspawn", 3500, 60, "barracksghostsulfur", GhostMeeleTypes, true, false, "barracksghostsulfurspawn")
    createGeneralSpawner(5, Difficulty * 3, "archeryghostsulfurspawn", 3800, 60, "archeryghostsulfur", GhostArcheryTypes, true, false, "archeryghostsulfurspawn")
    createGeneralSpawner(5, Difficulty * 4 + 6, "barracksghostsulfurspawn", 3800, 60, "barracksghostsulfur", GhostMeeleTypes, true, true, "barracksghostsulfurspawnAdvance",nil,"p2barracksspawn")
    --createGeneralSpawner(5, Difficulty * 4 + 2, "archeryghostsulfurspawn", 3500, 60, "archeryghostsulfur", GhostArcheryTypes, true, true, "archeryghostsulfurspawnAdvance")
    createGeneralSpawner(5, Difficulty * 3 + 8, "barracksghostislandspawn", 3800, 60, "barracksghostisland", GhostSword4Types, true, false, "barracksghostislandspawn", "islandghostdef")
    createGeneralSpawner(5, Difficulty * 2, "barracksghostislandspawn", 3800, 180, "barracksghostisland", GhostSword4Types, true, true, "barracksghostislandspawnAdvance")
    createGeneralSpawner(6, Difficulty * 5, "islandStoneSpawn", 3800, 60, nil, NVTypes, true, false, "islandStoneSpawn")
    createGeneralSpawner(6, Difficulty * 5, "islandStoneSpawn", 40000, 300, nil, NVTypes, true, true, "islandStoneSpawnAdvance")
    createBKSpawnerDefend(5)

    --CityDefenders
    createGeneralSpawner(2, 1, "upperwallsdeftop", 3800, 60, "archerytop", BowTypes, true, false, "SpawnerDefTop")
    createGeneralSpawner(2, 1, "upperwallsdefbottom", 3800, 60, "archerytop", BowTypes, true, false, "SpawnerDefBottom")
    createGeneralSpawner(2, 1, "lowerwalldeftop", 3800, 60, "archerybottom", BowTypes, true, false, "SpawnerDefTop2")
    createGeneralSpawner(2, 1, "lowerdefwallbottom", 3800, 60, "archerybottom", BowTypes, true, false, "SpawnerDefBottom2")
end

function createAttackingArmies()
    --TopSpawner
    createGeneralSpawner(5, Difficulty * 6 + 15, "cavespawntop", 40000, 60, "spawnerp5", GhostMeeleTypes, true, true, "SpawnerCaveTopGhostAdvance")
    createGeneralSpawner(6, Difficulty * 3 + 3, "cavespawntop", 40000, 60, "spawnerp6", NVMeeleTypes, true, true, "SpawnerCaveTopNVAdvance")

    --MiddleSpawner
    --createGeneralSpawner(5, Difficulty * 6 + 12, "cavespawnmiddle", 40000, 60, "spawnerp5", GhostMeeleTypes, true, true, "SpawnerCaveMiddleGhostAdvance")
    createGeneralSpawner(6, Difficulty * 3 + 2, "cavespawnmiddle", 40000, 60, "spawnerp6", NVMeeleTypes, true, true, "SpawnerCaveMiddleNVAdvance")
    createGeneralSpawner(5, Difficulty * 3 + 2, "middlecavspawn", 40000, 60, "middlecavspawner", HeavyCavTypes, true, true, "middlecavspawneradvance")
    createGeneralSpawner(5, Difficulty * 3 + 4, "middlecavspawn", 4000, 60, "middlecavspawner", HeavyCavTypes, true, false, "middlecavspawner")
    for i = 1, 2 do
        createGeneralSpawner(6, Difficulty * 3, "middleNVSpawn" .. i, 3500, 60, "middleNVSpawner" .. i, NVMeeleTypes, true, false, "middleNVSpawn" .. i .. "Defend")
        createGeneralSpawner(6, Difficulty * 3, "middleNVSpawn" .. i, 40000, 60, "middleNVSpawner" .. i, NVMeeleTypes, true, true, "middleNVSpawn" .. i .. "Advance")
    end

    --BottomSpawner
    createGeneralSpawner(5, Difficulty * 4 + 4, "bottomswordspawn", 40000, 60, "bottomswordspawner", GhostMeeleTypes, true, true, "bottomswordspawneradvance")
    createGeneralSpawner(5, Difficulty * 4 + 6, "bottomswordspawn", 10000, 60, "bottomswordspawner", GhostMeeleTypes, true, false, "bottomswordspawner")
    createGeneralSpawner(5, Difficulty * 4 + 4, "bottomarcherspawn", 40000, 60, "bottomarcherspawner", GhostArcheryTypes, true, true, "bottomarcherspawneradvance")
    createGeneralSpawner(5, Difficulty * 4 + 6, "bottomarcherspawn", 10000, 60, "bottomarcherspawner", GhostArcheryTypes, true, false, "bottomarcherspawner")
    for i = 1,4 do
        local ghostTypes = GhostMeeleTypes
        if i == 2 then
            ghostTypes = GhostArcheryTypes
        end
        createGeneralSpawner(5, Difficulty * 3 + 2, "bottomghostspawn" .. i, 40000, 60, "bottomghostspawner" .. i, ghostTypes, true, true, "bottomghostspawn" .. i .. "Advance")
        createGeneralSpawner(5, Difficulty * 3 + 4, "bottomghostspawn" .. i, 8000, 60, "bottomghostspawner" .. i, ghostTypes, true, false, "bottomghostspawn" .. i .. "Defend")
    end
    createGeneralSpawner(6, Difficulty * 2, "bottomnvspawn", 40000, 60, "bottomnvspawner", NVMeeleTypes, true, true, "bottomnvspawneradvance")
    createGeneralSpawner(6, Difficulty * 2 + 2, "bottomnvspawn", 6000, 60, "bottomnvspawner", NVMeeleTypes, true, false, "bottomnvspawner")

    --BK
    createBKSpawnerAdvance(5)

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

function createBKSpawnerDefend(_playerId)
    BKArmies["Defend"] = {
        player = _playerId,
        id = GetFirstFreeArmySlot(_playerId),
        strength = 12,
        position = GetPosition("bkspawn"),
        rodeLength = 4000,
        respawnTime = 40,
        spawnGenerator = GetEntityId("bk6"),
        spawnTypes = BlackKnightTypes,
        endless = true,
    }

    SetupArmy(BKArmies["Defend"])

    SetupAITroopSpawnGenerator("BKDefend", BKArmies["Defend"])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawnerBK" , 1, {}, {"Defend"})
end

function createBKSpawnerAdvance(_playerId)
    BKArmies["Advance"] = {
        player = _playerId,
        id = GetFirstFreeArmySlot(_playerId),
        strength = Difficulty * 2,
        position = GetPosition("bkspawn"),
        rodeLength = 4000,
        respawnTime = 180,
        spawnGenerator = GetEntityId("bk6"),
        spawnTypes = BlackKnightTypes,
        endless = true,
    }

    SetupArmy(BKArmies["Advance"])

    SetupAITroopSpawnGenerator("BKAdvance", BKArmies["Advance"])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawnerBK" , 1, {}, {"Advance"})
end

function swapBKArmies()
    for i = 1, 35 do
        ChangePlayer("bk" .. i, 4)
    end
    killBlackKnights()
    --createBKSpawnerAdvance(4)
    createBKSpawnerDefend(4)
end

function checkForBKOutpost()
    if IsDead("bk6") then
        Redeploy(MapEditor_Armies[2], GetPosition("bottomgate"), 4000, "defensiveArmies",GetEntityId("barracksbottom"))
        Redeploy(MapEditor_Armies[2], GetPosition("bottomgate"), 4000, "defensiveArmies",GetEntityId("archerybottom"))
        Redeploy(MapEditor_Armies[2], GetPosition("bottomgate"), 4000, "defensiveArmies",GetEntityId("foundrymiddlebottom"))
        return true
    end
end

function controlArmyDefendSpawnerBK(_id)
    if Counter.Tick2("controlArmyDefendSpawnerBK", 2) then
        if IsDead(BKArmies[_id]) then
            if IsDead("bk6") then
                return true
            end
            return false
        end
        Defend(BKArmies[_id])
    end
end

function controlArmyAdvanceSpawnerBK(_id)
    if Counter.Tick2("controlArmyAdvanceSpawnerBK", 2) then
        if IsDead(BKArmies[_id]) then
            if IsDead("bk6") then
                return true
            end
            return false
        end
        Advance(BKArmies[_id])
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

function createKerberosSpawner()
    createGeneralSpawner(6, Difficulty , "KerberosVillageWest", 40000, 180, "kerbSpawner1", NVMeeleTypes, true, false, "kerbSpawner1Advance")
    createGeneralSpawner(6, Difficulty * 2, "KerberosVillageWest", 4000, 180, "kerbSpawner1", NVTypes, true, false, "kerbSpawner1Defend")
    createGeneralSpawner(6, Difficulty, "KerberosVillageNorth", 40000, 180, "kerbSpawner2", NVMeeleTypes, true, false, "kerbSpawner2Advance")
    createGeneralSpawner(6, Difficulty * 2, "KerberosVillageNorth", 4000, 180, "kerbSpawner2", NVTypes, true, false, "kerbSpawner2Defend")
    createGeneralSpawner(6, Difficulty , "p4hq", 40000, 180, "kerbSpawner3", NVMeeleTypes, true, false, "kerbSpawner3Advance")
    createGeneralSpawner(6, Difficulty * 2, "p4hq", 4000, 180, "kerbSpawner3", NVTypes, true, false, "kerbSpawner3Defend")
    createGeneralSpawner(6, Difficulty, "p4hq", 40000, 180, "kerbSpawner3", NVMeeleTypes, true, false, "kerbSpawner4Advance")
    createGeneralSpawner(6, Difficulty, "p4hq", 4000, 180, "kerbSpawner3", NVTypes, true, false, "kerbSpawner4Defend")

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRuinSpawner" , 1, {}, {"kerbSpawner1",4})
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRuinSpawner" , 1, {}, {"kerbSpawner2",3})
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRuinSpawner" , 1, {}, {"kerbSpawner3",4})
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRuinSpawner" , 1, {}, {"kerbSpawner4",2})
end

function checkForRuinSpawner(_spawnerName, _ruinCount)
    if IsDead(_spawnerName) then
        for i = 1, _ruinCount do
            DestroyEntity(_spawnerName .. i)
        end
    end
end

function createKerberosReeinforcementArmies()
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("KerberosSpawn3"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace1

    for i = 1, 30 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    CreateMilitaryGroup(4, Entities.CU_BlackKnight, 0, GetPosition("KerberosSpawn1"), "Kerberos")
    ConnectLeaderWithArmy(GetEntityId("Kerberos"),Armies[CONST_ARMY_INDEX])

    if GDB.GetString("FmFKardinel") == "1" then
        createKardinel("KerberosSpawn2")
        ConnectLeaderWithArmy(GetEntityId("Kardinel"),Armies[CONST_ARMY_INDEX])
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createKardinelArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("KerberosEntrance"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("Kardinel"),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceKardinel" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createKerberosArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("KerberosEntrance"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("Kerberos"),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceKerberos" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createTreeTrollDefender()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("trollTreeSpawn"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    for i = 1, Difficulty do
        local index = CONST_ARMY_INDEX
        local pos = GetPosition("trollTreeSpawn")
        pos.X = pos.X + math.random(-600,600)
        pos.Y = pos.Y + math.random(-600,600)
        CreateMilitaryGroup(6, Entities.CU_Evil_Troll1, 0, pos, "troll" .. index .. i)
        SetEntitySize(GetEntityId("troll" .. index .. i), 6)
        ConnectLeaderWithArmy(GetEntityId("troll".. index .. i),Armies[index])
    end

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1, Difficulty*2 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
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

function controlArmyAdvanceKardinel(_id)
    if IsDead("Kardinel") then
        StartCountdown(60, function ()
            createKardinel("KerberosEntrance")
            createKardinelArmy()
        end)
        return true
    end
    Advance(Armies[_id])
end

function controlArmyAdvanceKerberos(_id)
    if IsDead("Kerberos") then
        DestroyEntity("Kerberos")
        StartCountdown(60, function ()
            CreateMilitaryGroup(4, Entities.CU_BlackKnight, 0, GetPosition("KerberosEntrance"), "Kerberos")
            createKerberosArmy()
        end)
        return true
    end
    Advance(Armies[_id])
end

function createVCSpawner()
    for i = 1, 1 + Difficulty do
        createGeneralSpawner(6,1,"vcspawn" .. i,20000,300,"spawnerp6",NVTypes,true,true)
    end
end

function createGhostBarbarianBaseDefenders()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("VargVillageNorth"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, 40 * Difficulty do
        troopDescription.leaderType = getRandomGhostMeleeTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral

    for i = 1, 3 * Difficulty do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceBarbarian" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyAdvanceBarbarian(_id)
    if IsDead(Armies[_id]) then
        DestroyEntity("Varg")
        DestroyEntity("Yuki")
        CreateMilitaryGroup(3, Entities.CU_Barbarian_Hero, 0, GetPosition("VargPos"), "Varg")
        CreateMilitaryGroup(3, Entities.PU_Hero11, 0, GetPosition("YukiPos"), "Yuki")
        CreateMilitaryGroup(2, Entities.CU_VeteranLieutenant, 0, GetPosition("gatevargspawn"), "VargGateKeeper")
        LookAt("VargGateKeeper","VargVillage")
        BriefingVarg()
        return true
    end
    Advance(Armies[_id])
end

function createBarbarianAttackers()
    Message("Yuki: Sieht so aus als könntet Ihr unsere Hilfe gebrauchen.")
    local pos = GetPosition("YukiSpawn")
    Camera.ScrollSetLookAt(pos.X,pos.Y)

    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("VargSpawn2"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub1

    for i = 1, 12 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    CreateMilitaryGroup(3, Entities.CU_Barbarian_Hero, 0, GetPosition("VargSpawn1"), "Varg")
    ConnectLeaderWithArmy(GetEntityId("Varg"),Armies[CONST_ARMY_INDEX])

    CreateMilitaryGroup(3, Entities.PU_Hero11, 0, GetPosition("YukiSpawn"), "Yuki")
    ConnectLeaderWithArmy(GetEntityId("Yuki"),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createVargArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("VargEntrance"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("Varg"),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceVarg" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyAdvanceVarg(_id)
    if IsDead("Varg") then
        StartCountdown(60, function ()
            DestroyEntity("Varg")
            CreateMilitaryGroup(3, Entities.CU_Barbarian_Hero, 0, GetPosition("VargEntrance"), "Varg")
            createVargArmy()
        end)
        return true
    end
    Advance(Armies[_id])
end

function createClosedArmies()
    for i = 1, 9 do
        Armies[CONST_ARMY_INDEX] = {
            player = 5,
            id = GetFirstFreeArmySlot(5),
            strength = 8,
            position = GetPosition("closedSpawn" .. i),
            rodeLength = 40000
        }
    
        SetupArmy(Armies[CONST_ARMY_INDEX])
    
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 12
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
    
        for i = 1, 10 do
            troopDescription.leaderType = getRandomGhostTroop()
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function graveArmies()
    for i = 1, 48 do
        local moduloSpawns = math.random(0,1)
        if Difficulty == 3 or Difficulty == 2 and Modulo(i-moduloSpawns,2) == 0 or Difficulty == 1  and Modulo(i-moduloSpawns,3) == 0 then
            Armies[CONST_ARMY_INDEX] = {
                player = 5,
                id = GetFirstFreeArmySlot(5),
                strength = 8,
                position = GetPosition("gr" .. i),
                rodeLength = 40000
            }
    
            SetupArmy(Armies[CONST_ARMY_INDEX])
    
            local troopDescription = {}
            troopDescription.maxNumberOfSoldiers = 4
            troopDescription.minNumberOfSoldiers = 1
            troopDescription.experiencePoints = HIGH_EXPERIENCE
    
            for i = 1, Difficulty do
                troopDescription.leaderType = getRandomGhostTroop()
                EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
            end

            if Difficulty > 1 and math.random(1,9 + gvDiffLVL * 3) then
                troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
                EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
            end
    
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    
            CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
        end
    end
end

function graveMonasteryArmies()
    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("mgr1"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1

    Armies[CONST_ARMY_INDEX] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("mgr2"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 5 + Difficulty
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral

    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createGhostErecArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 8,
        id = GetFirstFreeArmySlot(8),
        strength = 8,
        position = GetPosition("ErecSpawn"),
        rodeLength = 40000
    }
    
    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("Erec"),Armies[CONST_ARMY_INDEX])

    local leaderIds = GetPlayerLeaderIds(8)
        for i = 1, table.getn(leaderIds) do
            local currentLeaderId = leaderIds[i]
            if currentLeaderId ~= GetEntityId("Shagsworth") or currentLeaderId ~= GetEntityId("Scoob") then
                ConnectLeaderWithArmy(currentLeaderId,Armies[CONST_ARMY_INDEX])
            end
        end
    
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createMarySpawner()

    createGeneralSpawner(7, Difficulty * 3 + 2, "middlecavspawn", 40000, 60, "middlecavspawner", HeavyCavTypes, true, true, "middlecavspawneradvance")
    --createGeneralSpawner(7, Difficulty * 3 + 4, "middlecavspawn", 4000, 60, "middlecavspawner", HeavyCavTypes, true, false, "middlecavspawner")

    createGeneralSpawner(7, Difficulty * 2, "bottomarcherspawn", 40000, 60, "bottomarcherspawner", RangedTypes, true, true, "bottomarcherspawneradvance")
    --createGeneralSpawner(7, Difficulty, "bottomarcherspawn", 10000, 60, "bottomarcherspawner", RangedTypes, true, false, "bottomarcherspawner")

    createGeneralSpawner(7, Difficulty * 2, "bottomswordspawn", 40000, 60, "bottomswordspawner", MeleeTypes, true, true, "bottomswordspawneradvance")
    --createGeneralSpawner(7, Difficulty, "bottomswordspawn", 10000, 60, "bottomswordspawner", MeleeTypes, true, false, "bottomswordspawner")

    createGeneralSpawner(7, Difficulty * 2, "bottomghostspawn2", 40000, 60, "bottomghostspawner2", RangedTypes, true, true, "bottomghostspawner2advance")
    --createGeneralSpawner(7, Difficulty * 2, "bottomghostspawn2", 4000, 60, "bottomghostspawner2", RangedTypes, true, false, "bottomghostspawner2")

    createGeneralSpawner(7, Difficulty * 2, "bottomghostspawn4", 40000, 60, "bottomghostspawner4", MeleeTypes, true, true, "bottomghostspawner4advance")
    --createGeneralSpawner(7, Difficulty * 2, "bottomghostspawn4", 4000, 60, "bottomghostspawner4", MeleeTypes, true, false, "bottomghostspawner4")
end

function createNecroBoneArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("bonepit"),
        rodeLength = 40000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("necrobone"),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyDefend(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Defend(Armies[_id])
end

function controlArmyAdvance(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Advance(Armies[_id])
end