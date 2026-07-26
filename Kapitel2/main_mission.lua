KERBEROSHASKEY = false
ESCAPEDCASTLE = false
BKNUMBER = 0
ALIVEWORKERS = {}
VILLAGEEMPTY = {}
WORKERSESCAPED = 0
BKESCAPED = 0
KERBEROSESCAPED = false

CARAVANWAVEAMOUNT = 20

WAYPOINTS = {
    [2] = {"wellp3","towndefpoint2","WorkerEscapePoint"},
    [5] = {"attackAlteaLeft1","wellp1","wellp2","townmiddle","WorkerEscapePoint"},
    [6] = {"wellp4","wellp5","townmiddle","WorkerEscapePoint"},
    [7] = {"townmiddle","WorkerEscapePoint"}
}

VILLAGESTATUS = {
    [2] = 0,
    [5] = 0,
    [6] = 0,
    [7] = 0
}


function initDungeoncrawler()
    local markerPos = GetPosition("closedindoorgate")
    GUI.CreateMinimapMarker(markerPos.X,markerPos.Y,2)
    Explore.Show("explclosedgate", "closedindoorgate", 500)
    StartCountdown(1, function ()
        Logic.SetEntityScriptingValue(GetEntityId("Necro"),72,1)
	    CUtil.SetEntityDisplayName(GetEntityId("Necro"), "Nekromant")
    end, false)
    Logic.GroupStand(GetEntityId("Necro"))
    StartSimpleJob("checkForPrisonDoor")
    StartSimpleJob("checkNearPantryDoor")
    StartSimpleJob("checkNearNecro")
    StartSimpleJob("checkNearDefBlackKnights")
    for i = 1, 3 do
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "nearUnit" , 1, {}, {"BK" .. i})
    end
end

function checkNearPantryDoor()
    if KERBEROSHASKEY then
        return true
    end
    if IsNear("Kerberos", "closedindoorgate",1000) then
        Message("Kerberos: Die Tür ist zu. Wer von euch Trotteln hat den Schlüssel versteckt?!")
        return true
    end
end

function checkForPrisonDoor()
    for i = 1, 5 do
        if AreEntitiesInArea( 1, 0, GetPosition("doorCheck".. i), 400, 1) then
            checkEntranceTP()
            local PrisonDoor = ReplaceEntity( GetEntityId("prisonDoor"), Entities.XD_IndoorsWallDoorClosedL)
            SetEntityName(PrisonDoor, "prisonDoor")
            local blockingPos = GetPosition("blocking")
            local blocking = Logic.CreateEntity( Entities.XD_Evil_Camp02, blockingPos.X, blockingPos.Y, 0, 0 )
            Logic.SetEntityName(blocking,"blocker")
            prisonEscapeQuest()
            return true;
        end
    end
end

function prisonEscapeQuest()
    createArmyPrisonGuard()
    StartSimpleJob("checkChest")
end

function checkChest()
    if AreEntitiesInArea( 1, 0, GetPosition("prisonkeypos"), 200, 1) then
        Message("Kardinel: Hier liegt ein Schlüsselbund, der wird die Tür zum Lagerraum wohl öffnen können.")
        local chestPos = GetPosition("prisonchest")
        Logic.CreateEntity( Entities.XD_ChestOpen, chestPos.X, chestPos.Y, 143, 0 )
        Logic.DestroyEntity( GetEntityId("prisonchest") )
        Logic.DestroyEntity( GetEntityId("blocker") )
        for i = 1, 6 do
            Logic.DestroyEntity( GetEntityId("prisongr" .. i))
        end
        ReplaceEntity( GetEntityId("prisonDoor"), Entities.XD_IndoorsWallDoorOpenL)
        createSerfMovement(3)
        KERBEROSHASKEY = true
        StartSimpleJob("checkNearPantryDoorWithKey")
        return true
    end
    if AreEntitiesInArea( 1, 0, GetPosition("doorCheck3"), 1400, 1) == false then
        Logic.DestroyEntity( GetEntityId("blocker") )
        ReplaceEntity( GetEntityId("prisonDoor"), Entities.XD_IndoorsWallDoorOpenL)
    end
