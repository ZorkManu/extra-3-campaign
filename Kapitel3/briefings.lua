function BriefingStart()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    AP{
		title = "Ari",
		text = "War das wirklich eine gute Idee allein ohne Truppen hierherzukommen?",
		position = GetPosition("Ari"),
        action = function ()
            LookAt("Ari","Pilgrim")
        end,
        dialogCamera = true
	}
    AP{
		title = "Pilgrim",
		text = "Mach dich mal locker, Mercius hat mehr als genug Soldaten für ein ganzes Reich.",
		position = GetPosition("Pilgrim"),
        action = function ()
            LookAt("Pilgrim","Ari")
        end,
        dialogCamera = true
	}
    if SCHWARZACTIVE then
        AP{
            title = "Pilgrim",
            text = "Außerdem haben wir doch deinen Kumpel dabei. Der kann hoffentlich auch so gut kämpfen, wie er saufen kann.",
            position = GetPosition("Pilgrim"),
            action = function ()
                LookAt("Pilgrim","Schwarz")
            end,
            dialogCamera = true
        }
        AP{
            title = "Schwarz",
            text = "Da mach dir mal keine Sorgen, ich war in unserer Truppe immer der Stärkste. @cr Was dich angeht, bist du überhaupt wieder nüchtern?",
            position = GetPosition("Schwarz"),
            action = function ()
                LookAt("Schwarz","Pilgrim")
            end,
            dialogCamera = true
        }
        ASP("Pilgrim","Pilgrim","Ich halt mehr aus als der durchschnittliche Bürger. *hicks* Nur gegen Schluckauf bin ich nicht immun.",true)
    else
        ASP("Pilgrim","Pilgrim","Außerdem hast du ja mich. Und ich bin ja wohl der beste Begleiter den man sich wünschen kann.",true)
    end
    ASP("Ari","Ari","Beruhigend zu hören... Dann sag mal wie kommen wir am Schnellsten nach Mercius?",true)
    AP{
        title = "Pilgrim",
        text = "Wir müssen eigentlich nur geradeaus. @cr Ich habe auf dem Hinweg jedoch eine verlassene Burg gefunden. @cr Bevor wir uns nach Mercius begeben, sollten wir uns zumindest erstmal eine Bleibe errichten.",
        position = GetPosition("Pilgrim"),
        action = function ()
            LookAt("Pilgrim","Ari")
        end,
        dialogCamera = true
    }
    ASP("Pilgrim","Missionsbeschreibung","Findet eine Burg!",false)

    briefing.finished = function ()
        local markerPos = GetPosition("p1hq")
        GUI.CreateMinimapMarker(markerPos.X,markerPos.Y,2)
    end

    StartBriefing(briefing)
end

function BriefingHQ()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Ari","Ari","Das wäre erledigt. @cr Ich wusste gar nicht, dass die Geister hier auch schon angefangen haben ihr Unwesen zu treiben.",true)
    ASP("Pilgrim","Pilgrim","Die müssen neu sein.", true)
    ASP("Dario","Ari","Umso wichtiger, dass wir jetzt nach Mercius gehen. @cr Der Text kann warten, ich möchte erstmal wissen wie hier der Stand ist.",false)
    ASP("Pilgrim","Pilgrim","Wir sollten aber auch auf unsere Verteidigung achten. @cr Ich werde das Gefühl nicht los, das Mehr in der Nähe sind.",true)
    ASP("Pilgrim","Missionsbeschreibung","Sprecht mit dem Kommandanten von Mercius. @cr @cr Vernachlässigt Eure Verteidigung jedoch nicht!",false)

    StartBriefing(briefing)
end

