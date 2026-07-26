NVMountainArmies = {}
ArenaArmies = {}
OneTimeArmies = {}
PrologSpawnerArmies = {}

function CreateArmyStart(_playerId)
    armyStart[_playerId] = {
    	player = _playerId,
    	id = GetFirstFreeArmySlot(_playerId),
    	strength = 6,
    	position = GetPosition("StartArmy" .. _playerId),
    	rodeLength = 20000
	}
	SetupArmy(armyStart[_playerId])

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 1
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry1

    if (_playerId == 3) then
        troopDescription.leaderType = Entities.PU_LeaderSword2
    end

    for i = 1,4,1 do
	    EnlargeArmy(armyStart[_playerId],troopDescription)
	end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmyStart" , 1, {}, {_playerId})
end

function ControlArmyStart(_playerId)
	if IsDead(armyStart[_playerId]) then
        return true
   	else
		Advance(armyStart[_playerId])
    end
end

function attackSturmbach()
    attackArmy = {}
    for i = 1, 2, 1 do
        attackArmy[i] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = GetPosition("StartArmy3"),
            rodeLength = 23000
        }

        SetupArmy(attackArmy[i])

        local type = Entities.PU_LeaderSword2
        if (i == 2) then
            type = Entities.PU_LeaderBow2
        end
        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = type

        for j = 1, 8+Difficulty,1 do
            EnlargeArmy(attackArmy[i], troopDescription)
        end
        
        troopDescription.leaderType = Entities.PV_Cannon2
        for j = 0, math.max(0,Difficulty-i), 1 do
            EnlargeArmy(attackArmy[i], troopDescription) 
        end
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlAttackArmy" , 1, {}, {i})
    end
    StartCountdown(30, createUnknownAttacker, false)
end

function controlAttackArmy(_id)
    if IsDead(attackArmy[_id]) then
        return true
    end
    Advance(attackArmy[_id])
end

function createArmySwords()
    armySwords = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("Ambush"),
        rodeLength = 100000
    }

    SetupArmy(armySwords)

    for i = 1, 3 do
        ConnectLeaderWithArmy(GetEntityId("Sword"..i),armySwords)
    end

    StartSimpleJob("controlSwordArmy")
end

function controlSwordArmy()
    if IsDead(armySwords) then
        return true
    end
    Defend(armySwords)
end

function attackNVArmy()
    armyNV = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("EvilArmySupriseAttack"),
        rodeLength = 100000
    }

    SetupArmy(armyNV)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for j = 1, Difficulty,1 do
        EnlargeArmy(armyNV, troopDescription)
    end
    
    troopDescription.leaderType = Entities.PU_Hero14_Bearman1

    for j = 1, math.max(1,Difficulty-1),1 do
        EnlargeArmy(armyNV, troopDescription)
    end

    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for j = 1, math.max(1,Difficulty-1),1 do
        EnlargeArmy(armyNV, troopDescription)
    end

    StartSimpleJob("controlAttackArmyNV")
end

function controlAttackArmyNV()
    if IsDead(armyNV) then
        return true
    end
    Advance(armyNV)
end

function attackUnknownArmy()
    armyUnknown = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("EvilArmySupriseAttack"),
        rodeLength = 100000
    }

    SetupArmy(armyUnknown)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1,7 + Difficulty*3 ,1 do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(armyUnknown, troopDescription)
    end

    StartSimpleJob("controlAttackArmyUnknown")
end

function getRandomTroop()
    local randomGenerator = math.random()
    if randomGenerator < 0.17 then
        return Entities.PU_LeaderSword1
    elseif randomGenerator < 0.34 then
        return Entities.PU_LeaderPoleArm1
    elseif randomGenerator < 0.51 then
        return Entities.PU_LeaderBow1
    elseif randomGenerator < 0.68 then
        return Entities.PU_LeaderCavalry1
    elseif randomGenerator < 0.85 then
        return Entities.PU_LeaderHeavyCavalry1
    else
        return Entities.PU_LeaderRifle1
    end
end

function getRandomGhostTroop()
    local randomGenerator = math.random()
    if randomGenerator < 0.25 then
        return Entities.PU_LeaderSword1_Spectral
    elseif randomGenerator < 0.5 then
        return Entities.PU_LeaderPoleArm1_Spectral
    elseif randomGenerator < 0.75 then
        return Entities.PU_LeaderBow1_Spectral
    else
        return Entities.PU_LeaderRifle1_Spectral
    end