end

function createSerfMovement(_remaining)
    local prisoner = "prisoner".._remaining
    Move(prisoner,"prisonermovepoint")
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "prisonerNearWeapons" , 1, {}, {prisoner})
    if _remaining > 1 then
        createSerfMovement(_remaining-1)
    end
end

function prisonerNearWeapons(prisonerId)
    if IsNear(prisonerId, "prisonermovepoint", 250) then
        ChangePlayer( GetEntityId(prisonerId), 1)
        ReplaceEntity( GetEntityId(prisonerId), Entities.CU_BlackKnight_LeaderMace1)
        return true
    end
end

function checkNearPantryDoorWithKey()
    if IsNear("Kerberos", "closedindoorgate",1000) then
        local markerPos = GetPosition("closedindoorgate")
        GUI.DestroyMinimapPulse(markerPos.X,markerPos.Y)
        Explore.Hide("explclosedgate")
        ReplaceEntity( GetEntityId("closedindoorgate"), Entities.XD_IndoorsWallDoorOpenR)
        Logic.DestroyEntity( GetEntityId("blocker2") )
        for i = 1, 3 do
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "nearUnit" , 1, {}, {"Rifle" .. i})
        end
        StartSimpleJob("checkNearPantryEntry")
        return true
    end
end

function checkNearNecro()
    if AreEntitiesInArea( 1, 0, GetPosition("armyBlood"), 1200, 1) then
        UseHeroAbility("Necro", Abilities.AbilityCircularAttack, false)
        StartSimpleJob("destroyInHallNecro")
        Message("Kardinel: So kommen diese Geisterkrieger also hierhin. Dann wissen wir ja wen wir töten müssen!")
        StartSimpleJob("waitForArmyBlood")
        return true
    end
end

function waitForArmyBlood()
    if Counter.Tick2("waitForArmyBlood",1) then
        createArmyBlood()
        return true
    end
end

function destroyInHallNecro()
    if IsDead("Necro") then
        Logic.DestroyEntity(GetEntityId("Necro"))
        return true
    end
end

function checkNearDefBlackKnights()
    if AreEntitiesInArea( 1, 0, GetPosition("HallWayCheck1"), 1000, 1) or AreEntitiesInArea( 1, 0, GetPosition("HallWayCheck2"), 1000, 1) or AreEntitiesInArea( 1, 0, GetPosition("HallWayCheck3"), 1000, 1) then
        createArmnyAttackBlackKnights()
        return true
    end
end

function checkNearPantryEntry()
    if AreEntitiesInArea( 1, 0, GetPosition("PantryEntry"), 1000, 1) then
        createArmyPantryNV()
        StartSimpleJob("teleportInCave")
        StartSimpleJob("teleportOutCave")
        createCaveArmies()
        StartSimpleJob("checkForBootsChest")
        initScoutNPC()
        return true
    end
end

function checkEntranceTP()
    if IsNear("Kerberos", "blocking", 700) then
        local teleportPosOut = GetPosition("doorCheck3")
        SetPosition("Kerberos", teleportPosOut)
    end
    local leaderIds = GetPlayerLeaderIds(1)
    for i = 1, table.getn(leaderIds) do
        local currentLeaderId = leaderIds[i]
        if IsNear(currentLeaderId, "blocking", 700) then
            local teleportPosOut = GetPosition("doorCheck3")
            if currentLeaderId == GetEntityId("Kardinel") then
                DestroyEntity(GetEntityId("Kardinel"))
                DestroyEntity(GetEntityId("Feuerzahn"))
                createKardinel("doorCheck3")
            else
                SetPosition(currentLeaderId, teleportPosOut)
            end
        end
    end
end

