--------------------------------------------------------------------------------
-- MapName: Prolog: Friedensbruch
--
-- Author: Zork
--
--------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
Script.Load( "maps\\user\\Skripte\\Prolog\\main_mission.lua")
Script.Load( "maps\\user\\Skripte\\Prolog\\side_quests.lua")
Script.Load( "maps\\user\\Skripte\\Prolog\\briefings.lua")
Script.Load( "maps\\user\\Skripte\\Prolog\\armies.lua")
Script.Load( "maps\\user\\Skripte\\Prolog\\erebos_minigame.lua")
IncludeGlobals("MapEditorTools")
NPC = {}
armyStart = {}
Difficulty = 2

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
    SetPlayerName(2, "Winkelhain")
    SetPlayerName(3, "Sturmbach")
    SetPlayerName(4, "Banditen")
    SetNeutral(1,2)
    SetNeutral(1,3)
    SetNeutral(1,4)
    SetHostile(2,5)
    SetHostile(2,6)
    SetHostile(2,3)
    SetHostile(1,5)
    SetHostile(2,3)
    SetHostile(1,6)
    SetHostile(2,5)
    SetHostile(2,6)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (0)
    AddSulfur(0)
    AddIron  (0)
    AddWood  (0)	
    AddStone (0)	
    AddClay  (0)	
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
    ResearchTechnology( Technologies.T_BanditCulture, 1)
    ForbidTechnology( Technologies.UP1_Headquarter, 1 )
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupNormalWeatherGfxSet()
    Camera.ZoomSetFactorMax(1.5)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function InitWeather()
	--AddPeriodicSummer(10)
    AddPeriodicNight(10)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
    Display.SetPlayerColorMapping(2,9)
    Display.SetPlayerColorMapping(3,6)
    Display.SetPlayerColorMapping(4,14)
    Display.SetPlayerColorMapping(5,2)
    Display.SetPlayerColorMapping(6,13)
    Display.SetPlayerColorMapping(7,1)
    Display.SetPlayerColorMapping(8,2)
    
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
    if gvDiffLVL == 1 then
        Difficulty = 3
    elseif gvDiffLVL == 3 then
        Difficulty = 1
    end
    DisplaySpecialNames()
    ActivateBriefingsExpansion()
    armyOverrides()
    DZTrade_PunishmentJob = function ()
        return true
    end
    Logic.SetShareExplorationWithPlayerFlag(1, 7, 1)
    ResearchTechnology(Technologies.T_Masonry,2)
    ResearchTechnology(Technologies.T_Masonry,3)
    ResearchTechnology(Technologies.T_EnhancedGunPowder,6)
    ResearchTechnology(Technologies.T_FleeceArmor,6)
    ResearchTechnology(Technologies.T_BodkinArrow,6)
    ResearchTechnology(Technologies.T_SoftArcherArmor,6)
    ResearchTechnology(Technologies.T_ChainMailArmor,6)
    ResearchTechnology(Technologies.T_Turnery,6)
    if Difficulty >= 2 then
        ResearchTechnology(Technologies.T_LeatherMailArmor,6)
        ResearchTechnology(Technologies.T_LeatherArcherArmor,6)
        ResearchTechnology(Technologies.T_MasterOfSmithery,6)
        if Difficulty == 3 then
            ResearchTechnology(Technologies.T_PlateMailArmor,6)
            ResearchTechnology(Technologies.T_PaddedArcherArmor,6)
            ResearchTechnology(Technologies.T_IronCasting,6)
            ResearchTechnology(Technologies.T_Fletching,6)
            ResearchTechnology(Technologies.T_WoodAging,6)
            ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,6)
            ResearchTechnology(Technologies.T_LeadShot,6)
        end
    end
    MapEditor_SetupAI(2, 3, 150000, 0, "BaseWinkelhain", 0, 0)
	SetupPlayerAi( 2, {constructing = true, extracting = true, repairing = true, serfLimit = 8} )
    table.insert(MapEditor_Armies[2].ForbiddenTypes, UpgradeCategories.LeaderHeavyCavalry)
    table.insert(MapEditor_Armies[2].ForbiddenTypes, UpgradeCategories.LeaderRifle)
    MapEditor_Armies[2].offensiveArmies.strength = 0
    MapEditor_Armies[2].defensiveArmies.strength = 8
	MapEditor_SetupAI(3, 3, 100000, 1, "BaseSturmbach", 3, 0)
	SetupPlayerAi( 3, {constructing = true, extracting = true, repairing = true, serfLimit = 8} )
    MapEditor_Armies[3].offensiveArmies.strength = 12
    MapEditor_Armies[3].defensiveArmies.strength = 16
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.LeaderPoleArm)
    table.insert(MapEditor_Armies[3].ForbiddenTypes, UpgradeCategories.LeaderRifle)
    SetupPlayerAi(4, {})
    SetupPlayerAi(5, {})
    SetupPlayerAi(6, {})
    SetupPlayerAi(7, {})
    SetupPlayerAi(8, {})

	for i = 1, 2 do
        CreateHalberd(i)
        Logic.SetOnScreenInformation(GetEntityId("h" .. i), 0)
    end

    MakeInvulnerable(GetEntityId("Rudger"))

    CreateArmyStart(2)
    CreateArmyStart(3)

    initArmyDefendEntrance1()
    initArmyDefendEntrance2()
    initArmyDefendEntrance3()
    initArmyDefendGraveyard()
    createOneTimeArmy5NVDef()

    firstQuest()
end

function CreateHalberd(i)
    local NPC = {
        name = "h" .. i,
        number = i,
        follow = "Ari"
    }
    CreateNPC(NPC)
end

function DisplaySpecialNames() --Quelle fritz_98: Der edle Lord Buck
    SpecialNames = {
        Schwarz = "Schwarz",
        Rudger = "Rudger",
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
end