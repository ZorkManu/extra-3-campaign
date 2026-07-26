ARENA_OCCUPIED = false

function initWinkelhainNPCs()
    local NPC = {
        name = "Shagsworth",
        callback = BriefingShagsworth
    }
    CreateNPC(NPC)
    local NPC = {
        name = "villager1",
        callback = function ()
            BriefingVillagerWinkelhain(1)
        end
    }
    CreateNPC(NPC)
    local NPC = {
        name = "villager2",
        callback = function ()
            BriefingVillagerWinkelhain(2)
        end
    }
    CreateNPC(NPC)
    local NPC = {
        name = "villager3",
        callback = function ()
            BriefingVillagerWinkelhain(3)
        end
    }
    CreateNPC(NPC)
    local NPC = {
        name = "villager4",
        callback = function ()
            BriefingVillagerWinkelhain(4)
        end
    }
    CreateNPC(NPC)
end

function initBanditArena()
    SetHostile(2,7)
    Display.SetPlayerColorMapping(7,3)
    createArena1()
    createArena2()
end

function initArenaBanditsQuest()
    local NPC = {
        name = "Schwarz",
        heroName = "Ari",
        callback = BriefingArenaRumor
    }
    CreateNPC(NPC)
end

function createArenaFighter(_arenafight)
    ARENA_OCCUPIED = true
    DestroyEntity(GetEntityId("Ari"))
    DestroyEntity(GetEntityId("Schwarz"))
    CreateMilitaryGroup(1, Entities.PU_Hero5, 0, GetPosition("AriArena"), "Ari")
    CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("SchwarzArena"), "Schwarz")
    StartCountdown(1, function ()
        Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
        CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
    end, false)
    SetHostile(1,7)

    if _arenafight == 1 then
        arenaArmies1()
    elseif _arenafight == 2 then
        DestroyEntity(GetEntityId("Regar"))
        CreateMilitaryGroup(7, Entities.CU_VeteranMajor, 0, GetPosition("ArenaFighter3"), "Regar")
        arenaArmies2()
    end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "isArenaFighterRemaining" , 1, {}, {_arenafight})
end

function isArenaFighterRemaining(_arenafight)
    if AI.Player_GetNumberOfLeaders(7) == 0 then
        ARENA_OCCUPIED = false
        DestroyEntity(GetEntityId("Ari"))
        DestroyEntity(GetEntityId("Schwarz"))
        CreateMilitaryGroup(1, Entities.PU_Hero5, 0, GetPosition("AriArenaExit"), "Ari")
        CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("SchwarzArenaExit"), "Schwarz")
        StartCountdown(1, function ()
            Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
            CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
        end, false)
        SetNeutral(1,7)
        SetNeutral(7,1)
        createArena1()
        createArena2()
        if _arenafight == 1 then
            BriefingArenaWon1()
        elseif _arenafight == 2 then
            CreateMilitaryGroup(4, Entities.CU_VeteranMajor, 0, GetPosition("RegarArenaExit"), "Regar")
            BriefingArenaWon2()
        end
        return true
    end
    if IsDead("Ari") and IsDead("Schwarz") then
        ARENA_OCCUPIED = false
        DestroyEntity(GetEntityId("Ari"))
        SetNeutral(1,7)
        SetNeutral(7,1)
        CreateMilitaryGroup(1, Entities.PU_Hero5, 0, GetPosition("AriArenaExit"), "Ari")
        CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("SchwarzArenaExit"), "Schwarz")
        StartCountdown(1, function ()
            Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
            CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
        end, false)
        createArena1()
        createArena2()
        if _arenafight == 1 then
            BriefingArenaLoss1()
        elseif _arenafight == 2 then
            DestroyEntity(GetEntityId("Regar"))
            CreateMilitaryGroup(4, Entities.CU_VeteranMajor, 0, GetPosition("RegarArenaExit"), "Regar")
            BriefingArenaLoss2()
        end
        return true
    end
end

function arena1Won()
    local NPC = {
        name = "Regar",
        heroName = "Ari",
        callback = BriefingArena2
    }
    CreateNPC(NPC)
    Logic.SetShareExplorationWithPlayerFlag(1, 4, 1)
    setupSpawnerBandits()
end

function arena2Won()
    ChangePlayer("VillageHallBandits",1)
end

function initMinerQuest()
    local NPC = {
        name = "miner",
        heroName = "Ari",
        callback = BriefingMiner
    }
    CreateNPC(NPC)
end

function initMercTowerQuest()
    local NPC = {
        name = "towerBuilder",
        heroName = "Ari",
        callback = BriefingMercTower
    }
    CreateNPC(NPC)
end

function initSturmbachAggressionQuest()
    local NPC = {
        name = "General",
        heroName = "Ari",
        callback = BriefingSturmbachAggression
    }
    CreateNPC(NPC)
end

function setupWoodTribute()
    local tribute = {
        playerId = 1,
        text = "Zahlt 10000 Holz, damit Sturmbach in die Offensive geht!",
        cost = {Wood = 10000},
        Callback = BriefingWoodTribute
    }

    AddTribute(tribute)
end

function intiIronMineQuest()
    local NPC = {
        name = "MineOwner",
        heroName = "Ari",
        callback = BriefingIronMine
    }
    CreateNPC(NPC)
end

function setupIronMineTribute()
    local tribute = {
        playerId = 1,
        text = "Zahlt ".. Difficulty .."00 Silber für die Minenanlange!",
        cost = {Silver = 100*Difficulty},
        Callback = ironMinePayed
    }

    AddTribute(tribute)
end

function ironMinePayed()
    for i = 1, 5 do
        ChangePlayer("iron" .. i, 1)
    end
end

function moveShagsworthCamp()
    if IsNear("Shagsworth","shagsworthPos",200) and IsNear("Scoob","scoobPos",200) then
        LookAt("Shagsworth","campShagsworth")
        LookAt("Scoob","campShagsworth")
        local NPC = {
            name = "Shagsworth",
            callback = BriefingShagsworthQuest
        }
        CreateNPC(NPC)
        return true
    end
    Move("Shagsworth","shagsworthPos")
    Move("Scoob","campShagsworth")
end

function initLightHouseQuest()
    local NPC = {
        name = "lighthouseNPC",
        heroName = "Ari",
        callback = BriefingLighthouse
    }
    CreateNPC(NPC)
end

function isLighthouseBurning()
    if GetHealth("lighthouse") <= 45 then
        ChangePlayer("lighthouse",3)
        BriefingLighthouseSuccess()
        return true
    end
end

function getLighouseReward()
    AddGold(10000)
    Message("Die Minenarbeiter haben Euch einiges an Gold mitgebracht!")
end

function GetHealth( _entity )
	local entityID = GetEntityId( _entity );
 
	if not Tools.IsEntityAlive( entityID ) then
		return 0;
	end
	local maxHealth = Logic.GetEntityMaxHealth( entityID );
	local health = Logic.GetEntityHealth( entityID );
 
	return ( health / maxHealth ) * 100;
end