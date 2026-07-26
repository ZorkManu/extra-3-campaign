function BriefingStart()
    local briefing = {};
    local AP, ASP = AddPages(briefing);
    
    ASP("graveyard11", "Mentor","Die Toten erhebten sich eines Tages und versetzten die Siedlungen Evelances in Angst und Schrecken.")
    ASP("p1bow2", "Mentor","Die Dörfer bereiteten sich auf den Krieg vor.")
    ASP("village2", "Mentor","Auch wenn es ihnen nicht gefiehl mussten sie zusammenhalten ...")
    ASP("sp3village", "Mentor","... Um dem Übermächtigen Gegner standzuhalten.")
    ASP("lighthouse", "Mentor", "Der Leuchtturm wurde entzündet, Verstärkung war bereits in Bewegung gesetzt. Die Wege zu den umliegenden Reichen waren jedoch lang und beschwerlich.")
    ASP("towndefpoint3", "Mentor","Die nahe Festungsanlage des neuen Reiches sollte dabei helfen, selbst wenn ihre eigene Verteidigung standhalten muss.")

    if (fithplayeractive == 1) then
        ASP("Kerberos", "Mentor","Selbst Keberos war nicht sicher vor den Horden und musste sich mit den anderen Überlebenen zusammenschließen. Er befand sich in einer Höhle in der Nähe umgeben von Nebelvolk und musste sich vorerst einen Weg durch die Gegner bahnen, um zu den anderen Aufschließen zu können.")
        ASP("trollspawn1","Mentor","Doch passt auf, in der Höhle hausen Trolle! Ihr solltet es möglichst vermeiden sie zu wecken.")
    end

    ASP("hq4", "Missionsbeschreibung","Sorgt dafür, dass die Festungsanlage überlebt!",false)
    
    briefing.finished = function ()
        StartGame()
    end
        
    StartBriefing(briefing);
end

function BriefingReeinforcements()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("reeinfp41", "Mentor", "Seht nur! Die Verstärkung ist eingetroffen.")
    ASP("reeinfp11", "Mentor", "Es scheinen alle unsere Verbündete geantwortet zu haben!")
    ASP("reeinfp32", "Mentor", "Und an Truppen haben sie anscheinend auch nicht gespart.")
    ASP("CrawlerExit", "Mentor", "Selbst Kerberos Truppen haben sich zusammegefunden und eilen zur Hilfe!")
    ASP("graveyard14", "Mentor", "Jetzt ist die Zeit für den Gegenschlag, vernichtet die Invasoren bis auf den letzten Mann oder Troll!")

    briefing.finished = function ()
        showRemainingEnemiesCounter()
    end
        
    StartBriefing(briefing);
end