end

local PrologGhostSpawnTypes = {
    {Entities.PU_LeaderSword1_Spectral, 4},
    {Entities.PU_LeaderPoleArm1_Spectral, 4},
    {Entities.PU_LeaderBow1_Spectral, 4},
    {Entities.PU_LeaderRifle1_Spectral, 4}
}

local PrologNVSpawnTypes = {
    {Entities.CU_Evil_LeaderBearman1, 20},
    {Entities.CU_Evil_LeaderSkirmisher1, 20},
    {Entities.CU_Evil_LeaderSpearman1, 20}
}

local PrologBanditSpawnTypes = {
    {Entities.CU_BanditLeaderSword1, 20},
    {Entities.CU_BanditLeaderBow1, 20}
}

local function shouldStopSpawner(_spawner, _alternateSpawner)
    if _alternateSpawner then
        return IsDead(_spawner) or IsDead(_alternateSpawner)
    end
    return IsDead(_spawner)
end

function controlAttackArmyUnknown()
    if IsDead(armyUnknown) then
        UNKNOWNARMYDEAD = true
        return true
    end
    Advance(armyUnknown)
end

function setupSpawnerGhost1()
    local spawnPos = "EvilArmySupriseAttack"
    if IsDead("spawner3") then
        spawnPos = "EvilArmyPlayer2"
    end
    PrologSpawnerArmies[1] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 4 + Difficulty * 3,
        position = GetPosition(spawnPos),
        rodeLength = 12000,
        respawnTime = 90,
        spawnGenerator = GetEntityId("spawnGhost"),
        spawnTypes = PrologGhostSpawnTypes,
        endless = true
    }

    SetupArmy(PrologSpawnerArmies[1])
    SetupAITroopSpawnGenerator("PrologSpawnerGhost1", PrologSpawnerArmies[1])
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawnerProlog" , 1, {}, {1, "spawnGhost"})
end

function controlArmyDefendSpawnerProlog(_id, _spawner, _alternateSpawner)
    if Counter.Tick2("controlArmyDefendSpawnerProlog" .. _id, 2) then
        if IsDead(PrologSpawnerArmies[_id]) then
            if shouldStopSpawner(_spawner, _alternateSpawner) then
                return true
            end
            return false
        end
        Defend(PrologSpawnerArmies[_id])
    end
end

function setupSpawnerGhost2()
    PrologSpawnerArmies[2] = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 4 + Difficulty * 3,
        position = GetPosition("EvilArmyPlayer3"),
        rodeLength = 13000,
        respawnTime = 90,
        spawnGenerator = GetEntityId("spawnGhost"),
        spawnTypes = PrologGhostSpawnTypes,
        endless = true
    }

    SetupArmy(PrologSpawnerArmies[2])
    SetupAITroopSpawnGenerator("PrologSpawnerGhost2", PrologSpawnerArmies[2])
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawnerProlog" , 1, {}, {2, "spawnGhost"})
end

function setupSpawnerNV1()
    local spawnPos = "EvilArmySupriseAttack"
    if IsDead("spawner3") then
        spawnPos = "EvilArmyPlayer2"
    end
    PrologSpawnerArmies[3] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = Difficulty,
        position = GetPosition(spawnPos),
        rodeLength = 12000,
        respawnTime = 120,
        spawnGenerator = GetEntityId("spawner1"),
        spawnTypes = PrologNVSpawnTypes,
        endless = true
    }

    SetupArmy(PrologSpawnerArmies[3])
    SetupAITroopSpawnGenerator("PrologSpawnerNV1", PrologSpawnerArmies[3])
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawnerProlog" , 1, {}, {3, "spawner1", "spawner3"})
end

function setupSpawnerNV2()
    PrologSpawnerArmies[4] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 2 * Difficulty,
        position = GetPosition("EvilArmyPlayer3"),
        rodeLength = 13000,
        respawnTime = 120,
        spawnGenerator = GetEntityId("spawner2"),
        spawnTypes = PrologNVSpawnTypes,
        endless = true
    }

    SetupArmy(PrologSpawnerArmies[4])
    SetupAITroopSpawnGenerator("PrologSpawnerNV2", PrologSpawnerArmies[4])
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawnerProlog" , 1, {}, {4, "spawner2"})
end

