WAVE = {
    [2] = 1,
    [5] = 1,
    [6] = 1,
    [7] = 1,
}
NECROID = 1
NECROPOS = {}
PLAYERWAYPOINTS = {
    [1] = {"wellp4","wellp5"},
    [5] = {"village1","p5barracksspawn1","fleeingsp5","spvillage1","p5barracksspawn2","attackAlteaLeft1"},
    [6] = {"attackSonnspitzLeft","village2","attackSonnspitzRight1"},
    [2] = {"FinsterwaldMiddle","FinsterwaldInnerLeft","FinsterWaldInnerRight","sp3village"},
    [7] = {"towndefpoint2","towndefpoint4","townleftdef","townmiddle","towndefpoint3"}
}

function Waves()
    createWaveBanditsAttack()
    createWaveBanditsDefend()
    createWaveP5()
    createWaveP6()
    createWaveP2()
    createWaveP7()
end

function BigWaves(_playerId)
    if _playerId == 6 then
        BigWave6()
        return
    end
    if _playerId == 7 then
        BigWave7()
        return
    end
    
    local PatrolPoints = {}
    local patPos, nvSpawnPos, ghostSpawnPos
    if _playerId == 5 then
        nvSpawnPos = GetPosition("nvspawn2")
        ghostSpawnPos = GetPosition("graveyard13")
        patPos = GetPosition("attackAlteaRight")
        if IsDead("barracksp53") and IsDead("barracksp52") then
            patPos = GetPosition("alteaAttackPoint")
        end
    else
        patPos = GetPosition("FinsterwaldMiddle")
        nvSpawnPos = GetPosition("nvspawn4")
        ghostSpawnPos = GetPosition("graveyard24")
        if IsDead("p2chapel") and IsDead("p2wood2") and IsDead("p2wood1") and IsDead("p2iron1") then
            patPos = GetPosition("FinsterwaldInnerLeft")
        end
    end
    PatrolPoints = {
        [0] = { X = patPos.X, Y = patPos.Y, WaitTime = 60},
        [1] = { X = patPos.X, Y = patPos.Y, WaitTime = 60},
    }
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = ghostSpawnPos,
        rodeLength = 5000,
        Patrol = {
            CurrentPosition = patPos,
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, WAVE[_playerId]*Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for j = 1, WAVE[_playerId]+Difficulty do
        troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    --Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("village1"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP".. _playerId .."Wave" , 1, {}, {CONST_ARMY_INDEX, 1})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1

    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = nvSpawnPos,
        rodeLength = 5000,
        Patrol = {
            CurrentPosition = nvSpawnPos,
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 3 + 2 * Difficulty
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, math.max(1,WAVE[_playerId]) do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, math.floor((Difficulty + WAVE[_playerId])/6) do
        CreateMilitaryGroup(4, Entities.CU_Evil_Troll1, 0, nvSpawnPos, "troll" .. CONST_ARMY_INDEX .. i)
        SetEntitySize(GetEntityId("troll" .. CONST_ARMY_INDEX .. i), 5)
        ConnectLeaderWithArmy(GetEntityId("troll".. CONST_ARMY_INDEX .. i),Armies[CONST_ARMY_INDEX])
    end
    --Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("village1"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP".. _playerId .."Wave" , 1, {}, {CONST_ARMY_INDEX, 1})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    
    for i = 1,math.floor((Difficulty + WAVE[_playerId])/6) do
        createNecro(_playerId)
    end
end

function BigWave6()
    local patPos = GetPosition("attackSonnspitzLeft")
    local ghostSpawnPos = GetPosition("nvspawn3")
    local nvSpawnPos = GetPosition("nvspawn2")
    for i = 1, 2 do
        if i == 2 then
            patPos = GetPosition("attackSonnspitzRight1")
            ghostSpawnPos = GetPosition("graveyard22")
            nvSpawnPos = GetPosition("nvspawn1")
        end
        local PatrolPoints = {
            [0] = { X = patPos.X, Y = patPos.Y, WaitTime = 60},
            [1] = { X = patPos.X, Y = patPos.Y, WaitTime = 60},
        }
        Armies[CONST_ARMY_INDEX] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = ghostSpawnPos,
            rodeLength = 5000,
            Patrol = {
                CurrentPosition = patPos,
                CurrentIndex = 0,
                LastTimePositionUpdated = 0
            },
            PatrolPoints = PatrolPoints,
            arrived = 0
        }
    
        SetupArmy(Armies[CONST_ARMY_INDEX])
    
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 12
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
    
        for j = 1, WAVE[6]*Difficulty do
            troopDescription.leaderType = getRandomGhostTroop()
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end
    
        for j = 1, WAVE[6]+Difficulty do
            troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end
    
        --Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("village1"))
    
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP6Wave" , 1, {}, {CONST_ARMY_INDEX, 1})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    
        Armies[CONST_ARMY_INDEX] = {
            player = 4,
            id = GetFirstFreeArmySlot(4),
            strength = 8,
            position = nvSpawnPos,
            rodeLength = 5000,
            Patrol = {
                CurrentPosition = nvSpawnPos,
                CurrentIndex = 0,
                LastTimePositionUpdated = 0
            },
            PatrolPoints = PatrolPoints,
            arrived = 0
        }
    
        SetupArmy(Armies[CONST_ARMY_INDEX])
    
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 3 + 2 * Difficulty
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
    
        for j = 1, math.max(1,WAVE[6]) do
            troopDescription.leaderType = getRandomNVTroop()
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end
    
        for i = 1, math.floor((Difficulty + WAVE[6])/6) do
            CreateMilitaryGroup(4, Entities.CU_Evil_Troll1, 0, nvSpawnPos, "troll" .. CONST_ARMY_INDEX .. i)
            SetEntitySize(GetEntityId("troll" .. CONST_ARMY_INDEX .. i), 5)
            ConnectLeaderWithArmy(GetEntityId("troll".. CONST_ARMY_INDEX .. i),Armies[CONST_ARMY_INDEX])
        end
        --Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("village1"))
    
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP6Wave" , 1, {}, {CONST_ARMY_INDEX, 1})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
        
        for i = 1,math.floor((Difficulty + WAVE[6])/6) do
            createNecro(6)
        end
    end
end

function BigWave7()
    
end

function createWaveBanditsAttack()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("grave9"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceBandits" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createWaveBanditsDefend()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("grave9"),
        rodeLength = 1000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, 4 + Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendBandits" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createWaveP5()
    if Logic.GetPlayerEntities(5,0,1) == 0 then
        return
    end
    local PatrolPoints = {
        [0] = { X = GetPosition("attackAlteaRight").X, Y = GetPosition("attackAlteaRight").Y, WaitTime = 60},
        [1] = { X = GetPosition("attackAlteaRight").X, Y = GetPosition("attackAlteaRight").Y, WaitTime = 60},

    }
    if IsDead("barracksp53") and IsDead("barracksp52") then
        PatrolPoints = {
            [0] = { X = GetPosition("alteaAttackPoint").X, Y = GetPosition("alteaAttackPoint").Y, WaitTime = 60},
            [1] = { X = GetPosition("alteaAttackPoint").X, Y = GetPosition("alteaAttackPoint").Y, WaitTime = 60},
        }
    end
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("graveyard13"),
        rodeLength = 5000,
        Patrol = {
            CurrentPosition = GetPosition("attackAlteaRight"),
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, WAVE[5]/2 + 3 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("village1"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP5Wave" , 1, {}, {CONST_ARMY_INDEX, 0})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1

    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("nvspawn3"),
        rodeLength = 5000,
        Patrol = {
            CurrentPosition = GetPosition("attackAlteaRight"),
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 3 + 2 * Difficulty
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, math.max(1,WAVE[5]/6) do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("village1"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP5Wave" , 1, {}, {CONST_ARMY_INDEX, 0})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    WAVE[5] = WAVE[5] + 1
end

function controlArmyP5Wave(_id, _deathwave)
    if IsDead(Armies[_id]) then
        if _deathwave == 1 then
            return true
        end
        if Armies[_id].player == 3 then
            if IsDead(Armies[_id + 1]) then
                StartCountdown(30,createWaveP5,false)
            end
        else
            if IsDead(Armies[_id - 1]) then
                StartCountdown(30,createWaveP5,false)
            end
        end
        return true
    end
    if Armies[_id].arrived == 1 then
        Advance(Armies[_id])
        return false
    end
    if IsNear(Armies[_id].IDs[1],"attackAlteaRight",2000) or IsNear(Armies[_id].IDs[1],"attackAlteaMiddle",2000) then
        Armies[_id].arrived = 1
    end
    Patrol(Armies[_id])
end

function createWaveP6()
    if IsDead("p6hq") then
        return
    end
    local random = math.random(1,2)
    local _posGhost = GetPosition("graveyard14")
    local _posNV = GetPosition("nvspawn2")
    local _posRedeploy = GetPosition("attackSonnspitzLeft")
    local _posRedeploy2 = GetPosition("attackSonnspitzLeft2")
    local house1 = "houseP6left"
    local house2 = "p6sulfur3"
    if (random == 1) then
        _posGhost = GetPosition("graveyard22")
        _posNV = GetPosition("nvspawn1")
        _posRedeploy = GetPosition("attackSonnspitzRight1")
        _posRedeploy2 = GetPosition("attackSonnspitzRight2")
        house1 = "houseP6right"
        house2 = "mineP6right"
    end
    local PatrolPoints = {
        [0] = { X = _posRedeploy.X, Y = _posRedeploy.Y, WaitTime = 60},
        [1] = { X = _posRedeploy.X, Y = _posRedeploy.Y, WaitTime = 60},
    }
    if IsDead(house1) and IsDead(house2) then
        PatrolPoints = {
            [0] = { X = _posRedeploy2.X, Y = _posRedeploy2.Y, WaitTime = 60},
            [1] = { X = _posRedeploy2.X, Y = _posRedeploy2.Y, WaitTime = 60},
        }
    end
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = _posGhost,
        rodeLength = 5000,
        Patrol = {
            CurrentPosition = _posRedeploy,
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, WAVE[6]/2 + 3 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],_posRedeploy)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP6Wave" , 1, {}, {CONST_ARMY_INDEX, 0})
    --Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changeAggroSpotP6" , 1, {}, {CONST_ARMY_INDEX, random})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1

    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = _posNV,
        rodeLength = 5000,
        Patrol = {
            CurrentPosition = _posRedeploy,
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 3 + 2 * Difficulty
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, math.max(1,WAVE[6]/6) do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],_posRedeploy)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP6Wave" , 1, {}, {CONST_ARMY_INDEX, 0})
    --Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changeAggroSpotP6" , 1, {}, {CONST_ARMY_INDEX, random})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    WAVE[6] = WAVE[6] + 1
end

function changeAggroSpotP6(_id, _random)
    if IsDead(Armies[_id]) then
        return true
    end
    local _house = "houseP6left"
    local _mine = "mineP6left"
    local _target = "attackSonnspitzLeft2"
    if _random == 1 then
        _house = "houseP6right"
        _mine = "mineP6right"
        _target = "attackSonnspitzRight2"
    end
    if IsDead(_house) and IsDead(_mine) then
        Redeploy(Armies[_id],GetPosition(_target))
        return true
    end
end

function controlArmyP6Wave(_id, _deathwave)
    if IsDead(Armies[_id]) then
        if _deathwave == 1 then
            return true
        end
        if Armies[_id].player == 3 then
            if IsDead(Armies[_id + 1]) then
                StartCountdown(30,createWaveP6,false)
            end
        else
            if IsDead(Armies[_id - 1]) then
                StartCountdown(30,createWaveP6,false)
            end
        end
        return true
    end
    if Armies[_id].arrived == 1 then
        Advance(Armies[_id])
        return false
    end
    if IsNear(Armies[_id].IDs[1],"attackSonnspitzLeft",2000) or IsNear(Armies[_id].IDs[1],"attackSonnspitzRight1",2000) then
        Armies[_id].arrived = 1
    end
    Patrol(Armies[_id])
end

function createWaveP2()
    if AI.Player_GetNumberOfLeaders(2) <= 1 then
        return
    end
    local patPos = GetPosition("FinsterwaldMiddle")
    if IsDead("p2chapel") and IsDead("p2wood2") and IsDead("p2wood1") and IsDead("p2iron1") then
        patPos = GetPosition("FinsterwaldInnerLeft")
    end
    local PatrolPoints = {
        [0] = { X = patPos.X, Y = patPos.Y, WaitTime = 60},
        [1] = { X = patPos.X, Y = patPos.Y, WaitTime = 60},
    }

    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("graveyard24"),
        rodeLength = 13000*2,
        Patrol = {
            CurrentPosition = patPos,
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, WAVE[2]/2 + 2 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("FinsterwaldMiddle"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP2Wave" , 1, {}, {CONST_ARMY_INDEX, 0})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1

    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("nvspawn4"),
        rodeLength = 13000*2,
        Patrol = {
            CurrentPosition = patPos,
            CurrentIndex = 0,
            LastTimePositionUpdated = 0
        },
        PatrolPoints = PatrolPoints,
        arrived = 0
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 3 + 2 * Difficulty
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, math.max(1,WAVE[2]/6) do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("FinsterwaldMiddle"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP2Wave" , 1, {}, {CONST_ARMY_INDEX, 0})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    WAVE[2] = WAVE[2] + 1
end

function controlArmyP2Wave(_id, _deathwave)
    if IsDead(Armies[_id]) then
        if _deathwave == 1 then
            return true
        end
        if Armies[_id].player == 3 then
            if IsDead(Armies[_id + 1]) then
                StartCountdown(30,createWaveP2,false)
            end
        else
            if IsDead(Armies[_id - 1]) then
                StartCountdown(30,createWaveP2,false)
            end
        end
        return true
    end
    if Armies[_id].arrived == 1 then
        Advance(Armies[_id])
        return false
    end
    if IsNear(Armies[_id].IDs[1],"FinsterwaldMiddle",2000) then
        Armies[_id].arrived = 1
    end
    Patrol(Armies[_id])
end

function createWaveP7()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("graveyard22"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, WAVE[7]/2 + 3 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("attackPointP71"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP7Wave" , 1, {}, {CONST_ARMY_INDEX})
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changeAggroSpotP7" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1

    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("nvspawn1"),
        rodeLength = 5000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 3 + 2 * Difficulty
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, math.max(1,WAVE[7]/6) do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Redeploy(Armies[CONST_ARMY_INDEX],GetPosition("attackPointP71"))

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyP7Wave" , 1, {}, {CONST_ARMY_INDEX})
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changeAggroSpotP7" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    WAVE[7] = WAVE[7] + 1
end

function changeAggroSpotP7(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    if IsDead("defbuilding1") then
        Redeploy(Armies[_id],GetPosition("attackPointP72"))
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changeAggroSpotP72" , 1, {}, {CONST_ARMY_INDEX})
        return true
    end
end

function changeAggroSpotP72(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    if IsDead("archeryp71") then
        Redeploy(Armies[_id],GetPosition("attackPointP73"))
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "changeAggroSpotP73" , 1, {}, {CONST_ARMY_INDEX})
        return true
    end
end

function changeAggroSpotP73(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    if IsDead("archeryp71") then
        Redeploy(Armies[_id],GetPosition("attackPointP74"))
        return true
    end
end

function controlArmyP7Wave(_id)
    if IsDead(Armies[_id]) then
        if Armies[_id].player == 3 then
            if IsDead(Armies[_id + 1]) then
                StartCountdown(30,createWaveP7,false)
            end
        else
            if IsDead(Armies[_id - 1]) then
                StartCountdown(30,createWaveP7,false)
            end
        end
        return true
    end
    if IsDead("p7hq") then
        Advance(Armies[_id])
        return false
    end
    Defend(Armies[_id])
end

function controlArmyAdvanceBandits(_id)
    if IsDead(Armies[_id]) then
        if IsDead("spawnerBanditAttack") == false then
            StartCountdown(30,createWaveBanditsAttack,false)
        end
        return true
    end
    Advance(Armies[_id])
end

function controlArmyDefendBandits(_id)
    if IsDead(Armies[_id]) then
        if IsDead("spawnerBanditAttack") == false then
            StartCountdown(30,createWaveBanditsDefend,false)
        end
        return true
    end
    Defend(Armies[_id])
end

function StartTimer()
    Counter.Tick2("TICK", 9999)
    StartSimpleJob("TickCounter")
end

function TickCounter()
    Counter.Tick("TICK")
end

function createNecro(_playerId)
    local necroId = NECROID
    NECROID = NECROID + 1
    local pos = "nvspawn1"
    if _playerId == 5 then
        pos = "nvspawn3"
    end
    CreateMilitaryGroup(4,Entities.CU_Evil_Queen,0,GetPosition(pos), "necro" .. necroId)
    NECROPOS[necroId] = PLAYERWAYPOINTS[_playerId][math.random(table.getn(PLAYERWAYPOINTS[_playerId]))]
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlNecro" , 1, {}, {_playerId,necroId})
    StartCountdown(1, function ()
        local id = GetEntityId("necro" .. necroId)
        Logic.SetEntityScriptingValue(id,72,1)
        CUtil.SetEntityDisplayName(id, "Nekromant")
    end, false)
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