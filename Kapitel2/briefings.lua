function BriefingStart()
    local npc = {
        name = "Kardinel",
    }
    CreateNPC(npc)
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kerberos","Kerberos","Mary, was bringt dich hierher, ist dein neuster Plan schon geschmiedet?", true)
    ASP("Mary","Mary","Sehr wohl und er ist schon im vollen Gange. Die Kunde hat dich wohl noch nicht erreicht, mehrere Dörfer, Städte und sogar Festungen des neuen Reichs sind bereits dem Erdboden gleich.", true)
    ASP("Kerberos","Kerberos","Du meinst vollkommen zerstört? @cr Und über was sollen wir herrschen wenn du fertig bist? Wie bist du überhaupt an so viele Soldaten gekommen, dass so etwas auch nur annähernd möglich ist?",true)
    ASP("Mary","Mary","Es geht mir nicht mehr um das Herrschen. @cr Ich möchte Rache an denjenigen nehmen, die damals meinen Plan vereitelt haben und weil meine Gifte nicht für ganze Armeen reichen habe ich mich an anderen Methoden bedient.", true)
    ASP("Kerberos","Kerberos","Das Reich völlig zu zerstören war nie der Plan! @cr Rache hin oder her, eine Schreckensherrschaft kann ohne Bewohner nicht funktionieren!",true)
    AP{
		title = "Mary",
		text = "Schade, ich hätte gehofft, dass wir einer Meinung wären. Gut dann sollst du auch Zeuge meiner Macht werden.",
		position = GetPosition("Mary"),
        dialogCamera = false,
        action = function ()
            UseHeroAbility(GetEntityId("Mary"), Abilities.AbilityCircularAttack, false)
            createArmyStart()
        end
	}
    AP{
		title = "Kardinel",
		text = "Dunkler Lord, überall im Schloss sind Feinde aufgetaucht, es sind zu viele, Ihr müsst Euch in Sicherheit bringen!",
		npc = {
            id = GetEntityId("Kardinel"),
            isObserved = true
        },
        action = function ()
            Move("Kardinel", "KardinelMovePose")
        end
	}
    ASP("Kerberos","Kerberos","Mary was hast du getan?!",true)
    ASP("Mary","Mary","Es wird Zeit deinen Platz in meiner neuen Armee zu finden, aber verstehe mich nicht falsch du wirst nicht freiwillig daran teilnehmen.",true)

    briefing.finished = function ()
        createStartingArmies()
        StartSimpleJob("checkForStartArmies")
        SetHostile(1,3)
        SetHostile(2,3)
        DestroyNPC(npc)
    end

    StartBriefing(briefing);
end

function BriefingFirstBattleDone()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local page1 = AP{
		title = "Mary",
		text = "Ich glaube das genügt erstmal als Einstieg, ich muss mich um die umliegenden Dörfer kümmern. @cr Meine Untertanen werden Euch wohl genug beschäftigen.",
		npc = {
            id = GetEntityId("Mary"),
            isObserved = true
        },
        action = function ()
            StartSimpleJob("moveMaryOut")
        end,
	};

    ASP("Kerberos","Kerberos","Kardinel, Bericht was geht hier vor?",true)
    ASP("Kardinel","Kardinel","Eure Hoheit, die Situation ist komplett aus der Kontrolle. Überall in unserem Schloss wimmelt es nur so von durchsichtigen Kriegern.", true)
    ASP("closedindoorgate","Kardinel","Unsere einzige Chance ist es zu fliehen und so viele Leute wie möglich mitzunehmen. @cr Auf dem Weg hierher ist Feuerzahn und mir das Tor zur Speisekammer aufgefallen, dort sollte es einen Weg in die anliegenden Höhlensysteme geben.", false)
    ASP("Kerberos","Kerberos","Bitte sag mir nicht du hast deinen Hund \"Feuerzahn\" genannt. Wie alt bist du? 14?",true)
    ASP("Kardinel","Kardinel","Doch, das habe ich. Er klingt cool und reflektiert meine lässige Persönlichkeit.",true)
    ASP("Kerberos","Kerberos","...",true)
    ASP("Kerberos","Kerberos","Auf gehts Männer wir müssen Richtung Speisekammer. @cr Wir werden uns draußen mit unseren restlichen Truppen sammeln und dann zurückschlagen!",true)
    ASP("Kerberos","Missionsbeschreibung","Entkommt der schwarzen Festung.",false)

    briefing.finished = function ()
        ResolveBriefing(page1);
    end
    
    StartBriefing(briefing);
