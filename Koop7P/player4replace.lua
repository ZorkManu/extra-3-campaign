function InitPlayer4Replace()
    P4StartUpgrades()
    StartSimpleJob("UpgradeP4")
    CreateDefenseArmies()
    CreateMovableArmy()
    StartSimpleJob("ExpandDefenseArmies")
    for i = 1,3 do
        createTributeP4MovableArmy(i)
    end
    createTributeP4MovableArmySelf()
end

function CreateDefenseArmies()
    ArmyLeftDefense = UnlimitedArmy:New({
		Player = 4,
		Area = 4000,
		Formation = UnlimitedArmy.Formations.Lines,
		LeaderFormation  = FormationFunktion,
		TransitAttackMove = true,
	})

	ArmyLeftDefenseRecruiter = UnlimitedArmyRecruiter:New(ArmyLeftDefense, {
		Buildings = {
			Logic.GetEntityIDByName("foundryp4"),
			Logic.GetEntityIDByName("stablep4"),
		},
		ArmySize = 5,
		UCats = {
			{UCat = UpgradeCategories.LeaderHeavyCavalry, SpawnNum = 1, Looped = true},
			{UCat = UpgradeCategories.LeaderCavalry, SpawnNum = 1, Looped = true},
			{UCat = UpgradeCategories.Cannon3, SpawnNum = 1, Looped = true},
		},
		ResCheat = true
	})
	ArmyLeftDefense:AddCommandMove(GetPosition("townleftdef"),true)
	ArmyLeftDefense:AddCommandDefend(GetPosition("townleftdef"), 4000, true)

    ArmyMiddleDefense = UnlimitedArmy:New({
		Player = 4,
		Area = 4000,
		Formation = UnlimitedArmy.Formations.Lines,
		LeaderFormation  = FormationFunktion,
		TransitAttackMove = true,
	})

	ArmyMiddleDefenseRecruiter = UnlimitedArmyRecruiter:New(ArmyMiddleDefense, {
		Buildings = {
			Logic.GetEntityIDByName("barracksp4"),
			Logic.GetEntityIDByName("foundryp4"),
			Logic.GetEntityIDByName("stablep4"),
		},
		ArmySize = 5,
		UCats = {
			{UCat = UpgradeCategories.LeaderHeavyCavalry, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderSword, SpawnNum = 1, Looped = true},
			{UCat = UpgradeCategories.LeaderCavalry, SpawnNum = 1, Looped = true},
			{UCat = UpgradeCategories.Cannon3, SpawnNum = 1, Looped = true},
		},
		ResCheat = true
	})
	ArmyMiddleDefense:AddCommandMove(GetPosition("towndefmiddle"),true)
	ArmyMiddleDefense:AddCommandWaitForIdle(true)
	ArmyMiddleDefense:AddCommandDefend(GetPosition("towndefmiddle"), 4000, true)

    ArmyRightDefense = UnlimitedArmy:New({
		Player = 4,
		Area = 4000,
		Formation = UnlimitedArmy.Formations.Lines,
		LeaderFormation  = FormationFunktion,
		TransitAttackMove = true,
	})

	ArmyRightDefenseRecruiter = UnlimitedArmyRecruiter:New(ArmyRightDefense, {
		Buildings = {
			Logic.GetEntityIDByName("barracksp4"),
			Logic.GetEntityIDByName("archeryp4"),
            Logic.GetEntityIDByName("archeryp42"),
		},
		ArmySize = 6,
		UCats = {
			{UCat = UpgradeCategories.LeaderPoleArm, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderBow, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderRifle, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderSword, SpawnNum = 1, Looped = true},
		},
		ResCheat = true
	})
	ArmyRightDefense:AddCommandMove(GetPosition("towndefpoint1"),true)
	ArmyRightDefense:AddCommandWaitForIdle(true)
	ArmyRightDefense:AddCommandDefend(GetPosition("towndefpoint1"), 4000, true)
end

