GATEOPEN = {
    [1] = true,
    [2] = true,
    [3] = true
}
TICK = 0
TROLLWAVE = 1

function reachCastleQuest()
    StartSimpleJob("checkForCastle")
end

function checkForCastle()
    if IsDead(Armies[ARMYINDEXP1HQ]) and IsDead("towerp1hq") then
        ChangePlayer("p1hq",1)
        ChangePlayer("merctowerp1",1)
        AddGold(800)
        AddClay(1700)
        AddWood(2000)
        AddStone(1000)
        initDarioNPC()
        local markerPos = GetPosition("p1hq")
        GUI.DestroyMinimapPulse(markerPos.X,markerPos.Y,2)
        StartCountdown(220, function ()
            createGeneralSpawner(5, Difficulty * 2, "nearbasespawn", 3500, 320, "nearbasespawner", Ghosttypes, true, true, "nearbySpawnAdvance")
        end, false)
        --StartCountdown(300, function ()
            --if Difficulty ~= 1 then
                --createGeneralSpawner(6, Difficulty*2 - 2, "stonespawn", 3500, 600, "stonespawner", {{Entities.PU_Hero14_Bearman1,20}}, true, true, "stoneMineSpawnAdvance")
            --end
        --end, false)
        BriefingHQ()
        return true
    end
end

function initDarioNPC()
    GUI.CreateMinimapMarker(GetPosition("Dario").X,GetPosition("Dario").Y,2)
	Explore.Show("explDario", "Dario", 3000)
    CreateNPC {
        name = "Dario",
        callback = BriefingEnterMercius,
    }
end

function initWoodcutterChiefNPC()
    CreateNPC {
        name = "p2captain",
        callback = BriefingSulfurBase,
    }
end

function checkForSulfurBase()
    if IsDead("barracksghostsulfur") and IsDead("archeryghostsulfur") then
        CreateNPC {
            name = "p2captain",
            callback = BriefingSulfurBaseConquered,
        }
        return true
    end
end

function startWoodCutterQuest()
    CreateNPC {
        name = "p2captain",
        callback = BriefingWoodCutterStart,
    }
end

function startKerberosQuest()
    createKerberosSpawner()
    for i = 1, 3 do
        ReplaceEntity( GetEntityId("gatekerberos" .. i), Entities.XD_DarkWallStraightGate)
    end
    StartSimpleJob("checkForKerberosBase")
    StartSimpleJob("checkForKerberosReeinforcements")
end

function checkForKerberosReeinforcements()
    if AreEntitiesInArea( 1, 0, GetPosition("areaCheckKerberos"), 4000, 1) then
        Message("Kerberos: Scheint als wären wir gerade rechtzeitig. Zeigt diesen Nebelkrieger wer besser Angst und Schrecken verbreiten kann!")
        local pos = GetPosition("KerberosSpawn1")
        Camera.ScrollSetLookAt(pos.X,pos.Y)
        Logic.SetShareExplorationWithPlayerFlag(1, 4, 1)
        createKerberosReeinforcementArmies()
        return true
    end
end

function checkForKerberosBase()
    for i = 1, 4 do
        if IsDead("kerbSpawner" .. i) == false then
            return false
        end
    end
    for i = 1, 3 do
        if IsDead("kerbtower" .. i) == false then
            return false
        end
    end
    if AreEntitiesInArea( 6, 0, GetPosition("KerberosVillageMiddle"), 10000, 1) then
        return false
    end
    DestroyEntity("Kerberos")
    DestroyEntity("Kardinel")
    DestroyEntity("Feuerahn")
    CreateMilitaryGroup(4, Entities.CU_BlackKnight, 0, GetPosition("KerberosStand"), "Kerberos")
    LookAt("Kerberos","KerberosEntrance")
    if GDB.GetString("FmFKardinel") == "1" then
        createKardinel("KardinelStand")
        LookAt("Kardinel","KerberosEntrance")
        CreateNPC {
            name = "Kardinel",
            callback = BriefingKardinel,
        }
    end
    BriefingKerberos()
    createPlayer4()
    StartSimpleJob("checkNearKerberos")
    return true
