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

function Overrides()

    MapEditor_GetArmyDefaultDescription = function(_strength)
        local description = {
            serfLimit		=	(_strength^2)+2,
            extracting		=	true,
            extractResourcesData = {
                active = true,
                priorityOrder = {
                    {entityType = Entities.XD_ResourceTree, resourceType = ResourceType.WoodRaw},
                    {entityType = Entities.XD_Silver1, resourceType = ResourceType.SilverRaw},
                    {entityType = Entities.XD_Clay1, resourceType = ResourceType.ClayRaw},
                    {entityType = Entities.XD_Stone1, resourceType = ResourceType.StoneRaw},
                    {entityType = Entities.XD_Stone_BlockPath, resourceType = ResourceType.StoneRaw},
                    {entityType = Entities.XD_Stone_BlockPath_Med, resourceType = ResourceType.StoneRaw},
                    {entityType = Entities.XD_Iron1, resourceType = ResourceType.IronRaw},
                    {entityType = Entities.XD_Sulfur1, resourceType = ResourceType.SulfurRaw}
                },
                searchRange = 2000,
                idleTreshold = 12
            },
            resources = {
                gold		=	1000,
                clay		=	1800,
                iron		=	1000,
                sulfur		=	1000,
                stone		=	1800,
                wood		=	10000
            },
            refresh = {
                gold		=	1000,
                clay		=	0,
                iron		=	0,
                sulfur		=	50,
                stone		=	0,
                wood		=	1000,
                updateTime	=	30
            },
            repairing		= 	true,
            constructing	=	true,
            rebuildData = {
                delay							= 30*(5-_strength),
                randomTime						= 15*(5-_strength),
                MaxAttemptsPreferredPosition 	= 5
            }
        }
        return description
    end


    MapEditor_SetupAI = function(_playerId, _strength, _range, _techlevel, _position, _aggressiveLevel, _peaceTime, _multiTrain, _defenseRange, _attackPosition, _baitDetection)

        -- Valid
        if 	_strength == 0 or _strength > 3 or
        _techlevel < 0 or _techlevel > 3 or
        _playerId < 1 or _playerId > 16 or
        _aggressiveLevel < 0 or _aggressiveLevel > 3 or
        type(_position) ~= "string" then
            assert(false, "wrong input detected; aborting")
            return
        end
    
        -- get position
        local position = GetPosition(_position)
    
        -- check for buildings
        if Logic.GetPlayerEntitiesInArea(_playerId, 0, position.X, position.Y, 0, 1, 8) == 0 then
            return
        end
    
        -- army
        if MapEditor_Armies == nil then
            MapEditor_Armies = {}
        end
        if MapEditor_Armies.controlerId == nil then
            MapEditor_Armies.controlerId = {offensiveArmies = {}, defensiveArmies = {}}
        end
        if not MapEditor_Armies[_playerId] then
            MapEditor_Armies[_playerId] = {
                description = MapEditor_GetArmyDefaultDescription(_strength),
                prioritylist = {},
                prioritylist_lastUpdate = 0,
                multiTraining = _multiTrain or true,
                player = _playerId,
                id = 0,
                techLVL = _techlevel,
                aggressiveLVL =	_aggressiveLevel,
                TroopRecruitmentDelay = 11 - (3*_aggressiveLevel),
                ForbiddenTypes = {},
                RebuildExcludedTypes = {Entities.PB_Headquarters1, Entities.PB_Headquarters2, Entities.PB_Headquarters3, Entities.CB_RobberyTower1},
                RebuildExcludedIDs = {},
                RebuildBuildingData = {},
                armies = {}
            }
            -- needed for building placement only allowed in vision range of player
            Logic.ActivateUpdateOfExplorationForAllPlayers()
            --
            MapEditor_Armies[_playerId].ControlHomeSectorTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "MapEditor_Armies_RefreshHomeSector", 1, {}, {_playerId, _position})
            MapEditor_Armies[_playerId].RebuildTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "MapEditor_Armies_BuildingDestroyed", 1, {}, {_playerId})
            MapEditor_Armies[_playerId].CSiteSerfControlTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "MapEditor_Armies_AttachSerfsToCSites", 1, {}, {_playerId})
            MapEditor_Armies[_playerId].SerfExtractingControlTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "MapEditor_Armies_SendSerfsToResourceExtracting", 1, {}, {_playerId})
        end
    
        -- ulan only on tech lvl 3
        if _techlevel < 3 then
            table.insert(MapEditor_Armies[_playerId].ForbiddenTypes, UpgradeCategories.LeaderUlan)
        end
        -- rifle only on tech lvl 1 and above
        if _techlevel < 1 then
            table.insert(MapEditor_Armies[_playerId].ForbiddenTypes, UpgradeCategories.LeaderRifle)
        end
    
        -- Upgrade entities
        for i=1,_techlevel do
            Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, _playerId)
            Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, _playerId)
            Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, _playerId)
        end
        if _techlevel == 3 then
            Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry, _playerId)
            Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry, _playerId)
            Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, _playerId)
        end
    
        SetupPlayerAi(_playerId, MapEditor_Armies[_playerId].description)
        EvaluateArmyHomespots(_playerId, position, nil)
        --MapEditor_Armies[_playerId].Sector = CUtil.GetSector(ArmyHomespots[_playerId].recruited[1].X/100, ArmyHomespots[_playerId].recruited[1].Y/100)
        if IsValid(_position) then
            MapEditor_Armies[_playerId].Sector = Logic.GetSector(GetID(_position))
        elseif Logic.GetEntityAtPosition(position.X, position.Y) > 0 then
            MapEditor_Armies[_playerId].Sector = Logic.GetSector(Logic.GetEntityAtPosition(position.X, position.Y))
        else
            MapEditor_Armies[_playerId].Sector = EvaluateNearestUnblockedSector(position.X, position.Y, 2000, 100)
        end
        assert(MapEditor_Armies[_playerId].Sector ~= 0, "Evaluating army base sector failed! Aborting!")
    
        -- troop recruitment generator
        SetupAITroopGenerator("MapEditor_Armies_".._playerId, _playerId)
        --Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND, nil, "StartMapEditor_ArmyAttack", 1, nil, {_playerId, _peaceTime})
        --if MapEditor_Armies.controlerId.offensiveArmies[_playerId] == nil then
            --MapEditor_Armies.controlerId.offensiveArmies[_playerId] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {_playerId, "offensiveArmies"})
        --end
        --if MapEditor_Armies.controlerId.defensiveArmies[_playerId] == nil then
            --MapEditor_Armies.controlerId.defensiveArmies[_playerId] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMapEditor_Armies", 1, {}, {_playerId, "defensiveArmies"})
        --end
        if not AIchunks[_playerId] then
            AI_InitChunks(_playerId)
        end
        if _baitDetection then
            if not TRACK_AI_MOVEMENTS then
                TRACK_AI_MOVEMENTS = TRACK_AI_MOVEMENTS or {}
                function GameCallback_EntityMoved(_id, _x, _y, _x2, _y2, _distance)
                    if IsMilitaryLeader(_id) then
                        for i = 1, table.getn(TRACK_AI_MOVEMENTS) do
                            local player = TRACK_AI_MOVEMENTS[i]
                            if Logic.EntityGetPlayer(_id) == player and table_findvalue(MapEditor_Armies[player].offensiveArmies.IDs, _id) ~= 0 then
                                local range = GetEntityTypeMaxAttackRange(_id, player)
                                local dist = GetNearestEnemyDistance(player, {X = _x2, Y = _y2}, range + 500)
                                if dist and dist >= range * 2/3 then
                                    local t = MapEditor_Armies[player].offensiveArmies.IDs[_id]
                                    t.DistanceMoved = (t.DistanceMoved or 0) + _distance
                                end
                            end
                        end
                    end
                end
            end
            if not TRACK_AI_MOVEMENTS[_playerId] then
                table.insert(TRACK_AI_MOVEMENTS, _playerId)
            end
        end
    end

    AITroopGenerator_Action = function(_player)

        local _army = MapEditor_Armies[_player]
        local belowlimit = AITroopGenerator_IsBelowTroopLimit(_army)
        if belowlimit then
            local silver = Logic.GetPlayersGlobalResource(_player, ResourceType.SilverRaw) + Logic.GetPlayersGlobalResource(_player, ResourceType.Silver)
            local coal = Logic.GetPlayersGlobalResource(_player, ResourceType.Knowledge)
            -- Get entityType/Category (cannon = etype; else ucat)
            local eTyp, id = AITroopGenerator_EvaluateMilitaryBuildingsPriority(_player, _army.ForbiddenTypes)
    
            if eTyp then
                -- no leader only spam allowed; instead check resources + some spare for soldiers
                local cost = {}
                local enough = true
                Logic.FillLeaderCostsTable(_player, IsCannonType(eTyp) and Logic.LeaderGetUpgradeCategoryFromSoldierType(_player, eTyp) or eTyp, cost)
                for k, v in pairs(cost) do
                    if Logic.GetPlayersGlobalResource(_player, k) + Logic.GetPlayersGlobalResource(_player, k + 1) < v * 4 then
                        enough = false
                        break
                    end
                end
                if enough then
                    if _army.techLVL == 3 then
                        if eTyp == Entities.PV_Cannon1 then
                            if silver >= 100 and coal >= 500 then
                                eTyp = Entities.PV_Cannon5
                            else
                                eTyp = Entities.PV_Cannon3
                            end
                        elseif eTyp == Entities.PV_Cannon2 then
                            if silver >= 150 and coal >= 500 then
                                eTyp = Entities.PV_Cannon6
                            else
                                eTyp = Entities.PV_Cannon4
                            end
                        end
                    end
    
                    if _army.multiTraining and id then
                        if IsCannonType(eTyp) then
                            (SendEvent or CSendEvent).BuyCannon(id, eTyp)
                        else
                            Logic.BarracksBuyLeader(id, eTyp)
                        end
                    else
                        AI.Army_BuyLeader(_player, _army.id, eTyp)
                    end
                end
            end
        end
        return false
    
    end

    AITroopGenerator_EvaluateMilitaryBuildingsPriority = function(_player, _forbiddenTypes)

        if _player == 2 then
            for k, v in pairs(MapEditor_Armies[2].armies) do
                if not AITroopGeneratorArmy_IsAtTroopLimit(MapEditor_Armies[2],k) then
                    if type(k) == "number" and not IsDead(k) and MilitaryBuildingIsTrainingSlotFree(k) then
                        if k == GetEntityId("p2barracks") then
                            return UpgradeCategories.LeaderBandit,k
                        end
                        if k == GetEntityId("barrackstop") or k == GetEntityId("barracksbottom") or k == GetEntityId("barracksmiddle") or k == GetEntityId("barracksfinal") then
                            return math.random(2) == 1 and UpgradeCategories.LeaderSword or UpgradeCategories.LeaderPoleArm, k
                        end
                        if k == GetEntityId("archerytop") or k == GetEntityId("archerybottom") or k == GetEntityId("archerymiddletop") or k == GetEntityId("archerymiddlebottom") or k == GetEntityId("archeryfinal") then
                            return math.random(2) == 1 and UpgradeCategories.LeaderBow or UpgradeCategories.LeaderRifle, k
                        end
                        if k == GetEntityId("foundrymiddletop") or k == GetEntityId("foundrymiddlebottom") then
                            return Entities.PV_Cannon3, k
                        end
                        if k == GetEntityId("stablemiddle") then
                            return math.random(2) and UpgradeCategories.LeaderHeavyCavalry or UpgradeCategories.LeaderCavalry, k
                        end
                    elseif string.sub(k, 1, 16) == "patrolwallbottom" then
                        local archeryID = GetEntityId("archerymiddlebottom")
                        if not IsDead(archeryID) and MilitaryBuildingIsTrainingSlotFree(archeryID) then
                            return UpgradeCategories.LeaderBow, archeryID
                        end
                    elseif string.sub(k, 1, 13) == "patrolwalltop" then
                        local archeryID = GetEntityId("archerymiddletop")
                        if not IsDead(archeryID) and MilitaryBuildingIsTrainingSlotFree(archeryID) then
                            return UpgradeCategories.LeaderBow, archeryID
                        end
                    elseif string.sub(k, 1, 13) == "patrolwallbig" then
                        local archeryID = GetEntityId("archeryfinal")
                        if not IsDead(archeryID) and MilitaryBuildingIsTrainingSlotFree(archeryID) then
                            return UpgradeCategories.LeaderBow, archeryID
                        end
                    elseif string.sub(k, 1, 6) == "patrol" then
                        local barracksID = GetEntityId("barracksfinal")
                        local archeryID = GetEntityId("archeryfinal")
                        local barracks
                        local archery
                        if not IsDead(barracksID) and MilitaryBuildingIsTrainingSlotFree(barracksID) then
                            barracks = math.random(2) == 1 and UpgradeCategories.LeaderSword or UpgradeCategories.LeaderPoleArm
                        end
                        if not IsDead(archeryID) and MilitaryBuildingIsTrainingSlotFree(archeryID) then
                            archery = math.random(2) == 1 and UpgradeCategories.LeaderBow or UpgradeCategories.LeaderRifle
                        end

                        if barracks and archery then
                            if math.random(2) == 1 then
                                return barracks, barracksID
                            else
                                return archery, archeryID
                            end
                        end
                        
                        if barracks then
                            return barracks, barracksID
                        end
                        
                        if archery then
                            return archery, archeryID
                        end
                    end
                end
            end
            return false
        end

        local num = {}
        num.Barracks, num.Archery, num.Stable, num.Foundry = AI.Village_GetNumberOfMilitaryBuildings(_player)
        num.MercenaryTower = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_player, Entities.PB_MercenaryTower)
        if MapEditor_Armies[_player].prioritylist_lastUpdate == 0 or Logic.GetTime() > MapEditor_Armies[_player].prioritylist_lastUpdate + 30 then
            local armorclasspercT = GetPercentageOfLeadersPerArmorClass(AIEnemiesAC[_player])
            for i = 1,7 do
                local bestdclass = BS.GetBestDamageClassByArmorClass(armorclasspercT[i].id)
                local ucat = GetUpgradeCategoryInDamageClass(bestdclass)
                for k,v in pairs(BS.CategoriesInMilitaryBuilding) do
                    local tpos = table_findvalue(v, ucat)
                    if tpos ~= 0 then
                        if num[k] > 0 then
                            if table_findvalue(_forbiddenTypes, v[tpos]) == 0 then
                                MapEditor_Armies[_player].prioritylist[i] = {name = k, typ = v[tpos]}
                            else
                                table.remove(MapEditor_Armies[_player].prioritylist, i)
                            end
                        end
                    end
                end
            end
            MapEditor_Armies[_player].prioritylist_lastUpdate = Logic.GetTime()
        end
        if MapEditor_Armies[_player].multiTraining then
            if num.Foundry > 0 then
                local MapEditor_Armies_FoundryTypes = {Entities.PB_Foundry1, Entities.PB_Foundry2}
                if MapEditor_Armies[_player].techLVL > 2 then
                    -- high tier cannons can only be produced at lvl2 foundry
                    MapEditor_Armies_FoundryTypes = {Entities.PB_Foundry2}
                end
                for id in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_player), CEntityIterator.OfAnyTypeFilter(unpack(MapEditor_Armies_FoundryTypes))) do
                    if MilitaryBuildingIsTrainingSlotFree(id) then
                        local types = {Entities.PV_Cannon1, Entities.PV_Cannon2}
                        for i = table.getn(types), 1, -1 do
                            if table_findvalue(_forbiddenTypes, types[i]) > 0 then
                                table.remove(types, i)
                            end
                        end
                        return (next(types) and types[math.random(1, table.getn(types))]), id
                    end
                end
            end
            for k, v in pairs(MapEditor_Armies[_player].prioritylist) do
                if v.name == "MercenaryTower" then
                    for id in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_player), CEntityIterator.OfAnyTypeFilter(Entities["PB_"..v.name])) do
                        if MilitaryBuildingIsTrainingSlotFree(id) then
                            return v.typ, id
                        end
                    end
                else
                    for id in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_player), CEntityIterator.OfAnyTypeFilter(Entities["PB_"..v.name.."1"], Entities["PB_"..v.name.."2"])) do
                        if Logic.GetEntityType(id) ~= Entities.PB_Foundry1 then
                            if MilitaryBuildingIsTrainingSlotFree(id) then
                                return v.typ, id
                            end
                        end
                    end
                end
            end
        else
            if num.Foundry > 0 and (MilitaryBuildingIsTrainingSlotFree(({Logic.GetPlayerEntities(_player, Entities.PB_Foundry1, 1)})[2]) or MilitaryBuildingIsTrainingSlotFree(({Logic.GetPlayerEntities(_player, Entities.PB_Foundry2, 1)})[2])) then
                local types = {Entities.PV_Cannon1, Entities.PV_Cannon2}
                for i = table.getn(types), 1, -1 do
                    if table_findvalue(_forbiddenTypes, types[i]) > 0 then
                        table.remove(types, i)
                    end
                end
                return (next(types) and types[math.random(1, table.getn(types))])
            end
            for k, v in pairs(MapEditor_Armies[_player].prioritylist) do
                local entity = ({Logic.GetPlayerEntities(_player, Entities["PB_"..v.name.."1"], 1)})[2] or ({Logic.GetPlayerEntities(_player, Entities["PB_"..v.name.."2"], 1)})[2] or ({Logic.GetPlayerEntities(_player, Entities["PB_"..v.name], 1)})[2]
                if entity then
                    if MilitaryBuildingIsTrainingSlotFree(entity) then
                        return v.typ
                    end
                end
            end
        end
    end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---@param _army table army table
    ---@return boolean
    AITroopGenerator_IsAtTroopLimit = function(_army)
        local numtroops = 0
        local maxstrength = 0
        for i in pairs(_army.armies) do
            if _army.armies[i].patrolArmies then
                numtroops = numtroops + table.getn(_army.armies[i].patrolArmies.IDs)
                maxstrength = maxstrength + _army.armies[i].patrolArmies.strength
            end
            numtroops = numtroops + table.getn(_army.armies[i].offensiveArmies.IDs) + table.getn(_army.armies[i].defensiveArmies.IDs)
            maxstrength = maxstrength + _army.armies[i].offensiveArmies.strength + _army.armies[i].defensiveArmies.strength
        end
        return numtroops >= maxstrength
    end

    ---@param _army table army table
    ---@return boolean
    AITroopGeneratorArmy_IsAtTroopLimit = function(_army, _buildingId)
        local numtroops = 0
        local maxstrength = 0
        if _army.armies[_buildingId].patrolArmies then
            numtroops = numtroops + table.getn(_army.armies[_buildingId].patrolArmies.IDs)
            maxstrength = maxstrength + _army.armies[_buildingId].patrolArmies.strength
        end
        numtroops = numtroops + table.getn(_army.armies[_buildingId].offensiveArmies.IDs) + table.getn(_army.armies[_buildingId].defensiveArmies.IDs)
        maxstrength = maxstrength + _army.armies[_buildingId].offensiveArmies.strength + _army.armies[_buildingId].defensiveArmies.strength
        return numtroops >= maxstrength
    end

    AITroopGenerator_CheckLeaderAttachedToBarracks = function(_player, _id)
        local buildingID = Logic.LeaderGetBarrack(_id)
        if buildingID ~= 0 then
            if _player == 3 or _player == 4 then
                buildingID = 1
            end

            local _type
            local tab = MapEditor_Armies[_player]
            local armyID = buildingID

            if buildingID == GetEntityId("archerymiddletop") then
                if tab.armies["patrolwalltop"].patrolArmies ~= nil then
                    if table.getn(tab.armies["patrolwalltop"].patrolArmies.IDs) < tab.armies["patrolwalltop"].patrolArmies.strength then
                        _type = "patrolArmies"
                        armyID = "patrolwalltop"
                    end
                end
            elseif buildingID == GetEntityId("archerymiddlebottom") then
                if tab.armies["patrolwallbottom"].patrolArmies ~= nil then
                    if table.getn(tab.armies["patrolwallbottom"].patrolArmies.IDs) < tab.armies["patrolwallbottom"].patrolArmies.strength then
                        _type = "patrolArmies"
                        armyID = "patrolwallbottom"
                    end
                end
            elseif buildingID == GetEntityId("barracksfinal") or buildingID == GetEntityId("archeryfinal") then
                if buildingID == GetEntityId("archeryfinal") then
                    for i = 1, 3 do
                        if tab.armies["patrolwallbig" .. i].patrolArmies ~= nil then
                            if table.getn(tab.armies["patrolwallbig" .. i].patrolArmies.IDs) < tab.armies["patrolwallbig" .. i].patrolArmies.strength then
                                _type = "patrolArmies"
                                armyID = "patrolwallbig" .. i
                            end
                        end
                    end
                end
                if armyID == buildingID then
                    for i = 1, P2PatrolArmies do
                        if tab.armies["patrol" .. i].patrolArmies ~= nil then
                            if table.getn(tab.armies["patrol" .. i].patrolArmies.IDs) < tab.armies["patrol" .. i].patrolArmies.strength then
                                _type = "patrolArmies"
                                armyID = "patrol" .. i
                            end
                        end
                    end
                end
            end

            if Logic.IsEntityInCategory(_id, EntityCategories.Cannon) == 1 then
                _type = "offensiveArmies"
            end
            if not _type then
                if tab.armies[buildingID] then
                    if table.getn(tab.armies[buildingID].defensiveArmies.IDs) < tab.armies[buildingID].defensiveArmies.strength then
                        _type = "defensiveArmies"
                    elseif table.getn(tab.armies[buildingID].offensiveArmies.IDs) < tab.armies[buildingID].offensiveArmies.strength then
                        _type = "offensiveArmies"
                    end
                end
            end
            table.insert(tab.armies[armyID][_type].IDs, _id)
            tab.armies[armyID][_type][_id] = tab.armies[armyID][_type][_id] or {}
            tab.armies[armyID][_type][_id].TriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "AITroopGenerator_RemoveLeader", 1, {}, {_player, _id, _type, armyID})
            tab.armies[armyID][_type][_id].IdleCheck = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "AITroopGenerator_CheckForIdle", 1, {}, {_player, _id, _type, armyID})
            tab.armies[armyID][_type][_id].HomespotIndex = math.random(1, table.getn(ArmyHomespots[_player].recruited))
        end
        return true
    end

    AITroopGenerator_CheckForIdle = function(_player, _id, _spec, _armyId)
        if not IsValid(_id) then
            return true
        end
        local tab = MapEditor_Armies[_player].armies[_armyId][_spec][_id]
        if tab.HomespotReached then
            return true
        end
        if Logic.GetCurrentTaskList(_id) == "TL_MILITARY_IDLE"
        or (Logic.GetCurrentTaskList(_id) == "TL_VEHICLE_IDLE" and not next(CEntity.GetReversedAttachedEntities(_id))) then
    
            local index = (tab and tab.HomespotIndex) or math.random(1, table.getn(ArmyHomespots[_player].recruited))
            local anchor = MapEditor_Armies[_player].armies[_armyId][_spec].position or ArmyHomespots[_player].recruited[index]
            local pos = GetPosition(_id)
            local MilitaryBuildingID = Logic.LeaderGetNearbyBarracks(_id)

            if _spec == "patrolArmies" then
                if Logic.LeaderGetNumberOfSoldiers(_id)
                    < Logic.LeaderGetMaxNumberOfSoldiers(_id)
                then
                    return false
                end
            end

    
            if MilitaryBuildingID ~= 0 then
                if Logic.IsConstructionComplete(MilitaryBuildingID) == 1 then
                    if Logic.IsEntityInCategory(_id, EntityCategories.Cannon) == 1
                    or (Logic.LeaderGetNumberOfSoldiers(_id) == Logic.LeaderGetMaxNumberOfSoldiers(_id) and AreAllSoldiersOfLeaderDetachedFromMilitaryBuilding(_id)) then
                        if not tab.FormationType then
                            tab.FormationType = math.random(1, 7)
                            Logic.LeaderChangeFormationType(_id, tab.FormationType)
                            tab.RecruitmentComplete = true
                        end
                        Logic.GroupAttackMove(_id, anchor.X, anchor.Y, math.random(360))
                    else
                        if CEntity.GetReversedAttachedEntities(_id)[42] then
                            Logic.DestroyEntity(_id)
                            return true
                        end
                    end
                end
            else
                if Counter.Tick2("AITroopGenerator_CheckForIdle_" .. _player .. "_" .. _id, 5) then
                    Logic.GroupAttackMove(_id, anchor.X, anchor.Y, math.random(360))
                end
            end
            -- first attempt to reach homespot failed (e.g. due to enemies on the way)
            if tab.RecruitmentComplete and Counter.Tick2("AITroopGenerator_CheckForIdle_" .. _id, 5) then
                Logic.GroupAttackMove(_id, anchor.X, anchor.Y, math.random(360))
            end
    
        end
    end

    AITroopGenerator_RemoveLeader = function(_player, _id, _spec, _armyId)

        local entityID = Event.GetEntityID()
    
        if entityID == _id then
            if type(_spec) == "number" then
                removetablekeyvalue(ArmyTable[_player][_spec + 1].IDs, entityID)
                ArmyTable[_player][_spec + 1][_id] = nil
            else
                removetablekeyvalue(MapEditor_Armies[_player].armies[_armyId][_spec].IDs, entityID)
                MapEditor_Armies[_player].armies[_armyId][_spec][_id] = nil
            end
            return true
        end
    
    end

    ControlMapEditor_Armies = function(_playerId, _type, _buildingId)

        if MapEditor_Armies[_playerId] and MapEditor_Armies[_playerId].armies[_buildingId][_type] then
            if _type == "patrolArmies" then
                MapEditor_Armies_Patrol(MapEditor_Armies[_playerId].armies[_buildingId][_type])
                return
            end
            local pos = MapEditor_Armies[_playerId].armies[_buildingId][_type].position
            local range
            if MapEditor_Armies[_playerId].armies[_buildingId][_type].AttackAllowed then
                range = MapEditor_Armies[_playerId].armies[_buildingId][_type].rodeLength
            else
                range = MapEditor_Armies[_playerId].armies[_buildingId][_type].baseDefenseRange
            end
            local dist, eID = GetNearestEnemyDistance(_playerId, pos, range)
            if dist and dist <= range then
                for i = 1, table.getn(MapEditor_Armies[_playerId].armies[_buildingId][_type].IDs) do
                    local id = MapEditor_Armies[_playerId].armies[_buildingId][_type].IDs[i]
                    local tab = MapEditor_Armies[_playerId].armies[_buildingId][_type][id]
                    local barracks = Logic.LeaderGetNearbyBarracks(id)
                    if Logic.LeaderGetNumberOfSoldiers(id) < Logic.LeaderGetMaxNumberOfSoldiers(id) and barracks ~= 0 and MilitaryBuildingIsTrainingSlotFree(barracks) then
                        (SendEvent or CSendEvent).BuySoldier(id)
                    end
                    if Logic.GetCurrentTaskList(id) == "TL_MILITARY_IDLE" or Logic.GetCurrentTaskList(id) == "TL_VEHICLE_IDLE" then
                        if GetDistance(GetPosition(id), pos) < 1500 + (100 * MapEditor_Armies[_playerId].aggressiveLVL)
                        and (tab.RecruitmentComplete or Logic.IsHero(id) == 1 or Logic.IsEntityInCategory(id, EntityCategories.Cannon) == 1
                        or IsVeteranLeader(id)) then
                            ManualControl_AttackTarget(_playerId, nil, id, _type, eID, _buildingId)
                            tab.HomespotReached = tab.HomespotReached or true
                        end
                    end
                    if tab then
                        if (tab.lasttime and (tab.lasttime + 3 < Logic.GetTime() ) and not Logic.IsEntityMoving(id))
                        or (tab.lasttime and (tab.lasttime + 10 < Logic.GetTime() ))
                        or (tab.currenttarget and not Logic.IsEntityAlive(tab.currenttarget)) then
                            ManualControl_AttackTarget(_playerId, nil, id, _type, eID, _buildingId)
                            tab.HomespotReached = tab.HomespotReached or true
                        end
                    end
                end
            else
                for i = 1, table.getn(MapEditor_Armies[_playerId].armies[_buildingId][_type].IDs) do
                    local id = MapEditor_Armies[_playerId].armies[_buildingId][_type].IDs[i]
                    local tab = MapEditor_Armies[_playerId].armies[_buildingId][_type][id]
                    if tab and tab.lasttime then
                        if GetDistance(GetPosition(id), pos) > 1500 + (100 * MapEditor_Armies[_playerId].aggressiveLVL) then
                            local anchor = MapEditor_Armies[_playerId].armies[_buildingId].position or ArmyHomespots[_playerId].recruited[tab.HomespotIndex]
                            Logic.MoveSettler(id, anchor.X, anchor.Y)
                            tab.HomespotReached = tab.HomespotReached or true
                        end
                    else
                        if Logic.LeaderGetNumberOfSoldiers(id) < Logic.LeaderGetMaxNumberOfSoldiers(id) then
                            if not Logic.IsEntityMoving(id) then
                                local barracks = GetNearestBarracks(_playerId, id)
                                if GetDistance(id, barracks) > 1000 then
                                    Logic.MoveSettler(id, Logic.GetEntityPosition(barracks))
                                end
                            end
                            if Logic.LeaderGetNearbyBarracks(id) ~= 0 then
                                (SendEvent or CSendEvent).BuySoldier(id)
                            end
                        else
                            if GetDistance(GetPosition(id), pos) > 1500 + (100 * MapEditor_Armies[_playerId].aggressiveLVL)
                            and tab.RecruitmentComplete then
                                local anchor = MapEditor_Armies[_playerId].armies[_buildingId].position or ArmyHomespots[_playerId].recruited[tab.HomespotIndex]
                                Logic.MoveSettler(id, anchor.X, anchor.Y)
                                tab.HomespotReached = tab.HomespotReached or true
                            end
                        end
                    end
                end
            end
        end
    end

    -- function to control armies' attack target and to give the respective command
