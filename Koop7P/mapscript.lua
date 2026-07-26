--------------------------------------------------------------------------------
-- MapName: Kapitel2: Der Feind meines Feindes ...
--
-- Author: Zork
--
--------------------------------------------------------------------------------

Script.Load( Folders.MapTools.."Main.lua" )
Script.Load("maps\\user\\Skripte\\Koop7P\\helper.lua")
Script.Load("maps\\user\\Skripte\\Koop7P\\player5.lua")
Script.Load("maps\\user\\Skripte\\Koop7P\\upgrades.lua")
Script.Load("maps\\user\\Skripte\\Koop7P\\waves.lua")
Script.Load("maps\\user\\Skripte\\Koop7P\\briefings.lua")
Script.Load("maps\\user\\Skripte\\Koop7P\\player4replace.lua")
IncludeGlobals("Explore")
IncludeGlobals("MapEditorTools")

PLAYERCOUNT = 0
TIMER = 0
DEFENSEPOINT = 4
TICK = 0
PLAYERFIVEMULT = 0
SPAWNEROFF = 0
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
	SetPlayerName(8, "Feinde")
	for i = 1,7 do
        SetFriendly(i,1)
        SetFriendly(i,2)
        SetFriendly(i,3)
        SetFriendly(i,4)
        SetFriendly(i,5)
        SetFriendly(i,6)
        SetFriendly(i,7)
        SetHostile(i,8)
        for j = 1, 7 do
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
	Display.SetPlayerColorMapping(8,2)
end

function InitGameResources()
    local InitGoldRaw 		= 600
	local InitClayRaw 		= 400
	local InitWoodRaw 		= 700
	local InitStoneRaw 		= 400
	local InitIronRaw 		= 600
	local InitSulfurRaw		= 0

	--Add Players Resources
	local i
	for i=1,4,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw, InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

    Script.Load("extra2\\shr\\maps\\user\\EMS\\tools\\s5CommunityLib\\packer\\devLoad.lua");
	mcbPacker.Paths = { { "extra2\\shr\\maps\\user\\EMS\\tools\\", ".lua" } }
	mcbPacker.require("s5CommunityLib/lib/UnlimitedArmy")
    mcbPacker.require("s5CommunityLib/lib/UnlimitedArmyRecruiter")
    Script.Load("maps\\user\\Skripte\\Koop7P\\music.lua")
    initBossMusicCounter()

    Script.Load("maps\\user\\Skripte\\Koop7P\\armiesdef.lua")

    TriggerFix.AllScriptsLoaded()

    function TriggerFix.ShowErrorMessage() end

	UnlimitedArmy.ForceNoHook = true

	InitPlayerColorMapping()
    InitDiplomacy()
    InitWeatherGfxSets()
    insertGhostHeroAbilites()

    CreateWoodPile("woodpile1",100000)
    CreateWoodPile("woodpile2",100000)
    CreateWoodPile("woodpile3",100000)
    CreateWoodPile("woodpile4",100000)
    CreateWoodPile("woodpile5",100000)
    CreateWoodPile("woodpile6",100000)
    CreateWoodPile("woodpile7",100000)
    CreateWoodPile("woodpile8",100000)
    CreateWoodPile("woodpile9",100000)

    fithplayeractive = 0
    fourthplayeractive = 0

    if XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID(4) == 1 then
        fourthplayeractive = 1
    end

    if XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID(5) == 1 then
        fithplayeractive = 1
    end
	
	-- Init  global MP stuff
	MultiplayerTools.InitCameraPositionsForPlayers()
	SetUpGameLogicOnMPGameConfigLight()

    for i = 1, 4 do
        ForbidTechnology(Technologies.B_Mercenary, i)
    end

    for i = 1, 5 do
        ForbidTechnology(Technologies.B_Woodcutter, i)
        ForbidTechnology(Technologies.B_Forester, i)
    end

	for i = 1, 3 do 
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;

    if fourthplayeractive == 1 then
        Display.SetPlayerColorMapping(4, XNetwork.GameInformation_GetLogicPlayerColor(4));
    end

    if fithplayeractive == 1 then
        Display.SetPlayerColorMapping(5, XNetwork.GameInformation_GetLogicPlayerColor(5));
    end

    if fithplayeractive >= 1 then
        Logic.SetNumberOfBuyableHerosForPlayer(5, 0)
        ResearchTechnology( Technologies.T_KnightsCulture, 5)
        gvMercenaryTower.Cooldown.BuyLeaderBlackKnight = 0
	    gvMercenaryTower.Cooldown.BuyLeaderBlackSword = 0
        PLAYERFIVEMULT = 1
        for i = 1, 4 do
            Logic.SetShareExplorationWithPlayerFlag(i, 5, 1)
        end
    else
        for i = 1,7 do
            DestroyEntity(GetEntityId("merc"..i))
        end
    end

    if fourthplayeractive >= 1 then
        DestroyEntity(GetEntityId("villagecenterreplace1"))
        DestroyEntity(GetEntityId("villagecenterreplace2"))
    else
        MapEditor_SetupAI(4, 1, 100000, 0, "towndefpoint3", 0, 0)
	    SetupPlayerAi( 4, {constructing = true, extracting = true, repairing = true, serfLimit = 8} )
        MapEditor_Armies[4].offensiveArmies.strength = 0
        MapEditor_Armies[4].defensiveArmies.strength = 0
        SetPlayerName(4, "Südfang")
        Display.SetPlayerColorMapping(4,1)
        ReplaceEntity( GetEntityId("villagecenterp4"), Entities.PB_VillageCenter3)
    end

    SuspendAllStartEntities()

    InitDifficultyChoice()
