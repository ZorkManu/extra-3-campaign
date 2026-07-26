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
    Logic.SetShareExplorationWithPlayerFlag(1, 7, 1)
    ResearchTechnology(Technologies.T_Masonry,2)
    ResearchTechnology(Technologies.T_Masonry,3)
    ResearchTechnology(Technologies.T_EnhancedGunPowder,1)
    ResearchTechnology(Technologies.T_FleeceArmor,1)
    ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,1)
    ResearchTechnology(Technologies.T_LeadShot,1)
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

    StartCountdown(1, function ()
        Logic.SetEntityScriptingValue(GetEntityId("Rudger"),72,1)
        CUtil.SetEntityDisplayName(GetEntityId("Rudger"), "Rudger")
    end, false)

    CreateArmyStart(2)
    CreateArmyStart(3)

    initArmyDefendEntrance1()
    initArmyDefendEntrance2()
    initArmyDefendEntrance3()
    initArmyDefendGraveyard()
    createOneTimeArmy5NVDef()

    firstQuest()
end

function CreateHalberd(i) --creation of halberd NPC Source dedk.de/wiki
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