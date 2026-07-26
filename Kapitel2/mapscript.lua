--------------------------------------------------------------------------------
-- MapName: Kapitel2: Der Feind meines Feindes ...
--
-- Author: Zork
--
--------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
Script.Load("maps\\user\\Skripte\\Kapitel2\\main_mission.lua")
Script.Load("maps\\user\\Skripte\\Kapitel2\\side_quests.lua")
Script.Load("maps\\user\\Skripte\\Kapitel2\\briefings.lua")
Script.Load("maps\\user\\Skripte\\Kapitel2\\armies.lua")
Script.Load("maps\\user\\Skripte\\Kapitel2\\helper.lua")
Script.Load("maps\\user\\Skripte\\Kapitel2\\waves.lua")
Script.Load("maps\\user\\Skripte\\Kapitel2\\village_def_armies.lua")
IncludeGlobals("MapEditorTools")

Difficulty = 2
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(1, "Kerberos")
	SetPlayerName(2, "Finsterwald")
	SetPlayerName(3, "Geistertruppen")
	SetPlayerName(4, "Nebelvolk")
	SetPlayerName(5, "Altea")
	SetPlayerName(6, "Sonnspitz")
	SetPlayerName(7, "Südfang")
	SetHostile(1,3)
	SetHostile(2,3)
	SetHostile(1,4)
	SetHostile(2,4)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupEvelanceWeatherGfxSet()
    Camera.ZoomSetFactorMax(1)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
    ResearchTechnology( Technologies.T_KnightsCulture, 1)
	ResearchTechnology( Technologies.T_LeatherMailArmor, 1)
	ResearchTechnology( Technologies.T_ChainMailArmor, 1)
	ResearchTechnology( Technologies.T_IronCasting, 1)
	ResearchTechnology( Technologies.T_SoftArcherArmor, 1)
	ResearchTechnology( Technologies.T_WoodAging, 1)
	ResearchTechnology( Technologies.T_BodkinArrow, 1)
	ResearchTechnology( Technologies.T_FleeceArmor, 1)
	ResearchTechnology( Technologies.T_LeadShot, 1)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
    Display.SetPlayerColorMapping(1,12)
    Display.SetPlayerColorMapping(2,14)
	Display.SetPlayerColorMapping(3,13)
	Display.SetPlayerColorMapping(4,2)
	Display.SetPlayerColorMapping(5,9)
	Display.SetPlayerColorMapping(6,3)
	Display.SetPlayerColorMapping(7,1)
	Display.SetPlayerColorMapping(8,14)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
    if gvDiffLVL == 1 then
        Difficulty = 3
    elseif gvDiffLVL == 3 then
        Difficulty = 1
    end
	gvLighthouse.UpdateTroopQuality = function(_time)
		gvLighthouse.troopamount = math.max(gvLighthouse.troopamount, math.min(round(3 ^ (1 + 60 / 10000)), 10))
		gvLighthouse.soldieramount = math.max(gvLighthouse.soldieramount, math.min(round(2 ^ (1 + 60 / 2000)), 12))
		if table.getn(gvLighthouse.troops) > 14 then
			table.remove(gvLighthouse.troops, math.random(1, table.getn(gvLighthouse.troops) - 14))
		elseif table.getn(gvLighthouse.troops) > 6 and table.getn(gvLighthouse.troops) <= 14 then
			table.remove(gvLighthouse.troops, math.random(1, table.getn(gvLighthouse.troops) - 6))
		end
	end
    LocalMusic.UseSet = EVELANCEMUSIC
	gvMercenaryTower.Cooldown.BuyLeaderBlackKnight = 0
	gvMercenaryTower.Cooldown.BuyLeaderBlackSword = 0
	AIEnemies_ExcludedTypes[Entities.CU_AggressiveWolf] = true
	MapEditor_SetupAI(3, 1, 100000, 2, "armyStart1", 0, 0)
	SetupPlayerAi( 3, {} )
	MapEditor_SetupAI(4, 3, 100000, 2, "armyStart1", 0, 0)
	SetupPlayerAi( 4, {} )
	createStartingArmies()
	DisplaySpecialNames()
	createKardinel("KardinelSpawn")
	initDungeoncrawler()
	initKerberosArmorSideQuest()
	initVillageDefs()
	--testOutside()

	function GameCallback_PaydayPayed(_player,_amount)
		if (_player == 1) then
			if (VILLAGESTATUS[2] == 1) then
				checkForPayday2()
			end
			if (VILLAGESTATUS[5] == 1) then
				checkForPayday5()
			end
			if (VILLAGESTATUS[6] == 1) then
				checkForPayday6()
			end
			if (VILLAGESTATUS[7] == 1) then
				checkForPayday7()
			end
			if (VILLAGESTATUS[2] >= 1) then
				checkForPaydayMilitary2()
			end
			if (VILLAGESTATUS[5] >= 1) then
				checkForPaydayMilitary5()
			end
			if (VILLAGESTATUS[7] >= 1) then
				checkForPaydayMilitary7()
			end
		end
	end
end

function checkForPayday2()
	if IsDead("p2hq") then
		return
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(2)) do
        AddGold(5)
    end
	for i = 1, 4 do
		if IsDead("p2wood" .. i) == false then
			AddWood(100)
		end
	end
	for i = 1, 3 do
		if IsDead("p2iron" .. i) == false then
			AddIron(100)
		end
	end
