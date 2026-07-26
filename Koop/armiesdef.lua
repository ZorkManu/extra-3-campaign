Armies = {}
CONST_ARMY_INDEX = 0

function initStartingEnemies()
    for i = 1, 12 do 
        createDefArmyGrave(i)
    end
    createDefArmyGraveyard()
end

function createDefArmyGrave(_graveid)
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("grave" .. _graveid),
        rodeLength = 3000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, math.max(1,math.ceil(TICK/700)) do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendGrave" , 1, {}, {CONST_ARMY_INDEX, _graveid})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createDefArmyGraveyard()
    Armies[CONST_ARMY_INDEX] = {
        player = 7,
        id = GetFirstFreeArmySlot(7),
        strength = 8,
        position = GetPosition("nvspawn3"),
        rodeLength = 5500
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, math.max(1,math.ceil(TICK/700)) do
        troopDescription.leaderType = getRandomNVTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendGraveyard" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createNecroArmy(_pos)
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition(_pos),
        rodeLength = 3000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty + 2 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createGhostErecArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("grave10"),
        rodeLength = 10000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    local erecId = GetEntityId("ghosterec")
    CEntity.SetArmor(erecId,20)
    ConnectLeaderWithArmy(erecId,Armies[CONST_ARMY_INDEX])

    for i = 1, Difficulty * 5 do
        troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon2
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon3
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createGhostPilgrimArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("nvspawn3"),
        rodeLength = 10000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    local pilgrimId = GetEntityId("ghostpilgrim")
    CEntity.SetArmor(pilgrimId,20)
    ConnectLeaderWithArmy(pilgrimId,Armies[CONST_ARMY_INDEX])

    for i = 1, Difficulty * 5 do
        troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon2
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon3
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createGhostAriArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("grave13"),
        rodeLength = 10000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    local ariId = GetEntityId("ghostari")
    CEntity.SetArmor(ariId,20)
    ConnectLeaderWithArmy(ariId,Armies[CONST_ARMY_INDEX])

    for i = 1, Difficulty * 5 do
        troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon2
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon3
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createGhostDrakeArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("graveyard24"),
        rodeLength = 10000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    local drakeId = GetEntityId("ghostdrake")
    CEntity.SetArmor(drakeId,20)
    ConnectLeaderWithArmy(drakeId,Armies[CONST_ARMY_INDEX])

    for i = 1, Difficulty * 10 + 25 do
        troopDescription.leaderType = Entities.PU_LeaderRifle1_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 10 + 20 do
        troopDescription.leaderType = Entities.PU_LeaderBow1_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon2
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon3
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createMtnArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("mtb1"),
        rodeLength = 9000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty * 5 + 25 do
        troopDescription.leaderType = Entities.PU_LeaderRifle1_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 5 + 20 do
        troopDescription.leaderType = Entities.PU_LeaderBow1_Spectral
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, Difficulty * 2 do
        troopDescription.leaderType = Entities.PV_Cannon3
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyAdvance(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Advance(Armies[_id])
end

function controlArmyDefend(_id)
    if IsDead(Armies[_id]) then
        return true
    end
    Defend(Armies[_id])
end

function controlArmyDefendGrave(_id, _graveid)
    if IsDead(Armies[_id]) then
        if SPAWNEROFF == 1 then
            return true
        end
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "delayDefArmyGraveSpawn" , 1, {}, {_graveid})
        return true
    end
    Defend(Armies[_id])
end

function delayDefArmyGraveSpawn(_graveid)
    if Counter.Tick2("delayDefArmyGraveSpawn" .. _graveid, 120 - 30 * Difficulty) then
        createDefArmyGrave(_graveid)
        return true
    end
end

function controlArmyDefendGraveyard(_id)
    if IsDead(Armies[_id]) then
        if SPAWNEROFF == 1 then
            return true
        end
        StartSimpleJob("delayDefArmyGraveyardSpawn")
        return true
    end
    Defend(Armies[_id])
end

function delayDefArmyGraveyardSpawn()
    if Counter.Tick2("delayDefArmyGraveyardSpawn" , 120 - 30 * Difficulty) then
        createDefArmyGraveyard()
        return true
    end
end

GetDistance = function(_a, _b)

	if type(_a) ~= "table" then
		_a = GetPosition(_a)
	end

	if type(_b) ~= "table" then
		_b = GetPosition(_b)
	end

	if _a.X ~= nil then
		return math.sqrt((_a.X - _b.X)^2+(_a.Y - _b.Y)^2)
	else
		return math.sqrt((_a[1] - _b[1])^2+(_a[2] - _b[2])^2)
	end

end