function controlArmyAdvanceSpawnerProlog(_id, _spawner, _alternateSpawner)
    if Counter.Tick2("controlArmyAdvanceSpawnerProlog" .. _id, 2) then
        if IsDead(PrologSpawnerArmies[_id]) then
            if shouldStopSpawner(_spawner, _alternateSpawner) then
                return true
            end
            return false
        end
        Advance(PrologSpawnerArmies[_id])
    end
end

function initArmyDefendGraveyard()
    ArmyDefendGraveyard = {
        player = 6,
        id = GetFirstFreeArmySlot(6),
        strength = 8,
        position = GetPosition("defenseArmyGhost"),
        rodeLength = 4000
    }

    SetupArmy(ArmyDefendGraveyard)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, 10*Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(ArmyDefendGraveyard, troopDescription)
    end

    StartSimpleJob("controlArmyDefendGraveyard")
end

function controlArmyDefendGraveyard()
    if IsDead(ArmyDefendGraveyard) then
        if not IsDead("spawnGhost") then
            initArmyDefendGraveyard()
        end
        return true
    end
    Defend(ArmyDefendGraveyard)
end

function initArmyDefendEntrance1()
    ArmyDefendEntrance1 = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("EvilArmyPlayer2"),
        rodeLength = 5000
    }

    SetupArmy(ArmyDefendEntrance1)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1
        EnlargeArmy(ArmyDefendEntrance1, troopDescription)
    end

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderSpearman1
        EnlargeArmy(ArmyDefendEntrance1, troopDescription)
    end

    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1
    EnlargeArmy(ArmyDefendEntrance1, troopDescription)

    StartSimpleJob("controlArmyDefendEntrance1")
end

function controlArmyDefendEntrance1()
    if IsDead(ArmyDefendEntrance1) then
        if not IsDead("spawner1") then
            initArmyDefendEntrance1()
        end
        return true
    end
    Defend(ArmyDefendEntrance1)
end

function initArmyDefendEntrance3()
    ArmyDefendEntrance3 = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("EvilArmySupriseAttack"),
        rodeLength = 5000
    }

    SetupArmy(ArmyDefendEntrance3)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1
        EnlargeArmy(ArmyDefendEntrance3, troopDescription)
    end

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderSpearman1
        EnlargeArmy(ArmyDefendEntrance3, troopDescription)
    end

    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1
    EnlargeArmy(ArmyDefendEntrance3, troopDescription)

    StartSimpleJob("controlArmyDefendEntrance3")
end

function controlArmyDefendEntrance3()
    if IsDead(ArmyDefendEntrance3) then
        if not IsDead("spawner3") then
            initArmyDefendEntrance3()
        end
        return true
    end
    Defend(ArmyDefendEntrance3)
end

function initArmyDefendEntrance2()
    ArmyDefendEntrance2 = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("EvilArmyPlayer3"),
        rodeLength = 4000
    }

    SetupArmy(ArmyDefendEntrance2)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1
        EnlargeArmy(ArmyDefendEntrance2, troopDescription)
    end

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderSpearman1
        EnlargeArmy(ArmyDefendEntrance2, troopDescription)
    end

    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1
    EnlargeArmy(ArmyDefendEntrance2, troopDescription)

    StartSimpleJob("controlArmyDefendEntrance2")
end

function controlArmyDefendEntrance2()
    if IsDead(ArmyDefendEntrance2) then
        if not IsDead("spawner2") then
            initArmyDefendEntrance2()
        end
        return true
    end
    Defend(ArmyDefendEntrance2)
end

function initReeinforcementsSpawner1()
    ArmyReeinforcementSpawner = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("reeinfSpawn"),
        rodeLength = 10000
    }

    SetupArmy(ArmyReeinforcementSpawner)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1, Difficulty + 4, 1 do
        EnlargeArmy(ArmyReeinforcementSpawner, troopDescription)
    end


    StartSimpleJob("controlArmyReeinforcementSpawns1")
end

function controlArmyReeinforcementSpawns1()
    if IsDead(ArmyReeinforcementSpawner) then
        return true
    end
    Defend(ArmyReeinforcementSpawner)