end

function checkForPaydayMilitary2()
	if IsDead("stablep2") == false then
		local entity = Entities.PU_LeaderCavalry1
		if math.random(1,2) == 1 then
			entity = Entities.PU_LeaderHeavyCavalry1
		end
		CreateMilitaryGroup(1, entity, 5, GetPosition("p2cavspawn"))
	end
end

function checkForPayday5()
	if IsDead("p5hq") then
		return
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(5)) do
        AddGold(5)
    end
	for i = 1, 4 do
		if IsDead("p5wood" .. i) == false then
			AddWood(100)
		end
	end
	for i = 1, 3 do
		if IsDead("p5iron" .. i) == false then
			AddIron(100)
		end
	end
	for i = 1, 2 do
		if IsDead("p5gold" .. i) == false then
			AddGold(100)
		end
	end
end

function checkForPaydayMilitary5()
	for i = 1, 3 do
		if IsDead("barracksp5" .. i) == false and math.random(1,3) == 1 then
			local entity = Entities.PU_LeaderSword3
			if math.random(1,2) == 1 then
				entity = Entities.PU_LeaderPoleArm3
			end
			CreateMilitaryGroup(1, entity, 8, GetPosition("p5barracksspawn" .. i))
		end
	end
end

function checkForPayday6()
	if IsDead("p6hq") then
		return
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(6)) do
        AddGold(5)
    end
	if IsDead("p6iron") == false then
		AddIron(100)
	end
	if IsDead("p6gold") == false then
		AddGold(100)
	end
	for i = 1, 3 do
		if IsDead("p6sulfur" .. i) == false then
			AddSulfur(100)
		end
	end
	if IsDead("mineP6left") == false then
		AddSulfur(100)
	end
end

function checkForPayday7()
	if IsDead("p7hq") then
		return
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(7)) do
        AddGold(5)
    end
	if IsDead("p7wood") == false then
		AddWood(100)
	end
	for i = 1, 3 do
		if IsDead("p7iron" .. i) == false then
			AddIron(200)
		end
	end
	if IsDead("p7gold") == false then
		AddGold(100)
	end
	if IsDead("p7sulfur") == false then
		AddSulfur(100)
	end
end

function checkForPaydayMilitary7()
	for i = 1, 2 do
		if IsDead("archeryp7" .. i) == false and math.random(1,5) == 1 then
			local entity = Entities.PU_LeaderBow4
			if math.random(1,2) == 1 then
				entity = Entities.PU_LeaderRifle2
			end
			CreateMilitaryGroup(1, entity, 12, GetPosition("p7archerspawn" .. i))
		end
	end
	if IsDead("barracksp7") == false and math.random(1,5) == 1 then
		local entity = Entities.PU_LeaderSword4
		if math.random(1,2) == 1 then
			entity = Entities.PU_LeaderPoleArm4
		end
		CreateMilitaryGroup(1, entity, 12, GetPosition("p7barrackspawn"))
	end
	if IsDead("stablep6") == false and math.random(1,5) == 1 then
		local entity = Entities.PU_LeaderHeavyCavalry2
		if math.random(1,2) == 1 then
			entity = Entities.PU_LeaderCavalry2
		end
		CreateMilitaryGroup(1, entity, 12, GetPosition("p6cavspawn"))
	end
end

function createKardinel(_spawnpoint)
	CreateMilitaryGroup(1, Entities.CU_BlackKnight_LeaderSword3, 0, GetPosition(_spawnpoint),"Kardinel")
	StartCountdown(3, function ()
		Logic.SetEntityScriptingValue(GetEntityId("Kardinel"),72,1)
		CUtil.SetEntityDisplayName(GetEntityId("Kardinel"), "Kardinel")
	end, false)
	CEntity.SetMaxHealth(GetEntityId("Kardinel"),600)
	SetHealth("Kardinel", 100)
	CreateMilitaryGroup(2, Entities.CU_AggressiveWolf4, 0, GetPosition(_spawnpoint),"Feuerzahn")
	Logic.SetEntityInvulnerabilityFlag(GetEntityId("Feuerzahn"), 1)
	CEntity.SetDamage(GetEntityId("Feuerzahn"),40)
	StartCountdown(3, function ()
		Logic.SetEntityScriptingValue(GetEntityId("Feuerzahn"),72,1)
		CUtil.SetEntityDisplayName(GetEntityId("Feuerzahn"), "Feuerzahn")
	end, false)
	Logic.GroupGuard(GetEntityId("Feuerzahn"), GetEntityId("Kardinel"))
	StartSimpleJob("controlFeuerzahn")
end

function controlFeuerzahn()
	if IsDead("Feuerzahn") then
		return true
	end
	if Counter.Tick2("controlFeuerzahn", 20) then
		Logic.GroupGuard(GetEntityId("Feuerzahn"), GetEntityId("Kardinel"))
	end
end

function testOutside()
	local teleportPosOut = GetPosition("CrawlerExitKerberos")
    TeleportSettler(GetEntityId("Kerberos"), teleportPosOut.X,teleportPosOut.Y)
	for i = 1, 6 do
		CreateMilitaryGroup(1, Entities.CU_BlackKnight_LeaderMace1, 0, GetPosition("CrawlerExit"))
	end
	arriveOutside()
end