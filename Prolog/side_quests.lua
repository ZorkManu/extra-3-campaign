ARENA_OCCUPIED = false
SHAGTALKED = false

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
    CreateMilitaryGroup(1, Entities.PU_Hero_Bandit, 0, GetPosition("SchwarzArena"), "Schwarz")
    --Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
    CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
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
        CreateMilitaryGroup(1, Entities.PU_Hero_Bandit, 0, GetPosition("SchwarzArenaExit"), "Schwarz")
        --Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
        CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
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
        CreateMilitaryGroup(1, Entities.PU_Hero_Bandit, 0, GetPosition("SchwarzArenaExit"), "Schwarz")
        --Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
        CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
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

function moveShagsworthQuest()
    if IsNear("Shagsworth","ShagsworthClay",200) and IsNear("Scoob","ScoobClay",200) then
        CreateMilitaryGroup(2, Entities.CU_SettlerIdle, 0, GetPosition("WitnessSpawn"), "Will")
        local NPC = {
            name = "Shagsworth",
            callback = BriefingVillagerMaulwurfUpdate
        }
        CreateNPC(NPC)
        return true
    end
    Move("Shagsworth","ShagsworthClay")
    Move("Scoob","ScoobClay")
end

function moveShagsworthCamp()
    if IsNear("Shagsworth","shagsworthPos",200) and IsNear("Scoob","scoobPos",200) then
        LookAt("Shagsworth","AriCampsite")
        LookAt("Scoob","SchwarzCampsite")
        local NPC = {
            name = "Shagsworth",
            callback = BriefingShagsworthQuest
        }
        CreateNPC(NPC)
        return true
    end
    Move("Shagsworth","shagsworthPos")
    Move("Scoob","scoobPos")
end

function checkForPrisonGhost()
    local ghostPrison = GetPosition("ghostPrison")
    local foundEntities = { Logic.GetPlayerEntitiesInArea(6,nil,ghostPrison.X,ghostPrison.Y,200) }
    if foundEntities[1] > 0 then
        local foundMoreEntities = { Logic.GetPlayerEntitiesInArea(6,nil,ghostPrison.X,ghostPrison.Y,400) }
        for i in pairs(foundEntities) do
            if i > 1 then
                local entity = foundEntities[i]
                ChangePlayer(entity,8)
            end
        end
        local fence = GetPosition("Fence")
        Logic.CreateEntity( Entities.XD_IronGrid2, fence.X, fence.Y, 14 , 0 )
        TeleportSettler(GetEntityId("Ari"),GetPosition("AriCampsite").X,GetPosition("AriCampsite").Y)
        if IsDead("Schwarz") == false then
            TeleportSettler(GetEntityId("Schwarz"),GetPosition("SchwarzCampsite").X,GetPosition("SchwarzCampsite").Y)
        end
        BriefingGhostImprisoned()
        GUI.DestroyMinimapPulse(ghostPrison.X,ghostPrison.Y)
        SetHostile(4,6)
        return true
    end
end

function initSturmbachNPCs()
    local NPC = {
        name = "p3_Scolar",
        heroName = "Ari",
        callback = BriefingP3Scolar
    }
    CreateNPC(NPC)
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