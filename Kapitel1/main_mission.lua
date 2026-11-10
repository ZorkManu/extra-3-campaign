NEVASSA_REACHED = false
NEVASSA_TAKEN = false

function pillageMinesQuest()
    GUI.CreateMinimapMarker(GetPosition("mine1").X,GetPosition("mine1").Y,2)
	Explore.Show("explm1", "mine1", 3000)
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkM" , 1, {}, {1})
	GUI.CreateMinimapMarker(GetPosition("mine2").X,GetPosition("mine2").Y,2)
	Explore.Show("explm2", "mine2", 3000)
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkM" , 1, {}, {2})
	GUI.CreateMinimapMarker(GetPosition("mine3").X,GetPosition("mine3").Y,2)
	Explore.Show("explm3", "mine3", 3000)
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "checkM" , 1, {}, {3})
end

function checkM(_position)
    if IsDead("mine" .. _position) then
        GUI.DestroyMinimapPulse(GetPosition("mine" .. _position).X,GetPosition("mine" .. _position).Y)
        Explore.Hide("explm" .. _position)
        return true
    end
end

function beginInvadeNevassa()
    StartSimpleJob("checkInRange")
    CreateMilitaryGroup(2, Entities.PU_Hero11, 0, GetPosition("defYuki"), "Yuki")
    initDefenderArmies()
end

function checkInRange()
    if AreEnemiesInArea( 2, GetPosition("defYuki"), 6000) then
        BriefingDefenseNevassa()
        Explore.Show("battlefield", "exploreDef", 6000)
        return true
    end
end

function timerIslandAttack()
    if NEVASSA_REACHED then
        return true
    end
    if Counter.Tick2("timerIslandAttack", 300) then
        Defeat()
        return true
    end
end

function islandAttacker()
    MapEditor_SetupAI(3, 3, 10000, 3, "gdefspawn2", 0, 0)
    SetupPlayerAi( 3, {} )
    for i = 3, 6 do
        ResearchTechnology(Technologies.T_SilverSwords,i)
        ResearchTechnology(Technologies.T_SilverPlateArmor,i)
        ResearchTechnology(Technologies.T_SilverArrows,i)
        ResearchTechnology(Technologies.T_SilverArcherArmor,i)
        ResearchTechnology(Technologies.T_SilverLance,i)
        ResearchTechnology(Technologies.T_SilverBullets,i)
        if Difficulty >= 2 then
            ResearchTechnology(Technologies.T_EnhancedGunPowder,6)
            ResearchTechnology(Technologies.T_FleeceArmor,i)
            ResearchTechnology(Technologies.T_BodkinArrow,i)
            ResearchTechnology(Technologies.T_SoftArcherArmor,i)
            ResearchTechnology(Technologies.T_ChainMailArmor,i)
            ResearchTechnology(Technologies.T_Turnery,i)
            if Difficulty == 3 then
                ResearchTechnology(Technologies.T_LeatherMailArmor,i)
                ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
                ResearchTechnology(Technologies.T_MasterOfSmithery,i)
            end
        end
    end
    MapEditor_SetupAI(4, 3, 10000, 1, "nvspawn1", 0, 0)
    SetupPlayerAi( 4, {} )
    initGhostSpawnerIsland()
    SetHostile(1,3)
    Explore.Show("explreeinf", "ghostreeinf4", 3000)
    Camera.ScrollSetLookAt(GetPosition("ghostreeinf4").X, GetPosition("ghostreeinf4").Y)
    Message("Varg: Was ist da denn los? Zurück gehts wohl nicht mehr. Also immer nach vorne!")
    DestroyEntity(GetEntityId("smith"))
end

function checkForDefenders()
    if IsDead("Yuki") and AI.Player_GetNumberOfLeaders(2) == 1 then
        startTownFight()
        return true
    end
end