end

function createPlayerTroops()
    for i = 1, 2 do
        CreateMilitaryGroup(1, Entities.PU_LeaderSword3, 8, GetPosition("p1sword" .. i))
        CreateMilitaryGroup(1, Entities.PU_LeaderBow2, 4, GetPosition("p1bow" .. i))
        if fourthplayeractive == 1 then
            CreateMilitaryGroup(4, Entities.PU_LeaderPoleArm3, 8, GetPosition("p4spear" .. i))
            CreateMilitaryGroup(4, Entities.PU_LeaderBow3, 8, GetPosition("p4bow" .. i))
        end
    end
    CreateMilitaryGroup(3, Entities.PU_LeaderCavalry2, 6, GetPosition("p3cav1"))
    CreateMilitaryGroup(3, Entities.PU_LeaderHeavyCavalry2, 4, GetPosition("p3hcav2"))
    if fourthplayeractive == 1 then
        CreateMilitaryGroup(4, Entities.PU_LeaderSword3, 8, GetPosition("towndefmiddle"))
    end
    local p7spawn = GetPosition("p7spawn")
    local p7attacker = GetPosition("p7attacker")
    for i = 1, 3 do
        AI.Entity_CreateFormation(7, Entities.PU_LeaderHeavyCavalry2, nil, 8, p7spawn.X, p7spawn.Y, p7attacker.X*100, p7attacker.Y*100, 3, 0)
    end
end

function InitGame()
    InitGameResources()
    Difficulties[1] = 1
    Difficulties[2] = 1
    Difficulties[3] = 1
    Difficulties[4] = 6
    Difficulties[5] = 2
    Difficulties[6] = 1
    Difficulties[7] = 1

    if fithplayeractive >= 1 then
        InitPlayer5SideHustle()
    end

    LocalMusic.UseSet = EVELANCEMUSIC
	MapEditor_SetupAI(8, 1, 100000, 2, "graveyard23", 0, 0)
	SetupPlayerAi( 8, {} )
    ResumeAllStartEntities()
    StartSimpleJob("checkForHQ")

    createPlayerTroops()
    BriefingStart()
end

function StartGame()
    MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
    Counter.Tick2("TIMER",5400)
    StartSimpleJob("TickCounter")
    StartCountdown(5400, reeinforcements, true)
    StartSimpleJob("UpgradeEnemies")
    StartSimpleJob("checkForHQs")

    if fourthplayeractive == 0 then
        InitPlayer4Replace()
    end
    initStartingEnemies()
    StartSimpleJob("Waves")
end

function TickCounter()
    Counter.Tick("TIMER")
    TICK = Counter.GetTick("TIMER")
end

function checkForHQ()
    if IsDead("hq4") then
        Defeat()
    end
end

