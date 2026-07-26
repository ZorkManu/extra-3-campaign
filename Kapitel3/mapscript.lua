--------------------------------------------------------------------------------
-- MapName: Kapitel3: Schlacht um Mercius
--
-- Author: Zork
--
--------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
Script.Load( "maps\\user\\Skripte\\Kapitel3\\armies.lua")
Script.Load( "maps\\user\\Skripte\\Kapitel3\\helper.lua")
Script.Load( "maps\\user\\Skripte\\Kapitel3\\player2.lua")
Script.Load( "maps\\user\\Skripte\\Kapitel3\\player3.lua")
Script.Load( "maps\\user\\Skripte\\Kapitel3\\main_mission.lua")
Script.Load( "maps\\user\\Skripte\\Kapitel3\\briefings.lua")
IncludeGlobals("MapEditorTools")
Difficulty = 2

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
    SetPlayerName(2, "Mercius")
    SetPlayerName(3, "Varg")
    SetPlayerName(4, "Kerberos")
    for i = 1, 4 do
        SetFriendly(1, i)
        SetHostile(i, 5)
        SetHostile(i, 6)
        SetHostile(i, 7)
    end
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
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupNormalWeatherGfxSet()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function InitWeather()
	AddPeriodicSummer(600)
    --AddPeriodicRain(40)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
    Display.SetPlayerColorMapping(2,4)
    Display.SetPlayerColorMapping(3,2)
    Display.SetPlayerColorMapping(4,12)
    Display.SetPlayerColorMapping(5,13)
    Display.SetPlayerColorMapping(6,6)
    Display.SetPlayerColorMapping(8,14)
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
    Overrides()
    if gvDiffLVL == 1 then
        Difficulty = 3
    elseif gvDiffLVL == 3 then
        Difficulty = 1
    end

    Camera.ZoomSetFactorMax(1.75)

    AIEnemies_ExcludedTypes[Entities.CB_LighthouseActivated] = true

    for i = 1,6 do
        ChangePlayer("w" .. i, 2)
    end

    for i = 2, 4 do 
        ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
        ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
        ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
        ResearchTechnology(Technologies.T_LeatherMailArmor,i)
        ResearchTechnology(Technologies.T_MasterOfSmithery,i)
        ResearchTechnology(Technologies.T_Fletching,i)
        ResearchTechnology(Technologies.T_FleeceArmor,i)
        ResearchTechnology(Technologies.T_ChainMailArmor,i)
        ResearchTechnology(Technologies.T_SoftArcherArmor,i)
        ResearchTechnology(Technologies.T_WoodAging,i)
        ResearchTechnology(Technologies.T_LeadShot,i)
        ResearchTechnology(Technologies.T_IronCasting,i)
        ResearchTechnology(Technologies.T_BodkinArrow,i)
        ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
        ResearchTechnology(Technologies.T_PlateMailArmor,i)
        ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
        ResearchTechnology(Technologies.T_Turnery,i)
        ResearchTechnology(Technologies.T_Sights,i)
    end

    Camera.ZoomSetFactorMax(1.5)
    DisplaySpecialNames()
    createSchwarz()

    createPlayer2()

    createInitialArmies()
    reachCastleQuest()

    Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "TriggerCondition_IsLeader", "OnLeaderCreated", 1)

    TriggerCondition_IsLeader = function ()
        local EntityId = Event.GetEntityID()
        return Logic.IsLeader(EntityId) == 1
    end
    
    OnLeaderCreated = function ()
        LastCreatedLeaderId = Event.GetEntityID()
    end
 
    function BuyLeader(_BarracksId, _UpgradeCategory)
        local PreviousLeaderId = LastCreatedLeaderId
        Logic.BarracksBuyLeader(_BarracksId, _UpgradeCategory)
        if LastCreatedLeaderId ~= PreviousLeaderId then
            return LastCreatedLeaderId
        end
        return 0
    end

    createPlayer3()
    Tools.ExploreArea( -1, -1, 900 )
end

function createSchwarz()
    if GDB.GetString("mayorSturmbach") ~= "Schwarz" then
        CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("SchwarzSpawn"), "Schwarz")
        StartCountdown(3, function ()
            Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
            CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
        end, false)
    end
end