end

function checkNearKerberos()
    for key, value in pairs(BKArmies["Advance"]["IDs"]) do
        if IsNear("Kerberos", value, 1000) then
            swapBKArmies()
            return true
        end
    end
    if IsNear("Kerberos", "bk6", 1000) then
        swapBKArmies()
        return true
    end
end

function woodCutterJob()
    Message("Ein Holzfäller ist unterwegs!")
    local pos = GetPosition("WoodCutterSpawn")
    GUI.CreateMinimapPulse(pos.X, pos.Y, 0)
	StartCountdown(5, function ()
		GUI.DestroyMinimapPulse(GetPosition("WoodCutterSpawn").X, GetPosition("WoodCutterSpawn").Y)
	end, false)
    CreateMilitaryGroup(2, Entities.CU_BanditLeaderSword1, 0, pos, "WoodCutter")
    StartSimpleJob("moveWoodCutter")
end

function moveWoodCutter()
    if IsDead("WoodCutter") then
        StartCountdown(20, woodCutterJob, false)
        return true
    end
    if IsNear("WoodCutter","WoodCutterMove", 300) then
        DestroyEntity("WoodCutter")
        CreateMilitaryGroup(2, Entities.CU_BanditLeaderSword1, 0, GetPosition("WoodCutterInsideSpawn"), "WoodCutter")
        Move("WoodCutter","WoodCutterAnimation")
        StartCountdown(2,function ()
            Logic.SuspendEntity(GetEntityId("WoodCutter"))
            Logic.SetTaskList(GetEntityId("WoodCutter"),TaskLists.TL_TRAIN2_BARRACKS2)
        end,false)
        StartCountdown(60, function ()
            Logic.ResumeEntity(GetEntityId("WoodCutter"))
            Logic.SetTaskList(GetEntityId("WoodCutter"),TaskLists.TL_MILITARY_IDLE)
            woodCutterReturnJob()
        end, false)
        return true
    end
    Move("WoodCutter","WoodCutterMove")
end

function woodCutterReturnJob()
    Move("WoodCutter","WoodCutterInsideSpawn")
    StartCountdown(2,function ()
        Message("Der Holzfäller macht sich auf den Weg zu den Toren!")
        DestroyEntity("WoodCutter")
        CreateMilitaryGroup(2, Entities.PU_Travelling_Salesman, 0, GetPosition("WoodCutterMove"), "WoodCutter")
        moveWoodCutterBack()
    end, false)
end

function moveWoodCutterBack()
    if IsDead("WoodCutter") and (GATEOPEN[1] == true or GATEOPEN[2] == true or GATEOPEN[3] == true) then
        StartCountdown(20, woodCutterJob, false)
        return true
    end
    local gate, gateText, gateId
    if GATEOPEN[1] == true then
        gate = "bottomgate"
        gateText = "untere Tor"
        gateId = 1
    elseif GATEOPEN[2] == true then
        gate = "frontgate"
        gateText = "mittlere Tor"
        gateId = 2
    else
        gate = "uppergate"
        gateText = "obere Tor"
        gateId = 3
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForWoodCutter", 1, {}, {gate,gateText,gateId})
end

function checkForWoodCutter(_gate,_gateText,_gateId)
    if IsNear("WoodCutter",_gate,1000) then
        GATEOPEN[_gateId] = false
        Message("Das " ..  _gateText .. " wird geschlossen!")
        if _gate == "bottomgate" then
            Redeploy(BKArmies["Advance"], GetPosition("bottomgate"))
            Redeploy(BKArmies["Defend"], GetPosition("bottomgate"))
            DestroyAITroopGenerator(BKArmies["Advance"])
            DestroyAITroopGenerator(BKArmies["Defend"])
        end
        if _gate == "bottomgate" then
            StartCountdown(80, function ()
                closeGate("bottomgate")
            end, true)
        elseif _gate == "frontgate" then
            StartCountdown(20, function ()
                closeGate("frontgate")
            end, true)
        elseif _gate == "uppergate" then
            StartCountdown(20, function ()
                closeGate("uppergate")
            end, true)
        end
        return true
    end
    if IsDead("WoodCutter") then
        StartCountdown(20,woodCutterJob,false)
        return true
    end
    Move("WoodCutter",_gate)