end

function BriefingScout()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Scout","Kundschafter","Lord Kerberos, es ist eine Freude euch zu sehen. @cr Nachdem die Höhle von diesen Kreaturen heimgesucht wurde, habe ich mich in dem Haus hier versteckt und gehofft Ihr würdet entkommen. Aus welchem Grund auch immer haben die weder mich noch meine Kanone angefasst.", true)
    ASP("Kerberos","Kerberos","Du Wurm weißt, dass das an Desertion grenzt oder? Wären wir nicht in dieser Lage hinge dein Kopf an einem Pfahl! @cr Du hast heute nochmal Glück, wir können einen Kundschafter gut gebrauchen, um durch die Höhle zu kommen.", true)
    ASP("Scout","Kundschafter","Habt Dank Mylord, Ihr werdet diese Entscheidung nicht bereuen! @cr In der Höhle wimmelt es nur so von diesen Dämonen, aber das ist nicht unser einziges Problem...", true)
    ASP("trollspawn3","Kundschafter","In dieser Höhle hausen Trolle und die sind nicht weniger gefährlich. Zum Glück schlafen die, wir sollten sie also möglichst vermeiden.")
    ASP("Kardinel","Kardinel","Gut wir sollten die Gegend gut erkundschaften bevor wir voran gehen. Wir haben nicht die Männer um uns um Trolle zu kümmern.")
    ASP("CaveExit","Missionsbeschreibung","Erreicht den Ausgang!")

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
    LookAt("Kardinel","Kerberos")
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kerberos","Kerberos","Widerliche Viecher diese Trolle, endlich sind wir draußen. Kardinel, Bericht.", true)
    ASP("Kardinel","Kardinel","Jawohl. Der Tunnel ist in der Nähe der Dörfer des neuen Reichs, die für den Fall Eurer Rückkehr aufgestellt wurden. Durch die eher unbequemen Tunnel haben die Bewohner sich allerdings nicht getraut genauer nach uns zu suchen.", true)
    ASP("Kerberos","Kerberos","Wir sind also mitten im feindlichen Territorium? Sag mal Kardinel? ...", true)
    ASP("Kardinel","Kardinel","Dunkler Lord?",true)
    ASP("Kerberos","Kerberos","Wer hat dir eigentlich das denken beigebracht? @cr WIE DUMM MUSS MAN SEIN MITTEN IN FEINDLICHES GEBIET ZU STOLZIEREN, WENN WIR EH SCHON STARKEN TRUPPENMANGEL HABEN?! @cr Was denkst du werden die wohl tun, wenn die uns sehen? @cr Uns zum Kaffee einladen?",true)
    ASP("Kardinel","Kardinel","Nun, der Tunnel wurde immerhin nicht zur Flucht sondern zum Angriff entwickelt. @cr Guckt mal die Dorfburg dort vorn ist von hier kaum verteidigt!",true)
    ASP("Kerberos","Kerberos","Was bleibt uns Anderes übrig. Falls sich diese Dörfer aufständisch fühlen, vernichten wir sie einfach. Also dann Männer vorwärts!",true)

    briefing.finished = function ()
        arriveOutside()
    end

    StartBriefing(briefing);
end

