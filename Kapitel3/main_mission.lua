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
        StartCountdown(220, createSpawnerNearBaseAdvance, false)
        StartCountdown(300, createSpawnerStoneAdvance, false)
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