function nearUnit(_unitName)
    if AreEntitiesInArea( 1, 0, GetPosition(_unitName), 400, 1) then
        ChangePlayer(GetEntityId(_unitName), 1)
        Sound.PlayGUISound(Sounds.VoicesLeader_LEADER_Yes_rnd_01, 200)
        return true
    end
    if IsDead(_unitName) then
        return true
    end
end

function teleportInCave()
    if IsNear("Kerberos", "CaveEntrance", 400) then
        local teleportPosOut = GetPosition("CaveInterior")
        SetPosition("Kerberos", teleportPosOut)
    end
    local FirstLeaderID = Logic.GetNextLeader(1, 0)
    local CurrentLeaderID = FirstLeaderID
    local tpKardinel = false
    repeat
        if CurrentLeaderID ~= 0 then
        if IsNear(CurrentLeaderID, "CaveEntrance", 400) then
            local teleportPosOut = GetPosition("CaveInterior")
                if CurrentLeaderID == GetEntityId("Kardinel") then
                    DestroyEntity(GetEntityId("Kardinel"))
                    DestroyEntity(GetEntityId("Feuerzahn"))
                    createKardinel("CaveInterior")
                    tpKardinel = true
                else
                    SetPosition(CurrentLeaderID, teleportPosOut)
                end
            end
        end
        if tpKardinel == false then
            CurrentLeaderID = Logic.GetNextLeader(1,CurrentLeaderID)
        else
            tpKardinel = false
        end
    until FirstLeaderID == CurrentLeaderID
    if ESCAPEDCASTLE then
        return true
    end
end

function teleportOutCave()
    if IsNear("Kerberos", "CaveExit", 400) then
        local teleportPosOut = GetPosition("CrawlerExitKerberos")
        TeleportSettler(GetEntityId("Kerberos"), teleportPosOut.X,teleportPosOut.Y)
        Logic.SuspendEntity(GetEntityId("Kerberos"))
        ChangePlayer("Kerberos", 8)
        StartSimpleJob("checkForEverybody")
    end
    if IsNear("Bombard", "CaveExit", 400) then
        local teleportPosOut = GetPosition("CrawlerExit")
        TeleportSettler(GetEntityId("Bombard"), teleportPosOut.X, teleportPosOut.Y)
        ChangePlayer("Bombard", 8)
    end
    if IsNear("Scout", "CaveExit", 400) then
        local teleportPosOut = GetPosition("CrawlerExit")
        TeleportSettler(GetEntityId("Scout"), teleportPosOut.X, teleportPosOut.Y)
        ChangePlayer("Scout", 8)
    end
    local leaderIds = GetPlayerLeaderIds(1)
    for i = 1, table.getn(leaderIds) do
        local currentLeaderId = leaderIds[i]
        if currentLeaderId ~= 0 and IsNear(currentLeaderId, "CaveExit", 400) then
            local teleportPosOut = GetPosition("CrawlerExit")
            if currentLeaderId == GetEntityId("Kardinel") then
                DestroyEntity(GetEntityId("Kardinel"))
                DestroyEntity(GetEntityId("Feuerzahn"))
                ChangePlayer("Kardinel", 8)
            else
                Logic.SetEntityName(currentLeaderId, "BK" .. BKNUMBER)
                TeleportSettler(GetEntityId("BK" .. BKNUMBER), teleportPosOut.X, teleportPosOut.Y)
                ChangePlayer("BK" .. BKNUMBER, 8)
                BKNUMBER = BKNUMBER + 1
            end
        end
    end
    if ESCAPEDCASTLE then
        return true
    end
end

function initScoutNPC()
    local NPC = {
        name = "Scout",
        heroName = "Kerberos",
        callback = BriefingScout
    }
    CreateNPC(NPC)
end

function checkForEverybody()
    if AI.Player_GetNumberOfLeaders(1) == 0 then
        ESCAPEDCASTLE = true
        Logic.ResumeAllEntities()
        ChangePlayer("Kerberos",1)
        ChangePlayer("Kardinel",1)
        ChangePlayer("Scout",1)
        ChangePlayer("Bombard",1)
        for i = 0, BKNUMBER do
            ChangePlayer("BK"..i,1)
        end
        BriefingArriveOutside()
        return true
    end
