P2PatrolArmies = 6

function createPlayer2()
    local pID = 2
    local strength = 3
    local range = 10000
    MapEditor_SetupAI(pID, strength, range, 3, "p2base", 3, 0)
	SetupPlayerAi( pID, {constructing = false, extracting = true, repairing = true, serfLimit = 12} )

    Tools.GiveResouces(2, 100000 , 0, 120000, 0, 200000, 100000)

    local lowerBarracksID = GetEntityId("p2barracks")
    MapEditor_Armies[pID].armies[lowerBarracksID] = {
        offensiveArmies = {
            id = lowerBarracksID,
            strength	= 2,
            position = GetPosition("p2barracksspawn"),
            enemySearchPosition = GetPosition("ghostsulfurbase"),
            rodeLength = 20000,
            baseDefenseRange = (range*2)/3,
            AttackAllowed =	true,
            baitDetection = false,
            IDs	= {}
        },
        defensiveArmies = {
            id = lowerBarracksID,
            strength	= 4,
            position = GetPosition("p2barracksspawn"),
            baseDefenseRange = math.min(range, 5000),
            IDs	= {}
        },
        position = GetPosition("p2barracksspawn"),
    }
	MapEditor_Armies.controlerId.offensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "offensiveArmies",lowerBarracksID})
	MapEditor_Armies.controlerId.defensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "defensiveArmies",lowerBarracksID})

    local miliaryBaseIDs = {
        [GetEntityId("barrackstop")] =  GetPosition("uppergate"),
        [GetEntityId("barracksbottom")] =  GetPosition("bottomgate"),
        [GetEntityId("barrackmiddle")] =  GetPosition("frontgate"),
        [GetEntityId("archerytop")] =  GetPosition("uppergate"),
        [GetEntityId("archerybottom")] =  GetPosition("bottomgate"),
        [GetEntityId("archerymiddletop")] =  GetPosition("frontgate"),
        [GetEntityId("archerymiddlebottom")] =  GetPosition("frontgate"),
        [GetEntityId("foundrymiddletop")] =  GetPosition("uppergate"),
        [GetEntityId("foundrymiddlebottom")] =  GetPosition("bottomgate"),
        [GetEntityId("stablemiddle")] =  GetPosition("frontgate"),
    }

    for k,v in pairs(miliaryBaseIDs) do
        local _strength = 5
        if string.sub(Logic.GetEntityName(k), 1, 7) == "foundry" then
            _strength = 2
        end
        MapEditor_Armies[pID].armies[k] = {
            offensiveArmies = {
                id = k,
                strength	= 0,
                position = v,
                rodeLength = 200000,
                baseDefenseRange = (range*2)/3,
                AttackAllowed =	true,
                baitDetection = false,
                IDs	= {}
            },
            defensiveArmies = {
                id = k,
                strength	= _strength,
                position = v,
                baseDefenseRange = math.min(range, 4000),
                IDs	= {}
            },
            position = v
        }
        MapEditor_Armies.controlerId.defensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "defensiveArmies",k})
    end

    local patrolPointsPositions = {}
    for i = 0, 17 do
        patrolPointsPositions[i] = { X = GetPosition("patrol" .. i).X, Y = GetPosition("patrol" .. i).Y, WaitTime = 30}
    end

    local numPoints = table.getn(patrolPointsPositions)
    for i = 1, P2PatrolArmies do
        local startIndex = math.floor((i - 1) * numPoints / P2PatrolArmies) + 1
        MapEditor_Armies[pID].armies["patrol" .. i] = {
            offensiveArmies = {
                strength	= 0,
                position = GetPosition("p2base"),
                rodeLength = 200000,
                baseDefenseRange = (range*2)/3,
                AttackAllowed =	true,
                baitDetection = false,
                id =  "patrol" .. i,
                IDs	= {}
            },
            defensiveArmies = {
                strength	= 0,
                position = GetPosition("p2base"),
                baseDefenseRange = math.min(range, 5000),
                id = "patrol" .. i,
                IDs	= {}
            },
            patrolArmies = {
                Patrol = {
                    CurrentPosition = GetPosition("patrol" .. startIndex),
                    CurrentIndex = startIndex,
                    LastTimePositionUpdated = 0
                },
                player = 2,
                PatrolPoints = patrolPointsPositions,
                strength	= 2,
                rodeLength = 3500,
                position = GetPosition("p2base"),
                baseDefenseRange = math.min(range, 5000),
                IDs	= {},
                id = "patrol" .. i,
            },
            position = GetPosition("p2base")
        }
        MapEditor_Armies.controlerId.defensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "patrolArmies","patrol" .. i})
    end

    local patrolPointsPositions = {}
    for i = 0, 2 do
        patrolPointsPositions[i] = { X = GetPosition("patrolwallbottom" .. i).X, Y = GetPosition("patrolwallbottom" .. i).Y, WaitTime = 30}
    end

    MapEditor_Armies[pID].armies["patrolwallbottom"] = {
        offensiveArmies = {
            strength	= 0,
            position = GetPosition("p2base"),
            rodeLength = 200000,
            baseDefenseRange = (range*2)/3,
            AttackAllowed =	true,
            baitDetection = false,
            id =  "patrolwallbottom",
            IDs	= {}
        },
        defensiveArmies = {
            strength	= 0,
            position = GetPosition("p2base"),
            baseDefenseRange = math.min(range, 5000),
            id = "patrolwallbottom",
            IDs	= {}
        },
        patrolArmies = {
            Patrol = {
                CurrentPosition = GetPosition("patrolwallbottom1"),
                CurrentIndex = 1,
                LastTimePositionUpdated = 0
            },
            player = 2,
            PatrolPoints = patrolPointsPositions,
            strength	= 1,
            rodeLength = 3500,
            position = GetPosition("p2base"),
            baseDefenseRange = math.min(range, 5000),
            IDs	= {},
            id = "patrolwallbottom",
        },
        position = GetPosition("p2base")
    }
    MapEditor_Armies.controlerId.defensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "patrolArmies","patrolwallbottom"})

    local patrolPointsPositions = {}
    for i = 0, 2 do
        patrolPointsPositions[i] = { X = GetPosition("patrolwalltop" .. i).X, Y = GetPosition("patrolwalltop" .. i).Y, WaitTime = 30}
    end

    MapEditor_Armies[pID].armies["patrolwalltop"] = {
        offensiveArmies = {
            strength	= 0,
            position = GetPosition("p2base"),
            rodeLength = 200000,
            baseDefenseRange = (range*2)/3,
            AttackAllowed =	true,
            baitDetection = false,
            id =  "patrolwalltop",
            IDs	= {}
        },
        defensiveArmies = {
            strength	= 0,
            position = GetPosition("p2base"),
            baseDefenseRange = math.min(range, 5000),
            id = "patrolwalltop",
            IDs	= {}
        },
        patrolArmies = {
            Patrol = {
                CurrentPosition = GetPosition("patrolwalltop1"),
                CurrentIndex = 1,
                LastTimePositionUpdated = 0
            },
            player = 2,
            PatrolPoints = patrolPointsPositions,
            strength	= 1,
            rodeLength = 3500,
            position = GetPosition("p2base"),
            baseDefenseRange = math.min(range, 5000),
            IDs	= {},
            id = "patrolwalltop",
        },
        position = GetPosition("p2base")
    }
    MapEditor_Armies.controlerId.defensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "patrolArmies","patrolwalltop"})

    local patrolPointsPositions = {}
    for i = 0, 4 do
        patrolPointsPositions[i] = { X = GetPosition("patrolwallbig" .. i).X, Y = GetPosition("patrolwallbig" .. i).Y, WaitTime = 30}
    end

    for i = 1, 3 do
        MapEditor_Armies[pID].armies["patrolwallbig" .. i] = {
            offensiveArmies = {
                strength	= 0,
                position = GetPosition("p2base"),
                rodeLength = 200000,
                baseDefenseRange = (range*2)/3,
                AttackAllowed =	true,
                baitDetection = false,
                id =  "patrolwallbig" .. i,
                IDs	= {}
            },
            defensiveArmies = {
                strength	= 0,
                position = GetPosition("p2base"),
                baseDefenseRange = math.min(range, 5000),
                id = "patrolwallbig" .. i,
                IDs	= {}
            },
            patrolArmies = {
                Patrol = {
                    CurrentPosition = GetPosition("patrolwallbig" .. i),
                    CurrentIndex = i,
                    LastTimePositionUpdated = 0
                },
                player = 2,
                PatrolPoints = patrolPointsPositions,
                strength	= 1,
                rodeLength = 3500,
                position = GetPosition("p2base"),
                baseDefenseRange = math.min(range, 5000),
                IDs	= {},
                id = "patrolwallbig" .. i,
            },
            position = GetPosition("p2base")
        }
        MapEditor_Armies.controlerId.defensiveArmies[pID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {pID, "patrolArmies","patrolwallbig" .. i})
    end

end