function startTownFight()
    DestroyEntity(GetEntityId("Yuki"))
    CreateMilitaryGroup(2, Entities.PU_Hero11, 0, GetPosition("defYuki"), "Yuki")
    MapEditor_SetupAI(7, 3, 10000, 3, "sulfurBase", 0, 0)
    SetupPlayerAi( 7, {} )
	--MapEditor_Armies[7].description.rebuild.delay = 9999999
    MapEditor_Armies[7].offensiveArmies.strength = 0
    MapEditor_Armies[7].defensiveArmies.strength = 6 - Difficulty
    table.insert(MapEditor_Armies[7].ForbiddenTypes, UpgradeCategories.LeaderBow)
    Explore.Hide("battlefield")
    SetNeutral(1,2)
    SetHostile(2,3)
    SetHostile(1,4)
    SetHostile(1,5)
    SetHostile(3,7)
    SetPlayerName(3, "Geistertruppen")
    SetPlayerName(5, "Nebelvolk")
    SetPlayerName(6, "???")
    SetPlayerName(7, "Verbündete")
    DestroyEntity(GetEntityId("southGate1"))
    DestroyEntity(GetEntityId("southGate2"))
    Logic.CreateEntity( Entities.XD_WallStraightGate, 27500, 27700, 45, 0 )
    Logic.CreateEntity( Entities.XD_WallStraightGate, 27100, 28100, 45, 0 )
    initEnemyDefenderArmies()
    createTownAttacker()
    createTownDefender()
    BriefingInvasionWon()
    Logic.RemoveTribute(1,SILVERTRIBUTE)
    Logic.RemoveTribute(1,IRONTRIBUTE)
    StartSimpleJob("reachNevassa")
    StartSimpleJob("checkForAttackers")
end

function reachNevassa()
    if AreEnemiesInArea(4, GetPosition("southEntrance"), 1000) then
        Message("Varg: Was sind das für Truppen? Hey, die Stadtschätze sind Unser, verzieht Euch!")
        Explore.Show("town","exploreTown",8000)
        return true
    end
end

function checkForAttackers()
    if ATTACKER_KILLED >= 4 then
        endTownFight()
        return true
    end
end

function endTownFight()
    SetHostile(1,6)
    SetFriendly(1,2)
    local yukipos = GetPosition("Yuki")
    DestroyEntity(GetEntityId("Yuki"))
    CreateMilitaryGroup(2, Entities.PU_Hero11, 0, yukipos, "Yuki")
    Explore.Hide("explreeinf")
    Logic.ChangeAllEntitiesPlayerID(2, 1)
    Logic.SetShareExplorationWithPlayerFlag(1, 7, 1)
    GUI.CreateMinimapMarker(GetPosition("sulfurBase").X,GetPosition("sulfurBase").Y,2)
    SetFriendly(1,7)
    ResearchTechnology(Technologies.GT_Construction, 1)
    ResearchTechnology(Technologies.GT_GearWheel, 1)
    ResearchTechnology(Technologies.GT_Literacy, 1)
    ResearchTechnology(Technologies.GT_Trading, 1)
    ResearchTechnology(Technologies.GT_Mercenaries, 1)
    ResearchTechnology(Technologies.GT_StandingArmy, 1)
    ResearchTechnology(Technologies.GT_Tactics, 1)
    ResearchTechnology(Technologies.T_UpgradeSword1)
    ResearchTechnology(Technologies.T_UpgradeSword2)
    ResearchTechnology(Technologies.T_UpgradeBow1)
    ResearchTechnology(Technologies.T_UpgradeBow2)
    AddPeriodicSummer(CYCLELENGTH)
    createOneTimeGhostAttacker()
    BriefingEndTownFight()
    CreateNPC {
        name = "alchemist",
        callback = BriefingSulfurBase,
    }
    initErebos()
    StartSimpleJob("checkForLighthouse")
    lighthouseNPC()
    initBoatsmanQuest()
    StartSimpleJob("uprisingQuestMotivationCheck")
end

function startGhostJobs()
    StartSimpleJob("checkForNight")
    StartSimpleJob("killGhosts")
end

function initErebos()
    for i = 1, 5 do
        ChangePlayer("ere"..i,2)
        Logic.GroupStand(GetEntityId("ere" .. i))
    end
    --StartSimpleJob("checkNVEntrance")
    StartSimpleJob("checkErebos")
end

function checkNVEntrance()
    if AreEnemiesInArea(5,GetPosition("nventrance"),1500) then
        local wtype = Logic.GetWeatherState()
        Logic.AddWeatherElement(wtype, 9999, 0, NighttimeGFXSets[wtype][math.random(1, table.getn(NighttimeGFXSets[wtype]))], 5, 15)
        Message("Varg: Warum wird es auf einmal Nacht? Dabei Dabei ist es erst 12 Uhr Mittags!")
        return true
    end
end

function checkErebos()
    for i = 1, 5 do
        if AreEnemiesInArea(5,GetPosition("ere" .. i),1500) then
            Message("Yuki: Besser nähern wir uns dem nicht in der Nacht, der tötet dann alles was ihm in die Quere kommt.")
            return true
        end
    end
