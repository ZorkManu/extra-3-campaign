function BriefingStart()
    local briefing = {};
    local AP, ASP = AddPages(briefing);
    
    ASP("banditAmbush", "Mentor","In dieser normalerweise eher ruhigen Gegend war der Frieden eines Tages am wanken.")
    ASP("defenseArmyGhost", "Mentor","Wie aus dem nichts erschienen sowohl Geister als auch das Nebelvolk.")
    ASP("BaseWinkelhain", "Mentor","Die sonst so friedlichen Dörfer waren auf einmal in der Lage sich verteidigen zu müssen.")
    ASP("BaseSturmbach", "Mentor","Die Kriegskunst war ihnen fern doch sie hatten keine andere Wahl.")
    ASP("banditAmbush", "Mentor", "Ein kleiner Außenposten des Reiches stand in der Nähe, musste sich aber vorerst wieder aufbauen.")
    ASP("banditAmbush", "Missionsbeschreibung","Überlebt und schlagt die Feinde zurück!")
    
    briefing.finished = function ()
        StartGame()
    end
        
    StartBriefing(briefing);
end