end

function arriveOutside()
    Camera.ZoomSetFactorMax(1.75)
    local markerPos = GetPosition("CaveExit")
    GUI.DestroyMinimapPulse(markerPos.X,markerPos.Y)
    Explore.Hide("explCaveExit")
    local NPC = {
        name = "mayorAltea",
        callback = BriefingMayorAltea
    }
    createKardinel("CrawlerExitKardinel")
    CreateNPC(NPC)
    StartTimer()
    Waves()
    createBanditDefArmy()
    StartSimpleJob("checkForCompletion")
    --StartSimpleJob("checkForEscapedBK")
    StartSimpleJob("checkForSuedfang")
end

function initVillageEscapeQuest()
    GUIQuestTools.StartQuestInformation("Caravan", "", 1, 1)
    StartSimpleJob("checkForEscaped")
end

function checkForEscaped()
    GUIQuestTools.UpdateQuestInformationString(""..WORKERSESCAPED)
end

function initVillageEscape(_playerId)
    VILLAGESTATUS[_playerId] = 2
    for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(_playerId)) do
        Logic.SetCurrentMaxNumWorkersInBuilding(eID, 0)
    end

    ALIVEWORKERS[_playerId] = 0
    VILLAGEEMPTY[_playerId] = 0
    for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Worker),CEntityIterator.OfPlayerFilter(_playerId)) do
        ALIVEWORKERS[_playerId] = ALIVEWORKERS[_playerId] + 1
    end

    --Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "workersKilled" , 1, {}, {_playerId})

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "villageEmpty" , 1, {}, {_playerId})
end

function workersKilled(_playerId)
    if VILLAGEEMPTY[_playerId] == 1 then
        return true
    end
    if GetHealth(Event.GetEntityID()) <= 0 then
        ALIVEWORKERS[_playerId] = ALIVEWORKERS[_playerId] - 1
    end
end

function villageEmpty(_playerId)
    local villagerRemaining = 0
    for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Worker),CEntityIterator.OfPlayerFilter(_playerId)) do
        villagerRemaining = villagerRemaining + 1
    end
    if villagerRemaining == 0 then
        VILLAGEEMPTY[_playerId] = 1
        startEvacuation(_playerId)
        Message("Kardinel: Die Arbeiter sind versammelt wir können los!")
        return true
    end
end

function startEvacuation(_playerId)
    if _playerId == 2 then
        setupFleeingCaravan(_playerId, 1)
    elseif _playerId == 5 then
        setupFleeingCaravan(_playerId, 1)
    elseif _playerId == 6 then
        setupFleeingCaravan(_playerId, 1)
    end
end

function setupFleeingCaravan(_playerId, _currentWave)
    local amount = math.min(CARAVANWAVEAMOUNT,ALIVEWORKERS[_playerId])
    if ALIVEWORKERS[_playerId] == 0 then
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkRemainingCaravan" , 1, {}, {_playerId, _currentWave-1})
        return
    end
    ALIVEWORKERS[_playerId] = ALIVEWORKERS[_playerId] - amount
    for i = 1, amount do
        local position = {
            X = GetPosition("fleeingsp" .. _playerId).X + math.random(-100, 100),
            Y = GetPosition("fleeingsp" .. _playerId).Y + math.random(-100, 100)
        }
        local name = "fleeing" .. _currentWave .. _playerId .. i
        CreateMilitaryGroup(_playerId, Entities.PU_Travelling_Salesman, 0, position, name )
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlFleeingCaravan" , 1, {}, {name,_playerId,1})
    end
    initEnemyCaravanAttackers(_playerId)
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "waitForNextCaravan" , 1, {}, {_playerId,_currentWave})
end