end

function churchQuest()
    for i = 4, 9 do
        initNVAttackSpawner(i, "nv" .. i)
    end
    MapEditor_Armies[6].offensiveArmies.strength = 8 + Difficulty*3
    MapEditor_Armies[6].defensiveArmies.strength = 12 + Difficulty*3
    Logic.ChangeAllEntitiesPlayerID(7, 1)
    StartSimpleJob("checkForGrid")
    StartSimpleJob("checkKey")
    CreateNPC {
        name = "monk",
        callback = BriefingMonk,
    }
end

function checkForGrid()
    if IsNear("Yuki","grid1",1000) or IsNear("Varg","grid1",1000) then
        if IsDead("nv7") then
            DestroyEntity(GetEntityId("grid1"))
            DestroyEntity(GetEntityId("grid2"))
            return true
        end
        Message("Yuki: Abgeschlossen. Das verspricht ein lustiges Suchspiel. Lasst uns in der Basis des Nebelvolks anfangen")
        StartCountdown(30, function ()
            StartSimpleJob("checkForGrid")
        end, false)
        return true
    end
end

function checkKey()
    if IsDead("nv7") then
        Message("Varg: Da liegt ein Schlüssel unter der Kirchenruine!")
        return true
    end
end

function checkAlchemistMove()
    if IsNear("alchemist", "alchemistMove", 1000) then
        CreateNPC {
            name = "alchemist",
            callback = BriefingAlchemist,
        }
        return true
    end
end

function monasteryDefense()
    ChangePlayer("villagecenter",1)
    ChangePlayer("monastery",1)
    ChangePlayer("beautification",1)
    ChangePlayer("farm",1)
    ChangePlayer("residence",1)
    ChangePlayer("tower1",1)
    ChangePlayer("tower2",1)
    StartCountdown(600,monasteryDefenseSuccess,true)
    summonFirstWave()
    StartCountdown(60,summonSecondWave,false)
    StartCountdown(120,summonThirdWave,false)
    StartCountdown(180,summonFourthWave,false)
    StartCountdown(240,summonFifthWave,false)
    StartCountdown(300,summonSixthWave,false)
    StartCountdown(360,summonSeventhWave,false)
    StartCountdown(420,summonEighthWave,false)
    StartCountdown(480,summonNinthWave,false)
    StartCountdown(540,summonTenthWave,false)

    StartSimpleJob("checkForMonastery")
end

function checkForMonastery()
    if IsDead("monastery") then
        Defeat()
        return true
    end
end

function monasteryDefenseSuccess()
    BriefingDefenseSuccess()
    AddPeriodicNight(999999)
    StartSimpleJob("checkForFinalTribute")
    StartSimpleJob("checkAlchemistMove")
    GUI.CreateMinimapMarker(GetPosition("p6hq").X,GetPosition("p6hq").Y,2)
end

function checkForFinalTribute()
    if IsDead("wall1") then
        for i = 1, 5 do
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "erebosMove" , 1, {}, {i})
        end
        Logic.SetShareExplorationWithPlayerFlag(1,2,1)
        return true
    end
end

function erebosMove(_id)
    --if IsNear("ere".. _id, "eresummon".. _id, 300) then
        --return true
    --end
    Move("ere".._id,"eresummon".._id)
end

function TributeEndgameBarrier()
    local Tribute = {
        playerId = 1,
        text = "Zahlt 2000 Schwefel um die Barrikade in die Luft zu sprengen",
        cost = {
            Sulfur = 2000
        },
        Callback = CallbackEndgameTribute
    }

    AddTribute(Tribute)
end

function CallbackEndgameTribute()
    for i = 1, 3 do
        Logic.CreateEffect(GGL_Effects.FXExplosion, GetPosition("wall" .. i).X, GetPosition("wall" .. i).Y, 1)
        DestroyEntity("wall" .. i)
    end
    Sound.PlayGUISound( Sounds.Military_SO_Cannon_rnd_1 , 100 )
    StartSimpleJob("victoryCondition")
end

function victoryCondition()
    if Counter.Tick2("victoryCondition",10) then
        if AI.Player_GetNumberOfLeaders(6) == 0 and IsDead("p6hq") then
            BriefingMaryDestroyed()
            GUI.DestroyMinimapPulse(GetPosition("p6hq").X,GetPosition("p6hq").Y,2)
            return true
        end
    end
end

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