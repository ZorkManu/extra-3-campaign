--------------------------------------------------------------------------------
-- MapName: Kapitel3: Schlacht um Mercius
--
-- Author: Zork
--
--------------------------------------------------------------------------------
SCHWARZACTIVE = false
KARDINELACTIVE = false

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
Script.Load( "maps\\user\\Skripte\\Kapitel4\\helper.lua")
IncludeGlobals("MapEditorTools")
Difficulty = 2

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
    ResearchTechnology( Technologies.B_Mercenary, 1 )
    ResearchTechnology( Technologies.T_BanditCulture, 1)
    gvMercTechsCheated = 1
    ResearchTechnology( Technologies.T_KnightsCulture, 1)
    ResearchTechnology( Technologies.T_BarbarianCulture, 1)
    ForbidTechnology( Technologies.T_EvilCulture, 1)
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
	AddPeriodicNight(10)
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
    Display.SetPlayerColorMapping(8,3)
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
    armyOverrides()
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

    if gvDiffLVL == 1 then
        Difficulty = 3
    elseif gvDiffLVL == 3 then
        Difficulty = 1
    end

    Camera.ZoomSetFactorMax(1.75)

    if GDB.GetString("mayorSturmbach") ~= "Schwarz" then
        SCHWARZACTIVE = true
    end
    if GDB.GetString("FmFKardinel") == "1" then
        KARDINELACTIVE = true
    end

    for i = 1,6 do
        ChangePlayer("w" .. i, 2)
    end

    for i = 2, 8 do 
        if i < 5 and i > 6 then
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
    end
    ResearchTechnology(Technologies.T_SilverSwords,8)
    ResearchTechnology(Technologies.T_SilverSwords,7)
    ResearchTechnology(Technologies.T_SilverPlateArmor,7)
    ResearchTechnology(Technologies.T_SilverArrows,7)
    ResearchTechnology(Technologies.T_SilverArcherArmor,7)
    ResearchTechnology(Technologies.T_SilverLance,7)
    ResearchTechnology(Technologies.T_SilverBullets,7)

    gvMercenaryTower.Cooldown.BuyLeaderBanditSword = 0
	gvMercenaryTower.Cooldown.BuyLeaderBanditBow = 0
    gvMercenaryTower.Cooldown.BuyLeaderBlackKnight = 0
	gvMercenaryTower.Cooldown.BuyLeaderBlackSword = 0
    gvMercenaryTower.Cooldown.BuyLeaderBarbarian = 0
	gvMercenaryTower.Cooldown.BuyLeaderElite = 0
    gvHeroAbilities["AbilitiesByHero"][Entities.PU_Hero4_Spectral] = {Abilities.AbilityRangedEffect, Abilities.AbilityCircularAttack}

    if GDB.GetString("FmFSuedfang") == 1 then
        
    else
        for i = 1, 30 do
            DestroyEntity("f" .. i)
        end
    end

    Tools.ExploreArea( -1, -1, 900 )
end

function createSchwarz()
    if SCHWARZACTIVE then
        CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("SchwarzSpawn"), "Schwarz")
        LookAt("Schwarz","p2barracksspawn")
        CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
        StartSimpleJob("checkForSchwarz")
    end
end

function checkForSchwarz()
    if IsDead("Schwarz") then
        StartCountdown(60, function ()
            if IsDead("Schwarz") then
                createSchwarz()
                local pos = GetPosition("SchwarzSpawn")
			    GUI.CreateMinimapPulse(pos.X, pos.Y, 1)
			    StartCountdown(5, function ()
				    GUI.DestroyMinimapPulse(GetPosition("SchwarzSpawn").X, GetPosition("SchwarzSpawn").Y)
			    end, false)
            end
        end, false)
        return true
    end
end

function createKardinel(_spawnpoint)
	CreateMilitaryGroup(4, Entities.CU_BlackKnight_LeaderSword3, 0, GetPosition(_spawnpoint),"Kardinel")
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
	CreateMilitaryGroup(4, Entities.CU_AggressiveWolf4, 0, GetPosition("Kardinel"),"Feuerzahn")
	Logic.GroupGuard(GetEntityId("Feuerzahn"), GetEntityId("Kardinel"))
	StartSimpleJob("controlFeuerzahn")
end

function looseCondition()
    if IsDead("p1hq") then
        Defeat()
        return true
    end
end