end

function initReeinforcementsSpawner2()
    ArmyReeinforcementSpawner2 = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("reeinfSpawn2"),
        rodeLength = 10000
    }

    SetupArmy(ArmyReeinforcementSpawner2)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1, Difficulty * 4, 1 do
        EnlargeArmy(ArmyReeinforcementSpawner2, troopDescription)
    end

    StartSimpleJob("controlArmyReeinforcementSpawns2")
end

function controlArmyReeinforcementSpawns2()
    if IsDead(ArmyReeinforcementSpawner2) then
        return true
    end
    Defend(ArmyReeinforcementSpawner2)
end

function createArmyVC()
    ArmyVC = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("vcarmy"),
        rodeLength = 4000
    }

    SetupArmy(ArmyVC)

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1
        EnlargeArmy(ArmyVC, troopDescription)
    end

    for i = 1, Difficulty, 1 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderSpearman1
        EnlargeArmy(ArmyVC, troopDescription)
    end

    StartSimpleJob("controlArmyDefendVC")
end

function controlArmyDefendVC()
    if IsDead(ArmyVC) then
        VCCAPTURED = true
        return true
    end
    Defend(ArmyVC)
end

function createOneTimeArmies()
    for i = 1, Difficulty + math.floor(Difficulty/3) do
        OneTimeArmies[i] = {
            player = 6,
            id = GetFirstFreeArmySlot(6),
            strength = 8,
            position = GetPosition("oneTimeArmy" .. i),
            rodeLength = 40000
        }
    
        SetupArmy(OneTimeArmies[i])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 8
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE

        for j = 1, 10 do
            troopDescription.leaderType = getRandomGhostTroop()
            EnlargeArmy(OneTimeArmies[i], troopDescription)
        end
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlOneTimeArmy" , 1, {}, {i})
    end
end

function controlOneTimeArmy(_id)
    if IsDead(OneTimeArmies[_id]) then
        return true
    end
    Advance(OneTimeArmies[_id])
end

