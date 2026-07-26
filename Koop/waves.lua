BOSSWAVES = {
    1200, --FirstNVWave
    2400, --Erebos + Necros + Trolls
    3600, --AttackOnTown
    5100, --FALLEN HEROES
}

BREAK = {
    1800,
    3000,
    4200
}

PLAYERWAYPOINTS = {
    {"p1move1","p1move2","p1move3","spvillage1","p1bow2","p1bow1"},
    {"p2move1","p2move2","attackSonnspitzLeft","village2","attackSonnspitzRight1"},
    {"p3hcav1","p3hcav2","FinsterwaldInnerLeft","FinsterWaldInnerRight","sp3village"},
    {"towndefpoint2","towndefmiddle","townleftdef","townmiddle","towndefpoint3"}
}

NVACTIVE = 0
SPECIALSACTIVE = 0

EREBOSID = 1
EREBOSPOS = {}
NECROID = 1
NECROPOS = {}

BOSSFIGHT2 = false
BOSSFIGHT3 = false
BOSSFIGHT4 = false

function Waves()
    if TICK == BOSSWAVES[3] - 120 then
        local player4name = XNetwork.GameInformation_GetLogicPlayerUserName(4)
        if player4name == '' then
            player4name = 'die Festungsstadt'
        end
        Message( "@color:255,0,0 Warnung, ein Großangriff auf " .. player4name .. " steht kurz bevor!" );
        if fourthplayeractive ~= 1 then
            Message("Die Festungstadt stellt euch Dorfhallen zur Verfügung!")
            ChangePlayer("vh1",1)
            ChangePlayer("vh2",2)
            ChangePlayer("vh3",3)
            ChangePlayer("serf1",1)
            ChangePlayer("serf2",2)
            ChangePlayer("serf3",3)
        end
    end
    if TICK == BOSSWAVES[2] then
        Message("Die Dorfhallen sind nun zum Verkauf erhältlich!")
        TributeVillageHalls()
    end
    if (TICK ~= 0) and (TICK < BOSSWAVES[1]) or (TICK < BOSSWAVES[2] and TICK > BREAK[1]) or (TICK < BOSSWAVES[3] and TICK > BREAK[2]) or (TICK > BREAK[3]) then
        WavesP1()
        WavesP2()
        WavesP3()
        if fourthplayeractive == 1 then
            WavesP4()
        end
    end
    if TICK == BOSSWAVES[1] then
        createNVBossWave1()
        createNVBossWave2()
        createNVBossWave3()
        createNVBossWave4()
        NVACTIVE = 1
    elseif TICK == BOSSWAVES[2] then
        local wtype = Logic.GetWeatherState()
        Logic.AddWeatherElement(wtype, 300, 0, NighttimeGFXSets[wtype][1], 5, 15)
        createSpecialUnitBossWave1()
        createSpecialUnitBossWave2()
        createSpecialUnitBossWave3()
        createSpecialUnitBossWave4()
        SPECIALSACTIVE = 1
        BOSSFIGHT2 = true
        Sound.StartMusic( LocalMusic.MusicPath .. LocalMusic.Bossfight2[1][1], LocalMusic.Bossfight2[1][2])
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "tickBossCounter" , 1, {}, {2})
    elseif TICK == BOSSWAVES[3] then
        Display.GfxSetSetLightParams(30,  0.0, 1.0, 40, -15, -50,  120,90,80,  81,21,21)
        Display.GfxSetSetFogParams(30, 0.0, 1.0, 1, 95,82,92, 3500,32000)
        local wtype = Logic.GetWeatherState()
        Logic.AddWeatherElement(wtype, 362, 0, 30, 5, 15)
        createNVWaveP4()
        createTownBossWave()
        BOSSFIGHT3 = true
        Sound.StartMusic( LocalMusic.MusicPath .. LocalMusic.Bossfight3[1][1], LocalMusic.Bossfight3[1][2])
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "tickBossCounter" , 1, {}, {3})
    elseif TICK == BOSSWAVES[4] then
        Display.GfxSetSetLightParams(30,  0.0, 1.0, 40, -15, -50,  30,60,90,  20,60,81)
        Display.GfxSetSetFogParams(30, 0.0, 1.0, 1, 50,62,92, 3500,32000)
        local wtype = Logic.GetWeatherState()
        Logic.AddWeatherElement(wtype, 364, 0, 30, 5, 15)
        BOSSFIGHT4 = true
        Sound.StartMusic( LocalMusic.MusicPath .. LocalMusic.Bossfight4[1][1], LocalMusic.Bossfight4[1][2])
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "tickBossCounter" , 1, {}, {4})
        createLastBossWave()
        return true
    elseif TICK >= 5350 then
        return true
    end