function BriefingEnterMercius()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Dario","Dario","Ari und Pilgrim? Was macht ihr beide hier? @cr Wobei Pilgrim dich hätte ich bei meiner Ankunft erwartet, du warst doch hier stationiert?! @cr Aber Ari Liebste, hattest du nicht einen Auftrag in Sturmbach?",true)
    ASP("Ari","Ari","Dario Liebster, der Auftrag in Sturmbach ist etwas eskaliert und Pilgrim kam mir zu Hilfe. @cr Wir sind aber genauso überrascht euch Beide hier zu sehen. Solltest du nicht im Palast sein und Helias in Crawford?",true)
    ASP("Dario","Dario","Die Situation verlangt meine Anwesenheit und Helias dient als mein Berater.",true)
    ASP("leftwall5","Dario","Unsere Fronten sind verhärtet und unsere Tore fielen dem Ansturm wilder Trolle zum Opfer. Wir verteidigen aktuell mit allen Truppen die wir haben.",false)
    ASP("middlewall8","Dario","Unser schwächeres mittleres Tor muss gegnerischer Kavallerie standhalten. Wie auch immer diese Schemen mit Pferden erschienen sind.",false)
    ASP("bottomwall3","Dario","Südlich kämpfen wir zusätzlich zu Geistern und dem Nebelvolk gegen schwarze Ritter. @cr Es liegt also nahe, dass Kerberos hinter den Angriffen steckt.",false)
    ASP("Helias","Helias","Das Kerberos sich aus seinem Exil traut! Dieses Mal werden wir ihm Gottes gerechte Strafe bringen.",true)
    ASP("Ari","Ari","In Sturmbach konnte ich zumindest in Erfahrung bringen das Mary de Morfichet in unserer aktuellen Situation verwickelt ist... Dann wird Kerberos auch nicht weit sein.",true)
    ASP("Pilgrim","Pilgrim","Was ist mit Dovbar in Südfang? Ich war dort letztens noch für ein paar Waffentests sollte er Kerberos nicht aufhalten?",true)
    ASP("Dario","Dario","Leider haben wir den Kontakt nach Südfang verloren. @cr Aber das ist nicht alles, Nevassa im Norden ist momentan ebenfalls von uns abgeschnitten. @cr Wir müssen im Fall der Fälle Truppen entsenden um die Städte zu retten.",true)
    ASP("Ari","Ari","Pilgrim und ich könnten uns darum kümmern. @cr Wir haben unser Lager vor dem Osttor aufgezogen.",true)
    ASP("Dario","Dario","Offene Wege zu unseren Verbündeten würde uns sehr entlassen. Ich werde die Zuständigen informieren. Sprecht mit denen, wenn ihr mehr wissen wollt.",true)
    ASP("p2barracksspawn","Dario","Wir haben aber auch noch ein anderes Problem. @cr Die Holzarbeiter im äußeren Ring können die Tore nicht reparieren, weil das Osttor auch unter Feuer steht. @cr Wir können keine Soldaten entsenden, deswegen müssen sich die Arbeiter dort selbst verteidigen. @cr Euer Lager steht in der Nähe, kümmert euch erst um dieses Problem.",false)
    ASP("Pilgrim","Pilgrim","Ich wusste es war eine gute Idee die Burg dort einzunehmen.",true)
    ASP("Ari","Ari","Keine Zeit für Selbstbeweihräucherung, Pilgrim. @cr Eine letzte Sache noch. Wir haben in der Nähe von Sturmbach Schriften gefunden, die wir nicht entziffern konnten. Sind die Gelehrten hier dazu in der Lage?",true)
    ASP("Helias","Helias","Lass mich mal sehen... Das ist alte Schrift von vor Gründung des Reiches! Normalerweise findet sich so etwas nur noch in alten religiösen Schriften. @cr Ich werde mich dem annehmen, besucht mich in der Universität der Stadt wenn ihr eure Aufgaben erledigt habt.",true)
    ASP("p2captain","Missionsbeschreibung","Sprecht mit dem Hauptmann der Bürgerwehr und helft bei der Erschließung der anliegenden Territorien. @cr Doch beeilt Euch, Mercius hat nur begrenzt Ressourcen und darf nicht fallen!",false)

    briefing.finished = function ()
        GUI.DestroyMinimapPulse(GetPosition("Dario").X,GetPosition("Dario").Y)
        Explore.Hide("explDario")
        Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
        initWoodcutterChiefNPC()
        Move("Helias","HeliasStudyPos")
        local markerPos = GetPosition("p2captain")
        GUI.CreateMinimapMarker(markerPos.X,markerPos.Y,2)
        CreateNPC {
            name = "general",
            callback = BriefingVargBase,
        }
        local markerPos = GetPosition("general")
        GUI.CreateMinimapMarker(markerPos.X,markerPos.Y,2)
    end

    StartBriefing(briefing)
end

function BriefingSulfurBase(_NpcDescription, _HeroId)
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local HeroName = GetEntityName(_HeroId)

    ASP("p2captain","Hauptmann der Bürgerwehr","Ich rede schon seit Tagen auf die Taugenichtse aus der Innenstadt ein, dass die uns helfen sollen! @cr Die gegenerische Basis im Süden ist klein, die könnten dort also einmal durchfegen und das Problem wäre gelöst. @cr Aber nein wir normalen Leute müssen uns mit nahezu endlosen Wellen an Geistern auseinandersetzen!",true)
    ASP(HeroName,HeroName,"Jetzt sind wir ja hier. Überlasst das uns.",true)
    ASP(HeroName,"Missionsbeschreibung","Zerstört die Basis im Süden.",false)

    briefing.finished = function ()
        GUI.DestroyMinimapPulse(GetPosition("p2captain").X,GetPosition("p2captain").Y)
        GUI.CreateMinimapMarker(GetPosition("barracksghostsulfurspawn").X,GetPosition("barracksghostsulfurspawn").Y,2)
        StartSimpleJob("checkForSulfurBase")
    end

    StartBriefing(briefing)
end