function BriefingMayorAltea()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("mayorAltea","Alteas Bürgermeister","Kerberos?! Ihr hier? Männer zu den Waffen!",true)
    ASP("Kerberos","Kerberos","Haltet ein wir sind heute ausnahmsweise nicht für Euren Untergang hier. @cr Wir wurden im Schloss von durchsichtigen Gestalten angegriffen und wollen Euch unsere Hilfe anbieten.",true)
    ASP("mayorAltea","Alteas Bürgermeister","Das der verhasste Kerberos mir einmal Hilfe anbieten würden. @cr Das klingt zu schön um wahr zu sein, Ihr wollt uns doch nur ausnutzen um zu entkommen!",true)
    ASP("Kerberos","Kerberos","Ihr habt es erfasst. @cr Ich schere mich nicht um Euer Überleben, aber ich brauche wen der für mich bürgt wenn ich mich im Königreich blicken lasse. @cr Meine Ritter sind zu stark um ihre Hilfe zu ignorieren, nehmt Ihr unsere Hilfe an?", true)
    ASP("village1","Alteas Bürgermeister","Da mögt Ihr Recht haben unsere Truppen können unseren Dorfeingang kaum halten. @cr Lange halten wir nicht mehr durch. @cr Auch wenn es mir nicht gefällt und meiner Aufgabe entgegenspricht, muss ich die Hilfe des Tyrannen annehmen. @cr @cr Nun was vermögt Ihr zu tun?",false)
    ASP("Kardinel","Kardinel","Laut meinen Information befindet sich die Grenzstadt Südfang in der Nähe. Dort solltet Ihr höhere Überlebenschancen haben. @cr Das Dorf hier ist verloren, am besten konzentrieren wir uns darauf so viele zu evakuieren wie möglich, während Altea seine Tore verteidigt.",true)
    ASP("Kerberos","Kerberos","Soso die Grenzstadt, wir sollten den umliegenden Dörfern besser helfen um deren Vertrauen zu gewinnen, ich kann mir nicht vorstellen, dass die uns da auch so einfach helfen wollen.",true)
    ASP("mayorAltea","Alteas Bürgermeister","Da gehe ich auch von aus, der Stadthalter Dovbar ist nicht gut auf Euch zu sprechen. @cr Ich werde Boten aussenden, die von Eurer Hilfe berichten werden. Nutzt dies um die die Siedler zur Stadt zu eskortieren. @cr @cr Wir werden Euch mit Truppen und Ressourcen versorgen, sprecht mit mir wenn Ihr bereit seid mit der Evakuierung loszulegen. Wir können Euch natürlich nicht mehr mit Ressourcen versorgen, wenn unsere Arbeiter das Dorf verlassen.",true)
    ASP("mayorSonnspitz","Alteas Bürgermeister","Ich würde jedoch empfehlen, erst die anderen Dörfer aufzusuchen bevor Ihr mit der Evakuierung startet. Wir halten wohl noch eine Weile durch und der Fluchtweg wird ohne weitere Truppen zu gefährlich.", false)

    briefing.finished = mayorAlteaSpoken

    StartBriefing(briefing);
end

function BriefingKardinelOutside()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kerberos","Kerberos","Jetzt wo wir den Schwachkopf dazu gebracht haben, temporär für uns zu bürgen könnten wir auch einfach durch das Tor in Südfang fliehen. @cr Kardinel Bericht, warum sollten wir diesen lausigen Bauern helfen?",true)
    ASP("Kardinel","Kardinel","Die Bewohner stehen dann in Eurer Schuld, dunkler Lord. Wir können zwar direkt reisaus nehmen, aber der Weg von Südfang führt direkt in die Festungsstadt Mercius. Sollten wir diese Schuld dort einlösen können, gäbe uns das Handlungsspielraum.",true)
    ASP("Kerberos","Kerberos","Verstehe. Wir helfen diesem Pack also so lange wir können und wenn es uns zu brenzlig wird nehmen wir reisaus.",true)

    StartBriefing(briefing)
end

function BriefingMayorSonnspitz()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("mayorSonnspitz","Sonnspitz' Bürgermeister","Einen schlechten Tag wünsche ich Euch. @cr Wir haben schon die Nachricht bekommen, dass Ihr helft. Ich trau Euch zwar kein bisschen, aber wenn Alteas Bürgermeister sein Wort einlegt, will ich mal nicht so sein.",true)
    ASP("lighthouse","Sonnspitz' Bürgermeister","Ihr könnt über unseren Leuchtturm Verstärkung anfordern, nutzt ihn gut. @cr Sprecht mit mir wenn Ihr bereit seid loszuziehen.",false)
    ASP("mayorSonnspitz","Sonnspitz' Bürgermeister","Achja bevor ichs vergesse, falls Ihr nach Finsterwald wollt: @cr Der direkte Weg führt durch eine feindliche Basis, nehmt also besser einen Umweg.", false)
    briefing.finished = mayorSonnspitzSpoken

    StartBriefing(briefing);
end

function BriefingMayorFinsterwald()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("mayorFinsterwald","Finsterwalds Bürgermeister","Kerberos, dass Ihr Euch traut außerhalb Eurer Burg rumzulaufen...",true)
    ASP("mayorFinsterwald","Finsterwalds Bürgermeister","Wir haben die Info aus Altea erhalten und werden Eure Unterstützung annehmen. Sprecht mit mir wenn Ihr bereit seid.",true)

    briefing.finished = mayorFinsterwaldSpoken

    StartBriefing(briefing);
end