end

function closeGate(_gate)
    for i  = 1, 2 do
        local gateEntity = ReplaceEntity( GetEntityId(_gate .. i), Entities.XD_WallStraightGate_Closed)
        SetEntityName(gateEntity, _gate .. i)
        MakeInvulnerable(gateEntity)
    end
    if GATEOPEN[1] == false and GATEOPEN[2] == false and GATEOPEN[3] == false then
        DestroyEntity("WoodCutter")
        gatherEveryone()
        BriefingAllGatesReeinforced()
    elseif IsDead("WoodCutter") then
        StartCountdown(20,woodCutterJob,false)
    else
        moveWoodCutterBack()
    end
end

function safeVillage()
    createClosedArmies()
    GUI.DestroyMinimapPulse(GetPosition("BigTree").X,GetPosition("BigTree").Y)
    AllowTechnology( Technologies.UP2_Headquarter, 1 )
    AllowTechnology( Technologies.GT_Architecture, 1 )
    for i in pairs(MapEditor_Armies[2].armies) do
        MapEditor_Armies[2].armies[i].defensiveArmies.rodeLength = 20000
        MapEditor_Armies[2].armies[i].defensiveArmies.baseDefenseRange = 20000
    end
    --MapEditor_Armies[4].armies[1].offensiveArmies.enemySearchPosition = GetPosition("KerberosVillageMiddle")
    --spawnInSiegeTrolls() TODO
    for i = 1, 3 do
        StartSimpleJob("checkForGate" .. i)
    end
    CreateNPC {
        name = "p2scolar",
        callback = BriefingScolar,
    }
    CreateNPC {
        name = "vcguardian",
        callback = BriefingVCGuard,
    }
end

function gatherEveryone(_reason)
    DestroyEntity("Dario")
    DestroyEntity("Pilgrim")
    DestroyEntity("Ari")
    DestroyEntity("Kerberos")
    DestroyEntity("Kardinel")
    local pId = 2
    if _reason == "blodmoon" then
        pId = 1
    end
    CreateMilitaryGroup(pId, Entities.PU_Hero1c, 0, GetPosition("DarioPosFort"), "Dario")
    if _reason == "blodmoon" then
        DestroyEntity("Helias")
        CreateMilitaryGroup(1, Entities.PU_Hero6, 0, GetPosition("HeliasPosFort"), "Helias")
        LookAt("Helias","p2base")
    end
    CreateMilitaryGroup(1, Entities.PU_Hero5, 0, GetPosition("AriPosFort"), "Ari")
    CreateMilitaryGroup(1, Entities.PU_Hero2, 0, GetPosition("PilgrimPosFort"), "Pilgrim")
    if MapEditor_Armies[3] ~= nil then
        local yuki = "YukiCutscene"
        local pId = 3
        if _reason == "blodmoon" then
            DestroyEntity("Yuki")
            yuki = "Yuki"
            pId = 1
        end
        CreateMilitaryGroup(pId, Entities.PU_Hero11, 0, GetPosition("YukiPosFort"), yuki)
        LookAt(yuki,"p2base")
        CreateMilitaryGroup(3, Entities.CU_Barbarian_Hero, 0, GetPosition("VargPosFort"), "VargCutscene")
        LookAt("VargCutscene","p2base")
    end
    if MapEditor_Armies[4].armies[1] ~= nil then
        CreateMilitaryGroup(4, Entities.CU_BlackKnight, 0, GetPosition("KerberosPosFort"), "KerberosCutscene")
        LookAt("KerberosCutscene","p2base")
        if KARDINELACTIVE then
            CreateMilitaryGroup(4, Entities.CU_BlackKnight_LeaderSword3, 0, GetPosition("KardinelPosFort"),"KardinelCutscene")
            LookAt("KardinelCutscene","p2base")
        end
    end
    LookAt("Ari","p2base")
    LookAt("Dario","p2base")
    LookAt("Pilgrim","p2base")
