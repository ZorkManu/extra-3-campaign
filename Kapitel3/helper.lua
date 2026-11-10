function Modulo(_A, _B)
    while _A >= _B do
        _A = _A - _B
    end
    return _A
end

function GetPlayerLeaderIds(_player)
    local leaderIds = {}
    local firstLeaderId = Logic.GetNextLeader(_player, 0)
    if firstLeaderId == 0 then
        return leaderIds
    end

    local currentLeaderId = firstLeaderId
    repeat
        table.insert(leaderIds, currentLeaderId)
        currentLeaderId = Logic.GetNextLeader(_player, currentLeaderId)
    until currentLeaderId == firstLeaderId

    return leaderIds
end

function createGeneralSpawner(_playerId, strength, position, rodeLength, respawnTime, spawnGenerator, spawnTypes, endless, advance, _generatorName, _redeployPosition, enemySearchPosition)
    local generatorName = _generatorName or (spawnGenerator .. (advance and "Advance" or "Defense"))
    if enemySearchPosition then
        enemySearchPosition = GetPosition(enemySearchPosition)
    end
    Armies[CONST_ARMY_INDEX] = {
        player = _playerId,
        id = GetFirstFreeArmySlot(_playerId),
        strength = strength,
        position = GetPosition(position),
        rodeLength = rodeLength,
        respawnTime = respawnTime,
        spawnGenerator = GetEntityId(spawnGenerator),
        spawnTypes = spawnTypes,
        endless = endless,
        generatorName = generatorName,
        enemySearchPosition = enemySearchPosition,
    }

    SetupArmy(Armies[CONST_ARMY_INDEX])

    SetupAITroopSpawnGenerator(generatorName, Armies[CONST_ARMY_INDEX])

    if _redeployPosition then
        Redeploy(Armies[CONST_ARMY_INDEX], GetPosition(_redeployPosition))
    end

    if advance == true then
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyAdvanceSpawner" , 1, {}, {CONST_ARMY_INDEX, spawnGenerator})
    else
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendSpawner" , 1, {}, {CONST_ARMY_INDEX, spawnGenerator})
    end

    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function GetHealth( _entity )
	local entityID = GetEntityId( _entity );
 
	if not Tools.IsEntityAlive( entityID ) then
		return 0;
	end
	local maxHealth = Logic.GetEntityMaxHealth( entityID );
	local health = Logic.GetEntityHealth( entityID );
 
	return ( health / maxHealth ) * 100;
end

function AreEnemiesInArea( _player, _position, _range)
    return AreEntitiesOfDiplomacyStateInArea( _player, _position, _range, Diplomacy.Hostile )
end
function AreEntitiesOfDiplomacyStateInArea( _player, _position, _range, _state )
    for i = 1,8 do
        if Logic.GetDiplomacyState( _player, i) == _state then
            if AreEntitiesInArea( i, 0, _position, _range, 1) then
                return true
            end
        end
    end
    return false
end

function UseHeroAbility(_Hero, _Ability, _Definitely) -- source: https://dedk.de/wiki/doku.php?id=utilfunctions:useheroability
 
    -- Get hero ID
    local HeroID = GetEntityId(_Hero)
 
    -- Is ability supported?
    assert(Logic.HeroIsAbilitySupported(HeroID, _Ability) == 1, "Ability not supported")
 
    if _Definitely ~= nil and _Definitely then
        -- Make sure the ability is completely charged
        local NeededTime = Logic.HeroGetAbilityRechargeTime(HeroID, _Ability)
        Logic.HeroSetAbilityChargeSeconds(HeroID, _Ability, NeededTime)
    end
 
    -- Use Ability
    if _Ability == Abilities.AbilityRangedEffect then
        GUI.SettlerAffectUnitsInArea(HeroID)
    elseif _Ability == Abilities.AbilityCircularAttack then
        GUI.SettlerCircularAttack(HeroID)
    elseif _Ability == Abilities.AbilityInflictFear then
        GUI.SettlerInflictFear(HeroID)
    elseif _Ability == Abilities.AbilityCamouflage then
        GUI.SettlerCamouflage(HeroID)
    elseif _Ability == Abilities.AbilitySummon then
        GUI.SettlerSummon(HeroID)
    elseif _Ability == Abilities.AbilityMotivateWorkers then
        GUI.SettlerMotivateWorkers(HeroID)
    else
        -- Ability not allowed cause it needs a target
        assert(false, "Ability not allowed")
    end
 
end

function UseNecroAbility(_Hero) -- source: https://dedk.de/wiki/doku.php?id=utilfunctions:useheroability
 
    -- Get hero ID
    local HeroID = GetEntityId(_Hero)
	local Ability = Abilities.AbilityCircularAttack


    if Logic.HeroGetAbilityRechargeTime(HeroID, Ability) == Logic.HeroGetAbiltityChargeSeconds(HeroID, Ability) then
		GUI.SettlerCircularAttack(HeroID)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "countdownNecroArmy" , 1, {}, {_Hero})
		return true
	end
	return false
end

