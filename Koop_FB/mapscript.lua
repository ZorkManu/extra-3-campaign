--------------------------------------------------------------------------------
-- MapName: Kapitel2: Der Feind meines Feindes ...
--
-- Author: Zork
--
--------------------------------------------------------------------------------

Script.Load( Folders.MapTools.."Main.lua" )
Script.Load("maps\\user\\Skripte\\Koop_FB\\helper.lua")
Script.Load("maps\\user\\Skripte\\Koop_FB\\briefings.lua")
Script.Load("maps\\user\\Skripte\\Koop_FB\\gameflow.lua")
IncludeGlobals("Explore")
IncludeGlobals("MapEditorTools")

Difficulty = 0
Difficulties = {}

function InitDifficultyChoice() --Credit: https://dedk.de/wiki/doku.php?id=scripting:tutorials:level2:tribute#zusaetzliche_parameter
    DifficultyModes = {
        VeryEasy = 1,
        Easy = 2,
        Normal = 3,
        Hard = 4,
        VeryHard = 5,
        Insane = 6
    }
    local DifficultyModeNames = {
        [DifficultyModes.VeryEasy] = "Sehr Leicht>>!",
        [DifficultyModes.Easy] = "Leicht>>!",
        [DifficultyModes.Normal] = "Normal>>!",
        [DifficultyModes.Hard] = "Schwer>>!",
        [DifficultyModes.VeryHard] = "Sehr Schwer>>!",
        [DifficultyModes.Insane] = "Irrsinnig>>!",
    }
    Difficulty = 0
    DifficultyTributeIds = {}
    for DifficultyMode, DifficultyModeName in ipairs(DifficultyModeNames) do
        local TributeId = CreateTributeDifficultyChoice(DifficultyMode, DifficultyModeName)
        table.insert(DifficultyTributeIds, TributeId)
    end
end

function CreateTributeDifficultyChoice(_DifficultyMode, _DifficultyName)
    local Tribute = {
        pId = 1,
        text = "Schwierigkeit @color:0,250,200 <<" .. _DifficultyName,
        cost = {
            Gold = 0
        },
        DifficultyMode = _DifficultyMode/2,
        Callback = CallbackTributeDifficultyChoice
    }
    return AddTribute(Tribute)
end

function CallbackTributeDifficultyChoice(_Tribute)
    Difficulty = _Tribute.DifficultyMode

	for _, TributeId in ipairs(DifficultyTributeIds) do
            Logic.RemoveTribute(1, TributeId)
    end
    InitGame()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(6, "Geistertruppen")
	SetPlayerName(5, "Nebelvolk")
    SetPlayerName(4, "Banditen")
	for i = 1,3 do
        SetFriendly(i,1)
        SetFriendly(i,2)
        SetFriendly(i,3)
        SetHostile(i,4)
        SetHostile(i,5)
        SetHostile(i,6)
        for j = 1, 3 do
            Logic.SetShareExplorationWithPlayerFlag(i, j, 1)
        end
    end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupEvelanceWeatherGfxSet()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
	Display.SetPlayerColorMapping(6,13)
	Display.SetPlayerColorMapping(5,2)
    Display.SetPlayerColorMapping(4,14)
end

function InitGameResources()
    local InitGoldRaw 		= 1200
	local InitClayRaw 		= 800
	local InitWoodRaw 		= 1000
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 600
	local InitSulfurRaw		= 450

	--Add Players Resources
	local i
	for i=1,3,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw, InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	InitPlayerColorMapping()
    InitDiplomacy()
    InitWeatherGfxSets()
    insertGhostHeroAbilites()
	
	-- Init  global MP stuff
	MultiplayerTools.InitCameraPositionsForPlayers()
	SetUpGameLogicOnMPGameConfigLight()

	for i = 1, 3 do 
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
        ResearchTechnology( Technologies.T_BanditCulture, i)
    end;

    SuspendAllStartEntities()

    InitDifficultyChoice()
end

function InitGame()
    InitGameResources()
    ResumeAllStartEntities()
    MapEditor_SetupAI(4, 1, 30000, 1, "BanditBase", 0, 0)
	SetupPlayerAi( 4, {{constructing = true, extracting = true, repairing = true, serfLimit = 8}})
    MapEditor_Armies[4].offensiveArmies.strength = math.floor(Difficulty)
    MapEditor_Armies[4].defensiveArmies.strength = math.ceil(Difficulty*3)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.BlackKnightLeaderSword3)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.BlackKnightLeaderMace1)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderElite)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.Evil_LeaderSkirmisher)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.Evil_LeaderBearman)
    table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderBarbarian)
    BriefingStart()
end

function StartGame()
    for i = 1,2 do
        local pos = GetPosition("w" .. i)
        DestroyEntity("w" .. i)
        Logic.CreateEntity( Entities.PB_WoodcuttersHut1, pos.X, pos.Y, 0, 2 )
    end
    for i = 3,4 do
        ChangePlayer("w" .. i, 2)
    end
    MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
    MapEditor_SetupAI(5, 1, 100000, 2, "spp2", 0, 0)
	SetupPlayerAi( 5, {} )
    MapEditor_SetupAI(6, 1, 100000, 2, "spp1", 0, 0)
	SetupPlayerAi( 6, {} )
    InitSpawner()
end

function insertGhostHeroAbilites()
    gvHeroAbilities["AuraAffectedCategoryByHeroType"][Entities.PU_Hero4_Spectral] = "Allies"
    gvHeroAbilities["AuraAffectedCategoryByHeroType"][Entities.PU_Hero10_Spectral] = "LongRange"
    gvHeroAbilities["AbilitiesByHero"][Entities.PU_Hero5_Spectral] = {Abilities.AbilitySummon}
    gvHeroAbilities["AbilitiesByHero"][Entities.PU_Hero4_Spectral] = {Abilities.AbilityRangedEffect, Abilities.AbilityCircularAttack}
    gvHeroAbilities["AbilitiesByHero"][Entities.PU_Hero2_Spectral] = {Abilities.AbilityPlaceBomb, Abilities.AbilityBuildCannon}
    gvHeroAbilities["AbilitiesByHero"][Entities.PU_Hero1c_Spectral] = {Abilities.AbilityInflictFear}
    gvHeroAbilities["AbilitiesByHero"][Entities.PU_Hero10_Spectral] = {Abilities.AbilitySniper, Abilities.AbilityRangedEffect}
end