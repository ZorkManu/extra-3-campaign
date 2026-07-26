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

function Modulo(_A, _B)
    while _A >= _B do
        _A = _A - _B
    end
    return _A
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

gvLighthouse = {
	delay = 60 + math.random(30),
	troopamount = 2 + math.random(4),
	techlevel = 1 + math.random(2),
	troops = {
		Entities.PU_LeaderSword1,
		Entities.PU_LeaderPoleArm1,
		Entities.PU_LeaderBow1,
		Entities.PU_LeaderRifle1,
		Entities.PU_LeaderCavalry1,
		Entities.PU_LeaderHeavyCavalry1,
		Entities.PU_LeaderSword2,
		Entities.PU_LeaderPoleArm2,
		Entities.PU_LeaderBow2,
		Entities.PU_LeaderSword3,
		Entities.PU_LeaderPoleArm3,
		Entities.PU_LeaderBow3,
		Entities.PU_LeaderSword4,
		Entities.PU_LeaderPoleArm4,
		Entities.PU_LeaderBow4,
		Entities.PU_LeaderRifle2,
		Entities.PU_LeaderCavalry2,
		Entities.PU_LeaderHeavyCavalry2,
		Entities.PU_LeaderUlan1
	},
	soldieramount = 1 + math.random(6),
	soldiercavamount = 1 + math.random(5),
	starttime = {},
	cooldown = 300,
	villageplacesneeded = 10 + math.random(5),
	UpdateTroopQuality = function(_time)
		gvLighthouse.troopamount = math.max(gvLighthouse.troopamount, math.min(round(3 ^ (1 + 60 / 10000)), 10))
		gvLighthouse.soldieramount = math.max(gvLighthouse.soldieramount, math.min(round(2 ^ (1 + 60 / 2000)), 12))
		if table.getn(gvLighthouse.troops) > 14 then
			table.remove(gvLighthouse.troops, math.random(1, table.getn(gvLighthouse.troops) - 14))
		elseif table.getn(gvLighthouse.troops) > 6 and table.getn(gvLighthouse.troops) <= 14 then
			table.remove(gvLighthouse.troops, math.random(1, table.getn(gvLighthouse.troops) - 6))
		end
	end
}

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

function getRandomGhostMeleeTroop()
    if math.random(1,2) == 1 then
        return Entities.PU_LeaderSword1_Spectral
    else
        return Entities.PU_LeaderPoleArm1_Spectral
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