end

function WavesP1()
    if Modulo(math.max(1,TICK-15),300-Difficulties[1]*30) == 0 then
        if SPECIALSACTIVE == 1 then
            for i = 1, Difficulties[1] do
                if math.random(1,6) == 6 then
                    createNecro(1)
                end
                if math.random(1,12) == 6 then
                    createTroll(1)
                end
            end
        end
        if NVACTIVE == 1 then
            createNVWaveP1()
        end
        local amount = math.ceil(TICK*Difficulties[1]/500) + PLAYERFIVEMULT + Difficulties[1] * 2
        local firstAmount = math.random(1,amount)
        createGhostWaveP1Graveyard(firstAmount)
        createGhostWaveP1Grave(amount - firstAmount)
    end
end

function WavesP2()
    if Modulo(math.max(1,TICK-5),300-Difficulties[2]*30) == 0 then
        if SPECIALSACTIVE == 1 then
            for i = 1, Difficulties[2] do
                if math.random(1,6) == 6 then
                    createNecro(2)
                end
                if math.random(1,12) == 6 then
                    createTroll(2)
                end
            end
        end
        if NVACTIVE == 1 then
            createNVWaveP2()
        end
        local amount = math.ceil(TICK*Difficulties[2]/500) + PLAYERFIVEMULT + Difficulties[2] * 2
        local firstAmount = math.random(1,amount)
        createGhostWaveP2Graveyard(firstAmount)
        createGhostWaveP2Graveyard2(amount - firstAmount)
    end
end

function WavesP3()
    if Modulo(math.max(1,TICK+15),300-Difficulties[3]*30) == 0 then
        if SPECIALSACTIVE == 1 then
            for i = 1, Difficulties[3] do
                if math.random(1,6) == 6 then
                    createNecro(3)
                end
                if math.random(1,12) == 6 then
                    createTroll(3)
                end
            end
        end
        if NVACTIVE == 1 then
            createNVWaveP3()
        end
        local amount = math.ceil(TICK*Difficulties[3]/500) + PLAYERFIVEMULT + Difficulties[3] * 2
        local firstAmount = math.random(1,amount)
        createGhostWaveP3Graveyard(firstAmount)
        createGhostWaveP3Grave(amount - firstAmount)
    end
end

function WavesP4()
    if Modulo(math.max(1,TICK-30),300-Difficulties[4]*30) == 0 then
        if SPECIALSACTIVE == 1 then
            for i = 1, Difficulties[4] do
                if math.random(1,6) == 6 then
                    createNecro(4)
                end
                if math.random(1,12) == 6 then
                    createTroll(4)
                end
            end
        end
        if NVACTIVE == 1 then
            createNVWaveP4()
        end
        local amount = math.ceil(TICK*Difficulties[4]/500) + PLAYERFIVEMULT + Difficulties[4] * 2
        local firstAmount = math.random(1,amount)
        createGhostWaveP4Graveyard(firstAmount)
        if amount - firstAmount > 0 then
            local secondAmount = math.random(1,amount - firstAmount)
            createGhostWaveP4Grave1(secondAmount)
            createGhostWaveP4Grave2(amount - (firstAmount + secondAmount))
        end
    end
end

