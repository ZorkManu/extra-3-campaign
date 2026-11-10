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
	--SetHostile(1,3)
	--SetHostile(2,3)
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
	armyOverrides()
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
	ActivateBriefingsExpansion = function()
		if not unpack{true} then 
			local unpack2;
			unpack2 = function( _table, i )
								i = i or 1;
								assert(type(_table) == "table");
								if i <= table.getn(_table) then
									return _table[i], unpack2(_table, i);
								end
							end
			unpack = unpack2;
		end
	 
		Briefing_ExtraOrig = Briefing_Extra;
	 
		Briefing_Extra = function( _v1, _v2 )
							 for i = 1, 2 do
								 local theButton = "CinematicMC_Button" .. i;
								 XGUIEng.DisableButton(theButton, 1);
								 XGUIEng.DisableButton(theButton, 0);
							 end
	 
							 if _v1.action then
								 assert( type(_v1.action) == "function" );
								 if type(_v1.parameters) == "table" then 
									 _v1.action(unpack(_v1.parameters));
								 else
									 _v1.action(_v1.parameters);
								 end
							 end
	 
							 Briefing_ExtraOrig( _v1, _v2 );
						 end;
	 
		GameCallback_EscapeOrig = GameCallback_Escape;
		StartBriefingOrig = StartBriefing;
		EndBriefingOrig = EndBriefing;
		MessageOrig = Message;
		CreateNPCOrig = CreateNPC;
	 
		StartBriefing = function(_briefing)
							assert(type(_briefing) == "table");
							if _briefing.noEscape then
								GameCallback_Escape = function() end;
								briefingState.noEscape = true;
							end
	 
							StartBriefingOrig(Umlaute(_briefing));
						end
	 
		EndBriefing = function()
						  if briefingState.noEscape then
							  GameCallback_Escape = GameCallback_EscapeOrig;
							  briefingState.noEscape = nil;
						  end
	 
						  EndBriefingOrig();
					  end;
	 
		Message = function(_text)
					  MessageOrig(Umlaute(tostring(_text)));
				  end;
	 
		CreateNPC = function(_npc)
						CreateNPCOrig(Umlaute(_npc));
					end;
	 
		Umlaute = function(_text)
					  local texttype = type(_text);
					  if texttype == "string" then
						  _text = string.gsub( _text, "ä", "\195\164" );
						  _text = string.gsub( _text, "ö", "\195\182" );
						  _text = string.gsub( _text, "ü", "\195\188" );
						  _text = string.gsub( _text, "ß", "\195\159" );
						  _text = string.gsub( _text, "Ä", "\195\132" );
						  _text = string.gsub( _text, "Ö", "\195\150" );
						  _text = string.gsub( _text, "Ü", "\195\156" );
						  return _text;
					  elseif texttype == "table" then
						  for k, v in _text do
							  _text[k] = Umlaute( v );
						  end
						  return _text;
					  else return _text;
					  end
				  end;
	end
	ActivateBriefingsExpansion()
    LocalMusic.UseSet = EVELANCEMUSIC
	gvMercenaryTower.Cooldown.BuyLeaderBlackKnight = 0
	gvMercenaryTower.Cooldown.BuyLeaderBlackSword = 0
	AIEnemies_ExcludedTypes[Entities.CU_AggressiveWolf] = true
	MapEditor_SetupAI(3, 1, 100000, 2, "armyStart1", 0, 0)
	SetupPlayerAi( 3, {} )
	MapEditor_SetupAI(4, 3, 100000, 2, "armyStart1", 0, 0)
	SetupPlayerAi( 4, {} )
	DisplaySpecialNames()
	createKardinel("KardinelSpawn")
	initDungeoncrawler()
	initKerberosArmorSideQuest()
	initVillageDefs()
	--testOutside()
	BriefingStart()

	local pos = GetPosition("altarright");
	Logic.CreateEffect( GGL_Effects.FXTemplarAltarEffect, pos.X, pos.Y, 2 );
	pos = GetPosition("altarleft");
	Logic.CreateEffect( GGL_Effects.FXTemplarAltarEffect, pos.X, pos.Y, 2 );

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
        AddGold(7)
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
	if VILLAGESTATUS[2] == 3 then
		return
	end
	if IsDead("stablep2") == false then
		local entity = Entities.PU_LeaderCavalry1
		if math.random(1,2) == 1 then
			entity = Entities.PU_LeaderHeavyCavalry1
		end
		local pos = GetPosition("p2cavspawn")
		CreateMilitaryGroup(1, entity, 5, pos)
		GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
		StartCountdown(5, function ()
			GUI.DestroyMinimapPulse(GetPosition("p2cavspawn").X, GetPosition("p2cavspawn").Y)
		end, false)
	end
end

function checkForPayday5()
	if IsDead("p5hq") then
		return
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(5)) do
        AddGold(7)
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
	if VILLAGESTATUS[5] == 3 then
		return
	end
	for i = 1, 3 do
		if IsDead("barracksp5" .. i) == false and (math.random(1,5) == 1 or i == 2) then
			local entity = Entities.PU_LeaderSword3
			if math.random(1,2) == 1 then
				entity = Entities.PU_LeaderPoleArm3
			end
			local pos = GetPosition("p5barracksspawn" .. i)
			CreateMilitaryGroup(1, entity, 8, pos)
			GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
			if i == 1 then
				StartCountdown(5, function ()
					GUI.DestroyMinimapPulse(GetPosition("p5barracksspawn1").X, GetPosition("p5barracksspawn1").Y)
				end, false)
			elseif i == 2 then
				StartCountdown(5, function ()
					GUI.DestroyMinimapPulse(GetPosition("p5barracksspawn2").X, GetPosition("p5barracksspawn2").Y)
				end, false)
			else
				StartCountdown(5, function ()
					GUI.DestroyMinimapPulse(GetPosition("p5barracksspawn3").X, GetPosition("p5barracksspawn3").Y)
				end, false)
			end
		end
	end
