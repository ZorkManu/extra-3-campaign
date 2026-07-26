FIRSTQUESTOUTOFRANGE = 0
TOWERVISITED = false
AMBUSHVISITED = false
BANDITSAPPEARED = false
UNKNOWNARMYDEAD = false
REEINFORCEMENTSARRIVED = false
STURMBACHALLIED = false
SCHWARZ_LIFE = 3
VCCAPTURED = false

function firstQuest()
    BriefingStart()
    StartSimpleJob("denyAriAbility")
end

function initSwords()
    CreateMilitaryGroup(3, Entities.PU_LeaderSword2, 4, GetPosition("SwordSpawn"), "Sword1")
    for i = 2, 3 do
        CreateMilitaryGroup(3, Entities.PU_LeaderSword2, 4, GetPosition("SwordSpawn"), "Sword" .. i)
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "guardSword" , 1, {}, {i})
    end
    StartSimpleJob("moveToAri")
end

function guardSword(_id)
    if IsDead("Sword" .. _id) or AMBUSHVISITED then
        return true
    end
    Logic.GroupGuard(GetEntityId("Sword" .. _id), GetEntityId("Sword1"))
end

function denyAriAbility()
    if (BANDITSAPPEARED) then
        Logic.HeroSetAbilityChargeSeconds(GetEntityId("Ari"), Abilities.AbilitySummon, 180)
        return true
    end
    Logic.HeroSetAbilityChargeSeconds(GetEntityId("Ari"), Abilities.AbilitySummon, 0)
end

function moveToAri()
    Move("Sword1", "Ari")
    if (IsNear("Sword1", "Ari", 500)) then
        if (FIRSTQUESTOUTOFRANGE > 0) then
            StartSimpleJob("followSwords")
            return true
        end
        BriefingSwords()
        return true
    end
end

function followSwords()
    if (not IsNear("Sword1", "Ari",2400)) then
        ariOutOfRange()
        return true
    elseif (IsNear("Ari", "BanditPos",1000) and not TOWERVISITED) then
        BriefingBanditTower()
        return true
    elseif (IsNear("Ari", "Ambush",1000)) then
        BriefingAmbush()
        return true
    elseif (not TOWERVISITED) then
        Move("Sword1", "BanditPos")
    else
        Move("Sword1", "Ambush")
    end

end

function ariOutOfRange()
    if (FIRSTQUESTOUTOFRANGE == 2) then
        Message("Schade dann bleibt uns nichts anderes über als Euch hier zu töten")
        SetHostile(1,3)
        SetHostile(7,3)
        Defeat()
        return
    elseif (FIRSTQUESTOUTOFRANGE == 0) then
        Message("Bitte bleibt in unserer Nähe")
    elseif FIRSTQUESTOUTOFRANGE == 1 then
        Message("Solangsam reißt uns der Geduldsfaden, folgt uns.")
    end
    LookAt("Sword1", "Ari")
    FIRSTQUESTOUTOFRANGE = FIRSTQUESTOUTOFRANGE + 1
    StartSimpleJob("moveToAri")
end

function checkForHalberds()
    if(IsDead("h1") and IsDead("h2")) then
        BriefingBandits()
        return true
    end
end

function checkForSwords()
    local allDead = true
    for i = 1, 3 do
        if (IsAlive("Sword"..i)) then
            allDead = false
        end
    end
    if (allDead) then
        BriefingPostBattle()
        return true
    end
end

function firstQuestDone()
    firstQuestDoneFlag = true
    for i = 1, 4 do
        AI.Entity_CreateFormation(1, Entities.PU_Serf, nil, 0, GetPosition("banditAmbush").X, GetPosition("banditAmbush").Y, GetPosition("Ari").X*100, GetPosition("Ari").Y*100, 3, 0)
    end
    Logic.SetShareExplorationWithPlayerFlag(1, 7, 0)
    SetHostile(3,4)
    initBanditArena()
    ChangePlayer("p1hq", 1)
    ChangePlayer("banditTower", 1)
    AddGold(800)
    AddClay(1700)
    AddWood(2000)
    AddStone(1000)
    Logic.SetQuestType(1, 2, MAINQUEST_CLOSED, 0)
    secondQuest()
    initMinerQuest()
    StartSimpleJob("checkForWinkelhain")
end

function secondQuest()
    local NPC = {
        name = "mayorWinkelhain",
        callback = BriefingMayorWinkelhain,
    }
    CreateNPC(NPC)
end