function reeinforcements()
    SPAWNEROFF = 1
    local bkplayer = 1
    local fortressplayer = 2
    if fithplayeractive == 1 then
        bkplayer = 5
    end
    if fourthplayeractive == 1 then
        fortressplayer = 4
    end

    local reeinfp11 = GetPosition("reeinfp11")
    local reeinfp12 = GetPosition("reeinfp12")
    local reeinfp31 = GetPosition("reeinfp31")
    local reeinfp32 = GetPosition("reeinfp32")
    local reeinfp41 = GetPosition("reeinfp41")
    local reeinfp42 = GetPosition("reeinfp42")
    local WorkerEscapePoint = GetPosition("WorkerEscapePoint")
    local CrawlerExit = GetPosition("CrawlerExit")
    local grave3 = GetPosition("grave3")
    local attackAlteaLeft1 = GetPosition("attackAlteaLeft1")
    local towngatemiddle = GetPosition("towngatemiddle")
    local spvillage1 = GetPosition("spvillage1")
    
    for i = 1, 10 do
        AI.Entity_CreateFormation(1, Entities.PU_LeaderCavalry2, nil, 8, reeinfp12.X, reeinfp12.Y, attackAlteaLeft1.X*100, attackAlteaLeft1.Y*100, 3, 0)
        AI.Entity_CreateFormation(1, Entities.PU_LeaderHeavyCavalry2, nil, 8, reeinfp11.X, reeinfp11.Y, attackAlteaLeft1.X*100, attackAlteaLeft1.Y*100, 3, 0)
        AI.Entity_CreateFormation(2, Entities.PV_Cannon1, nil, 8, WorkerEscapePoint.X, WorkerEscapePoint.Y, towngatemiddle.X*100, towngatemiddle.Y*100, 3, 0)
        AI.Entity_CreateFormation(2, Entities.PV_Cannon2, nil, 8, WorkerEscapePoint.X, WorkerEscapePoint.Y, towngatemiddle.X*100, towngatemiddle.Y*100, 3, 0)
        AI.Entity_CreateFormation(3, Entities.PU_LeaderHeavyCavalry2, nil, 8, reeinfp32.X, reeinfp32.Y, grave3.X*100, grave3.Y*100, 3, 0)
        AI.Entity_CreateFormation(3, Entities.PU_LeaderUlan1, nil, 8, reeinfp31.X, reeinfp31.Y, grave3.X*100, grave3.Y*100, 3, 0)
        AI.Entity_CreateFormation(fortressplayer, Entities.PU_LeaderBow4, nil, 12, reeinfp42.X, reeinfp42.Y, towngatemiddle.X*100, towngatemiddle.Y*100, 3, 0)
        AI.Entity_CreateFormation(fortressplayer, Entities.PU_LeaderSword4, nil, 12, reeinfp41.X, reeinfp41.Y, towngatemiddle.X*100, towngatemiddle.Y*100, 3, 0)
        AI.Entity_CreateFormation(bkplayer, Entities.CU_BlackKnight_LeaderMace1, nil, 4, CrawlerExit.X, CrawlerExit.Y, spvillage1.X*100, spvillage1.Y*100, 3, 0)
        AI.Entity_CreateFormation(bkplayer, Entities.CU_BlackKnight_LeaderSword3, nil, 8, CrawlerExit.X, CrawlerExit.Y, spvillage1.X*100, spvillage1.Y*100, 3, 0)
    end
    BriefingReeinforcements()
end

function showRemainingEnemiesCounter()
    GUIQuestTools.StartQuestInformation("Nephilim", "", 1, 1)
    StartSimpleJob("updateRemainingEnemiesCounter")
end

function updateRemainingEnemiesCounter()
    local leaderCount = AI.Player_GetNumberOfLeaders(6)
	leaderCount = leaderCount + AI.Player_GetNumberOfLeaders(7) - 4 - (EREBOSID-1)

    if leaderCount == 0 then
        Victory()
        return true
    end

    GUIQuestTools.UpdateQuestInformationString(""..leaderCount)
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

function checkForHQs()
    if IsDead("hq1") or IsDead("hq2") or IsDead("hq3") then
        Message("@color:255,0,0 Ein Verbündeter ist gefallen, die Notdorfzentren stehen nun zur Verfügung!")
        local _pos1 = GetPosition("serfSpawn")
        local _pos2 = GetPosition("townleftdef")
        for i = 1, 3 do
            AI.Entity_CreateFormation(i, Entities.PU_Serf, nil, 1, _pos1.X, _pos1.Y, _pos2.X*100, _pos2.Y*100, 3, 0)
        end
        local gate = ReplaceEntity( GetEntityId("gatevillage"), Entities.XD_WallStraightGate)
        SetEntityName(gate, "gatevillage")
        return true
    end
end

function CreateWoodPile( _posEntity, _resources )
    assert( type( _posEntity ) == "string" );
    assert( type( _resources ) == "number" );
    gvWoodPiles = gvWoodPiles or {
        JobID = StartSimpleJob("ControlWoodPiles"),
    };
    local pos = GetPosition( _posEntity );
    local pile_id = Logic.CreateEntity( Entities.XD_SingnalFireOff, pos.X, pos.Y, 0, 0 );
    SetEntityName( pile_id, _posEntity.."_WoodPile" );
    ReplaceEntity( _posEntity, Entities.XD_ResourceTree );
    Logic.SetResourceDoodadGoodAmount( GetEntityId( _posEntity ), _resources*10 );
    table.insert( gvWoodPiles, { ResourceEntity = _posEntity, PileEntity = _posEntity.."_WoodPile", ResourceLimit = _resources*9 } );
end
 
function ControlWoodPiles()
    for i = table.getn( gvWoodPiles ),1,-1 do
        if Logic.GetResourceDoodadGoodAmount( GetEntityId( gvWoodPiles[i].ResourceEntity ) ) <= gvWoodPiles[i].ResourceLimit then
            DestroyWoodPile( gvWoodPiles[i], i );
        end
    end
end
 
function DestroyWoodPile( _piletable, _index )
    local pos = GetPosition( _piletable.ResourceEntity );
    DestroyEntity( _piletable.ResourceEntity );
    DestroyEntity( _piletable.PileEntity );
    Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, 0 );
    table.remove( gvWoodPiles, _index )
end

