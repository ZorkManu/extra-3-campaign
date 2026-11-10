function setupPlayer4()
    MapEditor_SetupAI(4, 3, 100000, 1, "KerberosEntrance", 3, 0)
	SetupPlayerAi( 4, {constructing = true, extracting = true, repairing = true, serfLimit = 8} )
end

function createPlayer4()
    SetPlayerName(4, "Kerberos")
    DestroyEntity("DZBlockKerb")
    local units = tonumber(GDB.GetString("FmFEscaped")) or 0

    if units >= 4 then
        for i = 1, 4 do
            local _serfPos = GetPosition("KerberosSpawn2")
            AI.Entity_CreateFormation(4, Entities.PU_Serf, nil, 0, _serfPos.X, _serfPos.Y, 59697*100, 56965*100, 3, 0)
        end
        units = units - 4
    end
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderBarbarian)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderElite)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderBandit)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.Evil_LeaderSkirmisher)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.Evil_LeaderBearman)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderBanditBow)

    --local startStrength
    --if units >= 20 then
        --startStrength = 5
        --units = units - 20
    --else
        --startStrength = units/5
        --units = 0
    --end

    MapEditor_Armies[4].armies[1] = {
        offensiveArmies = {
            strength	= 20,
            position = GetPosition("KerberosVillageMiddle"),
            rodeLength = 2000000,
            baseDefenseRange = 2000000,
            AttackAllowed =	true,
            baitDetection = false,
            IDs	= {},
           -- enemySearchPosition = GetPosition("bottomghostspawn3")
        },
        defensiveArmies = {
            strength	= 6,
            position = GetPosition("KerberosVillageMiddle"),
            baseDefenseRange = 10000,
            IDs	= {}
        },
        position = GetPosition("KerberosVillageMiddle"),
    }
    local constructionplan = {
        { type = Entities.PB_Headquarters1, pos = GetPosition("p4hq"), level = 2},
        { type = Entities.PB_VillageHall1, pos = GetPosition("KerberosVillageNorth") },
        { type = Entities.PB_MercenaryTower, pos = GetPosition("KerberosVillageNorth") },
    };
    local constructionplanTemp = {
        { type = Entities.PB_ClayMine1, pos = GetPosition("KerberosVillageEast"), level = 2, units = 9 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Brickworks1, pos = invalidPosition, level = 1, units = 6 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_StoneMine1, pos = GetPosition("KerberosVillageWest"), level = 2, units = 9 },
        { type = Entities.PB_StoneMason1, pos = invalidPosition, level = 1, units = 6 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 1, units = 0 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_IronMine1, pos = GetPosition("KerberosVillageNorth"), level = 2, units = 9 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_IronMine1, pos = invalidPosition, level = 2, units = 9 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 9 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_SulfurMine1, pos = GetPosition("KerberosVillageEast"), level = 2, units = 9 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Bank1, pos = GetPosition("p4hq"), level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Bank1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Bank1, pos = GetPosition("KerberosVillageCenter"), level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
        { type = Entities.PB_Bank1, pos = invalidPosition, level = 2, units = 8 },
        { type = Entities.PB_Farm1, pos = invalidPosition, level = 2, units = 1 },
        { type = Entities.PB_Residence1, pos = invalidPosition, level = 2, units = 0 },
    }

    while table.getn(constructionplanTemp) > 0 and units > constructionplanTemp[1].units do
        units = units - constructionplanTemp[1].units
        table.insert(constructionplan,constructionplanTemp[1])
        table.remove(constructionplanTemp,1)
    end

    local constructionplanBeautification = {
        { type = Entities.PB_DarkTower1, pos = GetPosition("KerberosEntrance"), level = 2 },
        { type = Entities.PB_DarkTower1, pos = GetPosition("KerberosEntrance"), level = 2 },
        { type = Entities.PB_Beautification05, pos = GetPosition("KerberosVillageWest")},
        { type = Entities.PB_Beautification07, pos = GetPosition("KerberosVillageNorth")},
        { type = Entities.PB_Beautification11, pos = GetPosition("p4hq")},
        { type = Entities.PB_Beautification10, pos = GetPosition("KerberosVillageNorth")},
        { type = Entities.PB_Beautification04, pos = GetPosition("KerberosVillageNorth")},
    }

    for i = 1, table.getn(constructionplanBeautification) do
        table.insert(constructionplan,constructionplanBeautification[i])
    end

    --MapEditor_Armies[4].armies[1].defensiveArmies.strength = MapEditor_Armies[4].armies[1].defensiveArmies.strength + math.max (0, units /6)

     
    -- Bauplan an den KI Gegner übergeben
    FeedAiWithConstructionPlanFile( 4, constructionplan );

    MapEditor_Armies.controlerId.offensiveArmies[1] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {4, "offensiveArmies",1})
	MapEditor_Armies.controlerId.defensiveArmies[1] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {4, "defensiveArmies",1})
end