function BriefingSulfurBaseConquered()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("p2captain","Hauptmann der Bürgerwehr","Vielen Dank, endlich müssen wir nicht mehr kämpfen und können uns wieder unserer Arbeit zuwenden.",true)
    ASP("Ari","Ari","Sehr gut, wie steht es um die Reparatur der Tore?",true)
    ASP("p2captain","Hauptmann der Bürgerwehr","Nach unserer Einschätzung: Schlecht. @cr Würden wir die Tore jetzt verstärken, würden diese Fiecher ihre Trolle schicken und die ganze Arbeit wäre für nichts.",true)
    ASP("Ari","Ari","Irgendwelche Ideen oder soll ich Euch zum Arbeiten zwingen?",true)
    ASP("p2captain","Hauptmann der Bürgerwehr","Ganz ruhig, ich habe tatsächlich Eine.")
    ASP("BigTree","Hauptmann der Bürgerwehr","Außerhalb der Mauern steht ein großer stabiler uralter Baum. Mit dem Holz sollte das Tor länger standhalten.",false)
    ASP("Ari","Ari","Wir sollen also hinter den gegnerischen Linien holzfällen. @cr Dort sind nicht nur Nebelkrieger und Geister sondern auch schwarze Ritter. @cr Ich denke wir widmen uns erst anderen Aufgaben.",true)
    ASP("p2captain","Hauptmann der Bürgerwehr","Alles klar, sagt bescheid wenn der Weg zum Baum frei ist.",true)
    ASP("BigTree","Missionsbeschreibung","Schlagt euch bis zum großen Baum vor und sorgt dafür, dass ein Holzarbeiter dort arbeiten kann.",false)

    briefing.finished = function ()
        startWoodCutterQuest()
        ResearchTechnology( Technologies.GT_ChainBlock, 1 )
        GUI.DestroyMinimapPulse(GetPosition("barracksghostsulfurspawn").X,GetPosition("barracksghostsulfurspawn").Y,2)
        GUI.CreateMinimapMarker(GetPosition("BigTree").X,GetPosition("BigTree").Y,2)
        local markerPos = GetPosition("Strategist")
        GUI.CreateMinimapMarker(markerPos.X,markerPos.Y,2)
        CreateNPC {
            name = "Strategist",
            callback = BriefingKerberosBase,
        }
    end

    StartBriefing(briefing)
end

