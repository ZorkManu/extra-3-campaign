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

    AddTribute(tribute)
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
        text = "Gebt dem alten Barbar ".. 5000*Difficulty .. " Taler, damit er Euch 200 Silber überlässt.",
        cost = {Gold = 5000*Difficulty},
        Callback = function ()
            Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 200)
            DestroyEntity(GetEntityId("exbarbarian"))
            Message("War mir eine Freude mit dir Geschäfte zu machen. Ich bin dann mal weg!")
        end
    }

    AddTribute(tribute)
end