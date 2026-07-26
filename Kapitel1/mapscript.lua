--------------------------------------------------------------------------------
-- MapName: Kapitel1: Alte Fehden neue Chancen
--
-- Author: Zork
--
--------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
Script.Load("maps\\user\\Skripte\\Kapitel1\\main_mission.lua")
Script.Load("maps\\user\\Skripte\\Kapitel1\\side_quests.lua")
Script.Load("maps\\user\\Skripte\\Kapitel1\\briefings.lua")
Script.Load("maps\\user\\Skripte\\Kapitel1\\armies.lua")
IncludeGlobals("MapEditorTools")

Difficulty = 2

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
    SetPlayerName(2, "Nevassa")
    SetHostile(1,2)
	SetFriendly(2,6)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (500)
    AddIron  (500)
    AddWood  (3000)	
    AddClay  (1200)	
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupHighlandWeatherGfxSet()
    Camera.ZoomSetFactorMax(1.5)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
    ResearchTechnology( Technologies.T_BarbarianCulture, 1)
    ForbidTechnology( Technologies.UP2_Headquarter, 1 )
	ForbidTechnology( Technologies.UP1_Market, 1)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
    Display.SetPlayerColorMapping(1,2)
    Display.SetPlayerColorMapping(2,1)
	Display.SetPlayerColorMapping(3,13)
	Display.SetPlayerColorMapping(4,13)
	Display.SetPlayerColorMapping(5,6)
	Display.SetPlayerColorMapping(6,7)
	Display.SetPlayerColorMapping(7,9)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
    if gvDiffLVL == 1 then
        Difficulty = 3
    elseif gvDiffLVL == 3 then
        Difficulty = 1
    end
    LocalMusic.UseSet = HIGHLANDMUSIC
    MapEditor_SetupAI(2, 3, 10000, 2, "southEntrance", 0, 0)
	SetupPlayerAi( 2, {constructing = false, extracting = true, repairing = true, serfLimit = 4} )
	MapEditor_SetupAI(6, 3, 100000, 2, "eresummon2", 0, 0)
	SetupPlayerAi( 6, {constructing = false, extracting = true, repairing = true, serfLimit = 4} )
    MapEditor_Armies[2].offensiveArmies.strength = 0
    MapEditor_Armies[2].defensiveArmies.strength = 0
	MapEditor_Armies[2].description.rebuildData.delay = 999999
    createArmyMine()
    BriefingStart()
    initSmithQuest()
    initSilverQuest()
end

--https://dedk.de/wiki/doku.php?id=tutorials:briefings-erweiterungen
function ActivateBriefingsExpansion()
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

function Modulo(_A, _B)
    while _A > _B do
        _A = _A - _B
    end
    return _A
end