end

function mopUpGathering()
    DestroyEntity("VargCutscene")
    DestroyEntity("KerberosCutscene")
    DestroyEntity("VargCutscene")
    DestroyEntity("YukiCutscene")
    DestroyEntity("KardinelCutscene")
end

function spawnInSiegeTrolls()
    if GATEOPEN[1] == false then
        for i = 1, math.max((TROLLWAVE+Difficulty)/10) do
            CreateMilitaryGroup(6, Entities.CU_Evil_Troll1, 0, GetPosition("cavespawnbottom"), "troll1" .. TROLLWAVE .. i)
            local troll = GetEntityId("troll1" .. TROLLWAVE .. i)
            SetEntitySize(troll, 6)
            Logic.GroupAttack(troll, GetEntityId("bottomgate" .. math.random(1,2)))
        end
    end
    if GATEOPEN[2] == false then
        for i = 1, math.max((TROLLWAVE+Difficulty)/10) do
            CreateMilitaryGroup(6, Entities.CU_Evil_Troll1, 0, GetPosition("cavespawnmiddle"), "troll1" .. TROLLWAVE .. i)
            local troll = GetEntityId("troll1" .. TROLLWAVE .. i)
            SetEntitySize(troll, 6)
            Logic.GroupAttack(troll, GetEntityId("frontgate" .. math.random(1,2)))
        end
    end
    if GATEOPEN[3] == false then
        for i = 1, math.max((TROLLWAVE+Difficulty)/10) do
            CreateMilitaryGroup(6, Entities.CU_Evil_Troll1, 0, GetPosition("cavetrollspawn"), "troll1" .. TROLLWAVE .. i)
            local troll = GetEntityId("troll1" .. TROLLWAVE .. i)
            SetEntitySize(troll, 6)
            Logic.GroupAttack(troll, GetEntityId("uppergate" .. math.random(1,2)))
        end
    end
    TROLLWAVE = TROLLWAVE + 1
    StartCountdown(120, function ()
        if GATEOPEN[1] == false and GATEOPEN[2] == false and GATEOPEN[3] == false then
            spawnInSiegeTrolls()
        end
    end)

end

function checkForGate1()
    if IsDead("bottomgate1") or IsDead("bottomgate2") then
        GATEOPEN[1] = true
        return true
    end
end

function checkForGate2()
    if IsDead("frontgate1") or IsDead("frontgate2") then
        GATEOPEN[2] = true
        return true
    end
end

function checkForGate3()
    if IsDead("uppergate1") or IsDead("uppergate2") then
        GATEOPEN[3] = true
        return true
    end
end

function moveHeliasToDario()
    if IsNear("Helias","Dario", 800) then
        BriefingHeliasDario()
        return true
    end
    Move("Helias","Dario")
end

function moveHeliasAndDarioToCathedral()
    if IsNear("Dario","DarioMovePoint1",300) and IsNear("Helias","HeliasMovePoint1",300) then
        BriefingCathedralEntrance()
        return true
    end
    Move("Dario","DarioMovePoint1")
    Move("Helias","HeliasMovePoint1")
end

function nearBishop()
    if IsNear("Dario","DarioMovePoint2",300) and IsNear("Helias","HeliasMovePoint2",300) then
        BriefingRitual()
        return true
    end
    Move("Dario","DarioMovePoint2")
    Move("Helias","HeliasMovePoint2")
end

function bloodmoonDefense()
    ChangePlayer("Dario",1)
    ChangePlayer("Helias",1)
    DestroyEntity("Bishop")
    Counter.Tick2("TIMER",1800)
    StartSimpleJob("TickCounter")
    initMonasteryDef()
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "graveAttackerPlan", 1, {}, {60})
    graveAttackerPlan(60)
    Display.GfxSetSetLightParams(30,  0.0, 1.0, 40, -15, -50,  120,90,80,  81,21,21)
    Display.GfxSetSetFogParams(30, 0.0, 1.0, 1, 95,82,92, 3500,32000)
    local wtype = Logic.GetWeatherState()
    Logic.AddWeatherElement(wtype, 1800, 0, 30, 5, 15)
    ForbidTechnology( Technologies.T_MakeSnow, 1 )
    StartCountdown(1200, ritualFinished,true)