function createGhostWaveP1Graveyard(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("graveyard13"), 2)
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("attackAlteaRight"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("attackAlteaMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("spvillage1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createGhostWaveP1Grave(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("grave12"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("attackAlteaLeft1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("spvillage1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVWaveP1()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, math.ceil(TICK*(Difficulties[1])/6000) do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn3"), 2)
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("attackAlteaRight"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("attackAlteaMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("spvillage1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVBossWave1()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulties[1] + 3 do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn3"), 2)
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("attackAlteaRight"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("attackAlteaMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("spvillage1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createSpecialUnitBossWave1()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    local pos = GetPosition("nvspawn3")
    local randomName = "troll" .. math.random(1,100000)
    CreateMilitaryGroup(7,Entities.CU_Evil_Troll1,0, pos, randomName)
    SetEntitySize(GetEntityId(randomName), 5)
    waveArmy:AddLeader(GetEntityId(randomName))
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("attackAlteaRight"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("attackAlteaMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("spvillage1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)

    for i = 1, Difficulties[1] do
        createErebos(1)
        createNecro(1)
    end
end

function createGhostWaveP2Graveyard(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("graveyard14"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("attackSonnspitzLeft"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("village2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createGhostWaveP2Graveyard2(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("graveyard21"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("attackSonnspitzRight1"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("village2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVWaveP2()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, math.ceil(TICK*(Difficulties[2])/6000) do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn2"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("attackSonnspitzLeft"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("village2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVBossWave2()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulties[2] + 3 do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn2"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("attackSonnspitzLeft"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("village2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createSpecialUnitBossWave2()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    local pos = GetPosition("nvspawn2")
    local randomName = "troll" .. math.random(1,100000)
    CreateMilitaryGroup(7,Entities.CU_Evil_Troll1,0, pos, randomName)
    SetEntitySize(GetEntityId(randomName), 5)
    waveArmy:AddLeader(GetEntityId(randomName))
    waveArmy:AddCommandMove(GetPosition("attackSonnspitzLeft"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("village2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)

    for i = 1, Difficulties[2] do
        createErebos(2)
        createNecro(2)
    end
end

function createGhostWaveP3Graveyard(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("graveyard24"), 2)
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterwaldMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldInnerLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterWaldInnerRight"))
	    waveArmy:AddCommandWaitForIdle()
    end
    waveArmy:AddCommandMove(GetPosition("sp3village"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createGhostWaveP3Grave(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("grave4"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("FinsterwaldRight"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("FinsterWaldInnerRight"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("sp3village"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVWaveP3()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, math.ceil(TICK*(Difficulties[3])/6000) do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn1"), 2)
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterwaldMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldInnerLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterWaldInnerRight"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("sp3village"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVBossWave3()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulties[3] + 3 do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn1"), 2)
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterwaldMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldInnerLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterWaldInnerRight"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("sp3village"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createSpecialUnitBossWave3()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    local pos = GetPosition("nvspawn1")
    local randomName = "troll" .. math.random(1,100000)
    CreateMilitaryGroup(7,Entities.CU_Evil_Troll1,0, pos, randomName)
    SetEntitySize(GetEntityId(randomName), 5)
    waveArmy:AddLeader(GetEntityId(randomName))
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterwaldMiddle"))
	    waveArmy:AddCommandWaitForIdle()
    end
    if math.random() < 0.5 then
        waveArmy:AddCommandMove(GetPosition("FinsterwaldInnerLeft"))
	    waveArmy:AddCommandWaitForIdle()
    else
        waveArmy:AddCommandMove(GetPosition("FinsterWaldInnerRight"))
	    waveArmy:AddCommandWaitForIdle()
    end
	waveArmy:AddCommandMove(GetPosition("sp3village"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)

    for i = 1, Difficulties[3] do
        createErebos(3)
        createNecro(3)
    end
end

function createGhostWaveP4Graveyard(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("graveyard23"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("towndefpoint1"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("towndefpoint2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createGhostWaveP4Grave1(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("grave1"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("towndefmiddle"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createGhostWaveP4Grave2(_amount)
    if _amount == 0 then
        return
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, _amount do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("grave13"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("townleftdef"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("townmiddle"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVWaveP4()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, math.ceil(TICK*(Difficulties[4])/6000) do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn1"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("towndefpoint1"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("towndefpoint2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createNVBossWave4()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulties[4] + 3 do
        waveArmy:CreateLeaderForArmy(getRandomNVTroop(), 20, GetPosition("nvspawn1"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("towndefpoint1"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("towndefpoint2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)
end

function createSpecialUnitBossWave4()
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    local pos = GetPosition("nvspawn1")
    local randomName = "troll" .. math.random(1,100000)
    CreateMilitaryGroup(7,Entities.CU_Evil_Troll1,0, pos, randomName)
    SetEntitySize(GetEntityId(randomName), 5)
    waveArmy:AddLeader(GetEntityId(randomName))
    waveArmy:AddCommandMove(GetPosition("towndefpoint1"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("towndefpoint2"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)

    for i = 1, Difficulties[4] do
        createErebos(4)
        createNecro(4)
    end
end

function createTownBossWave()
    for i = 1, Difficulty * 2 do
        createNecro(4)
    end
    local waveArmy = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulty * 3 + 10 do
        waveArmy:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("grave13"), 2)
    end
    for i = 1, Difficulty * 2 do
        waveArmy:CreateLeaderForArmy(Entities.PU_LeaderSword4_Spectral, 14, GetPosition("grave13"), 2)
    end
    waveArmy:AddCommandMove(GetPosition("townleftdef"))
	waveArmy:AddCommandWaitForIdle()
    waveArmy:AddCommandMove(GetPosition("townmiddle"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy:AddCommandWaitForIdle()
	waveArmy:AddCommandAttackNearestTarget(200000,true)

    local waveArmy2 = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulty * 3 + 10 do
        waveArmy2:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("grave1"), 2)
    end
    for i = 1, Difficulty do
        waveArmy2:CreateLeaderForArmy(Entities.PU_LeaderSword4_Spectral, 14, GetPosition("grave1"), 2)
    end
    waveArmy2:AddCommandMove(GetPosition("towndefmiddle"))
	waveArmy2:AddCommandWaitForIdle()
	waveArmy2:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy2:AddCommandWaitForIdle()
	waveArmy2:AddCommandAttackNearestTarget(200000,true)

    local waveArmy3 = UnlimitedArmy:New({
		Player = 6,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    for i = 1, Difficulty * 3 + 10 do
        waveArmy3:CreateLeaderForArmy(getRandomGhostTroop(), 4, GetPosition("graveyard22"), 2)
    end
    for i = 1, Difficulty * 2 do
        waveArmy3:CreateLeaderForArmy(Entities.PU_LeaderSword4_Spectral, 14, GetPosition("graveyard22"), 2)
    end
    waveArmy3:AddCommandMove(GetPosition("towndefpoint1"))
	waveArmy3:AddCommandWaitForIdle()
	waveArmy3:AddCommandMove(GetPosition("towndefpoint2"))
	waveArmy3:AddCommandWaitForIdle()
    waveArmy3:AddCommandMove(GetPosition("towndefpoint3"))
	waveArmy3:AddCommandWaitForIdle()
	waveArmy3:AddCommandAttackNearestTarget(200000,true)
end

function createLastBossWave()
    StartSimpleJob("lastWaveCountdown1")
    StartSimpleJob("lastWaveCountdown2")
    StartSimpleJob("lastWaveCountdown3")
    StartSimpleJob("lastWaveCountdown4")
end

function lastWaveCountdown1()
    local pos = GetPosition("grave10")
    if Counter.Tick2("lastWaveCountdown1", 36) then
        local id = GetEntityId("ghosterec")
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Der General")
        Camera.ScrollSetLookAt(pos.X,pos.Y)
        Logic.Lightning(pos.X, pos.Y)
        createGhostErecArmy()
        for i = 1, Difficulties[4] do
            createNecro(1)
            createTroll(1)
        end
        return true
    end
    if Counter.GetTick("lastWaveCountdown1") == 35 then
        Explore.Show("ghost1",pos,2000)
        CreateMilitaryGroup(6, Entities.PU_Hero4_Spectral, 0, GetPosition("grave10"), "ghosterec")
    end
end

function lastWaveCountdown2()
    local pos = GetPosition("nvspawn3")
    if Counter.Tick2("lastWaveCountdown2", 54) then
        local id = GetEntityId("ghostpilgrim")
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Der Krieger")
        Camera.ScrollSetLookAt(pos.X,pos.Y)
        Logic.Lightning(pos.X, pos.Y)
        createGhostPilgrimArmy()
        for i = 1, Difficulties[2] do
            createNecro(2)
            createTroll(2)
        end
        return true
    end
    if Counter.GetTick("lastWaveCountdown2") == 53 then
        Explore.Show("ghost2",pos,2000)
        CreateMilitaryGroup(6, Entities.PU_Hero2_Spectral, 0, GetPosition("nvspawn3"), "ghostpilgrim")
    end
end

function lastWaveCountdown3()
    local pos = GetPosition("grave13")
    if Counter.Tick2("lastWaveCountdown3", 56) then
        local id = GetEntityId("ghostari")
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Die Banditin")
        Camera.ScrollSetLookAt(pos.X,pos.Y)
        Logic.Lightning(pos.X, pos.Y)
        createGhostAriArmy()
        for i = 1, Difficulties[4] do
            createNecro(4)
            createTroll(4)
        end
        return true
    end
    if Counter.GetTick("lastWaveCountdown3") == 55 then
        Explore.Show("ghost3",pos,2000)
        CreateMilitaryGroup(6, Entities.PU_Hero5_Spectral, 0, GetPosition("grave13"), "ghostari")
    end
end

function lastWaveCountdown4()
    local pos = GetPosition("graveyard24")
    if Counter.Tick2("lastWaveCountdown4", 58) then
        local id = GetEntityId("ghostdrake")
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Der Jäger")
        Camera.ScrollSetLookAt(pos.X,pos.Y)
        Logic.Lightning(pos.X, pos.Y)
        createGhostDrakeArmy()
        for i = 1, Difficulties[3] do
            createNecro(3)
            createTroll(3)
        end
        return true
    end
    if Counter.GetTick("lastWaveCountdown4") == 57 then
        Explore.Show("ghost4",pos,2000)
        CreateMilitaryGroup(6, Entities.PU_Hero10_Spectral, 0, GetPosition("graveyard24"), "ghostdrake")
    end
end

function createTroll(_playerId)
    local waveArmy = UnlimitedArmy:New({
		Player = 7,
		Area = 3000,
		TransitAttackMove = true,
		AutoDestroyIfEmpty = true,
        DoNotNormalizeSpeed = true,
        AIActive = true
	})
    local pos = GetPosition("nvspawn1")
    if _playerId == 1 then
        pos = GetPosition("nvspawn3")
    elseif _playerId == 2 then
        pos = GetPosition("nvspawn2")
    end
    local randomName = "troll" .. math.random(1,100000)
    CreateMilitaryGroup(7,Entities.CU_Evil_Troll1,0, pos, randomName)
    SetEntitySize(GetEntityId(randomName), 5)
    waveArmy:AddLeader(GetEntityId(randomName))
    if _playerId == 1 then
        if math.random() < 0.5 then
            waveArmy:AddCommandMove(GetPosition("attackAlteaRight"))
            waveArmy:AddCommandWaitForIdle()
        else
            waveArmy:AddCommandMove(GetPosition("attackAlteaMiddle"))
            waveArmy:AddCommandWaitForIdle()
        end
        waveArmy:AddCommandMove(GetPosition("spvillage1"))
        waveArmy:AddCommandWaitForIdle()
        waveArmy:AddCommandAttackNearestTarget(200000,true)
    elseif _playerId == 2 then
        waveArmy:AddCommandMove(GetPosition("attackSonnspitzLeft"))
	    waveArmy:AddCommandWaitForIdle()
	    waveArmy:AddCommandMove(GetPosition("village2"))
	    waveArmy:AddCommandWaitForIdle()
	    waveArmy:AddCommandWaitForIdle()
	    waveArmy:AddCommandAttackNearestTarget(200000,true)
    elseif _playerId == 3 then
        if math.random() < 0.5 then
            waveArmy:AddCommandMove(GetPosition("FinsterwaldLeft"))
            waveArmy:AddCommandWaitForIdle()
        else
            waveArmy:AddCommandMove(GetPosition("FinsterwaldMiddle"))
            waveArmy:AddCommandWaitForIdle()
        end
        if math.random() < 0.5 then
            waveArmy:AddCommandMove(GetPosition("FinsterwaldInnerLeft"))
            waveArmy:AddCommandWaitForIdle()
        else
            waveArmy:AddCommandMove(GetPosition("FinsterWaldInnerRight"))
            waveArmy:AddCommandWaitForIdle()
        end
        waveArmy:AddCommandMove(GetPosition("sp3village"))
        waveArmy:AddCommandWaitForIdle()
        waveArmy:AddCommandAttackNearestTarget(200000,true)
    else
        waveArmy:AddCommandMove(GetPosition("towndefpoint1"))
	    waveArmy:AddCommandWaitForIdle()
        waveArmy:AddCommandMove(GetPosition("towndefpoint2"))
	    waveArmy:AddCommandWaitForIdle()
	    waveArmy:AddCommandMove(GetPosition("towndefpoint3"))
	    waveArmy:AddCommandWaitForIdle()
	    waveArmy:AddCommandAttackNearestTarget(200000,true)
    end
end

function createNecro(_playerId)
    local necroId = NECROID
    NECROID = NECROID + 1
    local pos = "nvspawn1"
    if _playerId == 1 then
        pos = "nvspawn3"
    end
    if _playerId == 4 then
        local positions = {"nvspawn1","grave1","grave13"}
        pos = positions[math.random(1,3)]
    end
    CreateMilitaryGroup(7,Entities.CU_Evil_Queen,0,GetPosition(pos), "necro" .. necroId)
    NECROPOS[necroId] = PLAYERWAYPOINTS[_playerId][math.random(table.getn(PLAYERWAYPOINTS[_playerId]))]
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlNecro" , 1, {}, {_playerId,necroId})
    StartCountdown(1, function ()
        local id = GetEntityId("necro" .. necroId)
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Nekromant")
    end, false)
end

function createErebos(_playerId)
    local pos = 1
    if _playerId == 1 then
        pos = 3
    end
    CreateMilitaryGroup(7,Entities.PU_Hero14,0,GetPosition("nvspawn" .. pos), "ere" .. EREBOSID)
    EREBOSPOS[EREBOSID] = PLAYERWAYPOINTS[_playerId][math.random(table.getn(PLAYERWAYPOINTS[_playerId]))]
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlErebos" , 1, {}, {_playerId,EREBOSID})
    EREBOSID = EREBOSID + 1
end

function controlNecro(_pId, _necroId)
    local name = "necro" .. _necroId
    if IsDead(name) then
        Logic.DestroyEntity(GetEntityId(name))
        return true
    end
    if AreEnemiesInArea(7,GetPosition(name),600) then
        UseNecroAbility(name)
        if UseNecroAbility(name) == true then
            return false
        end
    end
    if IsNear(name,NECROPOS[_necroId],300) then
        NECROPOS[_necroId] = PLAYERWAYPOINTS[_pId][math.random(table.getn(PLAYERWAYPOINTS[_pId]))]
    end
    Move(name,GetPosition(NECROPOS[_necroId]))
end

function controlErebos(_pId, _ereId)
    local name = "ere" .. _ereId
    if IsDead(name) then
        --Logic.DestroyEntity(GetEntityId(name))
        return true
    end
    if IsNear(name,EREBOSPOS[_ereId],300) then
        EREBOSPOS[_ereId] = PLAYERWAYPOINTS[_pId][math.random(table.getn(PLAYERWAYPOINTS[_pId]))]
    end
    Move(name,GetPosition(EREBOSPOS[_ereId]))
end