function prepareForSturmbachAttack()
    SetFriendly(1,2)
    GUI.DestroyMinimapPulse(GetPosition("mayorWinkelhain").X,GetPosition("mayorWinkelhain").Y)
    initArenaBanditsQuest()
    initWinkelhainNPCs()
    StartCountdown(1200, attackSturmbach, true)
    StartSimpleJob("changeSturmbachAttackPlan")
end

function changeSturmbachAttackPlan()
    if Counter.Tick2("changeSturmbachAttackPlan", 900) then
        SetHostile(3,5)
        SetHostile(3,6)
        return true
    end
end

function createUnknownAttacker()
    SetHostile(3,5)
    SetHostile(3,6)
    SetHostile(4,5)
    SetHostile(4,6)
    SetPlayerName(5, "Nebelvolk")
    SetPlayerName(6, "???")
    attackNVArmy()
    attackUnknownArmy()
    StartSimpleJob("checkForUnknownAttacker")
    StartSimpleJob("checkForSturmbachAttacker")
end

function checkForSturmbachAttacker()
    if Counter.Tick2("checkForUnknownAttacker", 10) then
        if IsDead(attackArmy[1]) and IsDead(attackArmy[2]) then
            SetNeutral(1,3)
            SetNeutral(2,3)
            SetNeutral(3,2)
            SetNeutral(3,1)
            SetNeutral(3,4)
            SetNeutral(4,3)
            ChangePlayer("p2hq",1)
            ChangePlayer("p2hq",2)
            return true
        end
    end
end

function checkForUnknownAttacker()
    if Counter.Tick2("checkForUnknownAttacker", 10) then
        if IsDead(armyNV) and IsDead(armyUnknown) and IsDead(attackArmy[1]) and IsDead(attackArmy[2]) then
            SetFriendly(1,2)
            BriefingPostAttack()
            return true
        end
    end
end

function thirdQuest()
    MapEditor_Armies[2].offensiveArmies.strength = 3
    Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
    DestroyEntity(GetEntityId("villager2"))
    setupSpawnerGhost1()
    setupSpawnerGhost2()
    setupSpawnerNV1()
    setupSpawnerNV2()
    initMercTowerQuest()
    questReeinforcements()
    questSturmbach()
    StartSimpleJob("victoryCondition")
end

function questSturmbach()
    Move("General", "EntranceSturmbach")
    MakeInvulnerable(GetEntityId("General"))
    StartSimpleJob("ariInRangeSturmbach")
    
end

function ariInRangeSturmbach()
    if IsNear("Ari", "General", 1000) then
        BriefingEnterSturmhain()
        return true
    end
end

function CreateMayorSturmbach()
    local NPC = {
        name = "mayorSturmbach",
        heroName = "Ari",
        callback = BriefingMayorSturmbach
    }
    CreateNPC(NPC)
end

function finishSturmbachQuest()
    SetFriendly(1,3)
    ActivateShareExploration(1,3)
    initSturmbachAggressionQuest()
    intiIronMineQuest()
    initLightHouseQuest()
end

function questReeinforcements()
    local NPC = {
        name = "mayorWinkelhain",
        heroName = "Ari",
        callback = BriefingMayorWinkelhain2
    }
    CreateNPC(NPC)
end

function speakWithMessenger()
    local NPC = {
        name = "Rudger",
        heroName = "Ari",
        callback = BriefingRudger
    }
    CreateNPC(NPC)
end

function messengerArrival()
    if IsNear("Rudger", "scoutGate", 100) then
        ChangePlayer(GetEntityId("Rudger"), 1)
        BriefingMountains()
        return true
    end
end

function reeinforcementsMercius()
    CreateMilitaryGroup(1, Entities.PU_Hero2, 0, GetPosition("reeinfPilgrim"), "Pilgrim")
    CreateMilitaryGroup(1, Entities.PU_Scout, 0, GetPosition("reeinfScout"))
    CreateMilitaryGroup(2, Entities.PU_LeaderCavalry2, 0, GetPosition("reeinfRudger"), "Rudger")
    StartCountdown(1, function ()
        Logic.SetEntityScriptingValue(GetEntityId("Rudger"),72,1)
        CUtil.SetEntityDisplayName(GetEntityId("Rudger"), "Rudger")
    end, false)
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PV_Cannon2, 0, GetPosition("reeinf1" .. i))
    end
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PU_LeaderHeavyCavalry2, 5, GetPosition("reeinf2" .. i))
    end
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PU_LeaderHeavyCavalry2, 5, GetPosition("reeinf2" .. i))
    end
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PU_LeaderRifle2, 8, GetPosition("reeinf3" .. i))
    end
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PU_LeaderSword4, 12, GetPosition("reeinf4" .. i))
    end
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PV_Cannon3, 0, GetPosition("reeinf5" .. i))
    end
    for i = 1, 5 do
        CreateMilitaryGroup(1, Entities.PU_LeaderBow4, 12, GetPosition("reeinf6" .. i))
    end
    createArmyVC()
    StartSimpleJob("checkForAbandonedVillage")
    StartSimpleJob("checkForHotEnemiesInYourArea")
    BriefingReeinforcements()