end

function checkForPayday6()
	if IsDead("p6hq") then
		return
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(),CEntityIterator.OfPlayerFilter(6)) do
        AddGold(7)
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
        AddGold(10)
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
	local noUnits = true
	for i = 1, 2 do
		if IsDead("archeryp7" .. i) == false and math.random(1,4) == 1 then
			local entity = Entities.PU_LeaderBow4
			if math.random(1,2) == 1 then
				entity = Entities.PU_LeaderRifle2
			end
			local pos = GetPosition("p7archerspawn" .. i)
			CreateMilitaryGroup(1, entity, 12, pos)
			GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
			if i == 1 then
				StartCountdown(5, function ()
					GUI.DestroyMinimapPulse(GetPosition("p7archerspawn1").X, GetPosition("p7archerspawn1").Y)
				end, false)
			elseif i == 2 then
				StartCountdown(5, function ()
					GUI.DestroyMinimapPulse(GetPosition("p7archerspawn2").X, GetPosition("p7archerspawn2").Y)
				end, false)
			else
				StartCountdown(5, function ()
					GUI.DestroyMinimapPulse(GetPosition("p7archerspawn3").X, GetPosition("p7archerspawn3").Y)
				end, false)
			end
			noUnits = false
		end
	end
	if IsDead("barracksp7") == false and math.random(1,4) == 1 then
		local entity = Entities.PU_LeaderSword4
		if math.random(1,2) == 1 then
			entity = Entities.PU_LeaderPoleArm4
		end
		local pos = GetPosition("p7barrackspawn")
		CreateMilitaryGroup(1, entity, 12, pos)
		GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
		StartCountdown(5, function ()
			GUI.DestroyMinimapPulse(GetPosition("p7barrackspawn").X, GetPosition("p7barrackspawn").Y)
		end, false)
		noUnits = false
	end
	if IsDead("stablep6") == false and math.random(1,4) == 1 then
		local entity = Entities.PU_LeaderHeavyCavalry2
		if math.random(1,2) == 1 then
			entity = Entities.PU_LeaderCavalry2
		end
		local pos = GetPosition("p6cavspawn")
		CreateMilitaryGroup(1, entity, 12, pos)
		GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
		StartCountdown(5, function ()
			GUI.DestroyMinimapPulse(GetPosition("p6cavspawn").X, GetPosition("p6cavspawn").Y)
		end, false)
		noUnits = false
	end
	if IsDead("foundryp7") == false and math.random(1,4) == 1 then
		local entity = Entities.PV_Cannon3
		local pos = GetPosition("p7cannonspawn")
		CreateMilitaryGroup(1, entity, 12, pos)
		GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
		StartCountdown(5, function ()
			GUI.DestroyMinimapPulse(GetPosition("p7cannonspawn").X, GetPosition("p7cannonspawn").Y)
		end, false)
		noUnits = false
	end
	if noUnits == true then
		if IsDead("archeryp72") == false then
			local entity = Entities.PU_LeaderBow4
			local pos = GetPosition("p7archerspawn2")
			CreateMilitaryGroup(1, entity, 12, pos)
			GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
			StartCountdown(5, function ()
				GUI.DestroyMinimapPulse(GetPosition("p7archerspawn2").X, GetPosition("p7archerspawn2").Y)
			end, false)
		end
	end
end

function createKardinel(_spawnpoint)
	CreateMilitaryGroup(1, Entities.CU_BlackKnight_Hero2, 0, GetPosition(_spawnpoint),"Kardinel")
	CUtil.SetEntityDisplayName(GetEntityId("Kardinel"), "Kardinel")
	createFeuerzahn()
end

function controlFeuerzahn()
	if IsDead("Kardinel") then
		DestroyEntity(GetEntityId("Feuerzahn"))
		return true
	end
	if IsDead("Feuerzahn") then
		StartCountdown(10,createFeuerzahn,false)
		return true
	end
	if Counter.Tick2("controlFeuerzahn", 20) then
		Logic.GroupGuard(GetEntityId("Feuerzahn"), GetEntityId("Kardinel"))
	end
end

function createFeuerzahn()
	if IsDead("Kardinel") then
		return true
	end
	if IsDead("Feuerzahn") == false then
		return true
	end
	CreateMilitaryGroup(2, Entities.CU_BlackKnight_Hero2_Wolf, 0, GetPosition("Kardinel"),"Feuerzahn")
	CUtil.SetEntityDisplayName(GetEntityId("Feuerzahn"), "Feuerzahn")
	Logic.GroupGuard(GetEntityId("Feuerzahn"), GetEntityId("Kardinel"))
	StartSimpleJob("controlFeuerzahn")
end

function testOutside()
	local teleportPosOut = GetPosition("CrawlerExitKerberos")
	SetHostile(1,3)
	SetHostile(2,3)
    TeleportSettler(GetEntityId("Kerberos"), teleportPosOut.X,teleportPosOut.Y)
	createKardinel("CrawlerExitKardinel")
	for i = 1, 6 do
		CreateMilitaryGroup(1, Entities.CU_BlackKnight_LeaderMace1, 0, GetPosition("CrawlerExit"))
	end
	ResearchTechnology( Technologies.T_HeroicShoes)
	ResearchTechnology( Technologies.T_HeroicArmor)
	arriveOutside()
end