function controlFleeingCaravan(_caravanName,_playerId,_currentPoint)
    if IsDead(_caravanName) then
        return true
    end
    if IsNear(_caravanName, "WorkerEscapePoint", 1000) then
        WORKERSESCAPED = WORKERSESCAPED + 1
        DestroyEntity(GetEntityId(_caravanName))
        return true
    end
    local currentWaypoint = WAYPOINTS[_playerId][_currentPoint]
    if IsNear(_caravanName, currentWaypoint, 1000) and currentWaypoint ~= "WorkerEscapePoint" then
        local nextPoint = _currentPoint + 1
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "waitForBreakCaravan" , 1, {}, {_caravanName,_playerId,nextPoint})
        return true
    end
    Move(_caravanName, currentWaypoint)
end

function initEnemyCaravanAttackers(_playerId)
    if _playerId == 7 then
        return
    end
    local amount = math.max(Difficulty + 8, math.floor(WORKERSESCAPED / math.max(1, 10 - Difficulty)))
    if _playerId == 2 then
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRestspots" , 1, {}, {_playerId, "FinsterwaldRight", amount, 1, "grave4", "grave5", "grave6"})
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRestspots" , 1, {}, {_playerId, "wellp3", amount, 0, "grave4", "grave5", "grave3"})
    elseif _playerId == 5 then
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRestspots" , 1, {}, {_playerId, "wellp1", amount, 1, "grave12",})
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRestspots" , 1, {}, {_playerId, "wellp2", amount, 0, "grave13",})
    elseif _playerId == 6 then
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRestspots" , 1, {}, {_playerId, "wellp4", amount, 1, "grave2"})
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkForRestspots" , 1, {}, {_playerId, "wellp5", amount, 0, "grave1"})
    end
end

function checkForRestspots(_playerId, _location, _amount, _specialSpawn, _enemySpawn1, _enemySpawn2, _enemySpawn3)
    if AreEntitiesInArea( _playerId, 0, GetPosition(_location), 1000, 1) then
        local _enemySpawns = 1
        if _enemySpawn3 ~= nil then
            _enemySpawns = 3
        end
        local amount = math.ceil(_amount/_enemySpawns)
        createArmyGrave(_enemySpawn1, amount)
        if _enemySpawns == 3 then
            createArmyGrave(_enemySpawn2, amount)
            createArmyGrave(_enemySpawn3, amount)
        end
        if _specialSpawn == 1 then
            if _playerId == 5 then
                createSpecialAttacker5()
            elseif _playerId == 6 then
                createSpecialAttacker6()
            else
                createSpecialAttacker2()
            end
        end
        return true
    end
end

function waitForBreakCaravan(_caravanName,_playerId,_currentPoint)
    if Counter.Tick2("waitForBreakCaravan" .. _caravanName .. _playerId .. _currentPoint,10) then
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlFleeingCaravan" , 1, {}, {_caravanName,_playerId,_currentPoint})
        return true
    end
end

function waitForNextCaravan(_playerId,_currentWave)
    if Counter.Tick2("waitForNextCaravan" .. _playerId .. _currentWave,260) then
        setupFleeingCaravan(_playerId,_currentWave + 1)
        return true
    end
end

function checkRemainingCaravan(_playerId,_lastWave)
    local playername = "Altea"
    if _playerId == 6 then
        playername = "Sonnspitz"
    elseif _playerId == 2 then
        playername = "Finsterwald"
    end
    for j = 1, CARAVANWAVEAMOUNT do
        if IsDead("fleeing" .. _lastWave .. _playerId .. j) == false then
            return false
        end
    end
    VILLAGESTATUS[_playerId] = 3
    Message("Kardinel: Alle Karavanen von " .. playername .. " sind angekommen.")
    if VILLAGESTATUS[2] == 3 and VILLAGESTATUS[5] == 3 and VILLAGESTATUS[6] == 3 then
        --TODO: Letzte Welle
    end
    return true
end

