function Modulo(_A, _B)
    while _A >= _B do
        _A = _A - _B
    end
    return _A
end

function SetUpGameLogicOnMPGameConfigLight()

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Transfer player names
	do
		for PlayerID=1, HumenPlayer, 1 do
			local PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
			Logic.SetPlayerRawName( PlayerID, PlayerName )
		end
	end

	-- Set game state & human flag - transfer player color (needed in logic for post game statistics)
	do
		for PlayerID=1, HumenPlayer, 1 do
			local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( PlayerID )
			if IsHumanFlag == 1 then
				Logic.PlayerSetGameStateToPlaying( PlayerID )
				Logic.PlayerSetIsHumanFlag( PlayerID, 1 )

				local PlayerColorR, PlayerColorG, PlayerColorB = GUI.GetPlayerColor( PlayerID )
				Logic.PlayerSetPlayerColor( PlayerID, PlayerColorR, PlayerColorG, PlayerColorB )
			end
		end
	end

	-- Set up FoW
	MultiplayerTools.SetUpFogOfWarOnMPGameConfig()
	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	--[AnSu] I have to make a function to init the MP Interface
	--XGUIEng.ShowWidget(gvGUI_WidgetID.DiplomacyWindowMiniMap,0)
	XGUIEng.ShowWidget(gvGUI_WidgetID.NetworkWindowInfoCustomWidget,1)



	--Extra keybings only in MP
	Input.KeyBindDown(Keys.NumPad0, "KeyBindings_MPTaunt(1,1)", 2)  --Yes
	Input.KeyBindDown(Keys.NumPad1, "KeyBindings_MPTaunt(2,1)", 2)  --No
	Input.KeyBindDown(Keys.NumPad2, "KeyBindings_MPTaunt(3,1)", 2)  --Now
	Input.KeyBindDown(Keys.NumPad3, "KeyBindings_MPTaunt(7,1)", 2)  --help
	Input.KeyBindDown(Keys.NumPad4, "KeyBindings_MPTaunt(8,1)", 2)  --clay
	Input.KeyBindDown(Keys.NumPad5, "KeyBindings_MPTaunt(9,1)", 2)  --gold
	Input.KeyBindDown(Keys.NumPad6, "KeyBindings_MPTaunt(10,1)", 2) --iron
	Input.KeyBindDown(Keys.NumPad7, "KeyBindings_MPTaunt(11,1)", 2) --stone
	Input.KeyBindDown(Keys.NumPad8, "KeyBindings_MPTaunt(12,1)", 2) --sulfur
	Input.KeyBindDown(Keys.NumPad9, "KeyBindings_MPTaunt(13,1)", 2) --wood

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad0, "KeyBindings_MPTaunt(5,1)", 2)  --attack here
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "KeyBindings_MPTaunt(6,1)", 2)  --defend here

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad2, "KeyBindings_MPTaunt(4,0)", 2)  --attack you
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad3, "KeyBindings_MPTaunt(14,0)", 2) --VeryGood
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "KeyBindings_MPTaunt(15,0)", 2) --Lame
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_MPTaunt(16,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad6, "KeyBindings_MPTaunt(17,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "KeyBindings_MPTaunt(18,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_MPTaunt(19,0)", 2) --funny comments

end

function SuspendAllStartEntities()
    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(1)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.SuspendEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(2)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 and Logic.GetEntityType(eID) ~= Entities.CB_Grange then
            Logic.SuspendEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(3)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.SuspendEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(4)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.SuspendEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(5)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.SuspendEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(6)) do
        Logic.SuspendEntity(eID)
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(7)) do
        Logic.SuspendEntity(eID)
    end
end

function ResumeAllStartEntities()
    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(1)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.ResumeEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(2)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 and Logic.GetEntityType(eID) ~= Entities.CB_Grange then
            Logic.ResumeEntity(eID)
        end
    end

	for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(3)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.ResumeEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(4)) do
        if Logic.GetEntityType(eID) ~= Entities.PB_Farm1 and Logic.GetEntityType(eID) ~= Entities.PB_Farm2 and Logic.GetEntityType(eID) ~= Entities.PB_Farm3 and Logic.GetEntityType(eID) ~= Entities.PB_Tavern1 then
            Logic.ResumeEntity(eID)
        end
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(5)) do
        Logic.ResumeEntity(eID)
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(6)) do
        Logic.ResumeEntity(eID)
    end

    for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerOrBuildingFilter(),CEntityIterator.OfPlayerFilter(7)) do
        Logic.ResumeEntity(eID)
    end
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

function UseNecroAbility(_Hero) -- source: https://dedk.de/wiki/doku.php?id=utilfunctions:useheroability
    -- Get hero ID
    local HeroID = GetEntityId(_Hero)
	local Ability = Abilities.AbilityCircularAttack

    if Counter.Tick2("UseNecroAbility" .. _Hero, 2) then
        if Logic.HeroGetAbilityRechargeTime(HeroID, Ability) == Logic.HeroGetAbiltityChargeSeconds(HeroID, Ability) then
            CSendEvent.HeroCircularAttack(HeroID)
            local pos = GetPosition(_Hero)
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "countdownNecroArmy" , 1, {}, {_Hero})
            return true
        end
    end
	return false
end

function countdownNecroArmy(_NecroNo)
	if Counter.Tick2("countdownNecroArmy" .. _NecroNo, 3) then
        if IsDead(GetEntityId(_NecroNo)) then
            return true
        end
		createNecroArmy(_NecroNo)
		return true
	end
end

function getRandomGhostTroop()
    local randomGenerator = math.random()
	if SPECIALSACTIVE == 1 then
        if math.random(1,100) == 1 then
            return Entities.PV_Cannon2
        elseif math.random(1,100) == 2 then
            return Entities.PV_Cannon1
        end 
    end
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
    if randomGenerator < 0.25 then
        return Entities.CU_Evil_LeaderBearman1
    elseif randomGenerator < 0.50 then
        return Entities.CU_Evil_LeaderCavalry1
    elseif randomGenerator < 0.75 then
        return Entities.CU_Evil_LeaderSkirmisher1
    else
        return Entities.CU_Evil_LeaderSpearman1
   	end
end