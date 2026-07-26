function BriefingScout()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Scout","Kundschafter","Lord Kerberos, es ist eine Freude euch zu sehen. @cr Nachdem die Höhle von diesen Kreturen heimgesucht wurde, habe ich mich in dem Haus hier versteckt und gehofft Ihr würdet entkommen. Aus welchem Grund auch immer haben die weder mich noch meine Kanone angefasst.", true)
    ASP("Kerberos","Kerberos","Du Wurm weist, dass das an Dessertion grenzt oder? Wären wir nicht in dieser Lage hinge dein Kopf an einem Pfahl! @cr Du hast heute nochmal Glück, wir können einen Kundschafter gut gebrauchen, um durch die Höhle zu kommen.", true)
    ASP("Scout","Kundschafter","Habt Dank Mylord, ihr werdet diese Entscheidung nicht bereuen! @cr In der Höhle wimmelt es nur so von diesen Dämonen, aber das ist nicht unser einziges Problem...", true)
    ASP("trollspawn3","Kundschafter","In dieser Höhle hausen Trolle und die sind nicht weniger gefährlich. Zum Glück schlafen die, wir sollten sie also möglichst vermeiden.")
    ASP("Kardinel","Kardinel","Gut wir sollten die Gegend gut erkundschaften bevor wir voran gehen. Wir haben nicht die Männer um uns um Trolle zu kümmern.")
    ASP("CaveExit","Missionsbeschreibung","Ereicht den Ausgang!")

    briefing.finished = function ()
        local markerPos = GetPosition("CaveExit")
        GUI.CreateMinimapMarker(markerPos.X,markerPos.Y,2)
        Explore.Show("explCaveExit", "CaveExit", 1000)
        ChangePlayer("Scout",1)
        ChangePlayer("Bombard",1)
    end
    
    StartBriefing(briefing);
end

function BriefingArriveOutside()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    --ASP("Kerberos","Kerberos","Widerliche Viecher diese Trolle, endlich sind wir draußen. Kardinel, Bericht.", true)
    --ASP("Kardinel","Kardinel","Jawohl. Der Tunnel ist in der Nähe der Dörfer des neuen Reichs, die für den Fall Eurer Rückkehr aufgestellt wurden. Durch die eher umgequemen Tunnel haben die Bewohner sich allerdings nicht getraut genauer nach uns zu suchen.", true)
    --ASP("Kerberos","Kerberos","Wir sind also mitten im feindlichen Territorium? Sag mal Kardinel? ...", true)
    --ASP("Kardinel","Kardinel","Eure Boshaftigkeit?",true)
    --ASP("Kerberos","Kerberos","Wer hat dir eigentlich das denken beigebracht? WIE DUMM MUSS MAN SEIN MITTEN IN FEINDLICHES GEBIET ZU GEHEN, WENN WIR EH SCHON STARKEN TRUPPENMANGEL HABEN?! Was denkst du werden die wohl tun, wenn die uns sehen? Uns zum Kaffee einladen?",true)
    --("Kardinel","Kardinel","Beruhigt euch Euere Zornigkeit. Es war nun einmal der sicherste Weg aus dem Schloss. Und immerhin wisst Ihr gar nicht ob die Leute hier nicht schon anders beschäftigt sind. Wer weiß ob Mary hier auch schon ihr Unwesen trieb!",true)
    --ASP("Kerberos","Kerberos","Was bleibt uns Anderes übrig. Falls sich diese Dörfer aufständisch fühlen, vernichten wir sie einfach. Also dann Männer vorwärts!",true)
    ASP("test","test","test")

    briefing.finished = function ()
        arriveOutside()
    end

    StartBriefing(briefing);
end

function BriefingMayorAltea()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("test","test","test")

    briefing.finished = mayorAlteaSpoken

    StartBriefing(briefing);
end

function BriefingMayorSonnspitz()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("test","test","test")

    briefing.finished = mayorSonnspitzSpoken

    StartBriefing(briefing);
end

function BriefingMayorFinsterwald()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("test","test","test")

    briefing.finished = mayorFinsterwaldSpoken

    StartBriefing(briefing);
end

function BriefingAlteaEscape()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Bürgermeister Garek",
            text = "Können wir los?",
            position = GetPosition("mayorAltea"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Bürgermeister Garek",
        text = "Dann viel Glück!",
        position = GetPosition("mayorAltea"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Bürgermeister Garek",
        text = "Alles klar, braucht aber nicht zu lange. Ewig halten wir nicht mehr",
        position = GetPosition("mayorAltea"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                initVillageEscape(5)
			else 
				local NPC = {
                    name = "mayorAltea",
                    callback = BriefingAlteaEscape
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingSonnspitzEscape()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Bürgermeister Garek",
            text = "Können wir los?",
            position = GetPosition("mayorSonnspitz"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Bürgermeister Garek",
        text = "Dann viel Glück!",
        position = GetPosition("mayorSonnspitz"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Bürgermeister Garek",
        text = "Alles klar, braucht aber nicht zu lange. Ewig halten wir nicht mehr",
        position = GetPosition("mayorSonnspitz"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                initVillageEscape(6)
			else 
				local NPC = {
                    name = "mayorSonnspitz",
                    callback = BriefingSonnspitzEscape
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingFinsterwaldEscape()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Bürgermeister Garek",
            text = "Können wir los?",
            position = GetPosition("mayorFinsterwald"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Bürgermeister Garek",
        text = "Dann viel Glück!",
        position = GetPosition("mayorFinsterwald"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Bürgermeister Garek",
        text = "Alles klar, braucht aber nicht zu lange. Ewig halten wir nicht mehr",
        position = GetPosition("mayorFinsterwald"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                initVillageEscape(2)
			else 
				local NPC = {
                    name = "mayorFinsterwald",
                    callback = BriefingAlteaEscape
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingSuedfang()
    
end

function BriefingVictory()
end

function BriefingDefeat()
end

-- side_quests
function BriefingArmor()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kerberos","Kerberos","Da sind wir die Waffenkammer. Ich ziehe mich eben um, Kardinel halte Wache.", true)
    ASP("Kardinel","Kardinel","Ihr habt ihn gehört Männer. Keiner darf den dunklen König stören!", true)
    ASP("Kerberos","Nebenmission","Beschützt Kerberos! @cr Passt auf vor den Nekromanten. Vielleicht ist eis besser sie beschwören zu lassen, als Eure Truppen zu riskieren.")

    briefing.finished = function ()
        armorQuest()
    end
    
    StartBriefing(briefing);
end