function initVillageDefs()
    MapEditor_SetupAI(2, 1, 13000, 1, "fleeingsp2", 0, 0)
	SetupPlayerAi( 2, {serfLimit = 0} )
    MapEditor_Armies[2].offensiveArmies.strength = 14
    MapEditor_Armies[2].defensiveArmies.strength = 0
    MapEditor_Armies[2].description.rebuildData.delay = 999999
    table.insert(MapEditor_Armies[2].ForbiddenTypes, UpgradeCategories.LeaderCavalry)
    SetHostile(2,3)
    SetHostile(2,4)
    MapEditor_SetupAI(5, 2, 3000, 2, "village1", 0, 0)
	SetupPlayerAi( 5, {serfLimit = 0} )
    MapEditor_Armies[5].offensiveArmies.strength = 6
    MapEditor_Armies[5].defensiveArmies.strength = 0
    MapEditor_Armies[5].description.rebuildData.delay = 999999
    SetHostile(5,3)
    SetHostile(5,4)
	MapEditor_SetupAI(6, 3, 3000, 3, "townleftdef", 0, 0)
    SetupPlayerAi( 6, {serfLimit = 0} )
    MapEditor_Armies[6].offensiveArmies.strength = 6
    MapEditor_Armies[6].defensiveArmies.strength = 0
    MapEditor_Armies[6].description.rebuildData.delay = 999999
    SetHostile(6,3)
    SetHostile(6,4)
    MapEditor_SetupAI(7, 3, 3000, 3, "towndefpoint1", 0, 0)
    SetupPlayerAi( 7, {serfLimit = 0} )
    MapEditor_Armies[7].offensiveArmies.strength = 10
    MapEditor_Armies[7].defensiveArmies.strength = 0
    MapEditor_Armies[7].description.rebuildData.delay = 999999
    table.insert(MapEditor_Armies[7].ForbiddenTypes, UpgradeCategories.Cannon4)
    ResearchTechnology(2,Technologies.T_Masonry)
    ResearchTechnology(5,Technologies.T_Masonry)
    ResearchTechnology(6,Technologies.T_Masonry)
    ResearchTechnology(7,Technologies.T_Masonry)
    SetHostile(7,3)
    SetHostile(7,4)

    StartSimpleJob("checkDefPoint1")

    StartSimpleJob("checkDefPointP5")

    armyDefP6()
end

function armyDefP6(_pos)
    if _pos == 1 or _pos == nil then
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("village2"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    
    troopDescription.leaderType = Entities["PU_LeaderSword" .. math.random(3,4)]
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    troopDescription.leaderType = Entities["PU_LeaderPoleArm" .. math.random(3,4)]
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    troopDescription.leaderType = Entities["PU_LeaderHeavyCavalry" .. math.random(1,2)]
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    troopDescription.leaderType = Entities.PV_Cannon1
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    if IsDead("houseP6left") == false and IsDead("mineP6left") == false then
        Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("attackSonnspitzLeft"))
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changDefSpotP6" , 1, {}, {CONST_ARMY_INDEX,1})
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendP6" , 1, {}, {CONST_ARMY_INDEX,1})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end

    if _pos == 2 or _pos == nil then
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("village2"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    troopDescription.leaderType = Entities["PU_LeaderBow" .. math.random(3,4)]
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    troopDescription.leaderType = Entities["PU_LeaderRifle" .. math.random(1,2)]
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    troopDescription.leaderType = Entities["PU_LeaderCavalry" .. math.random(1,2)]
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    troopDescription.leaderType = Entities.PV_Cannon1
    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    if IsDead("houseP6right") == false and IsDead("mineP6right") == false then
        Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("attackSonnspitzRight1"))
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changDefSpotP6" , 1, {}, {CONST_ARMY_INDEX,2})
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendP6" , 1, {}, {CONST_ARMY_INDEX,2})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function changDefSpotP6(_id, _pos)
    if IsDead(Armies[_id]) then
        return true
    end
    local _house = "houseP6left"
    local _mine = "mineP6left"
    if _pos == 2 then
        _house = "houseP6right"
        _mine = "mineP6right"
    end
    if IsDead(_house) and IsDead(_mine) then
        Redeploy(Armies[_id],GetPosition("village2"))
        return true
    end
end

function controlArmyDefendP6(_id,_pos)
    if IsDead(Armies[_id]) then
        if IsDead("p6hq") then
            return true
        end
        if _pos == 1 then
            StartSimpleJob("waitForRespawnDefP6Left")
            return true
        end
        StartSimpleJob("waitForRespawnDefP6Right")
        return true
    end
    Defend(Armies[_id])
end

function waitForRespawnDefP6Left()
    if Counter.Tick2("waitForRespawnDefP6Left", 20) then
        armyDefP6(1)
        return true
    end
end

function waitForRespawnDefP6Right()
    if Counter.Tick2("waitForRespawnDefP6Right", 20) then
        armyDefP6(2)
        return true
    end
end

function checkDefPointP5()
    if IsDead("barracksp51") then
        ChangePlayer("barracksp52",5)
        MapEditor_Armies[5].offensiveArmies.strength = 10
        MapEditor_Armies[5].rodeLength = 10000
        Redeploy(MapEditor_Armies[5],GetPosition("spvillage1"),nil,"offensiveArmies")
        return true
    end
end

function checkDefPoint1()
    if IsDead("defbuilding1") then
        Redeploy(MapEditor_Armies[7],GetPosition("towndefpoint2"),nil,"offensiveArmies")
        StartSimpleJob("checkDefPoint2")
        return true
    end
end

function checkDefPoint2()
    if IsDead("archeryp71") then
        Redeploy(MapEditor_Armies[7],GetPosition("towndefpoint3"),nil,"offensiveArmies")
        StartSimpleJob("checkDefPoint3")
        return true
    end
end

function checkDefPoint3()
    if IsDead("barracksp7") then
        Redeploy(MapEditor_Armies[7],GetPosition("towndefpoint4"),nil,"offensiveArmies")
        return true
    end
end