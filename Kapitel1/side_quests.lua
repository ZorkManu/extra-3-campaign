function initSmithQuest()
    local NPC = {
        name = "smith",
        heroName = "Varg",
        callback = BriefingSmith
    }
    CreateNPC(NPC)
end

function smithTribute()
    local tribute = {
        playerId = 1,
        text = "Gebt dem Schmied ".. 300*Difficulty .. " Eisen, damit er Eure Rüstung verstärkt",
        cost = {Iron = 300*Difficulty},
        Callback = function ()
            ResearchTechnology(Technologies.T_ChainMailArmor)
        end
    }

    IRONTRIBUTE = AddTribute(tribute)
end

function initSilverQuest()
    StartSimpleJob("IsNearSilverSmith")
end

function IsNearSilverSmith()
    if IsNear("Varg", "silversmith", 3000) then
        BriefingSilverSmith()
        return true
    end
end

function initSilverNPC()
    local NPC = {
        name = "exbarbarian",
        heroName = "Varg",
        callback = BriefingSilverNPC
    }
    CreateNPC(NPC)
end

function silverTribute()
    local tribute = {
        playerId = 1,
        text = "Gebt dem alten Barbar ".. 4000*Difficulty .. " Taler, damit er Euch 200 Silber überlässt.",
        cost = {Gold = 4000*Difficulty},
        Callback = function ()
            Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 200)
            DestroyEntity(GetEntityId("exbarbarian"))
            Message("War mir eine Freude mit dir Geschäfte zu machen. Ich bin dann mal weg!")
        end
    }

    SILVERTRIBUTE = AddTribute(tribute)
end

function lighthouseNPC()
    CreateMilitaryGroup(8, Entities.PU_LeaderBow4, 0, GetPosition("bowSpawn"), "bowLighthouse")
    StartSimpleJob("moveLighthouseNPC")
end

function moveLighthouseNPC()
    Move("bowLighthouse",GetPosition("def13"))
    if IsNear("bowLighthouse","def13",200) then
        local NPC = {
            name = "bowLighthouse",
            callback = BriefingLighthouse
        }
        CreateNPC(NPC)
        return true
    end
end

function checkForLighthouse()
    if AreEntitiesInArea( 1, 0, GetPosition("nvspawn2"), 1000, 1) then
        ChangePlayer("lighthouse",1)
        AI.Entity_CreateFormation(1, Entities.PU_LeaderBow4, nil, 12, GetPosition("lighthouseSpawn").X, GetPosition("lighthouseSpawn").Y, GetPosition("nvspawn2").X*100, GetPosition("nvspawn2").Y*100, 3, 0)
        AI.Entity_CreateFormation(1, Entities.PU_LeaderSword4, nil, 12, GetPosition("lighthouseSpawn").X, GetPosition("lighthouseSpawn").Y, GetPosition("nvspawn2").X*100, GetPosition("nvspawn2").Y*100, 3, 0)
        Message("Leuchtturmwächter: Danke für die Rettung Lady Yuki!")
        StartCountdown(5, function ()
            Message("Varg: Pah, ihr Feiglinge versteckt euch in einem kleinen Hinterzimmer, während der Kampf vor eurer Tür wütet.")
        end, false)
        StartCountdown(10, function ()
            Message("Leuchtturmwächter: Vor Euch Barbarenabschaum müssen wir uns nicht rechtfertigen.")
        end, false)
        StartCountdown(15, function ()
            Message("Yuki: Nein, nein er hat schon Recht. Ich glaube nachdem wir hier fertig sind, habt ihr etwas Spezialtraining verdient.")
        end, false)
        StartCountdown(20, function ()
            Message("Leuchtturmwächter: *zittert sichtlich*")
        end, false)
        return true
    end
end

function initBoatsmanQuest()
    local boatsman = Logic.CreateEntity( Entities.CU_Hermit, GetPosition("boatsmanSpawn").X, GetPosition("boatsmanSpawn").Y, 275, 8 )
    SetEntityName(boatsman,"boatsman")
    local NPC = {
        name = "boatsman",
        callback = BriefingBoatsman
    }
    CreateNPC(NPC)
    return true
end

function initCrossingTribute()
    local tribute = {
        playerId = 1,
        text = "Gebt dem Fährmann 1000 Taler für eine Überfahrt am Tag.",
        cost = {Gold = 1000},
        Callback = function ()
            StartSimpleJob("checkForCrossing")
        end
    }
    AddTribute(tribute)
end

function checkForCrossing()
    if DAYORNIGHT == "day" then
        for i = 1, 4 do
            AI.Entity_CreateFormation(1, Entities.PU_Serf, nil, 0, GetPosition("serfSpawnIsland").X, GetPosition("serfSpawnIsland").Y, GetPosition("armyStart").X*100, GetPosition("armyStart").Y*100, 3, 0)
        end
        return true
    end
end

function uprisingQuestMotivationCheck()
    if Logic.GetAverageMotivation(1) < 1 then
        uprisingQuest()
        return true
    end
end

function uprisingQuest()
    Message("wütender Landarbeiter: Erst lasst Ihr diese Wilden hinter unsere Mauern und dann behandelt Ihr uns wie Dreck! Das machen wir nicht mehr mit!")
    ChangePlayer("villageHallP2",6)
    createArmyUprising()
end