function CreateMovableArmy()
    ArmyMovable = UnlimitedArmy:New({
		Player = 4,
		Area = 4000,
		Formation = UnlimitedArmy.Formations.Lines,
		LeaderFormation  = FormationFunktion,
		TransitAttackMove = true,
	})

	ArmyMovableRecruiter = UnlimitedArmyRecruiter:New(ArmyMovable, {
		Buildings = {
			Logic.GetEntityIDByName("barracksp4"),
			Logic.GetEntityIDByName("archeryp4"),
            Logic.GetEntityIDByName("archeryp42"),
			Logic.GetEntityIDByName("foundryp4"),
			Logic.GetEntityIDByName("stablep4"),
		},
		ArmySize = 7,
		UCats = {
			{UCat = UpgradeCategories.LeaderPoleArm, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderBow, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderRifle, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderSword, SpawnNum = 1, Looped = true},
            {UCat = UpgradeCategories.LeaderCavalry, SpawnNum = 1, Looped = true},
			{UCat = UpgradeCategories.LeaderHeavyCavalry, SpawnNum = 1, Looped = true},
			{UCat = UpgradeCategories.Cannon3, SpawnNum = 1, Looped = true},
		},
		ResCheat = true
	})
    ArmyMovable:AddCommandLuaFunc(defendPoint)
end

function defendPoint()
    ArmyMovable:ClearCommandQueue()
    local movepoints = {}
    local movepointsCount = 0
    ArmyMovable:AddCommandMove(GetPosition("towndefpoint1"))
    ArmyMovable:AddCommandWaitForIdle()
    if DEFENSEPOINT == 1 then
        local position = GetPosition("p1sword1")
        if AreEntitiesInArea( 1, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        local position = GetPosition("p1sword2")
        if AreEntitiesInArea( 1, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        if movepointsCount == 0 then
            table.insert(movepoints, GetPosition("spvillage1"))
            movepointsCount = movepointsCount + 1
        end
    elseif DEFENSEPOINT == 2 then
        local position = GetPosition("attackSonnspitzLeft")
        if AreEntitiesInArea( 2, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        local position = GetPosition("attackSonnspitzRight1")
        if AreEntitiesInArea( 2, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        if movepointsCount == 0 then
            table.insert(movepoints, GetPosition("spvillage2"))
            movepointsCount = movepointsCount + 1
        end
    elseif DEFENSEPOINT == 3 then
        local position = GetPosition("p3hcav1")
        if AreEntitiesInArea( 3, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        local position = GetPosition("p3hcav2")
        if AreEntitiesInArea( 3, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        if movepointsCount == 0 then
            table.insert(movepoints, GetPosition("sp3village"))
            movepointsCount = movepointsCount + 1
        end
    else
        local position = GetPosition("towndefpoint1")
        if AreEntitiesInArea( 4, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        local position = GetPosition("towndefmiddle")
        if AreEntitiesInArea( 4, 0, position, 2000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        local position = GetPosition("townleftdef")
        if AreEntitiesInArea( 4, 0, position, 5000, 1) then
            table.insert(movepoints, position)
            movepointsCount = movepointsCount + 1
        end
        if movepointsCount == 0 then
            table.insert(movepoints, GetPosition("towndefpoint3"))
            movepointsCount = movepointsCount + 1
        end
    end
    for i, position in ipairs(movepoints) do
        ArmyMovable:AddCommandMove(position, true)
        ArmyMovable:AddCommandWaitForIdle(true)
    end
    LASTDEFENSEPOINT = DEFENSEPOINT
end

function ExpandDefenseArmies()
    if Modulo(Counter.GetTick("TIMER"),900) == 0 then
        ArmyLeftDefenseRecruiter.ArmySize = ArmyMiddleDefenseRecruiter.ArmySize + 1
        ArmyMiddleDefenseRecruiter.ArmySize = ArmyMiddleDefenseRecruiter.ArmySize + 1
        ArmyRightDefenseRecruiter.ArmySize = ArmyRightDefenseRecruiter.ArmySize + 1
        ArmyMovableRecruiter.ArmySize = ArmyMovableRecruiter.ArmySize + 1
    end
end

function createTributeP4MovableArmy(_pid)
    local Tribute = {
        pId = 1,
        text = "Südfang soll Spieler " .. _pid .. " unterstützen.",
        cost = {},
        Callback = function ()
            DEFENSEPOINT = _pid
            StartCountdown(1,function ()
                createTributeP4MovableArmy(_pid)
                defendPoint()
            end,false)
        end
    }

    AddTribute(Tribute)
end

function createTributeP4MovableArmySelf()
    local Tribute = {
        pId = 1,
        text = "Südfang soll sich selbst verteidigen.",
        cost = {},
        Callback = function ()
            DEFENSEPOINT = 4
            StartCountdown(1,createTributeP4MovableArmySelf,false)
            defendPoint()
        end
    }

    AddTribute(Tribute)
end