end

function initMonasteryDef()
    local barracksId = GetEntityId("barracksholyguard")
    MapEditor_Armies[2].armies[barracksId] = {
        offensiveArmies = {
            id = barracksId,
            strength	= 0,
            position = GetPosition("holyguarddef"),
            enemySearchPosition = GetPosition("holyguarddef"),
            rodeLength = 0,
            baseDefenseRange = 0,
            AttackAllowed =	true,
            baitDetection = false,
            IDs	= {}
        },
        defensiveArmies = {
            id = barracksId,
            strength	= 2,
            position = GetPosition("holyguarddef"),
            baseDefenseRange = 5000,
            IDs	= {}
        },
        position = GetPosition("holyguarddef"),
    }
	MapEditor_Armies.controlerId.defensiveArmies[2] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {2, "defensiveArmies",barracksId})
end

function TickCounter()
    Counter.Tick("TIMER")
    TICK = Counter.GetTick("TIMER")
    if TICK >= 1200 then
        return true
    end
end

function graveAttackerPlan(_time)
    if TICK >= 1200 then
        return true
    end
    if Counter.Tick2("graveAttackerPlan".._time, _time) then
        graveArmies()
        graveMonasteryArmies()
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "graveAttackerPlan", 1, {}, {getNextTimeCounter()})
        return true
    end
end

function getNextTimeCounter()
    local progress = math.min(TICK / 1200, 1)
    return 60 * math.pow(30 / 60, progress)
end

function ritualFinished()
    gatherEveryone("blodmoon")
    MapEditor_SetupAI(7, 3, 100000, 3, "p7", 3, 0)
	SetupPlayerAi( 7, {constructing = true, extracting = true, repairing = true, serfLimit = 12} )
    Tools.GiveResouces(7, 1000000 , 0, 1200000, 0, 2000000, 1000000)
    SetPlayerName(7, "Mary")
    --createMarySpawner()

    MapEditor_Armies[7].armies[1] = {
        offensiveArmies = {
            strength	= 30,
            position = GetPosition("p7"),
            rodeLength = 200000,
            baseDefenseRange = 200000,
            AttackAllowed =	true,
            baitDetection = false,
            IDs	= {}
        },
        defensiveArmies = {
            strength	= 30,
            position = GetPosition("p7"),
            baseDefenseRange = 12000,
            IDs	= {}
        },
        position = GetPosition("p7"),
    }
	MapEditor_Armies.controlerId.offensiveArmies[1] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {7, "offensiveArmies",1})
	MapEditor_Armies.controlerId.defensiveArmies[1] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {7, "defensiveArmies",1})
    for i in pairs(MapEditor_Armies[2].armies) do
        MapEditor_Armies[2].armies[i].defensiveArmies.rodeLength = 200000
        MapEditor_Armies[2].armies[i].defensiveArmies.baseDefenseRange = 200000
    end

    --MapEditor_Armies[4].armies[1].offensiveArmies.enemySearchPosition = GetPosition("bottomghostspawn3")
    --Cutscene
    cutsceneReplace()
    for i = 5, 6 do
        SetHostile(i,8)
    end
    for i = 1, 2 do
        local bridge = ReplaceEntity( GetEntityId("bridge" .. i), Entities["PB_DrawBridgeClosed" .. i])
        SetEntityName(bridge, "bridge" .. i)
    end
    CreateNPC {
        name = "Catapultmaker",
        callback = BriefingCatapultmakerAfterRitual,
    }
    --StartSimpleJob("checkForSteamMashine")
    StartSimpleJob("checkForVictory")
end