function mayorAlteaSpoken()
    VILLAGESTATUS[5] = 1
    Logic.SetShareExplorationWithPlayerFlag(1, 5, 1)
    for i = 1, 2 do
        ChangePlayer("merc" .. i, 1)
    end
    initVillageEscapeQuest()
    local NPC = {
        name = "mayorSonnspitz",
        callback = BriefingMayorSonnspitz
    }
    CreateNPC(NPC)
    GUI.CreateMinimapMarker(GetPosition("spvillage2").X,GetPosition("spvillage2").Y,2)
	Explore.Show("expl1", "spvillage2", 1000)
    local NPC = {
        name = "mayorFinsterwald",
        callback = BriefingMayorFinsterwald
    }
    CreateNPC(NPC)
    GUI.CreateMinimapMarker(GetPosition("sp3village").X,GetPosition("sp3village").Y,2)
	Explore.Show("expl2", "sp3village", 1000)
    local NPC = {
        name = "mayorAltea",
        callback = BriefingAlteaEscape
    }
    CreateNPC(NPC)
    GUI.CreateMinimapMarker(GetPosition("WorkerEscapePoint").X,GetPosition("WorkerEscapePoint").Y,2)
	Explore.Show("explEscape", "WorkerEscapePoint", 1000)
    BANDITQUESTSTARTED = true
    GUI.CreateMinimapMarker(GetPosition("banditSpawn").X,GetPosition("banditSpawn").Y,2)
	Explore.Show("explBandits", "banditSpawn", 1500)
end

function mayorSonnspitzSpoken()
    VILLAGESTATUS[6] = 1
    Logic.SetShareExplorationWithPlayerFlag(1, 6, 1)
    ChangePlayer("merc7",1)
    ChangePlayer("lighthouse",1)
    local NPC = {
        name = "mayorSonnspitz",
        callback = BriefingSonnspitzEscape
    }
    CreateNPC(NPC)
end

function mayorFinsterwaldSpoken()
    VILLAGESTATUS[2] = 1
    Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
    ChangePlayer("merc6", 1)
    local NPC = {
        name = "mayorFinsterwald",
        callback = BriefingFinsterwaldEscape
    }
    CreateNPC(NPC)
end

function checkForSuedfang()
    if WORKERSESCAPED >= 15 * Difficulty + 50 then
        BriefingSuedfang()
        VILLAGESTATUS[7] = 1
        Logic.SetShareExplorationWithPlayerFlag(1, 7, 1)
        for i = 3, 5 do
            ChangePlayer("merc" .. i, 1)
        end
        ChangePlayer("archertower", 1)
        return true
    end
end

function checkForEscapedBK()
    if IsNear("Kerberos", "WorkerEscapePoint", 400) then
        DestroyEntity(GetEntityId("Kerberos"))
        KERBEROSESCAPED = true
    end
    local FirstLeaderID = Logic.GetNextLeader(1, 0)
    local CurrentLeaderID = FirstLeaderID
    repeat
        if CurrentLeaderID ~= 0 then
        if IsNear(CurrentLeaderID, "WorkerEscapePoint", 400) then
            if CurrentLeaderID == GetEntityId("Kardinel") then
                DestroyEntity(GetEntityId("Kardinel"))
                DestroyEntity(GetEntityId("Feuerzahn"))
                GDB.SetString("FmFKardinel","1")
                else
                    BKESCAPED = BKESCAPED + Logic.GetNumberOfSoldiers(CurrentLeaderID) + 1
                    Logic.DestroyGroupByLeader(CurrentLeaderID)
                end
            end
        end
        CurrentLeaderID = Logic.GetNextLeader(1,CurrentLeaderID)
    until FirstLeaderID == CurrentLeaderID
end

function checkForCompletion()
    if AI.Player_GetNumberOfLeaders(1) == 0 then
        if KERBEROSESCAPED == true then
            GDB.SetString("FmFEscaped", WORKERSESCAPED)
            GDB.SetString("FmFBK", BKESCAPED)
            BriefingVictory()
            return true
        end
        BriefingDefeat()
        return true
    end
end