function BriefingWoodCutterStart()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Hauptmann der Bürgerwehr",
            text = "Ist der Weg einigermaßen sicher?",
            position = GetPosition("p2captain"),
            firstText = "So sicher wie er gerade sein kann.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Hauptmann der Bürgerwehr",
        text = "Gut ich schicke einen Holzarbeiter los. Sorgt dafür, dass ihm nichts passiert.",
        position = GetPosition("p2captain"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Hauptmann der Bürgerwehr",
        text = "Alles klar, wir warten.",
        position = GetPosition("p2captain"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                woodCutterJob()
			else 
				local NPC = {
                    name = "p2captain",
                    callback = BriefingWoodCutterStart
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingAllGatesReeinforced()
    local textFmF = ""
    if GDB.GetString("FmFSuedfang") == "1" then
        textFmF = "Dovbar würde für ihn bürgen."
    else
        textFmF = "unsere Verteidigung in Evelance ist gefallen und er half einigen Bewohnern zu fliehen."
    end
    local kerberosActive = IsDead("KerberosCutscene") == false
    local vargActive = IsDead("VargCutscene") == false
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Dario","Dario","Sehr gut, die Tore sind zu. Wir haben jetzt Zeit, um uns zu erholen.",true)
    if kerberosActive or vargActive then
        ASP("Dario","Dario","Aber kommen wir erstmal zum offensichtlichen...",true)
        if kerberosActive then
            AP{
                title = "Dario",
                text = "Was macht Kerberos hier?!.",
                position = GetPosition("Dario"),
                action = function ()
                    LookAt("Dario","KerberosCutscene")
                end,
                dialogCamera = true
            }
            AP{
                title = "Kerberos",
                text = "Hast du noch nicht gehört? @cr @cr Ich gehöre jetzt zu den GUTEN.",
                position = GetPosition("KerberosCutscene"),
                action = function ()
                    LookAt("KerberosCutscene","Dario")
                end,
                dialogCamera = true
            }
            ASP("Dario","Dario","Nochmal fallen wir nicht auf deine billigen Tricks rein. @cr Was ist dein eigentliches Ziel?",true)
            AP{
                title = "Ari",
                text = "Lass gut sein Liebster, @cr wir werden sehen ob er lügt, wenn wir in Evelance ankommen. @cr Kerberos sagte, " .. textFmF, true,
                position = GetPosition("Ari"),
                action = function ()
                    LookAt("Ari","Dario")
                end,
                dialogCamera = true
            }
            if KARDINELACTIVE then
                ASP("KardinelCutscene","Kardinel","Die schiere Zahl der Gegner war zu viel für unsere Hoheit. @cr Sicherlich versteht Ihr genung von Taktik, um zu erkennen, dass wir nur gemeinsam eine Chance haben.",true)
                ASP("Dario","Dario","Leider hat er einen Punkt, wir gehen ein temporäres Bündnis ein.",true)
            end
            if vargActive then
                ASP("Dario","Dario","Das erklärt Kerberos. @cr Yuki willst du mir erklären, warum Varg auch hier ist?!",true)
            end
        else
            AP{
                title = "Dario",
                text = "Was macht Varg hier?!.",
                position = GetPosition("Dario"),
                action = function ()
                    LookAt("Dario","VargCutscene")
                end,
                dialogCamera = true
            }
        end
        if vargActive then
            AP{
                title = "Yuki",
                text = "Ganz einfach. @cr Wir wurden von Geistern angegriffen und Varg war so nett uns zu helfen. *lächelt*",
                position = GetPosition("YukiCutscene"),
                action = function ()
                    LookAt("YukiCutscene","Dario")
                    LookAt("Dario","YukiCutscene")
                end,
                dialogCamera = true
            }
            ASP("Dario","Dario","Wenn Diplomatie doch nur so einfach wäre ... @cr Wir können die Unterstützung gebrauchen. @cr @cr Ich schätze mal willkommen in Mercius Varg.",true)
        end
    end
    ASP("Ari","Ari","Jetzt zu dem aktuellen Stand. @cr Wir sind vorerst sicher, wie nutzen wir den neugewonnen Spielraum?",true)
    ASP("Pilgrim","Pilgrim","Ich dachte, ich könnte endlich mit einem lecker Bierchen die Pause genießen.",true)
    ASP("Ari","Ari","Wir sind hier lange noch nicht fertig...",true)
    AP{
        title = "Dario",
        text = "Pilgrim hat schon Recht, wir sollten die Zeit nutzen, um uns zu erholen. Wir werden auch versuchen die Stadt auf den kommenden Kampf vorzubereiten. @cr Ich gebe euch die Baupläne für eine Zitadelle, damit ihr die Zeit gut nutzen könnt.",
        position = GetPosition("Dario"),
        action = function ()
            LookAt("Dario","p2base")
        end,
        dialogCamera = true
    }
    ASP("middlewall9","Dario","Wir dürfen unsere Verteidigung aber auch nicht komplett vernachlässigen. @cr Der Gegner hat schon einmal unser Tor zerstört und wird es wieder versuchen. @cr Dieses Mal ist es zumindest stärker befestigt.",false)
    ASP("Ari","Ari","Ich werde unterdessen Helias einen Besuch abstatten. @cr Vielleicht hat er schon etwas herrausgefunden.",true)
    ASP("Helias","Missionsbeschreibung","Schaut nach dem Fortschritt der Übersetzung.",false)

    briefing.finished = function ()
        safeVillage()
        mopUpGathering()
    end

    StartBriefing(briefing)
end

function BriefingScolar()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("p2scolar","test","test",true)

    briefing.finished = function ()
        ResearchTechnology(Technologies.GT_Printing, 1)
        local NPC = {
            name = "Helias",
            callback = BriefingToCathedral
        }
        CreateNPC(NPC)
    end

    StartBriefing(briefing)
end

function BriefingToCathedral()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Helias","Helias","to be done",true)

    briefing.finished = function ()
        ResearchTechnology(Technologies.GT_Library, 1)
        local NPC = {
            name = "Helias",
            callback = BriefingReToCathedral
        }
        CreateNPC(NPC)
    end

    StartBriefing(briefing)
    
end

function BriefingReToCathedral()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Helias",
            text = "Sollen wir uns aufmachen?",
            position = GetPosition("Helias"),
            firstText = "Bringen wir es hinter uns.",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Helias",
        text = "Ich werde Dario informieren und dann mit dem Ritual beginnen.",
        position = GetPosition("Helias"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Helias",
        text = "Es wird keine leichte Aufgabe, ich bete für unseren Erfolg.",
        position = GetPosition("Helias"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                StartSimpleJob("moveHeliasToDario")
			else 
				local NPC = {
                    name = "Helias",
                    callback = BriefingReToCathedral
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingHeliasDario()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Helias","Helias","to be done",true)

    briefing.finished = function ()
        StartSimpleJob("moveHeliasAndDarioToCathedral")
    end

    StartBriefing(briefing)
end

function BriefingCathedralEntrance()
    local briefing = { noEscape = true };
    local AP, ASP = AddPages(briefing);

    ASP("Helias","Helias","Lasst uns durch, wir müssen zum Kloster.",true)
    AP{
		title = "Torwächter",
		text = "Ihr dürft passieren.",
		position = GetPosition("monasteryguardian"),
        action = function ()
            local gate = ReplaceEntity( GetEntityId("monasterygate"), Entities.XD_PalisadeGate2)
            SetEntityName(gate, "monasterygate")
        end
	}
    AP{
		title = "Dario",
		text = "Das ging schneller als erwartet. König sein hat seine Vorteile. @cr Jeder erkennt mich.",
		npc = {
            id = GetEntityId("Dario"),
            isObserved = true
        },
        action = function ()
            Move("Dario","DarioMovePoint2")
            Move("Helias","HeliasMovePoint2")
        end
	}

    briefing.finished = function ()
        local gate = ReplaceEntity( GetEntityId("monasterygate"), Entities.XD_PalisadeGate1)
        SetEntityName(gate, "monasterygate")
        DestroyNPC{name = "Dario"}
        StartSimpleJob("nearBishop")
    end

    StartBriefing(briefing)
end

function BriefingRitual()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Helias","Helias","to be done",true)

    briefing.finished = function ()
        bloodmoonDefense()
    end

    StartBriefing(briefing)
end

function BriefingAdvance()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Dario","Dario","to be done",true)

    briefing.finished = function ()
        mopUpGathering()
    end

    StartBriefing(briefing)
end

function BriefingKerberosBase()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Taktiker",
            text = "Um kurz die Lage zusammenzufassen: @cr Der Zugang zu Südfang ist aktuell von unserer Seite gesperrt, da sich Nebelvolk dort eingenißtet hat. @cr Ihr werdet deren Lager ausbrennen müssen. @cr Seid Ihr dazu bereit? Dann öffne ich die Tore. @cr Entscheidet nicht leichtfertig. Solltet Ihr das Nebelvolk nicht zerstören können, werden unsere Verteidiger nicht mehr standhalten können.",
            position = GetPosition("Strategist"),
            firstText = "Wir sind bereit. Öffnet die Tore",
            secondText = "Nein, es ist aktuell zu riskant.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Taktiker",
        text = "Viel Glück da draußen.",
        position = GetPosition("Strategist"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Taktiker",
        text = "Bereitet euch gut vor. Sowohl unsere Verteidigung, als auch der Pass nach Südfang sind essenziell für unser Überleben.",
        position = GetPosition("Strategist"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                GUI.DestroyMinimapPulse(GetPosition("Strategist").X,GetPosition("Strategist").Y,2)
                startKerberosQuest()
			else 
				local NPC = {
                    name = "Strategist",
                    callback = BriefingKerberosBase
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingKerberos()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kerberos","Kerberos","Habt ihr mich vermisst?",true)
    ASP("Pilgrim","Pilgrim","Nachdem du uns hintergangen hast damals? @cr Ich sollte dich und deine Männer auf der Stelle in die Luft jagen.",true)
    ASP("Kerberos","Kerberos","Das liegt alles in der Vergangenheit. @cr Wie ich das sehe, hat die Stadt gerade nicht die Truppen, um hier zu gewinnen. @cr Und ich kenne da ein paar fähige Männer...",true)
    if GDB.GetString("FmFSuedfang") == "1" then
        ASP("Kerberos","Kerberos","Außerdem bürgt Regent Dovbar für mich. Ihm traut ihr doch sicher.",true)
    end
    ASP("Ari","Ari","Auf deine Lügen fallen wir nicht rein, das sind doch deine Truppen vor dem Tor.",true)
    ASP("Kerberos","Kerberos","Meine Truppen, wir sind doch hier? @cr @cr *Ach das ist der Trupp den ich Mary damals zugeteilt habe.*",true)
    ASP("Kerberos","Kerberos","Überlasst den ruhig mir und wenn ihr schon dabei seid. Das hier ist jetzt meine Basis, ich werde mich hier ausbreiten mit den Leuten die mir aus Südfang gefolgt sind. @cr Bebaut also nicht meine Minen und das Dorfzentrum!",true)
    ASP("Pilgrim","Pilgrim","Ich kann mich nicht dazu bringen, dem Schuft zu trauen. @cr Was meinst du Ari?",true)
    ASP("Ari","Ari","Wir lassen ihn erstmal. Truppenunterstützung können wir mehr als gebrauchen @cr @cr Sollte er aber etwas anstellen, wird sich mein Bogen schon lockern.",true)
    briefing.finished = function ()
        createKerberosArmy()
    end

    StartBriefing(briefing)
end

function BriefingKardinel()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Kardinel","Kardinel","Hey",true)
    ASP("Pilgrim","Pilgrim","Hallo?",true)
    ASP("Kardinel","Kardinel","Der dunkle Lord überlässt Euch einige unserer Truppen. @cr Seht es als wohlwollendes Geschenk.",true)
    ASP("Pilgrim","Pilgrim","Sicher...",true)

    briefing.finished = function ()
        ResearchTechnology( Technologies.T_KnightsCulture, 1)
        createKardinelArmy()
    end

    StartBriefing(briefing)
end

function BriefingVargBase()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Truppenhauptmann",
            text = "Jenseits der Palisade wurde eine ziemlich große Horde Geister gesichtet. Wir können das Palisadentor nicht öffnen, weil eine so große Anzahl unsere Verteidigung drastisch schwächen könnte. @cr Wenn Ihr Euch um dieses Problem kümmern könnt, öffne ich das Tor für Euch.",
            position = GetPosition("general"),
            firstText = "Wir sind bereit für den Kampf!",
            secondText = "Ich brauche Bedenkzeit",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Truppenhauptmann",
        text = "Ich lasse das Tor öffnen. Tötet diese Bastarde! Auch wenn sie bereits tot sind...",
        position = GetPosition("general"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Truppenhauptmann",
        text = "Ich warte bis Ihr bereit seid.",
        position = GetPosition("general"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                StartCountdown(40,createBarbarianAttackers,false)
                createGhostBarbarianBaseDefenders()
                Logic.SetShareExplorationWithPlayerFlag(1, 3, 1)
                local gate = ReplaceEntity( GetEntityId("gatevarg"), Entities.XD_PalisadeGate2)
                SetEntityName(gate, "gatevarg")
                GUI.DestroyMinimapPulse(GetPosition("general").X,GetPosition("general").Y,2)
			else 
				local NPC = {
                    name = "general",
                    callback = BriefingVargBase
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingVarg()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Yuki","Yuki","Sieht so aus als wäre uns ein kleines Missgeschick passiert.",true)
    ASP("Ari","Ari","Auch schön dich wiederzusehen Yuki... @cr Was genau meinst du mit *Missgeschick*?",true)
    ASP("Yuki","Yuki","Wir haben vielleicht oder auch nicht eine ewige Nacht herbeigerufen.",true)
    ASP("Ari","Ari","Ihr habt was?!",true)
    ASP("Varg","Varg","Naja, uns blieb nicht viel über, wir mussten immerhin eine gegnerische Basis plätten.",true)
    ASP("Ari","Ari","Wer hat dir Abschaum überhaupt erlaubt zu sprechen?",true)
    ASP("Yuki","Yuki","Keine Sorge, der gute Varg möchte uns bei unserem Problem helfen. @cr @cr \"Und wenn nicht...\" *grinst*",true)
    ASP("Varg","Varg","*schaudert* Was auch immer. @cr Wir haben uns für einen Waffenstillstand geeinigt, solange wir eine Lösung für das Problem mit Mary gefunden haben.",true)
    ASP("Ari","Ari","Mary also. Also wie ich vermutet habe.",true)
    ASP("Varg","Varg","Wir werden hier unsere Basis errichten. Seid also so gut und baut hier nicht. @cr Sprecht mich noch einmal an, wenn wir fertig sind.",true)
    ASP("Yuki","Yuki","Ich werde mich einmal umhören zu dem Dauernachtproblem. Viel Spaß an der Front!",true)

    briefing.finished = function ()
        ResearchTechnology( Technologies.T_BarbarianCulture, 1)
        createPlayer3()
        StartSimpleJob("YukiLurkMission")
    end

    StartBriefing(briefing)
end

function BriefingVictory()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Erec","Erec","to be done",true)

    briefing.finished = function ()
        Victory()
    end

    StartBriefing(briefing)
end

--SideQuests

function BriefingTrader1()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Trader1","Technologiehändler","Ihr seht aus, als würdet Ihr etwas mehr Feuerkraft brauchen. @cr @cr Da habe ich genau das Richtige!",true)

    briefing.finished = function ()
        Tribute1()
    end

    StartBriefing(briefing)
end

function BriefingTrader2()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Trader2","Technologiehändler","Pferdezucht für Dummies, heute im Angebot, nur ".. Difficulty .."00 Silber!",true)

    briefing.finished = function ()
        Tribute2()
    end

    StartBriefing(briefing)
end

function BriefingTrader3()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Trader3","Händler","Feinstes Eisen, guter Preis!",true)

    briefing.finished = function ()
        Tribute3()
    end

    StartBriefing(briefing)
end

function BriefingTrader4()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Trader4","Händler","Du willst Lehm, du bekommst Lehm! @cr Greif zu du wirst es nicht bereuen!",true)

    briefing.finished = function ()
        Tribute4()
    end

    StartBriefing(briefing)
end

function BriefingTrader5()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Trader5","Händler","Eigens gehacktes Holz, nur hier mit Qualitätssiegel des Königs!",true)
    ASP("Ari","Ari","Das wüsste ich...",true)

    briefing.finished = function ()
        Tribute5()
    end

    StartBriefing(briefing)
end

function BriefingTrader6()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Trader6","Händler","Stein, frischer Stein!",true)

    briefing.finished = function ()
        Tribute6()
    end

    StartBriefing(briefing)
end

function BriefingSmelter()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Smelter","Kanonengießer","Ah Freunde von außerhalb!",true)
    ASP("Smelter","Kanonengießer","Mir wurde gesagt ihr könntet etwas Feuerkraft gebrauchen. @cr Die Schönheiten hier, habe ich nur für euch gebaut!",true)

    briefing.finished = function ()
        local pos = GetPosition("CannonSmelterSpawn") 
        AI.Entity_CreateFormation(1, Entities.PV_Cannon3, nil, 8, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
        AI.Entity_CreateFormation(1, Entities.PV_Cannon2, nil, 8, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
    end

    StartBriefing(briefing)
end

function BriefingVCGuard()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Wache",
            text = "Das Tor hier ist geschlossen. @cr Der Weg zu einem Sumpf und dort sprießen Nebelkrieger förmlich aus dem Boden.",
            position = GetPosition("vcguardian"),
            firstText = "Öffnet es trotzdem.",
            secondText = "Verstanden",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Wache",
        text = "Aber auf Eure Verantwortung.",
        position = GetPosition("vcguardian"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Wache",
        text = "Schönen Tag noch.",
        position = GetPosition("vcguardian"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                createVCSpawner()
                local gate = ReplaceEntity( GetEntityId("vcgate"), Entities.XD_PalisadeGate2)
                SetEntityName(gate, "vcgate")
			else 
				local NPC = {
                    name = "vcguardian",
                    callback = BriefingVCGuard
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingYukiLurkMission()
    local firework = Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, GetPosition("YukiFirework").X, GetPosition("YukiFirework").Y, 1 );
    local briefing = { noEscape = true };
    local AP, ASP = AddPages(briefing);

    ASP("Yuki","Yuki","Wo gäbe es bessere Infos zu einem Ritual als in der Kirche. @cr Reinzukommen wird ein Leichtes.",true)
    AP{
		title = "Wächter",
		text = "Was war das?!",
		npc = {
            id = GetEntityId("monasteryguardian"),
            isObserved = true
        },
        action = function ()
            Sound.PlayGUISound(Sounds.Military_SO_Fireworks, 80)
            Move("monasteryguardian", "YukiFirework")
        end
	}

    briefing.finished = function ()
        DestroyNPC{name = "monasteryguardian"}
        DestroyEntity("Yuki")
        CreateMilitaryGroup(3, Entities.PU_Hero11, 0, GetPosition("YukiJumpPos"), "Yuki")
        BriefingYukiComment()
    end
    StartBriefing(briefing)
end

function BriefingYukiComment()
    local briefing = {};
    local AP, ASP = AddPages(briefing);
    AP{
		title = "Yuki",
		text = "Trottel.",
		npc = {
            id = GetEntityId("Yuki"),
            isObserved = true
        },
        action = function ()
            Logic.CreateEffect( GGL_Effects.FXBuildingSmoke, GetPosition("Yuki").X, GetPosition("Yuki").Y, 1 );
        end
	}

    briefing.finished = function ()
        Logic.DestroyEffect(firework)
        StartSimpleJob("moveYukiInLurkPos")
        StartSimpleJob("moveGuardianBack")
    end

    StartBriefing(briefing)
end

function BriefingYukiLurking()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Yuki","Yuki","Hey, wie hast du mich denn so schnell gefunden?",true)
    ASP("Dario","Dario","Ich hatte das Gefühl, einen stechenden Blick zu spüren. @cr Du weißt, dass nur geweihte Personen des Glaubens hier sein dürfen?",true)
    ASP("Yuki","Yuki","Als ob mich so eine Formalität je aufgehalten hätten. *lächelt* @cr Genug geredet, ich \"glaube\" meine Kampfkraft wird hier gebraucht.",true)

    briefing.finished = function ()
        ChangePlayer("Yuki",1)
        YUKISPOKEN = true
    end

    StartBriefing(briefing)
end

function BriefingLighthouse()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("LighthouseKeeper","Leuchtturmwärter","Mir wird mal wieder nicht geholfen...",true)
    ASP("Ari","Ari","Das ist auch ein Weg eine Konversation zu starten... @cr Was gibts?",true)
    ASP("Lighthouse","Leuchtturmwärter","Dieser Leuchtturm hinter mir soll umliegende Dörfer benachrichtigen und das Feuer im Kohlebecken ist sogar in Sturmbach noch sichtbar.",true)
    ASP("Ari","Ari","Komm zum Punkt.",true)
    ASP("LighthouseKeeper","Leuchtturmwärter","Meine Güte da ist aber wer ungeduldig... @cr @cr Gut, weil gerade nicht niemand aus der Stadt kommt um Kohle vorbeizubringen, kann ich das Leuchtfeuer nicht aktivieren.",true)
    ASP("Ari","Ari","Unterstützung aus Sturmbach könnte praktisch sein. @cr Wie kommen wir an Kohle?",true)
    ASP("LighthouseKeeper","Leuchtturmwärter","Mir kommen da zwei Möglichkeiten in den Sinn. @cr Entweder Ihr verbrennt Holz, so machen das zumindest die Barbaren oder ihr baut Kohle durch eine Mine ab.",true)
    ASP("LighthouseKeeper","Leuchtturmwärter","Eine Kohlemine könnt ihr an jeder Felsformation bauen, da sollte es immer was zu holen geben. @cr Östlich von hier gibt es einen passenden Felsen. @cr Versucht es also einmal dort.",true)

    briefing.finished = function ()
        ChangePlayer("Lighthouse",1)
        TributeLighthouse()
    end

    StartBriefing(briefing)
end

function BriefingSilverMine()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Varg","Varg","Wir sind soweit aufgebaut. @cr Wir sind aber beschränkt auf normale Barbaren.",true)
    ASP("VargSilver","Varg","Mit etwas Silber könnten wir unsere Krieger mit unserem berühmten Elixier ausstatten, dann wären sie unaufhaltsam! @cr Leider ist das Silbervorkommen auf der anderen Seite des Flusses, ein Winter ist also nötig.",false)
    ASP("Varg","Varg","Zum Glück hat mir der Alchemist aus Nevassa einige alchemistische Schriften mitgegeben, die sollten helfen eine Wettermaschine zu bauen.",true)
    ASP("Varg","Varg","Wenn Ihr Silber findet, nehmen wir es natürlich auch mit liebend gern.",true)

    briefing.finished = function ()
        ResearchTechnology(Technologies.GT_Metallurgy, 1 )
        StartSimpleJob("checkForSilverMine")
    end

    StartBriefing(briefing)
end

function BriefingMonasteryGuardian()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("monasteryguardian","Wächter","Es dürfen nur Geistlichen in das Kloster. @cr Seht also zu, dass Ihr verschwindet!",true)

    StartBriefing(briefing)
end

function BriefingCatapultmaker()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Catapultmaker","Katapultmacher","Meine Katapulte stehen hier schon seit Längerem. @cr Leider ist die Defensive nicht gerade ihre Stärke. @cr Sollten wir in den Angriff übergehen, so werde ich mit Stolz beobachten, wie sie gegnerische Basen zu Schutt und Asche verwandeln!",true)

    StartBriefing(briefing)
end

function BriefingCatapultmakerAfterRitual()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local catapultSurvived = 0
    for i = 1, 4 do
        if IsDead("c"..i) == false then
            catapultSurvived = catapultSurvived + 1
        end
    end

    if catapultSurvived == 0 then
        ASP("Catapultmaker","Katapultmacher","Zu gerne hätte ich Euch meine Katapulte zur Verfügung gestellt, aber sie wurden alle zerstört... ",true)
    elseif catapultSurvived == 4 then
        ASP("Catapultmaker","Katapultmacher","Alle meine Katapulte haben den Blutmond überstanden und das nur Dank Euch! @cr Nun nehmt sie und zeigt unserem Gegner, mit wem er es zutun hat!",true)
    else
        ASP("Catapultmaker","Katapultmacher","Einige meiner Katapulte haben den Blutmond nicht überstanden und aber Jedes hat großes Zertörungspotential. @cr Nehmt den Rest der Katapulte und zeigt unserem Gegner, mit wem er es zutun hat!",true)
    end

    briefing.finished = function ()
        for i = 1, 4 do
            ChangePlayer("c"..i,1)
        end
    end

    StartBriefing(briefing)
end

function BriefingTownFarmer()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("TownFarmer","Landwirt","Guten Tag. @cr Ich habe meine bescheidenen Felder in der Mitte der Stadt angelegt. @cr Warum fragt Ihr? @cr @cr Ganz einfach, im Falle der Belagerung können wir uns weiterhin grundlegend versorgen.",true)
    ASP("TownFarmer","Landwirt","Nun, wenn ich so einen Blick über die Festungsmauern werfe, war das wohl die richtige Entscheidung",true)

    StartBriefing(briefing)
end

function BriefingShagsworth()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Shagsworth","Shagsworth","Hey Königin Ari! @cr Lange nicht gesehen. @cr Sicher wollt Ihr wissen was bei meinen Nachforschungen herrausgekommen ist?",true)
    ASP("Ari","Ari","Lasst hören.",true)
    ASP("Shagsworth","Shagsworth","Die Geister erscheinen in der Nacht und verschwinden am Tag.",true)
    ASP("Ari","Ari","...",true)
    ASP("Shagsworth","Shagsworth","...",true)
    ASP("Ari","Ari","Und weiter?",true)
    ASP("Shagsworth","Shagsworth","Leider ging nach Eurer Abreise schon die Sonne auf.",true)
    ASP("Ari","Ari","Du willst mich doch auf den Arm nehmen...",true)
    ASP("Shagsworth","Shagsworth","Tut mir leid aber meine Arme sind zu schwächlich. @cr Wie dem auch sei, auf dem Weg durch die Berge habe ich weitaus Interessanteres herrausgefunden.",true)
    ASP("Ari","Ari","Bitte sag mir jetzt nicht, dass Geister durchsichtig sind.",true)
    ASP("Shagsworth","Shagsworth","Nein nein natürlich nicht. Ich bin einigen komischen Gestalten mit Flammen um sich herum gesehen.",true)
    ASP("Shagsworth","Shagsworth","Neugierig wie ich bin habe ich die nächsten 4 Tage damit verbracht mich zu verstecken und denen bis ins Nest zu folgen.",true)
    ASP("Shagsworth","Shagsworth","Und was mich da erwartet hat, war jenseins dem was ich mir vorstellen konnte.",true)
    ASP("Shagsworth","Shagsworth","Die haben Trolle gebaut aus riesigen Mengen an Knochen und Fleisch. @cr Allein wenn ich daran zurückerinnere schaudert es mir am ganzen Körper.",true)
    ASP("Shagsworth","Shagsworth","Ich könnte mehr herrausfinden, Gerüchten zufolge gibt es nördlich eine ähnliche Knochengrube.",true)
    if VARGSPOKEN == true then
        ASP("Ari","Ari","Der Weg dahin ist frei, tu dir keinen Zwang an",true)
        ASP("Shagsworth","Shagsworth","Danke wir sehen uns dort!",true)
        briefing.finished = function ()
            StartSimpleJob("moveShagsNorth")
        end
    else
        ASP("Ari","Ari","Wir werden das Tor bald öffnen. Halte dich bereit",true)
        briefing.finished = function ()
            StartSimpleJob("waitForVargQuest")
        end
    end

    StartBriefing(briefing)
end

function BriefingShagsworthGate()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Shagsworth","Shagsworth","Hallo mein glatzköpfiger Freund, ist hinter diesem Tor zufällig ein großer Leichenhaufen?",true)
    ASP("VargGateKeeper","Torwächter","Ich hab die Anweisung bekommen, niemanden durchzulassen. @cr Was dahinter abgeht, interessiert nur unseren Jarl und die komische Chinesin.",true)
    ASP("Ari","Ari","*Eine komische Chinesin hmm?* @cr @cr ... Dann werde ich Yuki wohl Bescheid geben müssen.",true)
    ASP("VargGateKeeper","Torwächter","Ich habs mir anders überlegt ihr dürft passieren.",true)
    ASP("Ari","Ari","Dachte ich mir schon.",true)

    briefing.finished = function ()
        ReplaceEntity(GetEntityId("gatevarg2"),Entities.XD_PalisadeGate2)
        Move("VargGateKeeper","gateKeeperMove")
    end

    StartBriefing(briefing)
end

function BriefingShagsworthPit()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("","","",true)

    briefing.finished = function()

    end

    StartBriefing(briefing)
end