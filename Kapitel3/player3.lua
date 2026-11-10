function createPlayer3()
    SetPlayerName(3, "Varg")
    local _serfPos = GetPosition("VargSpawn2")
    for i = 1, 8 do
        AI.Entity_CreateFormation(3, Entities.PU_Serf, nil, 0, _serfPos.X, _serfPos.Y, 59697*100, 56965*100, 3, 0)
    end
    Logic.SetShareExplorationWithPlayerFlag(1, 3, 1)
    MapEditor_SetupAI(3, 3, 100000, 1, "VargEntrance", 3, 0)
	SetupPlayerAi( 3, {constructing = true, extracting = true, repairing = true, serfLimit = 8} )
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.BlackKnightLeaderSword3)
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.BlackKnightLeaderMace1)
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.LeaderBandit)
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.Evil_LeaderSkirmisher)
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.Evil_LeaderBearman)
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.LeaderBanditBow)

    MapEditor_Armies[3].armies[1] = {
        offensiveArmies = {
            strength	= 12,
            position = GetPosition("VargVillage"),
            rodeLength = 200000,
            baseDefenseRange = 200000,
            AttackAllowed =	true,
            baitDetection = false,
            IDs	= {}
        },
        defensiveArmies = {
            strength	= 6,
            position = GetPosition("VargVillage"),
            baseDefenseRange = 8000,
            IDs	= {}
        },
        position = GetPosition("VargVillage"),
    }
	MapEditor_Armies.controlerId.offensiveArmies[1] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {3, "offensiveArmies",1})
	MapEditor_Armies.controlerId.defensiveArmies[1] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {3, "defensiveArmies",1})

    local constructionplan = {
        { type = Entities.PB_Headquarters1, pos = GetPosition("p3hq"), level = 1},
        { type = Entities.PB_VillageHall1, pos = GetPosition("VargVillageNorth") },
        { type = Entities.PB_MercenaryTower, pos = GetPosition("VargVillageNorth") },
     
        { type = Entities.PB_ClayMine1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Brickworks1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_GoldMine1, pos = invalidPosition, level = 2 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_StoneMine1, pos = GetPosition("VargVillageNorthWest"), level = 2 },
        { type = Entities.PB_StoneMason1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_IronMine1, pos = invalidPosition, level = 2 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Blacksmith1, pos = GetPosition("p3hq"), level = 2 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_MercenaryTower, pos = invalidPosition },
        { type = Entities.PB_Tower1, pos = GetPosition("VargEntrance"), level = 2 },
        { type = Entities.PB_Tower1, pos = GetPosition("VargEntrance"), level = 2 },
        { type = Entities.PB_Blacksmith1, pos = GetPosition("VargVillageNorth"), level = 2 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Blacksmith1, pos = GetPosition("VargVillageWest"), level = 2 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Blacksmith1, pos = GetPosition("VargVillageWest"), level = 2 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
        { type = Entities.PB_Beautification03, pos = GetPosition("VargVillageWest")},
        { type = Entities.PB_Beautification08, pos = GetPosition("VargVillageNorth")},
        { type = Entities.PB_Beautification11, pos = GetPosition("p3hq")},
        { type = Entities.PB_Beautification12, pos = GetPosition("VargVillageNorth")},
        { type = Entities.PB_CoalmakersHut1, pos = GetPosition("VargVillageWest")},
        { type = Entities.PB_CoalmakersHut1, pos = GetPosition("VargVillageWest")},
        { type = Entities.PB_Beautification02, pos = GetPosition("VargVillageNorth")},
    };
     
    -- Bauplan an den KI Gegner übergeben
    FeedAiWithConstructionPlanFile( 3, constructionplan );

    StartSimpleJob("checkForP3FinishedBuilding")
end

function checkForP3FinishedBuilding()
    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(3)) do
        if Logic.GetEntityType(eID) == Entities.PB_Beautification02 then
            CreateNPC {
                name = "Varg",
                callback = BriefingSilverMine,
            }
            return true
        end
    end
end

function checkForSilverMine()
    if Logic.GetWeatherState() == 3 then
        local constructionplan = {
            { type = Entities.PB_SilverMine1, pos = GetPosition("VargSilver"), level = 2},
        }
        FeedAiWithConstructionPlanFile( 3, constructionplan );
        createVargArmy()
        return true
    end
end