ManualControl_AttackTarget = function(_player, _armyId, _id, _type, _target, _buildingId)

	local tabname, range, pos, newtarget, IsMelee, etype, dist
	etype = Logic.GetEntityType(_id)
	local f = function(_tab, _id, _ntarget)
		if not _tab[_id].currenttarget and _ntarget and Logic.GetDiplomacyState(_player, Logic.EntityGetPlayer(_ntarget)) == Diplomacy.Hostile then
			_tab[_id].currenttarget = _ntarget
			_tab[_id].lasttime = Logic.GetTime()
		else
			if _tab[_id].currenttarget and _tab[_id].currenttarget ~= _ntarget and _ntarget and Logic.GetDiplomacyState(_player, Logic.EntityGetPlayer(_ntarget)) == Diplomacy.Hostile then
				_tab[_id].currenttarget = _ntarget
				_tab[_id].lasttime = Logic.GetTime()
			end
		end
		if _tab.baitDetection then
			if _target then
				local dist = GetDistance(_target, _id)
				if dist > _tab.rodeLength then
					_tab[_id].TriggerIDs.baitDetectionTrigger = Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND, nil, "ControlLeaderStillBaitedJob", 1, nil, {_id, _target, _armyId, _type})
				end
			end
		end
	end

	if not _armyId then
		tabname = MapEditor_Armies[_player].armies[_buildingId][_type]
		range = tabname.baseDefenseRange
	else
		tabname = ArmyTable[_player][_armyId]
		range = tabname.rodeLength
	end
	pos = GetPosition(_id)
	newtarget = CheckForBetterTarget(_id, _target or (tabname[_id] and tabname[_id].currenttarget), nil)
		or GetNearestEnemyInRange(_player, tabname.enemySearchPosition or pos, range - GetDistance(pos, tabname.enemySearchPosition or tabname.position))
		or GetNearestTarget(_player, _id)

	tabname[_id] = tabname[_id] or {}

	IsMelee = (Logic.IsEntityInCategory(_id, EntityCategories.Melee) == 1)
	IsAntiBuildingCannon = (gvAntiBuildingCannonsRange[etype] ~= nil)
	dist = GetDistance(_id, newtarget)

	if newtarget and newtarget > 0 then
		if IsMelee then
			if Logic.GetSector(newtarget) == Logic.GetSector(_id) then
				if dist > range then
					if _target then
						f(tabname, _id, _target)
						Logic.GroupAttack(_id, _target)
					end
				else
					f(tabname, _id, newtarget)
					Logic.GroupAttack(_id, newtarget)
				end
			end

		else
			if dist > range then
				if _target then
					f(tabname, _id, _target)
					Logic.GroupAttack(_id, _target)
				end
			else
				--[[if IsAntiBuildingCannon then
					local maxrange = GetEntityTypeBaseAttackRange(etype)
					if dist > maxrange + 200 and dist < maxrange * 2 then
						if not Logic.IsEntityMoving(_id) then
							RetreatToMaxRange(_id, newtarget, maxrange * 9/10)
						end
					else
						Logic.GroupAttack(_id, newtarget)
					end
				else]]
					Logic.GroupAttack(_id, newtarget)
				--end
				f(tabname, _id, newtarget)
			end
		end
	else
		if _target then
			f(tabname, _id, _target)
			Logic.GroupAttack(_id, _target)
		end
	end
