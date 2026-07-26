--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Music Script Credit to Ghoul
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
LocalMusic = LocalMusic or {}

LocalMusic.MusicPath = "maps\\user\\Skripte\\Koop\\music\\"

LocalMusic.SetEvelance["summer"] = 	{
	{ "19_Evelance_Summer1.mp3", 154 },
	{ "20_Evelance_Summer2.mp3", 152 },
	{ "21_Evelance_Summer3.mp3", 165 },
	{ "22_Evelance_Summer4.mp3", 150 },
	{ "23_Evelance_Summer5.mp3", 158 },
	{ "24_Evelance_Summer6.mp3", 168 }
}

LocalMusic.SetEvelance["snow"] =		{
	{ "29_Evelance_Winter1.mp3", 135 },
	{ "25_MiddleEurope_Winter1.mp3", 144 }
}

LocalMusic.Bossfight2 = {
	{ "ReturntotheWarrens.mp3", 81 }
}
LocalMusic.Bossfight3 = {
	{ "TowninChaos.mp3", 360 }
}
LocalMusic.Bossfight4 = {
	{ "DarkestDungeonBeneaththeKingdom.mp3", 360 }
}
LocalMusic.SetMainTheme = LocalMusic.SetEvelance["summer"]

LocalMusic.SongLength = 0
LocalMusic.BattlesOnTheMap = 0
LocalMusic.LastBattleMusicStarted = 0

function LocalMusic_UpdateMusic()
	if TICK > 2 then
		if Counter.GetTick("Boss2") > 1 or Counter.GetTick("Boss3") > 1 or Counter.GetTick("Boss4") > 1 then
			BOSSFIGHT2 = false
			BOSSFIGHT3 = false
			BOSSFIGHT4 = false
			return
		end
	end
	if BOSSFIGHT2 == false and BOSSFIGHT3 == false and BOSSFIGHT4 == false and LocalMusic.SongLength ~= 0 then
		--Music is playing?
		if LocalMusic.SongLength > Logic.GetTime() then
			return
		end
	end

	local Weather = Logic.GetWeatherState()
	
	if Weather == 1 then
		--normal
		Weather = "summer"
	elseif Weather == 2 then
		--rain
		Weather = "summer"
	elseif Weather == 3 then
		--snow
		Weather = "snow"
	end

	LocalMusic.MusicPath = "maps\\user\\Skripte\\Koop\\music\\"

	local SetToUse

	if BOSSFIGHT2 == true then
		SetToUse = LocalMusic.Bossfight2
	elseif BOSSFIGHT3 == true then
		SetToUse = LocalMusic.Bossfight3
	elseif BOSSFIGHT4 == true then
		SetToUse = LocalMusic.Bossfight4
	else
		SetToUse = LocalMusic.SetEvelance[Weather]
		LocalMusic.MusicPath = Folders.Music
	end

	--is briefing running?
 	if (IsBriefingActive ~= nil and IsBriefingActive() == true )
 	or (IsCutsceneActive~= nil and IsCutsceneActive() == true)then
		SetToUse = LocalMusic.SetBriefing
	end

	local SongAmount = table.getn(SetToUse)
	local Random = 1 + XGUIEng.GetRandom(SongAmount-1)
	local SongToPlay = LocalMusic.MusicPath .. SetToUse[Random][1]

	Sound.StartMusic( SongToPlay, 157)
	LocalMusic.SongLength =  Logic.GetTime() + SetToUse[Random][2] + 2

	LocalMusic.BattlesOnTheMap = 0

end

function initBossMusicCounter()
	Counter.Tick2("Boss2", LocalMusic.Bossfight2[1][2])
	Counter.Tick2("Boss3", LocalMusic.Bossfight3[1][2])
	Counter.Tick2("Boss4", LocalMusic.Bossfight4[1][2])
end

function tickBossCounter(_boss)
	Counter.Tick("Boss" .. _boss)
	if Counter.GetTick("Boss" .. _boss) == 0 then
		return true
	end
end