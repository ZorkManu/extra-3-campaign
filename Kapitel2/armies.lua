Armies = {}
CONST_ARMY_INDEX = 0

function createStartingArmies()
    createArmyStart()
    createArmyHallWay()
    createSharpShooterDef()
    createArmyDefendBarricade()
end

function createArmyStart()
    for i = 1, 4 do
        Armies[CONST_ARMY_INDEX] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = GetPosition("armyStart" .. i),
            rodeLength = 3000
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.PU_LeaderSword1_Spectral

        if i == 2 and Difficulty >= 2 or i == 3 and Difficulty == 3 then
            troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        end

        for j = 1, 1 do
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function createArmyHallWay()
    for i = 1, 5 do
        Armies[CONST_ARMY_INDEX] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = GetPosition("armyHallWay" .. i),
            rodeLength = 3000
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.PU_LeaderSword1_Spectral

        if i == 2 then
            troopDescription.leaderType = Entities.PU_LeaderPoleArm1_Spectral
        elseif i == 3 then
            troopDescription.leaderType = Entities.PU_LeaderBow1_Spectral
        elseif i == 4 then
            troopDescription.leaderType = Entities.PU_LeaderSword1_Spectral
            if Difficulty == 3 then
                troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
            end
        else
            troopDescription.leaderType = Entities.PU_LeaderPoleArm1_Spectral
        end

        for j = 1, 1 do
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function createSharpShooterDef()
    for i = 1, 3 do
        CreateMilitaryGroup(3, Entities.PU_LeaderRifle1_Spectral, 3, GetPosition("sharpshooterdef" .. i), "shooter" .. i)
        Logic.GroupStand(GetEntityId("shooter" .. i))
    end
end

function createArmyDefendBarricade()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("armyDefendBarricade"),
        rodeLength = 1000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.PU_LeaderSword1_Spectral

    for j = 1, Difficulty do
        if Difficulty == 3 and j == 3 then
            troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral
        end
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createArmyBlood()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("armyBlood"),
        rodeLength = 3000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, 3 + Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createArmnyAttackBlackKnights()
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition("armyAttackBlackKnights"),
        rodeLength = 3000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for j = 1, 3 + Difficulty do
        troopDescription.leaderType = getRandomGhostTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createArmyPrisonGuard()
    for i = 1, 3 do
        Armies[CONST_ARMY_INDEX] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = GetPosition("PrisonDef" .. i),
            rodeLength = 3000
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.PU_LeaderPoleArm1_Spectral

        for j = 1, math.max(1,Difficulty-i) do
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function createArmyPantryNV()
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("CaveEntrance"),
        rodeLength = 3000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4 + Difficulty*2
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for j = 1, Difficulty do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createNecroArmy(_pos)
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition(_pos),
        rodeLength = 3000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = getRandomGhostTroop()

    EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createCaveArmies()
    initCaveTrolls()
    createCaveDef()
    createCaveArmy()
end

function initCaveTrolls()

    for i = 1, 3 do
        CreateMilitaryGroup(4, Entities.CU_Evil_Troll1, 0, GetPosition("trollspawn" .. i), "troll" .. i)
        SetEntitySize(GetEntityId("troll" .. i), 5)
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "caveTrollSleep" , 1, {}, {i})
    end
end

function caveTrollSleep(_id)
    if AreEntitiesInArea( 1, 0, GetPosition("troll".. _id), 1300, 1) then
        Message("Ihr habt einen Troll geweckt!")
        setupAggressiveTroll(_id)
        return true
    end
    Logic.GroupStand(GetEntityId("troll" .. _id))
end

function setupAggressiveTroll(_id)
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("trollspawn" .. _id),
        rodeLength = 30000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    ConnectLeaderWithArmy(GetEntityId("troll".._id),Armies[CONST_ARMY_INDEX])

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvance" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createCaveDef()
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("nvdef"),
        rodeLength = 1000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4 + Difficulty*2
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for j = 1, Difficulty do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createCaveArmy()
    for i = 1, 3 do
        Armies[CONST_ARMY_INDEX] = {
            player = 4,
            id = GetFirstFreeArmySlot(4),
            strength = 8,
            position = GetPosition("nvcavespawn" .. i),
            rodeLength = 3000
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 4 + Difficulty*4
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

        --troopDescription.leaderType = Entities.CU_Evil_LeaderSpearman1

        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function createArmyGrave(_position,_amount)
    Armies[CONST_ARMY_INDEX] = {
        player = 3,
        id = GetFirstFreeArmySlot(3),
        strength = 8,
        position = GetPosition(_position),
        rodeLength = 4000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 4
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE

    for i = 1, _amount do
        troopDescription.leaderType = getRandomGhostMeleeTroop()
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpecialAttacker2()
    local amount = (Difficulty * (math.max(1,WORKERSESCAPED)/2))/19
    for i = 3, 6 do
        Armies[CONST_ARMY_INDEX] = {
            player = 3,
            id = GetFirstFreeArmySlot(3),
            strength = 8,
            position = GetPosition("grave" .. i),
            rodeLength = 4000
        }

        SetupArmy(Armies[CONST_ARMY_INDEX])

        local troopDescription = {}
        troopDescription.maxNumberOfSoldiers = 12
        troopDescription.minNumberOfSoldiers = 1
        troopDescription.experiencePoints = HIGH_EXPERIENCE
        troopDescription.leaderType = Entities.PU_LeaderSword4_Spectral

        for i = 1, amount do
            EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
        end

        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
        CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
    end
end

function createSpecialAttacker5()
    local amount = math.ceil(Difficulty * (math.max(1,WORKERSESCAPED)/2)/19)
    Armies[CONST_ARMY_INDEX] = {
        player = 4,
        id = GetFirstFreeArmySlot(4),
        strength = 8,
        position = GetPosition("mountainpassCave"),
        rodeLength = 4000
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 20
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1, amount do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.CU_Evil_LeaderCavalry1

    for i = 1, amount/2 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    for i = 1, amount/4 do
        CreateMilitaryGroup(4, Entities.CU_Evil_Troll1, 0, GetPosition("mountainpassCave"), "troll" .. CONST_ARMY_INDEX .. i)
        SetEntitySize(GetEntityId("troll" .. CONST_ARMY_INDEX .. i), 5)
        ConnectLeaderWithArmy(GetEntityId("troll".. CONST_ARMY_INDEX .. i),Armies[CONST_ARMY_INDEX])
    end

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefend" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function createSpecialAttacker6()
    local amount = math.max(1,(Difficulty * (math.max(1,WORKERSESCAPED)/2))/39)
    for i = 1, amount do
        createNecro(1)
    end
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