end

MapEditor_Armies_Patrol = function(_army)

	assert(_army.PatrolPoints and table.getn(_army.PatrolPoints) > 0, "army has no valid patrol points data. Aborting!")
	if not _army.Patrol then
		_army.Patrol = {}
	end

    if not _army.RecruitmentComplete then
        if table.getn(_army.IDs) < _army.strength then
            return
        end
        _army.RecruitmentComplete = true
        for i = 1, table.getn(_army.IDs) do
            local v = _army.IDs[i]
            if Logic.LeaderGetNumberOfSoldiers(v) < Logic.LeaderGetMaxNumberOfSoldiers(v) then
                _army.RecruitmentComplete = false
                return
            end
        end
    end

	if not _army.Patrol.CurrentPosition then
		_army.Patrol = {CurrentPosition = _army.position, CurrentIndex = 0, LastTimePositionUpdated = Logic.GetTime()}
		if not _army.PatrolPoints[0] then
			_army.PatrolPoints[0] = _army.position
			_army.PatrolPoints[0].WaitTime = _army.Patrol.HomePositionWaitTime or 30
		end
	end
	if _army.Patrol.LastTimePositionUpdated + _army.PatrolPoints[_army.Patrol.CurrentIndex].WaitTime < Logic.GetTime() then
		if _army.Patrol.CurrentIndex < table.getn(_army.PatrolPoints) then
			_army.Patrol.CurrentPosition = {X = _army.PatrolPoints[_army.Patrol.CurrentIndex + 1].X, Y = _army.PatrolPoints[_army.Patrol.CurrentIndex + 1].Y}
			_army.Patrol.CurrentIndex = _army.Patrol.CurrentIndex + 1
		else
			_army.Patrol.CurrentPosition = {X = _army.PatrolPoints[0].X, Y = _army.PatrolPoints[0].Y}
			_army.Patrol.CurrentIndex = 0
		end
		_army.Patrol.LastTimePositionUpdated = Logic.GetTime()
	end
	local pos = _army.Patrol.CurrentPosition
    local range = _army.rodeLength
	local dist, eID = GetNearestEnemyDistance(_army.player, _army.enemySearchPosition or pos, range)
	if dist then
		for i = 1, table.getn(_army.IDs) do
			local id = _army.IDs[i]
			if GetDistance(GetPosition(id), pos) > 1500
			and dist <= math.min(3000, range) and not gvEMSFlag and eID then
				if Logic.IsEntityInCategory(id, EntityCategories.Hero) == 1 then
					ManualControl_AttackTarget(_army.player,nil,id,"patrolArmies",eID,_army.id)
				else
					Logic.GroupAttack(id, eID)
				end
			else
				if Logic.GetCurrentTaskList(id) == "TL_MILITARY_IDLE" or Logic.GetCurrentTaskList(id) == "TL_VEHICLE_IDLE" then
					ManualControl_AttackTarget(_army.player,nil,id,"patrolArmies",eID,_army.id)
				end
				if _army[id] then
                    if (_army[id].lasttime and (_army[id].lasttime + 3 < Logic.GetTime()))
                    or (_army[id].currenttarget and not Logic.IsEntityAlive(_army[id].currenttarget)) then
                        ManualControl_AttackTarget(_army.player, nil, id, "patrolArmies", eID, _army.id)
                    end
                end
			end
		end
	else
		if _army.position.X ~= pos.X or _army.position.Y ~= pos.Y then
			Redeploy(_army, pos, nil, "patrolArmies", _army.id)
		end
		MapEditor_Armies_Retreat(_army)
	end