function cutsceneReplace()
    killGhosts()
    Logic.SetShareExplorationWithPlayerFlag(1, 8, 1)
    AddPeriodicSummer(999999)
    StartSummer(99999)
    SetPlayerName(8, "Erec?")
    local lookPos = GetPosition("uppgergate2")
    local erecId = AI.Entity_CreateFormation(8, Entities.PU_Hero4_Spectral, nil, 0, GetPosition("ErecSpawn").X, GetPosition("ErecSpawn").Y, lookPos.X*100, lookPos.Y*100, 3, 0)
    MakeInvulnerable(erecId)
    SetEntityName(erecId, "Erec")
    CUtil.SetEntityDisplayName(erecId, "Erec")

    for i = 1, 2 do
        local pos = GetPosition("ErecTroopsSpawn" .. i)
        for j = 1,3 do
            MakeInvulnerable(AI.Entity_CreateFormation(8, Entities.PU_LeaderSword4_Spectral, Entities.PU_SoldierSword4_Spectral, 12, pos.X, pos.Y, lookPos.X*100, lookPos.Y*100, 3, 0))
        end
    end
    createGhostErecArmy()
    for i = 1, 2 do
        ReplaceEntity( GetEntityId("uppergate" .. i), Entities.XD_WallStraightGate)
        GATEOPEN[3] = true
    end
    for i = 1, 2 do
        ReplaceEntity( GetEntityId("frontgate" .. i), Entities.XD_WallStraightGate)
        GATEOPEN[2] = true
    end
    for i = 1, 2 do
        ReplaceEntity( GetEntityId("bottomgate" .. i), Entities.XD_WallStraightGate)
        GATEOPEN[1] = true
    end
    BriefingAdvance()
end

function killGhosts()
    for key in pairs(Armies) do
        if Armies[key].player == 5 then
            if Armies[key].generatorName ~= nil then
                DestroyAITroopGenerator(Armies[key])
            end
        end
    end
    local leaderIds = GetPlayerLeaderIds(5)
    for i = 1, table.getn(leaderIds) do
        local currentLeaderId = leaderIds[i]
        local soldiers = { Logic.GetSoldiersAttachedToLeader(currentLeaderId) }

        for k = 2, table.getn(soldiers) do
            SetHealth( soldiers[k], 0 )
        end

        SetHealth( currentLeaderId, 0 )
    end
end

function killBlackKnights()
    local BlackKnightLookup = {}

    for i = 1, table.getn(BlackKnightTypes) do
        BlackKnightLookup[BlackKnightTypes[i][1]] = BlackKnightTypes[i][2]
    end

    local leaderIds = GetPlayerLeaderIds(5)
    for i = 1, table.getn(leaderIds) do
        local currentLeaderId = leaderIds[i]
        if BlackKnightLookup[Logic.GetEntityType(currentLeaderId)] ~= nil then
            if Logic.GetEntityType(currentLeaderId) ~= Entities.CU_VeteranCaptain then
                local soldiers = { Logic.GetSoldiersAttachedToLeader(currentLeaderId) }

                for k = 2, table.getn(soldiers) do
                    DestroyEntity( soldiers[k] )
                end
            end

            DestroyEntity( currentLeaderId )
        end
    end
end

function checkForSteamMashine()
    if IsDead("SteamMashine") then
        for i = 1, 2 do
            ReplaceEntity( GetEntityId("MaryGate" .. i), Entities.XD_WallStraightGate)
        end
        Message("Ari: Wir haben eine Maschine zerstört. Pilgrim du kennst dich doch mit Technik aus, wofür war die?")
        StartCountdown(5,function ()
            Message("Pilgrim: Technik? Ich bin Alchemist. Aber es scheint als hättest du Glück, ich war letztens bei Leonardo für Schwefel und er hat mir solche Dinger gezeigt.")
        end,false)
        StartCountdown(8,function ()
            Message("Pilgrim: Die Dampfmaschine war eine Kontrolleinheit für die linken Tore. Unser zerstörerischer Ansatz war also genau das Richtige. Das Tor links ist jetzt offen.")
        end,false)
        return true
    end
end

function checkForVictory()
    if IsDead("p7hq") then
        BriefingVictory()
        return true
    end
end