end

function checkForAbandonedVillage()
    if VCCAPTURED == true then
        Message("Seht nur ein verlassenes Dorfzentrum, lasst es uns besetzen.")
        ChangePlayer("abandonedVillage",1)
        return true
    end
end

function checkForHotEnemiesInYourArea()
    if AreEnemiesInArea( 6, GetPosition("spawnGhost"), 3000) or IsDead("reeinfSpawner2") then
        createOneTimeArmies()
        return true
    end
end

function victoryCondition()
    if Counter.Tick2("victoryCondition",10) then
        if AI.Player_GetNumberOfLeaders(5) == 0 and AI.Player_GetNumberOfLeaders(6) == 0 and IsDead("spawnGhost") then
            victoryCheck()
            return true
        end
    end
end

function victoryCheck()
    ARENA_OCCUPIED = true
    DestroyEntity(GetEntityId("Ari"))
    DestroyEntity(GetEntityId("Schwarz"))

    CreateMilitaryGroup(1, Entities.PU_Hero5, 0, GetPosition("AriEnd"), "Ari")
    CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("SchwarzEnd"), "Schwarz")

    LookAt("Ari", "Schwarz")
    LookAt("Schwarz", "Ari")

    if REEINFORCEMENTSARRIVED and STURMBACHALLIED then
        DestroyEntity(GetEntityId("Rudger"))
        DestroyEntity(GetEntityId("Pilgrim"))
        CreateMilitaryGroup(1, Entities.PU_LeaderCavalry2, 0, GetPosition("RudgerEnd"), "Rudger")
        CreateMilitaryGroup(1, Entities.PU_Hero2, 0, GetPosition("PilgrimEnd"), "Pilgrim")
        LookAt("Pilgrim", "Rudger")
        LookAt("Rudger", "Pilgrim")

        BriefingVictory()
        return
    end
    if REEINFORCEMENTSARRIVED then
        DestroyEntity(GetEntityId("Rudger"))
        DestroyEntity(GetEntityId("Pilgrim"))
        CreateMilitaryGroup(1, Entities.PU_LeaderCavalry2, 0, GetPosition("RudgerEnd"), "Rudger")
        CreateMilitaryGroup(1, Entities.PU_Hero2, 0, GetPosition("PilgrimEnd"), "Pilgrim")
        LookAt("Pilgrim", "Rudger")
        LookAt("Rudger", "Pilgrim")

        BriefingVictoryNoAllies()
        return
    end
    if STURMBACHALLIED then
        BriefingVictoryNoReeinf()
        return
    end
    BriefingVictoryNoHelp()
end

function checkForWinkelhain()
    if IsDead("p2hq") then
        Defeat()
    end
end

function checkForSchwarz()
    if IsDead("Schwarz") and not ARENA_OCCUPIED then
        if SCHWARZ_LIFE > 0 then
            SCHWARZ_LIFE = SCHWARZ_LIFE - 1
            Message("Schwarz ist im Kampf verletzt worden. Er hat noch " .. SCHWARZ_LIFE .. " Leben")
            CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("banditAmbush"), "Schwarz")
            StartCountdown(1, function ()
                Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
			    CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
            end, false)
            return
        end
        Message("Schwarz ist im Kampf gefallen!")
        Defeat()
    end
end

-- Quelle: https://dedk.de/wiki/doku.php?id=utilfunctions:areenemiesinarea
function AreEnemiesInArea( _player, _position, _range)
    return AreEntitiesOfDiplomacyStateInArea( _player, _position, _range, Diplomacy.Hostile )
end
function AreEntitiesOfDiplomacyStateInArea( _player, _position, _range, _state )
    for i = 1,8 do
        if Logic.GetDiplomacyState( _player, i) == _state then
            if AreEntitiesInArea( i, 0, _position, _range, 1) then
                return true
            end
        end
    end
    return false
end 