end

MapEditor_Armies_Retreat = function(_army, _rodeLength, _position)

	if _rodeLength then
		_army.rodeLength = _rodeLength
	end
	local pos = _army.position
	local groupAttackRange = 2000
	for i = 1, table.getn(_army.IDs) do
		local id = _army.IDs[i]
		local dist = GetDistance(GetPosition(id), pos)
		if dist > 1500 then
			local anchor = _army.position
			if Logic.GetCurrentTaskList(id) == "TL_MILITARY_IDLE"
			or Logic.GetCurrentTaskList(id) == "TL_VEHICLE_IDLE"
			and dist < _army.rodeLength - groupAttackRange then
				Logic.GroupAttackMove(id, anchor.X, anchor.Y, math.random(360))
			else
				Logic.MoveSettler(id, anchor.X, anchor.Y)
			end
		end
	end
end

Redeploy = function(_army, _position, _rodeLength, _type, _armyId)
	local army
	if _type then
		army = MapEditor_Armies[_army.player].armies[_armyId][_type]
	else
		army = ArmyTable[_army.player][_army.id + 1]
	end
	if _rodeLength then
		_army.rodeLength = _rodeLength
		army.rodeLength = _rodeLength
	end
	_army.position = _position
	army.position = _position
	if _type then
		ArmyHomespots[_army.player].recruited = nil
		EvaluateArmyHomespots(_army.player, _position, nil)
	else
		ArmyHomespots[_army.player][_army.id + 1] = nil
		EvaluateArmyHomespots(_army.player, _position, _army.id + 1)
	end
