MINIGAME_END = false
DIRECTIONS = {}

function startErebosMinigame()
    SetFriendly(1,8)
    StartSimpleJob("findDestroyedVillage")
    StartSimpleJob("firstCave")
    StartSimpleJob("nvVillage")
    StartSimpleJob("secondCave")
    StartSimpleJob("thirdCave")
    StartSimpleJob("finalCaves")
    CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("passerepos1"), "e1")
    StartSimpleJob("controlE1")
    CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("sidebaseerepos1"), "e2")
    CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("sidebaseerepos5"), "e3")
    StartSimpleJob("controlE23")
    CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("eredreieck1"), "e4")
    StartSimpleJob("controlE4")
    CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("ereRun1"), "e5")
    StartSimpleJob("controlE5")
    CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("ereBack1"), "e6")
    StartSimpleJob("controlE6")
    for i = 1, 5 do
        CreateMilitaryGroup(8, Entities.PU_Hero14, 0, GetPosition("erebosStand"..i), "e" .. 6+i)
    end
    StartSimpleJob("supriseErebos")
    StartSimpleJob("checkForRudger")
end

function findDestroyedVillage()
    if IsNear("Rudger", "destroyedVillage", 1500) then
        Message("Wie sieht das denn hier aus? Zerstörte Gebäude und Tierleichen. Mein treues Ross ich wittere Gefahr. Lass uns mit dieser Mission in die Geschichte eingehen!")
        return true
    end
end

function firstCave()
    if IsNear("Rudger", "checkScout8", 1080) then
        createNVArmyMountains(1, "NVCave1")
        Message("Ich schätze ich bin doch nicht allein hier! Keine Zeit fürs Kämpfen los weiter jetzt.")
        return true
    end
end

function nvVillage()
    if IsNear("Rudger", "checkScout15", 600) then
        createNVArmyMountains(2, "nvdorfspawn")
        return true
    end
end

function secondCave()
    if IsNear("Rudger", "checkScout6", 300) or IsNear("Rudger", "checkScout7", 300) then
        createNVArmyMountains(3, "NVCave2")
        return true
    end
end

function thirdCave()
    if IsNear("Rudger", "checkScout1", 150) or IsNear("Rudger", "checkScout2", 150) or IsNear("Rudger", "checkScout3", 150) or IsNear("Rudger", "checkScout4", 150) or IsNear("Rudger", "checkScout5", 150) then
        createNVArmyMountains(4, "NVCave3")
        return true
    end
end

function finalCaves()
    if IsNear("Rudger", "checkScout12", 200) or IsNear("Rudger", "checkScout13", 200) or IsNear("Rudger", "checkScout14", 200) then
        createNVArmyMountains(4, "NVCave4")
        createNVArmyMountains(5, "NVCave5")
        return true
    end
end

function controlE1()
    if MINIGAME_END then
        return true
    end
    if Counter.Tick2("controlE1", 5) then
        if IsNear("e1", "passerepos1", 100) then
            Move("e1", "passerepos2")
        elseif IsNear("e1", "passerepos2", 100) then
            Move("e1", "passerepos1")
        end
    end
end

function controlE23()
    if MINIGAME_END then
        return true
    end
    for i = 2, 3 do
        for j = 1,6 do
            if IsNear("e"..i, "sidebaseerepos" .. j, 100) then
                local newPos = j + 1
                if j == 6 then
                    newPos = 1
                end
                Move("e"..i, "sidebaseerepos" .. newPos)
            end
        end 
    end
end

function controlE4()
    if MINIGAME_END then
        return true
    end
    for i = 1, 3 do
        if IsNear("e4", "eredreieck" .. i, 100) then
            local newPos = i + 1
            if i == 3 then
                newPos = 1
            end
            Move("e4", "eredreieck" .. newPos)
        end
    end
end

function controlE5()
    if MINIGAME_END then
        return true
    end
    for i = 1, 4 do
        if IsNear("e5", "ereRun" .. i, 100) then
            local newPos
            if i == 4 then
                DIRECTIONS[5] = false
            elseif i == 1 then
                DIRECTIONS[5] = true
            end
            if DIRECTIONS[5] then
                newPos = i + 1
            else
                newPos = i - 1
            end
            Move("e5", "ereRun" .. newPos)
        end
    end
end

function controlE6()
    if MINIGAME_END then
        return true
    end
    for i = 1, 5 do
        if IsNear("e6", "ereBack" .. i, 100) then
            local newPos
            if i == 5 then
                DIRECTIONS[5] = false
            elseif i == 1 then
                DIRECTIONS[5] = true
            end
            if DIRECTIONS[5] then
                newPos = i + 1
            else
                newPos = i - 1
            end
            Move("e6", "ereBack" .. newPos)
        end
    end
end

function supriseErebos()
    if IsNear("Rudger", "checkScout10", 150) or IsNear("Rudger", "checkScout11", 150) or IsNear("Rudger", "checkScout9", 150) then
        StartSimpleJob("controlE9")
        return true
    end
end

function controlE9()
    if IsNear("e9", "erebosStand3", 100) then
        Move("e9", "erezick1")
        return false
    end
    for i = 1, 7 do
        if IsNear("e9", "erezick" .. i, 100) then
            if i == 7 then
                return true
            end
            Move("e9", "erezick"..i+1)
        end
    end
end

function checkForRudger()
    for i = 1, 5 do
        if IsNear("Rudger", "scoutEscape" .. i, 600) then
            MINIGAME_END = true
            BriefingMountainPassed()
            MakeInvulnerable(GetEntityId("Rudger"))
            return true
        end
    end
    if IsDead("Rudger") then
        MINIGAME_END = true
        Message("Ihr habt Rudger verloren, es wird keine Verstärkung geben.")
        return true
    end
end