function countdownNecroArmy(_NecroNo)
	if Counter.Tick2("countdownNecroArmy" .. _NecroNo, 1) then
        if IsDead(_NecroNo) then
            return true
        end
		createNecroArmy(_NecroNo)
		return true
	end
end

function DisplaySpecialNames() --Quelle fritz_98: Der edle Lord Buck
    SpecialNames = {
        Necro = "Nekromant",
		Necro1 = "Nekromant",
		Necro2 = "Nekromant",
		Necro3 = "Nekromant",
		Necro4 = "Nekromant",
		Necro5 = "Nekromant",
		Necro6 = "Nekromant",
		Necro7 = "Nekromant",
		Necro8 = "Nekromant",
		Necro9 = "Nekromant",
        Kardinel = "Kardinel",
        Schwarz = "Schwarz"
    }
    function GUIUpdate_SelectionName()
        local EntityId = GUI.GetSelectedEntity()
        local EntityName = Logic.GetEntityName(EntityId)
        if SpecialNames[EntityName] then
            XGUIEng.SetText(gvGUI_WidgetID.SelectionName, SpecialNames[EntityName])
            return
        end

        local EntityType = Logic.GetEntityType(EntityId)
        local EntityTypeName = Logic.GetEntityTypeName(EntityType)
        if EntityTypeName == nil then
            return
        end
        local StringKey = "names/" .. EntityTypeName
        XGUIEng.SetTextKeyName(gvGUI_WidgetID.SelectionName, StringKey)
    end
end

function armyOverrides()
    function CheckForBetterTarget(_eID, _target, _range)

        if not Logic.IsEntityAlive(_eID) then
            return
        end
    
        local sector = Logic.GetSector(_eID)
        local player = Logic.EntityGetPlayer(_eID)
        local etype = Logic.GetEntityType(_eID)
        local IsTower = (Logic.IsEntityInCategory(_eID, EntityCategories.MilitaryBuilding) == 1
            and CEntity.GetAttachedEntities(_eID)[55] and _eID == Logic.GetFoundationTop(CEntity.GetAttachedEntities(_eID)[55][1]))
        local IsMelee = (Logic.IsEntityInCategory(_eID, EntityCategories.Melee) == 1)
        local IsHero = (Logic.IsEntityInCategory(_eID, EntityCategories.Hero) == 1)
        local posX, posY = Logic.GetEntityPosition(_eID)
        local maxrange = GetEntityTypeMaxAttackRange(_eID, player)
        local bonusRange = 500
        local damageclass = GetEntityTypeDamageClass(etype)
        local damagerange = GetEntityTypeDamageRange(etype)
        local calcT = {}
        if IsMelee then
            bonusRange = bonusRange * 2
        end
        if IsHero then
            local flag = gvHeroAbilities.HeroAbilityControl(_eID)
            if flag then
                return -1
            end
        end
        if gvAntiBuildingCannonsRange[etype] then
            local res
            local target_eval = function(_target1, _target2, _eID)
                if Logic.GetDiplomacyState(Logic.EntityGetPlayer(_target1), Logic.EntityGetPlayer(_eID)) ~= Diplomacy.Hostile then
                    return _target2
                end
                if _target1 and Logic.IsBuilding(_target1) == 0 and IsValid(_target2) then
                    return _target2
                elseif _target1 and Logic.IsBuilding(_target1) == 1 then
                    if _target2 and Logic.IsBuilding(_target2) == 1 then
                        return _target2
                    else
                        if IsValid(_target1) then
                            return _target1
                        end
                    end
                elseif not _target1 and IsValid(_target2) then
                    return _target2
                end
            end
            local target = BS.CheckForNearestHostileBuildingInAttackRange(_eID, (_range or maxrange) + gvAntiBuildingCannonsRange[etype])
            local army = GetArmyByLeaderID(_eID)
            if army then
                local tab
                if type(army) == "string" then
                    tab = MapEditor_Armies[player][army]
                else
                    tab = ArmyTable[player][army+1]
                end
                if target
                and target == tab[_eID].currenttarget
                and GetDistance(_eID, target) > maxrange
                and Logic.GetTime() < tab[_eID].lasttime + 10 then
                else
                    res = target_eval(_target, target, _eID)
                end
            else
                res = target_eval(_target, target, _eID)
            end
            if res then
                return res
            end
        end
        if _target and Logic.IsEntityAlive(_target) and Logic.GetDiplomacyState(_target, player) == Diplomacy.Hostile
        and (IsMelee and sector == Logic.GetSector(_target)
        or not IsMelee) then
            calcT[1] = {id = _target, factor = DamageFactorToArmorClass[damageclass][GetEntityTypeArmorClass(Logic.GetEntityType(_target))], dist = GetDistance(_eID, _target)}
        end
    
        local postable = {}
        local clumpscore
        local attach
        ChunkWrapper.UpdatePositions(AIchunks[player])
        local entities = ChunkWrapper.GetEntitiesInAreaInCMSorted(AIchunks[player], posX, posY, _range or maxrange + bonusRange)
    
        if not next(entities) then
            if not next(calcT) then
                return
            else
                return calcT[1].id
            end
        end
        for i = 1, table.getn(entities) do
            if Logic.IsEntityAlive(entities[i]) then
                local ety = Logic.GetEntityType(entities[i])

                attach = CEntity.GetAttachedEntities(entities[i])[37]
                local damagefactor = DamageFactorToArmorClass[damageclass][GetEntityTypeArmorClass(ety)]
                if damagerange > 0 and (not gvAntiBuildingCannonsRange[etype] or etype == Entities.PV_Cannon6 or etype == Entities.PV_Cannon6_2) then
                    local mul = 1
                    if Logic.IsLeader(entities[i]) == 1 then
                        mul = 1 + Logic.LeaderGetNumberOfSoldiers(entities[i])
                    end
                    table.insert(postable, {pos = GetPosition(entities[i]), factor = damagefactor * mul + (threatbonus or 0)})
                end
                table.insert(calcT, {id = entities[i], factor = damagefactor + (threatbonus or 0), dist = GetDistance(_eID, entities[i])})
            end
        end
        local attachN = attach and table.getn(attach) or 0
        if damagerange > 0 and (not gvAntiBuildingCannonsRange[etype] or etype == Entities.PV_Cannon6 or etype == Entities.PV_Cannon6_2) then
            if next(postable) then
                clumppos, score = GetPositionClump(postable, damagerange, 100)
                for i = 1, table.getn(calcT) do
                    calcT[i].clumpscore = score / GetDistance(clumppos, GetPosition(calcT[i].id))
                end
            end
        end
        local distval = function(_dist, _range)
            if _dist > _range then
                if IsMelee then
                    return (_dist - _range) / _range
                else
                    return math.sqrt((_dist - _range) / _range)
                end
            else
                return 0
            end
        end
        table.sort(calcT, function(p1, p2)
            if p1.clumpscore then
                if IsTower then
                    return p1.clumpscore * p1.factor > p2.clumpscore * p2.factor
                else
                    return p1.clumpscore + p1.factor - distval(p1.dist, maxrange) > p2.clumpscore + p2.factor - distval(p2.dist, maxrange)
                end
            else
                return (p1.factor * 10 - distval(p1.dist, maxrange) - attachN) > (p2.factor * 10 - distval(p2.dist, maxrange) - attachN)
            end
        end)
        if next(calcT) then
            if IsMelee then
                for i = 1, table.getn(calcT) do
                    if sector == Logic.GetSector(calcT[i].id) then
                        return calcT[i].id
                    end
                end
            else
                return calcT[1].id
            end
        end
    end

    -- Comfort to get the armyID by leaderID