end

    function GameCallback_GUI_EntityIDChanged(_OldID, _NewID)

        local player = Logic.EntityGetPlayer(_OldID)
        --[[ needed when troop on top of the archers tower is upgraded
        currently deprecated, because troops do not upgrade anymore when research is done ]]
        for k,v in pairs(gvArchers_Tower.SlotData) do
    
            local slot = table_findvalue(gvArchers_Tower.SlotData[k],_OldID)
    
            if slot ~= 0 then
                gvArchers_Tower.SlotData[k][slot] = _NewID
                gvArchers_Tower.CurrentlyUsedSlots[k] = gvArchers_Tower.CurrentlyUsedSlots[k] + 1
                local TroopIDs = {Logic.GetSoldiersAttachedToLeader(gvArchers_Tower.SlotData[k][slot])}
                table.remove(TroopIDs,1)
                table.insert(TroopIDs,gvArchers_Tower.SlotData[k][slot])
    
                for i = 1,table.getn(TroopIDs) do
                    CEntity.SetDamage(TroopIDs[i], Logic.GetEntityDamage(TroopIDs[i]) * gvArchers_Tower.DamageFactor)
                    CEntity.SetArmor(TroopIDs[i], Logic.GetEntityArmor(TroopIDs[i]) * gvArchers_Tower.ArmorFactor)
                    CEntity.SetAttackRange(TroopIDs[i],GetEntityTypeMaxAttackRange((TroopIDs[i]), player) + gvArchers_Tower.MaxRangeBonus)
                end
    
            end
        end
        --[[ update AI data when troops upgrade
        note: troop upgrade timing order: GameCallback_GUI_EntityIDChanged -> DestroyedTrigger -> CreatedTrigger]]
        if ArmyTable and ArmyTable[player] then
            for k, v in pairs(ArmyTable[player]) do
                local tpos = table_findvalue(v.IDs, _OldID)
                if tpos ~= 0 then
                    Trigger.UnrequestTrigger(v[_OldID].TriggerID)
                    v.IDs[tpos] = _NewID
                    v[_NewID] = v[_OldID]
                    v[_OldID] = nil
                    v[_NewID].TriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "AITroopGenerator_RemoveLeader", 1, {}, {player, _NewID, k})
                    local enemies = BS.GetAllEnemyPlayerIDs(player)
                    for i = 1, table.getn(enemies) do
                        if AIchunks[enemies[i]] then
                            ChunkWrapper.RemoveEntity(AIchunks[enemies[i]], _OldID)
                            ChunkWrapper.AddEntity(AIchunks[enemies[i]], _NewID)
                        end
                    end
                    break
                end
            end
        end
    
        GameCallback_GUI_EntityIDChangedOrig(_OldID, _NewID)
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