function BriefingAlteaEscape()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Alteas Bürgermeister",
            text = "Können wir los?",
            position = GetPosition("mayorAltea"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Alteas Bürgermeister",
        text = "Dann viel Glück! Der Weg führt durch das Gebirge südlich. Gerüchten zufolgen sollen Geister und das Nebelvolk dort ihr Unwesen treiben.",
        position = GetPosition("mountainpassCave"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Alteas Bürgermeister",
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
            title = "Sonnspitz' Bürgermeister",
            text = "Können wir los?",
            position = GetPosition("mayorSonnspitz"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Sonnspitz' Bürgermeister",
        text = "Passt auf, der Weg führt durch aktives Kriegsgebiet.",
        position = GetPosition("mayorSonnspitz"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Sonnspitz' Bürgermeister",
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
            title = "Finsterwalds Bürgermeister",
            text = "Können wir los?",
            position = GetPosition("mayorFinsterwald"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Finsterwalds Bürgermeister",
        text = "Wir gehen auf direktem Wege nach Südfang. Auf dem Weg wurden jedoch schwebende Rüstungen entdeckt, wir werden es also mit heftigeren Gegnern zutun bekommen.",
        position = GetPosition("mayorFinsterwald"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Finsterwalds Bürgermeister",
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
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Dovbar","Dovbar","Das ich den Tyrannen vor dem ich das Reich Beschützen soll, in meinen Mauern willkommen heiße... @cr Ihr halft den Wehrdörfern jedoch bei der Flucht, seid Ihr nicht die Ursache dieser Katastrophe?", true)
    ASP("Kerberos","Kerberos","Danke für die netten Worte, ich hatte einen Sinneswandel und möchte meine vergangenen Taten wieder gut ...",true)
    ASP("Dovbar","Dovbar","Spart Euch die Schleimerei, Unhold. @cr Was ist Euer eigentliches Motiv?", true)
    ASP("Kerberos","Kerberos","Muss mir immer alles schlecht ausgelegt werden? @cr Mir scheint wir hätten momentan nur das gleiche Problem. @cr Wie sagt man so schön, der Feind meines Feindes ist mein Freund.",true)
    ASP("Dovbar","Dovbar","Gut \"Freund\" dann bringt Eure Aufgabe zuende und evakuiert den Rest der Bevölkerung.",true)

    briefing.finished = function ()
        allyWithSuedfang()
        local markerPos = GetPosition("Dovbar")
        GUI.DestroyMinimapPulse(markerPos.X,markerPos.Y)
        Explore.Hide("Dovbar")
    end

    StartBriefing(briefing);
end

function BriefingLastWave()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Dovbar","Dovbar","Alle Dörfer sind evakuiert, gute Arbeit für jemanden der Leute sonst eher ermordet.", true)
    ASP("Kerberos","Kerberos","Ihr schmeichelt mir. Also wie sieht es aus verlassen wir diesen Ort?",true)
    ASP("Dovbar","Dovbar","Nein, wir bleiben schön hier. Unsere Feinde haben unsere Evakuierungsmaßnahmen bemerkt und sind auf dem Vormarsch hierher.",true)
    ASP("attackPointP71","Dovbar","Eine so große Zahl können wir nicht abwehren und weil unser rechter Wall gebrochen und momentan nur sporadisch befestigt wurde, werden wir den ersten Ring aufgeben müssen.",false)
    ASP("Kerberos","Kerberos","Dann verziehen wir uns besser sofort, ich werde hier nicht für etwas Sinnloses sterben.",true)
    ASP("Dovbar","Dovbar","Den ersten Ring können wir nicht halten, das heißt aber nicht dass ich die Festung aufgebe.",true)
    ASP("suedfanggate1","Dovbar","Wenn wir die Tore schließen, können wir die Burgstadt verteidigen, bis Ihr mit Verstärkung aus Mercius zurückkommt und uns helft.", false)
    ASP("Dovbar","Dovbar","Die Mechanismen sind aber zerstört worden und wir benötigen Zeit um die Tore zu reparieren. @cr Und da kommt Ihr ins Spiel. Verteidigt den äußeren Ring solange wie Ihr könnt und zieht Euch dann zur Festung zurück.", true)
    ASP("Kerberos","Kerberos","Eine stehende Basis wäre für eine Rückeroberung tatsächlich nicht schlecht. Wir werden helfen. @cr Aber nur solange wie es geht. Ich werde wie bereits erklärt nicht für Euch und Euer lächerliche Festungsanlage sterben.",true)

    briefing.finished = function ()
        prepareLastWave()
    end

    StartBriefing(briefing);
end

function BriefingHoldout()
    DestroyEntity("Kerberos")
    DestroyEntity("Dovbar")

    CreateMilitaryGroup(1, Entities.CU_BlackKnight, 8, GetPosition("endPosKerberos"), "Kerberos")
    CreateMilitaryGroup(7, Entities.PU_Hero13, 8, GetPosition("endPosDovbar"), "Dovbar")

    LookAt("Kerberos","Dovbar")
    LookAt("Dovbar","Kerberos")

    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Dovbar","Dovbar","Das wäre hiermit erledigt. @cr Eine Schande wie viele gute Leute wir dort draußen verloren haben.", true)
    ASP("Kerberos","Kerberos","Da geht es Euch nicht anders als mir. Alleine in meinem Schloss musste ich viele meiner Männer zurücklassen.",true)
    ASP("Dovbar","Dovbar","Dann ist es umso wichtiger, dass Ihr sofort nach Mercius aufbrecht und Verstärkung anfordert. @cr Vielleicht können wir potentielle Überlebende dann noch retten.",true)
    ASP("Kerberos","Kerberos","Kommt Ihr gar nicht mit? Ich brauche wen der für mich bürgt.",true)
    ASP("Dovbar","Dovbar","Irgendwer muss hier die Stellung halten. @cr Und macht Euch die Leute im Fort keine Sorgen, es gibt genug Leute die Ihr hier gerettet habt, die für Euch aussagen werden.",true)
    ASP("Kerberos","Kerberos","Pah, Dankbarkeit. Widerlich. @cr Dann mache ich mich auf. Wenn ich wiederkomme werde ich die schwarze Festung zurückerobern und möchte, dass hier dafür eine Basis für meine Ankunft bereitsteht!",true)

    briefing.finished = function ()
    end

    StartBriefing(briefing);
end

function BriefingVictory()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("test","test","test", true)

    briefing.finished = function ()
        Victory()
    end

    StartBriefing(briefing);
end

function BriefingDefeat()
end

-- side_quests
function BriefingArmor()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kerberos","Kerberos","Da sind wir die Waffenkammer. Ich ziehe mich eben um, Kardinel halte Wache.", true)
    ASP("Kardinel","Kardinel","Ihr habt ihn gehört Männer. Keiner darf den dunklen König stören!", true)
    ASP("Kerberos","Nebenmission","Beschützt Kerberos! @cr Passt auf vor den Nekromanten. Vielleicht ist es besser sie beschwören zu lassen, als Eure Truppen zu riskieren.")

    briefing.finished = function ()
        armorQuest()
    end
    
    StartBriefing(briefing);
end

function BriefingBanditBro()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("banditBro","Banditenbruder","Ihr seid doch Kerberos? Was macht Ihr hier?", true)
    ASP("Kerberos","Kerberos","Den Helden spielen.",true)
    ASP("banditBro","Banditenbruder","Trifft sich gut, die Idioten von Altea wollen nicht auf mein Angebot eingehen.",true)
    ASP("banditSpawn","Banditenbruder","Meine Banditenkumpels sind draußen und werden von Geistern angegriffen. Zerstört den Unterschlupf ihrer Angreifer und sie werden sich Euch anschließen.",false)
    ASP("Kerberos","Kerberos","Mehr Truppen klingt verlockend, ich entscheide später ob ich die Zeit über habe.",true)

    briefing.finished = function ()
        BANDITQUESTSTARTED = true
        GUI.CreateMinimapMarker(GetPosition("banditSpawn").X,GetPosition("banditSpawn").Y,2)
        GUI.CreateMinimapMarker(GetPosition("explBanditAttack").X,GetPosition("explBanditAttack").Y,2)
	    Explore.Show("explBandits", "banditSpawn", 1500)
        ChangePlayer("banditBro",1)
    end
    
    StartBriefing(briefing);
end

function BriefingScoutP5()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("p5scout","Kundschafter","Ich beobachte unsere Feinde und habe größere Truppenmengen bemerkt. @cr Sollte einer dieser Wellen auf ein Dorf zurennen, wird die Verteidigung fallen. @cr Ich werde Euch bescheidgeben, wenn die sich in Bewegung setzen. Ihr solltet Euch dann schleunigst in Bewegung setzen.", true)

    briefing.finished = function ()
        SCOUTCHECK = 2
        ChangePlayer("p5scout",1)
        StartSimpleJob("checkForScout")
    end

    StartBriefing(briefing)
end

function BriefingStatue()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("dariostatue","Kerberos","Eine Statue von Dario, mit wird schlecht. @cr Ich würde die zu gerne zertrümmern, aber das hebe ich mir für später auf.", true)

    StartBriefing(briefing)
end