function createOneTimeArmy5NVDef()
    OneTimeArmies[6] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition("oneTimeArmy5"),
        rodeLength = 3000
    }

    SetupArmy(OneTimeArmies[6])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, 2 + Difficulty * 2 do
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1
        EnlargeArmy(OneTimeArmies[6], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlOneTimeArmy5NVDef", 1, {}, {})
end

function controlOneTimeArmy5NVDef()
    if IsDead(OneTimeArmies[6]) then
        return true
    end
    Defend(OneTimeArmies[6])
end

function createNVArmyMountains(_id, _pos)
    NVMountainArmies[_id] = {
        player = 5,
        id = GetFirstFreeArmySlot(5),
        strength = 8,
        position = GetPosition(_pos),
        rodeLength = 100000
    }

    SetupArmy(NVMountainArmies[_id])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 8
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, 3, 1 do
        troopDescription.leaderType = Entities.PU_Hero14_Bearman2
        EnlargeArmy(NVMountainArmies[_id], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlNVArmyMountains" , 1, {}, {_id})
end

function controlNVArmyMountains(_id)
    if IsDead(NVMountainArmies[_id]) then
        return true
    end
    Advance(NVMountainArmies[_id])
end

function createArena1()
    ArenaArmies[10] = {
        player = 7,
        id = GetFirstFreeArmySlot(7),
        strength = 8,
        position = GetPosition("ArenaFighter3"),
        rodeLength = 100000
    }

    SetupArmy(ArenaArmies[10])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = getRandomTroop()

    EnlargeArmy(ArenaArmies[10], troopDescription)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArenaArmiesRegular1" , 1, {}, {10})
end

function controlArenaArmiesRegular1(_id)
    if IsDead(ArenaArmies[_id]) then
        createArena1()
        return true
    end
    if ARENA_OCCUPIED == true then
        DestroyArmy(ArenaArmies[_id])
        return true
    end
    Advance(ArenaArmies[_id])
end

function createArena2()
    ArenaArmies[11] = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 8,
        position = GetPosition("AriArena"),
        rodeLength = 100000
    }

    SetupArmy(ArenaArmies[11])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 12
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = getRandomTroop()

    EnlargeArmy(ArenaArmies[11], troopDescription)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArenaArmiesRegular2" , 1, {}, {11})
end

function controlArenaArmiesRegular2(_id)
    if IsDead(ArenaArmies[_id]) then
        createArena2()
        return true
    end
    if ARENA_OCCUPIED == true then
        DestroyArmy(ArenaArmies[_id])
        return true
    end
    Advance(ArenaArmies[_id])
end


function arenaArmies1()
    for i  = 1, 2 + math.max(0,Difficulty-2) do
        ArenaArmies[i] = {
            player = 7,
            id = GetFirstFreeArmySlot(7),
            strength = 8,
            position = GetPosition("ArenaFighter" .. i),
            rodeLength = 100000
        }

        SetupArmy(ArenaArmies[i])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 12
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.CU_BanditLeaderSword1

        if i == 2 then
            troopDescription.leaderType = Entities.CU_BanditLeaderBow1
        end

        EnlargeArmy(ArenaArmies[i], troopDescription)

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArenaArmies" , 1, {}, {i}) 
    end
end

function arenaArmies2()
    for i  = 1, 2 + math.max(0,Difficulty-2) do
        ArenaArmies[i] = {
            player = 7,
            id = GetFirstFreeArmySlot(7),
            strength = 8,
            position = GetPosition("ArenaFighter" .. i),
            rodeLength = 100000
        }

        SetupArmy(ArenaArmies[i])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 12
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.CU_BanditLeaderSword1

        if i == 2 then
            troopDescription.leaderType = Entities.CU_BanditLeaderBow1
        end

        if i == 3 then
            troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace1
            ConnectLeaderWithArmy(GetEntityId("Regar"),ArenaArmies[i])
        end

        EnlargeArmy(ArenaArmies[i], troopDescription)

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArenaArmies" , 1, {}, {i}) 
    end
end

function controlArenaArmies(_id)
    if IsDead(ArenaArmies[_id]) then
        return true
    end
    if ARENA_OCCUPIED == false then
        DestroyArmy(ArenaArmies[_id])
        return true
    end
    Advance(ArenaArmies[_id])
end

function setupSpawnerBandits()
    local baseStrength = 2
    if UNKNOWNARMYDEAD then
        baseStrength = 4
    end

    PrologSpawnerArmies[5] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = baseStrength,
        position = GetPosition("BanditsSpawner"),
        rodeLength = 100000,
        respawnTime = 90,
        spawnGenerator = GetEntityId("BanditsSpawner"),
        spawnTypes = PrologBanditSpawnTypes,
        endless = true
    }

    SetupArmy(PrologSpawnerArmies[5])
    SetupAITroopSpawnGenerator("PrologSpawnerBandits", PrologSpawnerArmies[5])
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawnerProlog" , 1, {}, {5, "BanditsSpawner"})
end

function DestroyArmy(_ArmyTable)
    local PlayerId, ArmyId = _ArmyTable.player, _ArmyTable.id
    local LeaderIds = ArmyTable[PlayerId][ArmyId + 1].IDs
    for i = 1, table.getn(LeaderIds) do
        Logic.DestroyGroupByLeader(LeaderIds[i])
    end
end

function GetAllLeader(_player)
	local leaderIds = {}
	local cannonIds = {}
	local numberOfLeaders = Logic.GetNumberOfLeader(_player)
	local cannonCount = 0
	local prevLeaderId = 0
	local existing = {}
	for i=1,numberOfLeaders do
		local nextLeaderId = Logic.GetNextLeader( _player, prevLeaderId )
		if existing[nextLeaderId] then
			cannonCount = cannonCount + 1
	    else
	        existing[nextLeaderId] = true;
			table.insert(leaderIds,nextLeaderId)
	    end
		prevLeaderId = nextLeaderId
	end
	if cannonCount > 0 then
		local tempCannonIds = {}
		for i=1,4 do
			local counter = 0
			counter = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_player, Entities["PV_Cannon"..i])
			if counter > 0 then
				tempCannonIds = {Logic.GetPlayerEntities(_player, Entities["PV_Cannon"..i], counter)}
				table.remove(tempCannonIds,1)
				for j=1,table.getn(tempCannonIds) do
					table.insert(leaderIds,tempCannonIds[j])
					table.insert(cannonIds,tempCannonIds[j])
				end
			end
		end
	end
	return leaderIds, cannonIds
end