--player needs active armies!
---@param _id integer leaderID
---@return integer armyID
GetArmyByLeaderID = function(_id)
	assert(IsValid(_id), "invalid entityID")
	assert(Logic.IsLeader(_id) == 1, "entityID must be a leader")
	local player = Logic.EntityGetPlayer(_id)
	--assert((ArmyTable and ArmyTable[player]) or (MapEditor_Armies and MapEditor_Armies[player]), "player ID ".. player .." has no armies")
	if ArmyTable and ArmyTable[player] then
		for k, v in pairs(ArmyTable[player]) do
			if v.IDs and table.getn(v.IDs) and table.getn(v.IDs) > 0 then
				if table_findvalue(v.IDs, _id) ~= 0 then
					return k - 1
				end
			end
		end
	end
	if MapEditor_Armies and MapEditor_Armies[player] then
		for k, v in pairs(MapEditor_Armies[player].armies[1].defensiveArmies) do
			if k == "IDs" and table.getn(v) and table.getn(v) > 0 then
				if table_findvalue(v, _id) ~= 0 then
					return "defensiveArmies"
				end
			end
		end
		for k, v in pairs(MapEditor_Armies[player].armies[1].offensiveArmies) do
			if k == "IDs" and table.getn(v) and table.getn(v) > 0 then
				if table_findvalue(v, _id) ~= 0 then
					return "offensiveArmies"
				end
			end
		end
	end
end
end

function getRandomGhostMeleeTroop()
    if math.random(1,2) == 1 then
        return Entities.PU_LeaderSword1_Spectral
    else
        return Entities.PU_LeaderPoleArm1_Spectral
    end
end

function getRandomGhostTroop()
    local randomGenerator = math.random()
    if randomGenerator < 0.25 then
        return Entities.PU_LeaderSword1_Spectral
    elseif randomGenerator < 0.50 then
        return Entities.PU_LeaderPoleArm1_Spectral
    elseif randomGenerator < 0.75 then
        return Entities.PU_LeaderBow1_Spectral
    else
        return Entities.PU_LeaderRifle1_Spectral
    end
end

function getRandomNVTroop()
    local randomGenerator = math.random()
    if randomGenerator < 0.50 then
        return Entities.CU_Evil_LeaderBearman1
    elseif randomGenerator < 0.75 then
        return Entities.CU_Evil_LeaderSkirmisher1
    else
        return Entities.CU_Evil_LeaderSpearman1
    end
end