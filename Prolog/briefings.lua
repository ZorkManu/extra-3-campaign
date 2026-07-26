function BriefingStart()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP{
        text = "Ein Kampf war in einer sonst eher friedlichen Gegend ausgebrochen.",
        position = GetPosition("CameraStartFight"),
        dialogCamera = true
    }
    local page2 = AP{
        text = "Die einst friedlichen Dörfer dieser Gegend waren für ihre Holzarbeit und ihre Fischerei bekannt.",
        position = GetPosition("CameraStartFight"),
        dialogCamera = true
    }
    local page3 = AP {
        text = "Wieso sie sich jetzt bekämpften war König Dario ein Rätsel.",
        position = GetPosition("CameraStartFight"),
        dialogCamera = true
    }
    local page4 = AP {
        text = "Ari höchstpersönlich machte sich auf den Weg, um den Grund in Erfahrung zu bringen...",
        npc = { 
            id = GetEntityId( "Ari" ), 
            isObserved = true 
        },
        dialogCamera = true,
        action = Move("Ari", GetPosition("AriPos1"))
    }
    local page5 = AP {
        title = "Ari",
        text = "Ihr solltet mich schützen, nicht meinen Standort ausrufen. Könnt ihr leiser auftreten?",
        dialogCamera = true,
        npc = { 
            id = GetEntityId( "Ari" ), 
            isObserved = true 
        },
        action = function ()
            LookAt("Ari", "h1")
            end,
    }
    local page6 = AP {
        title = "Gardist Gerhard",
        text = "Verstanden, meine Königin. Wir bleiben dicht bei Euch und halten uns im Hintergrund.",
        npc = { 
            id = GetEntityId( "h1" ), 
            isObserved = true 
        },
        dialogCamera = true,
        action = function ()
            LookAt("h1", "Ari")
            end,
    }
    local page7 = AP {
        title = "Ari",
        text = "Ich habe das Gefühl, ohne euch wäre es sicherer. Aber genug der Rederei, lasst uns Winkelhain und Sturmbach aufsuchen.",
        npc = { 
            id = GetEntityId( "Ari" ), 
            isObserved = true 
        },
        dialogCamera = true,
        action = function ()
            LookAt("Ari", "h1")
            end,
    }
    local page8 = AP {
        title = "Ari",
        text = "Die beiden Dörfer befinden sich gerade im Krieg, wir sollten schauen, wem wir trauen können, bevor wir uns denen offenbaren.",
        npc = { 
            id = GetEntityId( "Ari" ), 
            isObserved = true 
        },
        dialogCamera = true,
        action = function ()
            LookAt("Ari", "p2hq")
            end,
        quest = {
            title = "Informationsbeschaffung",
            text = "Schaut Euch um und bringt Etwas über die Dörfer in Erfahrung.",
            type = MAINQUEST_OPEN,
            id = 1
        }
    }
    briefing.finished = function ()
        DestroyNPC{name = "Ari"}
        Logic.SetOnScreenInformation(GetEntityId("h1"), 0)
        initSwords()
    end

    StartBriefing(briefing);

end

function BriefingSwords()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Hauptmann",
        text = "Königin Ari, welch Ehre. Wir haben Euch erwartet.",
        position = GetPosition("Sword1")
    }
    local page2 = AP {
        title = "Ari",
        text = "Erwartet? Mit wem spreche ich hier?",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Hauptmann",
        text = "Wir gehören Sturmbach an. Als wir von Eurer Ankunft hörten, sind wir aufgebrochen, um Euch sicher ins Dorf zu führen.",
        position = GetPosition("Sword1")
    }
    local page4 = AP {
        title = "Hauptmann",
        text = "Bitte folgt uns.",
        position = GetPosition("Sword1")
    }
    local page5 = AP {
        title = "Ari",
        text = "*Woher wissen die überhaupt, dass ich hier bin? Und meinen exakten Weg? Sehr verdächtig… ich sollte mich erstmal unauffällig verhalten, sonst könnte die Situation schlecht für mich enden.*",
        position = GetPosition("Ari"),
        quest = {
            title = "Folgt den fremden Soldaten",
            text = "Die Soldaten führen sicher etwas im Schilde, folgt ihnen aber erst besser um nicht Verdächtig zu wirken.",
            type = MAINQUEST_OPEN,
            id = 2
        }
    }

    briefing.finished = function ()
        StartSimpleJob("followSwords")
        Logic.SetQuestType(1, 1, MAINQUEST_CLOSED, 0)
    end

    StartBriefing(briefing);
end

function BriefingBanditTower()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Ari",
        text = "Meines Wissens nach geht es hier nicht nach Sturmbach… und ein leerer Banditenturm mitten im Nirgendwo schreit selten nach einem sicheren Weg.",
        position = GetPosition("Ari")
    }
    local page2 = AP {
        title = "Ari",
        text = "*Diese Banditen gehörten zu meinen Jungs. Wenn selbst die verschwinden, steckt hier mehr dahinter.*",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "",
        text = "Der Hauptmann zuckt kurz zusammen und schaut Richtung Turm.",
        position = GetPosition("Sword1")
    }
    local page4 = AP {
        title = "Hauptmann",
        text = "Scheint, als bleiben die uns heute erspart. Wir müssen leider einen Umweg nehmen - ihr könnt schlecht einmal mitten durch die Kriegszone laufen. Bitte folgt uns weiter, die Reise… zieht sich ein wenig.",
        position = GetPosition("Sword1")
    }
    local page5 = AP {
        title = "Ari",
        text = "*Die haben definitiv nichts Gutes vor. Wenn ich mich jetzt querstelle, bringen die zuerst meine Wachen um und dann mich. Also erstmal freundlich lächeln, nicken und warten, bis sie einen Fehler machen.*",
        position = GetPosition("Ari")
    }

    briefing.finished = function ()
        TOWERVISITED = true
        StartSimpleJob("followSwords")
    end

    StartBriefing(briefing);
end

function BriefingAmbush()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Hauptmann",
        text = "Jetzt sind wir weit genug von Winkelhain entfernt. Männer legt sie in Ketten!",
        position = GetPosition("Sword1")
    }
    local page2 = AP {
        title = "Gardist Gerhard",
        text = "Nicht wenn wir mitreden können. Wir schützen die Königin mit unserem Leben.",
        position = GetPosition("h1"),
        action = function ()
            SetHostile(3,7)
            DestroyNPC{name = "h1"}
            DestroyNPC{name = "h2"}
        end
    }

    briefing.finished = function ()
        AMBUSHVISITED = true
        StartSimpleJob("checkForHalberds")
    end

    StartBriefing(briefing);
end

function BriefingBandits()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Ari",
        text = "Verdammt, diese Idioten. Gegen so viele hätten sie nichts machen können. Ich muss es positiv sehen, immerhin werde ich wohl schneller erfahren was hier los ist als ich dachte.",
        position = GetPosition("Ari")
    }
    local page2 = AP {
        title = "",
        text = "Währenddessen hörte Ari aus den Ruinen hinter sich einige Fußstapfen.",
        position = GetPosition("p1hq")
    }
    local page3 = AP {
        title = "?",
        text = "Lange Zeit nicht gesehen, Boss.",
        position = GetPosition("banditAmbush"),
        action = function ()
            CreateMilitaryGroup(1, Entities.CU_VeteranCaptain, 0, GetPosition("banditAmbush"), "Schwarz")
            LookAt("Schwarz", "Ari")
            StartCountdown(1, function ()
                Logic.SetEntityScriptingValue(GetEntityId("Schwarz"),72,1)
			    CUtil.SetEntityDisplayName(GetEntityId("Schwarz"), "Schwarz")
            end, false)
        end
    }
    local page4 = AP {
        title = "Ari",
        text = "Einen besseren Zeitpunkt zum erscheinen hättest du nicht wählen können Schwarz. Töten wir diese Hunde!",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "Schwarz",
        text = "Nichts lieber als das Boss. Du kannst uns immer rufen, wenn du uns brauchst.",
        position = GetPosition("banditAmbush"),
    }
    local page6 = AP {
        title = "Missionsbeschreibung",
        text = "Besiege die Entführer. Tipp: Ari kann nun Banditen rufen.",
        position = GetPosition("Ari")
    }

    briefing.finished = function ()
        BANDITSAPPEARED = true
        createArmySwords()
        SetHostile(1,3)
        StartSimpleJob("checkForSwords")
        StartSimpleJob("checkForSchwarz")
    end

    StartBriefing(briefing);
end

function BriefingPostBattle()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Ari",
        text = "Das war wirklich knapp. Und jetzt sagt mir: Woher wusstet ihr bitte schön, dass wir genau hier landen würden?",
        position = GetPosition("Ari")
    }
    local page2 = AP {
        title = "Schwarz",
        text = "Truppen abseits vom Schlachtfeld? Das ist nie normal. Wir haben sie schon vor deiner Ankunft beobachtet und schnell kapiert, was die vorhatten.",
        position = GetPosition("Schwarz")
    }
    local page3 = AP {
        title = "Ari",
        text = "Es war also richtig misstrauisch zu sein... Sag mal, weißt du etwas über den Krieg der hier ausgebrochen ist? Ich meine ich weiß jetzt, dass ich Sturmbach nicht trauen kann, aber was ist mit Winkelhain?",
        position = GetPosition("Ari")
    }
    local page4 = AP {
        title = "Schwarz",
        text = "Die scheinen genauso verwirrt über den Krieg zu sein wie du. Rede am Besten mal mit deren Bürgermeister, der kann deine Hilfe sicher brauchen.",
        position = GetPosition("mayorWinkelhain"),
        explore = BRIEFING_EXPLORATION_RANGE,
        marker = ANIMATED_MARKER
    }
    local page5 = AP {
        title = "Schwarz",
        text = "Achja und Boss, wir stehen natürlich wieder in deinem Dienst. Nimm unsere Burg und unseren Turm als Stützpunkt.",
        position = GetPosition("Schwarz"),
        quest = {
            title = "Potentielle Verbündete",
            text = "Winkelhain scheint genauso unwissend über den Krieg wie Ihr. Sprecht mit dem Bürgermeister von Winkelhain, um ihn als Verbündeten zu gewinnen.",
            type = MAINQUEST_OPEN,
            id = 3
        }
    }
    local page6 = AP {
        title = "Tipp",
        text = "Der Söldnerturm kann einige normal nicht erhältliche Truppen rekrutieren. Versucht einige Banditen zu rekrutieren.",
        position = GetPosition("banditTower")
    }

    briefing.finished = function ()
        Logic.SetQuestType(1, 2, MAINQUEST_CLOSED, 0)
        firstQuestDone()
    end

    StartBriefing(briefing);
end

function BriefingMayorWinkelhain()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Bürgermeister",
        text = "Sehen meine alten Augen richtig, seid Ihr es, meine Königin? Wenn ich gewusst hätte, dass Ihr kommt, hätte ich wenigstens den guten Mantel angezogen…",
        position = GetPosition("mayorWinkelhain")
    }
    local page2 = AP {
        title = "Ari",
        text = "Es tut mir Leid, ich habe mich nicht ankündigen lassen aufgrund der speziellen ... Situation.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Bürgermeister",
        text = "Das ist natürlich vollkommen verständlich. Und selbst wenn… unsere Ressourcen reichen im Moment nicht mal für einen anständigen Begrüßungskuchen.",
        position = GetPosition("mayorWinkelhain")
    }
    local page4 = AP {
        title = "Ari",
        text = "Das wäre selbst in der Friedenszeit nicht nötig gewesen. Winkelhain ist immerhin nicht wirklich bekannt für große Festivitäten, sondern einzig und allein für Holz.",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "Ari",
        text = "Was mich vor allem interessiert: Was zur Hölle ist hier los? Der Krieg ist vorbei, das Nebelvolk zerschlagen, Kerberos im Exil. Und trotzdem prügeln sich eure Dörfer, als gäbe es einen Preis dafür.",
        position = GetPosition("Ari")
    }
    local page6 = AP {
        title = "Bürgermeister",
        text = "Wenn ich das nur wüsste. Wir sind selber ja nur ein armes Holzfällerdorf im Wald und unsere Beziehungen nach Sturmbach waren normalerweise immer gut. Zumindest dachten wir das, bis deren Truppen auf einmal vor unserer Tür standen.",
        position = GetPosition("mayorWinkelhain")
    }
    local page7 = AP {
        title = "Bürgermeister",
        text = "Momentan sind es nur wenige Angreifer, aber unsere Späher konnten bestätigen, dass ein Großangriff bevorsteht.",
        position = GetPosition("battleFieldWinkelhain"),
        explore = BRIEFING_EXPLORATION_RANGE,
        marker = ANIMATED_MARKER
    }
    local page8 = AP {
        title = "Bürgermeister",
        text = "Wir können auch so schon kaum standhalten, wir brauchen dringendst Eure Hilfe, wenn unser Dorf überleben will.",
        position = GetPosition("battleFieldWinkelhain")

    }
    local page9 = AP {
        title = "Ari",
        text = "Ich bin zwar nicht mit Truppen hier, aber ich schaue mal was ich machen kann. Ich werde Euer Dorf nicht einfach so seinem Schicksal überlassen.",
        position = GetPosition("Ari")
    }
    local page10 = AP {
        title = "Ari",
        text = "Mit den wenigen Banditen kann ich hier wohl kaum helfen. Ich muss meine Siedlung weiter aufbauen und einmal mit Schwarz sprechen. Er kann mir sicher erzählen, ob sich hier weitere Banditentruppen rumtreiben.",
        position = GetPosition("Ari"),
        quest = {
            title = "Rettet Winkelhain",
            text = "Winkelhain ist in unmittelbarer Gefahr. Rekrutiert Soldaten und sucht die Gegend um Winkelhain nach Nützlichem ab. Eventuell kann Schwarz euch weiterhelfen. @cr Aber passt auf, es steht ein Großangriff auf Winkelhain bevor!",
            type = MAINQUEST_OPEN,
            id = 4
        }
    }
    local page11 = AP {
        title = "Missionsbeschreibung",
        text = "Verhindert, dass die Burg von Winkelhain fällt",
        position = GetPosition("p2hq")
    }
    briefing.finished = function()
        Logic.SetQuestType(1, 3, MAINQUEST_CLOSED, 0)
        prepareForSturmbachAttack()
    end

    StartBriefing(briefing);
end

function BriefingPostAttack()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Schwarz",
        text = "Was waren das bitte für Gestalten? Die Wilden mit den Schildkrötenpanzern waren ja schon seltsam, aber durch ein paar von denen konnte ich einfach durchgucken! Ich kämpfe doch nicht gegen Luft!",
        position = GetPosition("Schwarz")
    }
    local page2 = AP {
        title = "Ari",
        text = "Dass das Nebelvolk irgendwann wieder auftaucht, war klar. Aber was mit diesen Soldaten passiert ist, hat mit \"menschlich\" nichts mehr zu tun. Offenbar waren die Geistermärchen für Kinder doch eher Warnberichte.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Schwarz",
        text = "G… Geister? Also bitte, ich hab ja schon viel gesehen, aber Geister?! Die spuken doch nur in Tavernen, wenn der Wein schlecht ist… oder?",
        position = GetPosition("Schwarz")
    }
    local page4 = AP {
        title = "Ari",
        text = "Mach dir doch nicht gleich ins Hemd. Es gibt jetzt erstmal Wichtigeres. Die Soldaten von Sturmbach haben sich zurückgezogen und schienen auch von unseren neuen Freunden angegriffen worden zu sein. Nach dem Rückschlag lassen die doch sicher mit sich reden.",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "Schwarz",
        text = "Mach dir mal nichts vor, ich war nur… überrascht. Nach Sturmbach zu reisen ist trotzdem, als würdest du in ein Wespennest treten. Aber du hast recht, Boss - im Moment schießen die auf andere Ziele. Sprich auch mit dem Bürgermeister von Winkelhain, vielleicht hat der eine Idee, die nicht mit \"sterben\" endet.",
        position = GetPosition("Schwarz")
    }
    local page6 = AP {
        title = "Missionsbeschreibung",
        text = "Sprecht mit dem Bürgermeister von Winkelhain und reist nach Sturmbach.",
        position = GetPosition("Ari")
    }

    briefing.finished = function ()
        Logic.SetQuestType(1, 4, MAINQUEST_CLOSED, 0)
        Logic.AddQuest(1, 5, MAINQUEST_OPEN, "Verstärkung","Alleine habt Ihr schlechte Chancen zu Überleben. Sucht Winkelhain nach Möglichkeiten ab Eure Verbündeten zu alarmieren", 0)
        Logic.AddQuest(1, 6, MAINQUEST_OPEN, "Begraben des Kriegsbeils","Sturmbach ist nicht mehr Eure Priorität, gewinnt sie als Mitstreiter für den Kampf.", 0)
        Logic.AddQuest(1, 7, MAINQUEST_OPEN, "Gegenoffensive","Ihr werdet vom Nebelvolk und unbekannten Truppen angegriffen. Vernichtet die Angreifer und bringt der Region den Frieden zurück.", 0)
        thirdQuest()
    end

    StartBriefing(briefing);
end

function BriefingEnterSturmhain()

    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "General Roderik",
        text = "Wen haben wir denn da? Wenn das mal nicht die Königin höchstpersönlich ist. Auf Euch ist eine Belohnung ausgesetzt, für die ich mir endlich eine Insel und Ruhe vor diesem Chaos kaufen könnte.",
        position = GetPosition("General")
    }
    local page2 = AP {
        title = "Ari",
        text = "Sagt mir bitte, ihr habt gerade nichts Wichtigeres zu tun, als mir mit Kopfgeldern zu drohen. Von hier aus sehe ich, dass ihr selbst kaum überlebt. Wer ist denn so lebensmüde, ein Kopfgeld auf mich auszusetzen?",
        position = GetPosition("BaseSturmbach"),
        explore = BRIEFING_EXPLORATION_RANGE,
    }
    local page3 = AP {
        title = "General Roderik",
        text = "Zu unserer Verwunderung - der Bürgermeister. Aber ich beschwere mich nicht. Für das Kopfgeld würde ich mich sogar selbst verhaften lassen.",
        position = GetPosition("General")
    }
    local page4 = AP {
        title = "Ari",
        text = "Den Urlaub könnt Ihr euch abschminken, wenn euer Dorf vorher untergeht. Ohne Unterstützung der königstreuen Siedlungen seid ihr erledigt. Also: Wo steckt dieser Bürgermeister? Helft mir, und vielleicht müsst ihr euren Ruhestand nicht im brennenden Dorf verbringen.",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "General Roderik",
        text = "Ihr kommt in feindliches Territorium und versucht mich auch noch mit Belohnungen zu locken? ... Ich mag Euren Mumm.",
        position = GetPosition("General")
    }
    local page6 = AP {
        title = "General Roderik",
        text = "Na gut, der Bürgermeister befindet sich in dem Landsitz auf dem Berg hinter uns. Ich sorge dafür, dass Ihr durch kommt. Aber vergesst ja nicht Euer Versprechen!",
        position = GetPosition("mayorSturmbach"),
        explore = BRIEFING_EXPLORATION_RANGE,
    }
    local page7 = AP {
        title = "Missionsbeschreibung",
        text = "Geht zum Bürgermeister",
        position = GetPosition("Ari")
    }

    briefing.finished = function ()
        CreateMayorSturmbach()
    end

    StartBriefing(briefing);
end

function BriefingMayorSturmbach()
    local briefing = {};
    local AP = AddPages(briefing);

    page1 = AP {
        title = "Bürgermeister",
        text = "Königin Ari… (nervöses Lachen) Was verschlägt Euch denn in unser friedliches, völlig unauffälliges und garantiert nicht verschwörerisches Dorf?",
        position = GetPosition("mayorSturmbach")
    }
    page2 = AP {
        title = "Ari",
        text = "(zückt ein Messer) Ich komme gleich zum Punkt - im Gegensatz zu Euch. Warum wolltet Ihr mich umbringen lassen?",
        position = GetPosition("Ari")
    }
    page3 = AP {
        title = "Bürgermeister",
        text = "Ahhh, bitte habt Erbarmen! Töten wollte ich Euch nie, wirklich! Ich sollte Euch nur… bequem einsperren lassen. Für sehr, sehr lange Zeit.",
        position = GetPosition("mayorSturmbach")
    }
    page4 = AP {
        title = "Ari",
        text = "(streckt das Messer aus) Von wem und warum. Und denkt daran: Je detaillierter die Antwort, desto weiter weg bleibt die Spitze meines Messers von eurer Kehle.",
        position = GetPosition("Ari")
    }
    page5 = AP {
        title = "Bürgermeister",
        text = "Bitte, Ihr müsst nicht so weit gehen, ich verrate Euch alles! Eine Frau mit schwarzem Haar und Rapier… sehr adelig, sehr teuer. Sie bot eine gewaltige Summe für Winkelhain und eine noch größere für Euch. Ganze 500.000 Taler! Für so viel Geld verkauft man normalerweise sein Gewissen gleich mit.",
        position = GetPosition("mayorSturmbach")
    }
    page6 = AP {
        title = "Ari",
        text = "Eine adlig aussehende Frau mit schwarzem Haar und Rapier. Wenn das mal keine eindeutige Beschreibung ist. Aber sagt, woher wusste sie davon, dass ich hier herkomme?",
        position = GetPosition("Ari")
    }
    page7 = AP {
        title = "Bürgermeister",
        text = "(zittert) Ich weiß es nicht, ich schwöre.",
        position = GetPosition("mayorSturmbach")
    }
    page8 = AP {
        title = "Ari",
        text = "In Ordnung. (Sie zieht das Messer zurück und der Bürgermeister atmet auf). Die Informationen waren sehr hilfreich. Aber ... (Plötzlich wirft Ari ruckartig ihr Messer in die Brust des Bürgermeisters) ... Verräter kann ich hier nicht gebrauchen. Ich werde mich nach dem Aufruhr hier um einen Ersatz kümmern.",
        position = GetPosition("Ari"),
    }

    briefing.finished = function ()
        finishSturmbachQuest()
        SetHealth( GetEntityId("mayorSturmbach"), 0 )
        Logic.SetQuestType(1, 6, MAINQUEST_CLOSED, 0)
        STURMBACHALLIED = true
    end

    StartBriefing(briefing);
end

function BriefingMayorWinkelhain2()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Ari",
        text = "Herr Bürgermeister? Konntet Ihr euch auf den kürzlichen Angriff einen Reim bilden?",
        position = GetPosition("Ari")
    }
    local page2 = AP {
        title = "Bürgermeister",
        text = "Nein, leider nicht. Die Feinde haben sich meinen Spähern nach am alten Friedhof aufgestellt. Das ergibt keinen Sinn, der Friedhof hat keinen taktischen Vorteil",
        position = GetPosition("necroAltar1"),
        explore = BRIEFING_EXPLORATION_RANGE
    }
    local page4 = AP {
        title = "Ari",
        text = "Der Friedhof? Habt Ihr die feindlichen Truppen gesehen? Die sind halb durchsichtig?! Das ist der perfekte Ort für deren Basis!",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "Bürgermeister",
        text = "Ihr wollt doch nicht etwa sagen...? Ich weiß zwar nicht was mit wem wir es hier zu tun haben, aber diese Übermacht können wir auch mit Sturmbachs Hilfe nicht besiegen. Wenn uns niemand retten kommt, sind wir bald alle Geschichte!",
        position = GetPosition("mayorWinkelhain")
    }
    local page6 = AP {
        title = "Ari",
        text = "Stimmt, wenn uns niemand retten kommt, dann wars das mit uns. Aber genau deswegen bin ich hier. Ich möchte von Euch wissen wer Euer schnellster Bote ist und wie der am Schnellsten zu Fort Mercius kommt.",
        position = GetPosition("Ari")
    }
    local page7 = AP {
        title = "Bürgermeister",
        text = "Fort Mercius? Der ist leider zu weit weg. Der normale Weg beträgt mehrere Tage bis sogar Wochen.",
        position = GetPosition("mayorWinkelhain")
    }
    local page8 = AP {
        title = "Ari",
        text = "Der Normale? Also gibt es etwas Schnelleres?",
        position = GetPosition("Ari")
    }
    local page9 = AP {
        title = "Bürgermeister",
        text = "Es gäbe da noch den Weg durchs Gebirge. Aufgrund von Steinschlägen haben wirs aber bisher nicht geschafft einen ordentlichen Pfad zu errichten. Dort entlang zu gehen ist ziemlich riskant.",
        position = GetPosition("mayorWinkelhain")
    }
    local page10 = AP {
        title = "Ari",
        text = "Drastische Situation verlangen drastische Maßnahmen. Zumindest hat Dario das immer gesagt. Also wo finde ich Eueren besten Reiter.",
        position = GetPosition("Ari")
    }
    local page11 = AP {
        title = "Bürgermeister",
        text = "In Ordnung, mein bester und schnellster Reiter Rudger ist beim Stall am Rande des Dorfes. Teilt ihm seine Mission am Besten selbst mit. Das wird seine Motivation sicher steigern ...",
        position = GetPosition("Rudger"),
        explore = BRIEFING_EXPLORATION_RANGE,
    }
    local page12 = AP {
        title = "Missionsbeschreibung",
        text = "Sprecht mit Rudger und lasst ihn zu Fort Mercius aufbrechen.",
        position = GetPosition("Ari"),
        quest = {
            title = "Alarmiert Fort Mercius",
            text = "Winkelhain und Sturmbach schaffen es nicht allein. Lasst Rudger nach Mercius aufbrechen um Verstärkung anzufordern!",
            type = MAINQUEST_OPEN,
            id = 5
        }
    }

    briefing.finished = function ()
        speakWithMessenger()
    end

    StartBriefing(briefing);
end

function BriefingRudger()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Rudger",
        text = "Die Königin persönlich? Was für ein Tag! Ich bin Rudger - schnellster Reiter weit und breit. Was kann ich für Euch tun?",
        position = GetPosition("Rudger")
    }
    local page2 = AP {
        title = "Ari",
        text = "Dann gleich zur Sache: Reitet nach Fort Mercius und fordert Verstärkung an. Nehmt den Bergpass, der lange Weg ist keine Option.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Rudger",
        text = "Verstärkung besorgen? Ein Auftrag für Rudger! Mein Pferd und ich schlagen jede Zeitvorgabe. Die Barden werden den Ritt besingen, bevor ich wieder zurück bin.",
        position = GetPosition("Rudger"),
        action = function ()
            Move("Rudger", "scoutGate")
            StartSimpleJob("messengerArrival")
        end
    }
    local page5 = AP {
        title = "Ari",
        text = "Hoffentlich ist er so schnell, wie er behauptet. Namen kann ich später lernen, Hauptsache er liefert.",
        position = GetPosition("Ari")
    }

    StartBriefing(briefing);
end

function BriefingMountains()
    local briefing = {noEscape = true};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Rudger",
        text = "Da haben wir ja das Tor.",
        position = GetPosition("Rudger"),
        action = function ()
            gate = ReplaceEntity( GetEntityId("gateMountain"), Entities.XD_PalisadeGate2)
            SetEntityName(gate, "gateMountain")
        end
    }
    StartBriefing(briefing);
    local briefing = {noEscape = true};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Rudger",
        text = "Gut dann mal los.",
        npc = { 
            id = GetEntityId( "Rudger" ), 
            isObserved = true 
        },
        action = Move("Rudger", "scoutMove"),

    }
    local page2 = AP {
        title = "Missionsbeschreibung",
        text = "Durchquert das Gebirge. Rudger muss überleben! (Dringende Speicherempfehlung)",
        npc = { 
            id = GetEntityId( "Rudger" ), 
            isObserved = true,
            action = Move("Rudger", "scoutMove"),
        },
    }

    briefing.finished = function ()
        DestroyNPC{name = "Rudger"}
        Move("Rudger", "scoutMove")
        StartCountdown(2, function ()
            Logic.SetEntityScriptingValue(GetEntityId("Rudger"),72,1)
            CUtil.SetEntityDisplayName(GetEntityId("Rudger"), "Rudger")
            gate = ReplaceEntity( GetEntityId("gateMountain"), Entities.XD_PalisadeGate1)
            SetEntityName(gate, "gateMountain")
        end, false)
        StartCountdown(10, startErebosMinigame, false)
    end

    StartBriefing(briefing);
end

function BriefingMountainPassed()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Rudger",
        text = "Das wäre geschafft. Knapper als gewollt, aber das macht die Geschichte später nur spannender. Nun denn, treues Ross - auf nach Fort Mercius, bevor jemand merkt, wie knapp das wirklich war!"
    }

    briefing.finished = function ()
        DestroyEntity(GetEntityId("Rudger"))
        StartCountdown(900, reeinforcementsMercius, true)
    end

    StartBriefing(briefing);
end

function BriefingReeinforcements()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Pilgrim",
        text = "Da wären wir, der Winkelhainer Friedhof ist nicht mehr weit. Zeigen wir dem Nebelvolk mal die Wirkung neureichischer Sprengkraft!",
        position = GetPosition("Pilgrim")
    }
    local page2 = AP {
        title = "Rudger",
        text = "Mein Abenteuer naht sich dem Ende. Ich höre die Tavernen schon jetzt, wie sie meine Ruhmestaten ausschmücken - und garantiert nichts über die Stellen erwähnen, an denen ich fast vom Pferd gefallen bin.",
        position = GetPosition("Rudger")
    }
    local page3 = AP {
        title = "Pilgrim",
        text = "Das stimmt wohl, mein hochgestochener Freund. Die erste Runde geht auf mich - wenn wir das hier überleben. Also keine Geschichten vor der Schlacht, wir haben noch Arbeit.",
        position = GetPosition("Pilgrim")
    }
    local page4 = AP {
        title = "Tipp",
        text = "Kanonen sind unterschiedlich effektiv. Während Eisenkanonen hohen Schaden an Soldaten machen, sind Bronzekanonen sehr stark gegen Gebäude."
    }

    briefing.finished = function ()
        initReeinforcementsSpawner1()
        initReeinforcementsSpawner2()
        REEINFORCEMENTSARRIVED = true
        Logic.SetQuestType(1, 5, MAINQUEST_CLOSED, 0)
    end

    StartBriefing(briefing);
end

function BriefingVictory()
    local briefing = {};
    local AP,ASP = AddPages(briefing);

    ASP("Ari","Ari","Die Situation sah recht übel aus, gut dass Rudger es geschafft hat.", true)
    ASP("Rudger","Rudger","War etwas anderes zu erwarten? Wenn Ruhm eine Währung wäre, wäre ich jetzt der reichste Mann des Reiches!", true)
    ASP("Schwarz","Schwarz", "Alles klar, Mund zu, du Nervensäge. Sonst schick ich dich zurück durch das Gebirge - zu Fuß.", true)
    ASP("Pilgrim","Pilgrim","Ich war nur zufällig in Mercius, um ein paar Steine aus meiner Mine in Barmecia zu verkaufen, da kam Euer Bote angeritten. @cr Den Spaß konnte ich mir nicht entgehen lassen.", true)
    ASP("Schwarz","Schwarz", "Könnten wir uns vielleicht erstmal auf das Wichtige konzentrieren? Über die Schlacht austoben könnt ihr euch beide gleich in der Taverne. @cr Ari ich habe beunruhigende Neuigkeiten. In der Abtei fanden meine Leute Zeichen die an Rituale erinnern, auf dem Boden mit Blut gezeichnet. @cr Außerdem diese Schriften ...", true)
    ASP("Ari","Ari","...Schriften? Was steht in diesen Schriften?", true)
    ASP("Schwarz","Schwarz","Sorry, ich kann nicht lesen.", true)
    ASP("Ari","Ari","Dann gib mal her.",true)
    ASP("Ari","Ari","Scheint in einer anderen Sprache zu sein. Wir sollten die Schriften wohl einmal analysieren lassen.", true)
    ASP("Pilgrim","Pilgrim","Dann sollten wir zurück nach Mercius. Hier wird wohl kaum ein Sprachgelehrter sein.", true)
    ASP("Ari","Ari","Stimmt, dann lass uns sofort aufbrechen",true)
    ASP("Pilgrim","Pilgrim","Und den Ausflug in eine örtliche Taverne verpassen? Können wir nicht besser morgen los - mit weniger Feinden und mehr Bier?", true)
    ASP("Ari","Ari","Du denkst auch immer nur ans Saufen, Pilgrim… aber du hast Recht. Eine kleine Auszeit haben wir uns redlich verdient.", true)
    local choicePage = AP{
		mc 	 = { 
			title	= "Ari", 
			text 	= "Außerdem muss ich mich noch für einen Nachfolger für Sturmbach kümmern. Wer wäre dafür nur geeignet?",
			firstText   = "Schwarz (Sturmbach wird sich auf sein Militär konzentrieren. Schwarz wird Euch nicht weiter begleiten)",
			secondText  = "Winkelhains Bürgermeister (Sturmbach wird sich auf Gewinnung von Ressourcen konzentrieren)",
			firstSelected  = 15, 
			secondSelected = 18,
		},
		dialogCamera	=	true,
	}
    ASP("Ari","Ari","Schwarz, du bleibst hier und kümmerst dich Sturmbach. Ich brauche starke Verbündete sollte die Situation schlimmer werden.", true)
    ASP("Schwarz","Schwarz","Ich? Ich kann nicht behaupten, dass ich sowas je getan habe, aber ich werde dich nicht enttäuschen Boss", true)
    AP()
    ASP("Ari","Ari","Der Bürgermeister von Winkelhain sollte das übernehmen. Er hat dann zwar mehr zu tun, aber er hat die Nötige Erfahrung zum regieren.", true)
    

    briefing.finished = function ()
        if GetSelectedBriefingMCButton( choicePage ) == 1 then
            GDB.SetString("mayorSturmbach","Schwarz")
        else
            GDB.SetString("mayorSturmbach","Winkelhain")
        end
        Victory()
        Logic.SetQuestType(1, 7, MAINQUEST_CLOSED, 0)
    end
    StartBriefing(briefing);

end

function BriefingVictoryNoReeinf()
    local briefing = {};
    local AP,ASP = AddPages(briefing);

    ASP("Ari","Ari","Die Situation sah recht übel aus, durchzupreschen war nicht gerade einfach.", true)
    ASP("Schwarz","Schwarz", "Ari, ich habe beunruhigende Neuigkeiten. In der Abtei fanden meine Leute Zeichen die an Rituale erinnern, auf dem Boden mit Blut gezeichnet. @cr Außerdem diese Schriften ...", true)
    ASP("Ari","Ari","...Schriften? Was steht in diesen Schriften?", true)
    ASP("Schwarz","Schwarz","Sorry, ich kann nicht lesen.", true)
    ASP("Ari","Ari","Dann gib mal her.",true)
    ASP("Ari","Ari","Scheint in einer anderen Sprache zu sein. Wir sollten die Schriften wohl einmal analysieren lassen.", true)
    ASP("Schwarz","Schwarz","Dann sollten wir wohl nach Mercius. In solchen Hintlerwälterdörfern wie hier wird wohl kaum wer Sprachgelehrter sein.", true)
    ASP("Ari","Ari","Stimmt, dann lass uns sofort aufbrechen",true)
    ASP("Schwarz","Schwarz","Alles klar, Boss.",true)
    local choicePage = AP{
		mc 	 = { 
			title	= "Ari", 
			text 	= "Außerdem muss ich mich noch für einen Nachfolger für Sturmbach kümmern. Wer wäre dafür nur geeignet?",
			firstText   = "Schwarz (Sturmbach wird sich auf sein Militär konzentrieren. Schwarz wird Euch nicht weiter begleiten)",
			secondText  = "Winkelhains Bürgermeister (Sturmbach wird sich auf Gewinnung von Ressourcen konzentrieren)",
			firstSelected  = 15, 
			secondSelected = 18,
		},
		dialogCamera	=	true,
	}
    ASP("Ari","Ari","Schwarz, du bleibst hier und kümmerst dich Sturmbach. Ich brauche starke Verbündete sollte die Situation schlimmer werden.", true)
    ASP("Schwarz","Schwarz","Ich? Ich kann nicht behaupten, dass ich sowas je getan habe, aber ich werde dich nicht enttäuschen Boss", true)
    AP()
    ASP("Ari","Ari","Der Bürgermeister von Winkelhain sollte das übernehmen. Er hat dann zwar mehr zu tun, aber er hat die Nötige Erfahrung zum regieren.", true)
    

    briefing.finished = function ()
        if GetSelectedBriefingMCButton( choicePage ) == 1 then
            GDB.SetString("mayorSturmbach","Schwarz")
        else
            GDB.SetString("mayorSturmbach","Winkelhain")
        end
        Victory()
        Logic.SetQuestType(1, 7, MAINQUEST_CLOSED, 0)
    end
    StartBriefing(briefing);

end

function BriefingVictoryNoAllies()
    local briefing = {};
    local AP,ASP = AddPages(briefing);

    ASP("Ari","Ari","Die Situation sah recht übel aus, gut dass Rudger es geschafft hat.", true)
    ASP("Rudger","Rudger","War etwas anderes zu erwarten? Wenn Ruhm eine Währung wäre, wäre ich jetzt der reichste Mann des Reiches!", true)
    ASP("Schwarz","Schwarz", "Alles klar, Mund zu, du Nervensäge. Sonst schick ich dich zurück durch das Gebirge - zu Fuß.", true)
    ASP("Pilgrim","Pilgrim","Ich war nur zufällig in Mercius, um ein paar Steine aus meiner Mine in Barmecia zu verkaufen, da kam Euer Bote angeritten. @cr Den Spaß konnte ich mir nicht entgehen lassen.", true)
    ASP("Schwarz","Schwarz", "Könnten wir uns vielleicht erstmal auf das Wichtige konzentrieren? Über die Schlacht austoben könnt ihr euch beide gleich in der Taverne. @cr Ari ich habe beunruhigende Neuigkeiten. In der Abtei fanden meine Leute Zeichen die an Rituale erinnern, auf dem Boden mit Blut gezeichnet. @cr Außerdem diese Schriften ...", true)
    ASP("Ari","Ari","...Schriften? Was steht in diesen Schriften?", true)
    ASP("Schwarz","Schwarz","Sorry, ich kann nicht lesen.", true)
    ASP("Ari","Ari","Dann gib mal her.",true)
    ASP("Ari","Ari","Scheint in einer anderen Sprache zu sein. Wir sollten die Schriften wohl einmal analysieren lassen.", true)
    ASP("Pilgrim","Pilgrim","Dann sollten wir zurück nach Mercius. Hier wird wohl kaum ein Sprachgelehrter sein.", true)
    ASP("Ari","Ari","Stimmt, dann lass uns sofort aufbrechen",true)
    ASP("Pilgrim","Pilgrim","Und den Ausflug in eine örtliche Taverne verpassen? Können wir nicht besser morgen los - mit weniger Feinden und mehr Bier?", true)
    ASP("Ari","Ari","Du denkst auch immer nur ans Saufen, Pilgrim… aber du hast Recht. Eine kleine Auszeit haben wir uns redlich verdient.", true)
    ASP("Ari","Ari","Dass wir Sturmbach nicht als Verbündeten gewinnen können ist Schade, aber wir haben gerade andere Prioritäten. Lasst uns ausruhen und danach schnell nach Mercius!", true)
    

    briefing.finished = function ()
        GDB.SetString("mayorSturmbach","none")
        Victory()
        Logic.SetQuestType(1, 7, MAINQUEST_CLOSED, 0)
    end
    StartBriefing(briefing);

end

function BriefingVictoryNoHelp()
    local briefing = {};
    local AP,ASP = AddPages(briefing);

    ASP("Ari","Ari","Die Situation sah recht übel aus, durchzupreschen war nicht gerade einfach.", true)
    ASP("Schwarz","Schwarz", "Ari, ich habe beunruhigende Neuigkeiten. In der Abtei fanden meine Leute Zeichen die an Rituale erinnern, auf dem Boden mit Blut gezeichnet. @cr Außerdem diese Schriften ...", true)
    ASP("Ari","Ari","...Schriften? Was steht in diesen Schriften?", true)
    ASP("Schwarz","Schwarz","Sorry, ich kann nicht lesen.", true)
    ASP("Ari","Ari","Dann gib mal her.",true)
    ASP("Ari","Ari","Scheint in einer anderen Sprache zu sein. Wir sollten die Schriften wohl einmal analysieren lassen.", true)
    ASP("Schwarz","Schwarz","Dann sollten wir wohl nach Mercius. In solchen Hintlerwälterdörfern wie hier wird wohl kaum wer Sprachgelehrter sein.", true)
    ASP("Ari","Ari","Stimmt, dann lass uns sofort aufbrechen",true)
    ASP("Schwarz","Schwarz","Alles klar, Boss.",true)
    ASP("Ari","Ari","Dass wir Sturmbach nicht als Verbündeten gewinnen können ist Schade, aber wir haben gerade andere Prioritäten. Lasst uns schnell nach Mercius!", true)
    

    briefing.finished = function ()
        GDB.SetString("mayorSturmbach","none")
        Victory()
        Logic.SetQuestType(1, 7, MAINQUEST_CLOSED, 0)
    end
    

    briefing.finished = function ()
        if GetSelectedBriefingMCButton( choicePage ) == 1 then
            GDB.SetString("mayorSturmbach","Schwarz")
        else
            GDB.SetString("mayorSturmbach","Winkelhain")
        end
        Victory()
        Logic.SetQuestType(1, 7, MAINQUEST_CLOSED, 0)
    end
    StartBriefing(briefing);

end

--Side Quests--

function BriefingVillagerWinkelhain(_villager)
    local briefing = {};
    local AP, ASP = AddPages(briefing);
    local name = "villager" .. _villager

    if _villager == 1 then
        ASP(name,"Holzfäller Dietrich","Hach, schwere Zeiten sind über uns.",true)
        ASP(name,"Holzfäller Dietrich","Ich arbeite hier schon mein ganzes Leben als einfacher Holzfäller und in all den Jahren habe ich hier nicht so viel Trouble mitbekommen wie in den letzten Wochen. @cr Bei den ganzen Kämpfen traut man sich gar nicht mehr zu tief in den Wald, wer weiß, ob man dort auf die falsche Seite einer Klinge landet.",true)
        ASP(name,"Holzfäller Dietrich","Immerhin lebe ich nicht auf der anderen Seite des Dorfes. Dort wurden einige meiner Freunde vollkommen verstümmelt aufgefunden... @cr Ich habe eh nicht mehr lange zu Leben, Ihr aber schon. @cr Bitte passt auf, wenn Ihr die Wälder durchstreift, gerade in der Nacht wird es dort sehr gefährlich.",true)
    elseif _villager == 2 then
        ASP(name,"*Der Maulwurf*","Tag, man nennt mich den Maulwurf!",true)
        ASP(name,"*Der Maulwurf*","Warum fragt Ihr? @cr Ist doch klar, ich arbeite den ganzen Tag in der Mine und gehe abends auch nur in mein kleines Kellergeschoss im nächsten Wohnhaus.", true)
        ASP(name,"*Der Maulwurf*","Aber wenn man den ganzen Tag in der Mine verbringt, dann sieht man auch Sachen, die man lieber nicht gesehen hätte.", true)
        ASP(name,"*Der Maulwurf*","Gerade heute morgen stieß ich als ich den Minenschacht erweiterte auf ein Höhlensystem. @cr Erst dachte ich, ich hätte im Lotto gewonnen, doch dann kam es anders...", true)
        ASP(name,"*Der Maulwurf*","Ich schaute mich mit einer Fackel um und die Höhle schien schon komplett seiner Ressourcen beraubt und dazu stank es gewaltig. @cr Und glaubt mir, das roch nicht wie Lehm, den Geruch kenne ich in und auswendig.", true)
        ASP(name,"*Der Maulwurf*","Nun gut, hab' mir nix dabei gedacht und bin tiefer rein, da sehe ich etwas in der Ecke. @cr Es sah fast aus wie ein Mensch, aber war wie vom Nebel umhüllt.", true)
        ASP(name,"*Der Maulwurf*","Lange Geschichte, kurzer Sinn: @cr Ich bin gerannt und das nicht gerade langsam. @cr @cr Bin dann direkt durchs Dorf, aber keiner wollte mir glauben.", true)
        ASP(name,"*Der Maulwurf*","Ich hab also keine andere Möglichkeit als runter da, denen werd ichs zeigen. @cr Wenn ich wiederkomme dann werden alle Augen machen. @cr Ich mach mich auf, wir sprechen uns dann nachher nochmal!", true)
    elseif _villager == 3 then
        ASP(name,"Kunibert Großlinse","Lady Ari, auf ein Wort?",true)
        ASP(name,"Kunibert Großlinse","Im Südosten befindet sich eine Insel mit einer alten Dorfhalle. @cr Die Brücke zu ebenjener ging jedoch in einer schweren Regenperiode vor einigen Jahren kaputt.",true)
        ASP("Ari","Ari","*Eine schwere Regenperiode? @cr Damit meint er hoffentlich nicht die Überflutung die wir auf Cleycourt losließen.* @cr Danke für die Information ich werde schauen ob sich da etwas machen lässt.",true)
    else
        ASP(name,"Baumeister Bernhard","Wer lässt immer wieder solche Spinner in dieses Dorf?!",true)
        ASP(name,"Baumeister Bernhard","Da geht man einmal durch die Stadt und so ein Vogel hält mir eine geladene Waffe an den Kopf! @cr Meinte etwas von: *Ich bin auf Geisterjagd und folge einer heißen Spur.* @cr Von wegen. Eine verpasst hab ich dem, solch eine Frechheit!",true)
        ASP(name,"Baumeister Bernhard","Was für geistige Kleingärtner lässt der Bürgermeister hier überhaupt in der Stadt rumlaufen? Aufhängen sollte man den!",true)
    end
    StartBriefing(briefing);
end

function BriefingShagsworth()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Shagsworth","?","Die Königin höchstselbst, endlich mal eine vertrauenswürdige Person. @cr @cr Meine Nachforschungen haben mich in dieses kleine Dörfchen verschlagen und ich bin mir sicher, wir werden hier einen Durchbruch in der Forschung erleben.",true)
    ASP("Ari","Ari","Erstmal ganz ruhig, wer seid Ihr überhaupt?",true)
    ASP("Shagsworth","Shagsworth","Tut mir leid natürlich kennt Ihr mich nicht. @cr Mein Name ist Shagsworth, ich bin der königliche Forscher für Paranormales und das Übernatürliche. @cr Und das ist mein Partner Scoob.", true)
    ASP("Scoob","Scoob","Wuff",true)
    ASP("Ari","Ari","Ich weiß nicht was Dario für Leute anheuert, aber Forscher für das Übernatürliche klingt wie ein Geisterjäger. Wollt Ihr mich auf den Arm nehmen?",true)
    ASP("Shagsworth","Shagsworth","Liebend gern! ... Oh warte nein so war das nicht gemeint. @cr Es ist wahr wir sind Geisterjäger, aber glaubt mir unsere Forschung wird essentiell für die Zukunft des Reiches! Wenn Ihr mich entschuldigen würdet: Wir gehen gerade einer Spur nach.",true)

    StartBriefing(briefing);
end

function BriefingVillagerMaulwurfUpdate()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Will","Landarbeiter Will","... und dann fand ich ihn da unten tot mit mehreren Stichverletzungen",true)
    ASP("Shagsworth","Shagsworth","Wir kommen zu spät, verdammt! @cr Sag den anderen Minenarbeitern, sie sollen den Tunnel verschütten. @cr @cr ... Königin Ari was macht Ihr hier?",true)
    ASP("Ari","Ari","Ich suche nach Euch, Eure Talente sind vielleicht doch nicht so sinnlos wie ich angenommen habe.", true)
    ASP("Shagsworth","Shagsworth", "Eine überraschende Wendung, wie kommt der Sinneswandel?", true)
    ASP("Ari","Ari","Eben an der Front, sie kamen aus dem Südwesten. @cr Das Nebelvolk und für Euch vielleicht wichtiger an ihrer Seite waren schimmernde Krieger die Geistern aus den Geschichten recht ähnlich kamen. @cr Ich möchte, dass ihr Euch dem Problem widmet.", true)
    ASP("Shagsworth","Shagsworth","Jaja macht euch ruhig über mich lust ... @cr Wartet was?! @cr Geisterkrieger? Alles klar ich werde Euch so gut es geht helfen, trefft mich an meinem Lager, es ist im Wald im Norden von hier.",true)

    briefing.finished = function ()
        StartSimpleJob("moveShagsworthCamp")
    end

    StartBriefing(briefing)
end

function BriefingShagsworthQuest()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Ari","Ari","Da bin ich, was kann ich für Euch tun?",true)
    ASP("ghostPrison","Shagsworth", "Eigentlich nichts Großes. @cr Ich möchte nur, dass Ihr einen der Geisterkrieger hier in den Käfig lockt.",true)
    ASP("Ari","Ari","Alles klar, sonst noch Wünsche?",true)
    ASP("Shagsworth","Shagsworth","Etwas Geld wäre auch nicht schlecht, damit ich mir neue Arbeitsutensilien ...",true)
    ASP("Ari","Ari","Das war sarkastisch. Gut ich werde dir dein Versuchsobjekt holen. Warte hier.",true)
    ASP("ghostPrison","Missionsbeschreibung","Lockt einen Geistertrupp in das Gefängnis!", false)

    briefing.finished = function ()
        StartSimpleJob("checkForPrisonGhost")
    end

    StartBriefing(briefing)
end

function BriefingGhostImprisoned()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Shagsworth","Shagsworth", "Wunderbar, endlich kann ich meine Forschung beginnen. Ich danke Euch! Es wird jedoch etwas dauern bis ich zu Erkenntnissen komme.",true)
    ASP("Ari","Ari","Wie lange in etwa? Ich werde nach der Mission hier weiterziehen.",true)
    ASP("Shagsworth","Shagsworth","Dann mögen sich unsere Wege später erneut kreuzen, es könnte noch Tage bis Wochen dauern. @cr Ich kann euch aber einige Baupläne für Büchsenmacher geben, gegen das Nebelvolk könnt Ihr die sicher brauchen und gegen die Geister scheinen die immerhin auch recht effektiv zu sein.",true)
    ASP("Ari","Ari","Und damit rückst du erst jetzt raus? Na gut, besser spät als nie.",true)

    briefing.finished = function ()
        ResearchTechnology(Technologies.GT_Matchlock,1)
        GDB.SetString("Shagsworthquest","1")
    end

    StartBriefing(briefing)
end

function BriefingArenaRumor()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Ari",
        text = "Schwarz, wir brauchen Leute, die mehr können als nur dumm rumstehen. Wie steht es um unsere Bande?",
        position = GetPosition("Ari")
    }
    local page2 = AP {
        title = "Schwarz",
        text = "Leider mies, Boss. Außer mir und einer Handvoll haben alle die Zelte abgerissen. Zusammenhalt ist wohl aus der Mode.",
        position = GetPosition("Schwarz")
    }
    local page3 = AP {
        title = "Schwarz",
        text = "Ein paar ehemalige Bandenmitglieder haben sich hier in der Nähe niedergelassen und betreiben jetzt eine illegale Arenakämpfe. Mit was man so alles Geld verdienen kann...",
        position = GetPosition("arenaTent")
    }
    local page4 = AP {
        title = "Ari",
        text = "Wer kann’s ihnen verdenken. Ich spiele inzwischen die Ehrliche. Danke, dass du nicht auch zur Jahrmarktsattraktion wurdest.",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "Schwarz",
        text = "(räuspert sich) Selbstverständlich, Boss. Lass uns die Arena aus nächster Nähe ansehen - vielleicht schließen siche ein paar Banditen wieder an.",
        position = GetPosition("Schwarz"),
    }
    
    briefing.finished = function ()
        local NPC = {
            name = "Regar",
            heroName = "Ari",
            callback = BriefingArena
        }
        CreateNPC(NPC)
        Explore.Show("ShowArena", "arenaTent", 2000)
    end

    StartBriefing(briefing)
end

function BriefingArena()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Regar",
        text = "Ari! Lange nicht gesehen. Bereit, dein adeliges Dasein gegen ehrliche Arenakämpfe zu tauschen?",
        position = GetPosition("Regar")
    }
    local page2 = AP {
        title = "Ari",
        text = "Ich brauche Truppen, keine Schaukämpfe. Wenn ich mir eure Zirkusnummern anschaue, frage ich mich, ob ihr noch wisst, wie echte Schläge klingen.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Regar",
        text = "Dein Mundwerk ist spitzer als deine Pfeile, was? Die Zeit in Burgen hat dir den Biss nicht genommen.",
        position = GetPosition("Regar")
    }
    local page4 = AP {
        title = "Schwarz",
        text = "Ich hab nicht vergessen, wie du uns verraten hast. Wir bezahlen dich trotzdem - sofern du diesmal nicht wieder rennst.",
        position = GetPosition("Schwarz")
    }
    local choicePage = AP {
        mc = {
            title = "Regar",
            text = "Wir verdienen hier gut, aber es geht nichts über einen guten Kampf. Schwarz und du können mir in der Arena beweisen, dass ihr auch nicht an Können nachgelassen habt. Wenn ihr gegen meine Leute gewinnt, helfen wir euch.",
            position = GetPosition("Regar"),
            firstText = "Ihr habt doch eh keine Chance gegen uns Beide.",
            secondText = "Ich hab keine Zeit für deine albernen Kämpfe.",
            firstSelected = 6,
            secondSelected = 8
        }
    }
    local page6 = AP {
        title = "Regar",
        text = "Ich wusste ihr seid keine Langweiler, auf in die Arena mit euch!",
        position = GetPosition("Regar"),
    }
    local page7 = AP()
    local page8 = AP {
        title = "Regar",
        text = "Keine Unterhaltung, keine Unterstützung. Kommt wieder wenn ihr euch umentscheidet.",
        position = GetPosition("Regar"),
    }
    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
				createArenaFighter(1)
			else 
				local NPC = {
                    name = "Regar",
                    heroName = "Ari",
                    callback = BriefingReArena
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingReArena()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Regar",
            text = "Und jetzt bereit für den Kampf aller Kämpfe?",
            position = GetPosition("Regar"),
            firstText = "Ihr habt doch eh keine Chance gegen uns Beide.",
            secondText = "Ich hab keine Zeit für deine albernen Kämpfe.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Regar",
        text = "Ich wusste ihr seid keine Langweiler, auf in die Arena mit euch!",
        position = GetPosition("Regar"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Regar",
        text = "Keine Unterhaltung, keine Unterstützung. Kommt wieder wenn ihr euch umentscheidet.",
        position = GetPosition("Regar"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
				createArenaFighter(1)
			else 
				local NPC = {
                    name = "Regar",
                    heroName = "Ari",
                    callback = BriefingReArena
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingArenaWon1()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Regar",
        text = "Da habt ihr ja mal gezeigt was in euch Beiden steckt. Ich bin beeindruckt.",
        position = GetPosition("Regar")
    }
    local page2 = AP {
        title = "Schwarz",
        text = "Und du hast dich nicht mal selbst in den Ring getraut. Wirst du alt oder nur bequem?",
        position = GetPosition("Schwarz")
    }
    local page3 =  AP {
        title = "Regar",
        text = "Frech wie immer. Dann zeig ich dir persönlich, wo der Haken hängt. Ab in die Arena mit uns!",
        position = GetPosition("Regar")
    }
    local page4 = AP {
        title = "Ari",
        text = "Jetzt beruhigt euch beide mal. Regar wie steht es mit unserer Abmachung?",
        position = GetPosition("Ari")
    }
    local page5 = AP {
        title = "Regar",
        text = "Schon gut, wir helfen euch. Aber das vergesse ich nicht. Kommt wieder, wenn ihr euch traut - meine Dorfhalle setze ich darauf, dass ihr mich nicht schlagt.",
        position = GetPosition("VillageHallBandits")
    }
    local page6 = AP {
        title = "Schwarz",
        text = "Der hat Nerven. Die Dorfhalle holen wir uns mit links.",
        position = GetPosition("Schwarz")
    }

    briefing.finished = function()
		arena1Won()
	end
    StartBriefing(briefing)
end

function BriefingArenaLoss1()
    local briefing = {};
    local AP = AddPages(briefing);
    
    local page1 = AP {
        title = "Regar",
        text = "Schade, da habe ich mehr von euch erwartet. Versucht es gerne erneut",
        position = GetPosition("Regar")
    }

    briefing.finished = function()
        local NPC = {
            name = "Regar",
            heroName = "Ari",
            callback = BriefingReArena
        }
        CreateNPC(NPC)
    end
end

function BriefingArena2()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Regar",
        text = "Und doch noch Lust bekommen auf eine zweite Runde?",
        position = GetPosition("Regar")
    }
    local page2 = AP {
        title = "Ari",
        text = "Ich kann nicht sagen, dass ich mich besonders darauf freue, aber die Dorfhalle wäre schon recht praktisch.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Schwarz",
        text = "Du wirst schon sehen, du hast dich mit den Falschen angelegt, alter Mann. Der Boss und ich sind unschlagbar.",
        position = GetPosition("Schwarz")
    }
    local choicePage = AP {
        mc = {
            title = "Regar",
            text = "Ich mag zwar alt sein, aber euch verhaue ich noch mit links! Kanns losgehen 'Boss'?",
            position = GetPosition("Regar"),
            firstText = "Macht euch bereit, wir legen los",
            secondText = "Später, wir haben noch Wichtigeres zutun",
            firstSelected = 5,
            secondSelected = 7
        }
    }
    local page5 = AP {
        title = "Regar",
        text = "Dann auf einen guten Kampf!",
        position = GetPosition("Regar"),
    }
    local page6 = AP()
    local page7 = AP {
        title = "Reagar",
        text = "Im letzen Moment doch noch die Fliege machen, ich bin enttäuscht.",
        position = GetPosition("Regar"),
    }
    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
			    createArenaFighter(2)
			else 
				local NPC = {
                    name = "Regar",
                    heroName = "Ari",
                    callback = BriefingReArena2
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingReArena2()
    local briefing = {};
    local AP = AddPages(briefing);

    local choicePage = AP {
        mc = {
            title = "Regar",
            text = "Habt ihr euch wieder gefasst und seid bereit?",
            position = GetPosition("Regar"),
            firstText = "Wir waren nie aufgewärmter",
            secondText = "Nein, wir brauchen noch Zeit.",
            firstSelected = 2,
            secondSelected = 4
        }
    }
    local page2 = AP {
        title = "Regar",
        text = "Dann auf einen guten Kampf!",
        position = GetPosition("Regar"),
    }
    local page3 = AP()
    local page4 = AP {
        title = "Regar",
        text = "Kommt wieder wenn ihr euch umentscheidet.",
        position = GetPosition("Regar"),
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
                createArenaFighter(2)
			else 
				local NPC = {
                    name = "Regar",
                    heroName = "Ari",
                    callback = BriefingReArena2
                }
                CreateNPC(NPC)
			end
		end
    StartBriefing(briefing)
end

function BriefingArenaWon2()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Regar",
        text = "Ihr habt mich geschlagen - und das spüre ich noch morgen. Respekt.",
        position = GetPosition("Regar")
    }
    local page2 = AP {
        title = "Schwarz",
        text = "Hab ich zu viel versprochen? Also her mit der Dorfhalle.",
        position = GetPosition("Schwarz")
    }
    local page3 =  AP {
        title = "Regar",
        text = "Schon gut, ihr habt sie euch verdient. Ari, wenn du uns brauchst, sag Bescheid - du bist immer noch unser Boss.",
        position = GetPosition("Regar")
    }
    local page4 = AP {
        title = "Schwarz",
        text = "*Nach einer Tracht Prügel macht der wieder auf loyal?! Aus dem Vollidioten werd ich nicht schlau.*",
        position = GetPosition("Schwarz")
    }

    briefing.finished = function()
		arena2Won()
	end
    StartBriefing(briefing)
end

function BriefingArenaLoss2()
    local briefing = {};
    local AP = AddPages(briefing);
    
    local page1 = AP {
        title = "Regar",
        text = "Seht ihr, ihr Grünschnäbel könnt mir nichts.",
        position = GetPosition("Regar")
    }
    local page2 = AP {
        title = "Schwarz",
        text = "Du hattest nur Glück, nächstes Mal gewinnen wir!",
        position = GetPosition("Schwarz")
    }
    local page3 = AP {
        title = "Regar",
        text = "Heilt erstmal eure Wunden. Danach reden wir weiter.",
        position = GetPosition("Regar")
    }

    briefing.finished = function()
        local NPC = {
            name = "Regar",
            heroName = "Ari",
            callback = BriefingReArena2
        }
        CreateNPC(NPC)
    end
    StartBriefing(briefing)
end

function BriefingMiner()
    local briefing = {};
    local AP,ASP = AddPages(briefing);

    ASP("miner","Minenarbeiter","Alles Mist. Meine Jungs und ich können nicht arbeiten und das frustiert derbst.", true)
    ASP("Ari","Ari","Ich wäre bereit zu helfen, falls die Belohnung stimmt. Was gibt es?",true)
    ASP("claypit","Minenarbeiter","Unsere Minenanlage wurde in den Kämpfen zerstört und weil der Bürgermeister beschäftigt ist bekommen wir sie weder abgerissen, noch neugebaut. @cr Baut sie wieder auf damit wir endlich wieder was zu tun haben.")
    
    briefing.finished = function()
        QuestMine = {
            Player = 1,
            AreaPos = "claypit",
            AreaSize = 4000,
            EntityTypes = {
                {Entities.PB_ClayMine1, 1},
            },
            Callback = BriefingMinerFinished
        }
     
        SetupEstablish(QuestMine)
    end
    StartBriefing(briefing)
end

function BriefingMinerFinished()
    local briefing = {};
    local AP,ASP = AddPages(briefing);

    ASP("miner","Minenarbeiter","Vielen Dank jetzt gehts endlich wieder an die Arbeit! @cr Zum Dank gibts ein paar Pfeile die ich hier neben der Ruine gefunden habe", true)
    ASP("Ari","Ari","Pfeile?! Im Ernst? Obwohl ... das sind ziemlich Gute, die sollten wir auch herstellen können.", true)

    briefing.finished = function()
        local PosX,PosY = Tools.GetPosition("claypit")
	    local _number, _id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_ClayMine1, PosX, PosY, 4000, 1)

	    ChangePlayer(_id, 2)
        ResearchTechnology(Technologies.T_Fletching,1)
    end
    StartBriefing(briefing)
end

function BriefingMercTower()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Turmarchitekt",
        text = "Gehört Ihr nicht zu den Banditen? Ein beachtlicher Turm, den Ihr da habt - fast schon Kunst!",
        position = GetPosition("banditTower")
    }
    local page2 = AP {
        title = "Ari",
        text = "Ich habe den nicht gebaut. Und so beachtlich ist er auch nicht.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Turmarchitekt",
        text = "Ihr erkennt die architektonische Meisterleistung nicht. Die Linien, die Symmetrie - pure Poesie in Stein!",
        position = GetPosition("towerBuilder")
    }
    local choicePage = AP {
        mc = {
            title = "Turmarchitekt",
            text = "Wie wärs, ich bekomme Euren Turm und dafür geben ich Euch meine Pläne noch mehr von denen Bauen zu können.",
            firstText = "Ich denke die Pläne sind wertvoller. Ich nehme das Angebot an.",
            secondText = "Einen Turm gegen einen Plan? Klingt nicht wirklich fair.",
            firstSelected = 5,
            secondSelected = 7
        }
    }
    local page5 = AP {
        title = "Turmarchitekt",
        text = "Eine exzellente Entscheidung. Verbreitet diese wundervollen Türme in der Welt - sie braucht mehr Schönheit.",
        position = GetPosition("towerBuilder")
    }
    local page6 = AP ()
    local page7 = AP {
        title = "Turmarchitekt",
        text = "Sehr schade. Wenn Ihr euch besinnt, denkt an die Türme - sie warten darauf, geboren zu werden.",
        position = GetPosition("towerBuilder")
    }

    briefing.finished =
		function()
			if GetSelectedBriefingMCButton( choicePage ) == 1 then
				ChangePlayer("banditTower", 4)
                ResearchTechnology( Technologies.B_Mercenary, 1 )
			else 
				initMercTowerQuest()
			end
		end
    StartBriefing(briefing)
end

function BriefingSturmbachAggression()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "General Roderik",
        text = "Und wie sieht es aus mit dem Bürgermeister?",
        position = GetPosition("General")
    }
    local page2 = AP {
        title = "Ari",
        text = "Er hat eine tödliche Stichwunde mehr. Hängt es bitte nicht an die große Glocke. Zu viel Unruhe können wir gerade nicht gebrauchen.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "General Roderik",
        text = "Zu Befehl. Ihr habt jetzt das Kommando. Was sollen unsere Truppen tun?",
        position = GetPosition("General"),
    }
    local page4 = AP {
        title = "Ari",
        text = "Könnt ihr einen Gegenangriff zustandebringen? Der Bürgermeister von Winkelhain erzählte mir von einem Friedhof hinter feindlichen Linien. Wenn meine Vermutung stimmt, müssen wir den Toten einen Besuch abstatten.",
        position = GetPosition("Ari"),
    }
    local page5 = AP {
        title = "General Roderik",
        text = "Was wollt ihr da? Totengräber werden? Ist auch egal. Wir können gerade keine Großoffensive starten uns mangelt es an Holz für Pfeil und Bogen. 10.000 Einheiten wären genügend.",
        position = GetPosition("General")
    }
    local page6 = AP {
        title = "Ari",
        text = "Wer hätte das denn ahnen können, nachdem Ihr euren Holzlieferanten so nett behandelt habt. Na gut, ich werde das Holz auftreiben. Den Leuten aus Winkelhain wird das zwar nicht gefallen aber was solls.",
        position = GetPosition("Ari")
    }

    briefing.finished =
		function()
            setupWoodTribute()
            local NPC = {
                name = "woodWorker",
                heroName = "Ari",
                callback = BriefingWoodWorker
            }
            CreateNPC(NPC)
		end
    StartBriefing(briefing)
end

function BriefingWoodWorker()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Ari",
        text = "Wir brauchen 10.000 Einheiten Holz. Und das so schnell es geht",
        position = GetPosition("Ari")
    }
    local page2 = AP {
        title = "Holzarbeiter",
        text = "Ihr fallt direkt mit der Tür ins Haus. So viel Holz hätten wir, aber wofür genau?",
        position = GetPosition("woodWorker")
    }
    local page3 = AP{
        title = "Ari",
        text = "Nun ja, Sturmbach ist das Holz ausgegangen, nachdem sie euch angegriffen haben und jetzt brauchen sie welches um in die Offensive zu gehen.",
        position = GetPosition("Ari")
    }
    local page4 = AP{
        title = "Holzarbeiter",
        text = "Erst schlachten sie uns ab und jetzt stellen sie Forderungen? Wer sagt, dass sie das Holz nicht gegen uns einsetzen?",
        position = GetPosition("woodWorker")
    }
    local page5 = AP{
        title = "Ari",
        text = "Ich weiß, dass Eure Meinung von Sturmbach jetzt nicht mehr die Höchste ist. Aber wir brauchen jetzt deren Unterstützung. Sonst werden bald beide Dörfer in Schutt und Asche liegen.",
        position = GetPosition("Ari")
    }
    local page6 = AP{
        title = "Holzarbeiter",
        text = "Ihr habt ja Recht, ich habe mich übernommen. Mir mag es zwar nicht gefallen, aber wir müssen zusammenarbeiten. Ich werde euch die Holzlieferungen überlassen, sorgt für ihre Lieferung nach Sturmbach.",
        position = GetPosition("woodWorker")
    }

    briefing.finished = function ()
        AddWood(10000)
    end
    StartBriefing(briefing)
end

function BriefingWoodTribute()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "General Roderik",
        text = "Habt vielen Dank. Jetzt heizen wir es denen ordentlich ein Jungs.",
        position = GetPosition("General")
    }

    briefing.finished = function ()
        MapEditor_Armies[3].offensiveArmies.strength = 18
        Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 3)
        Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 3)
        Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 3)
        Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 3)
        ResearchTechnology(Technologies.GT_StandingArmy,1)
    end
    StartBriefing(briefing)
end

function BriefingIronMine()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Minenbesitzer",
        text = "Habt ihr gehört? Im ganzen Königreich taucht plötzlich Silber auf. Ein winziger Brocken soll mehr wert sein als meine ganze Mine!",
        position = GetPosition("MineOwner")
    }
    local page2 = AP {
        title = "Ari",
        text = "Silber reizt mich wenig. Würdet ihr tauschen, falls ich etwas davon hätte?",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Minenbesitzer",
        text = "Natürlich! Dann müsste ich nie wieder arbeiten. Nehmt die Anlage gleich mit, solange ihr Silber bringt.",
        position = GetPosition("MineOwner"),
    }

    briefing.finished =
		function()
            setupIronMineTribute()
		end
    StartBriefing(briefing)
end

function BriefingLighthouse()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Leuchtturmwärter",
        text = "Werte Dame, kann ich Euch um Hilfe bitten?",
        position = GetPosition("lighthouseNPC")
    }
    local page2 = AP {
        title = "Ari",
        text = "Kommt darauf an, ob etwas für mich dabei herausspringt.",
        position = GetPosition("Ari")
    }
    local page3 = AP {
        title = "Leuchtturmwärter",
        text = "Natürlich, in der jetzigen Lage kann das Lösen meines Problems sehr hilfreich sein. Auf einer Insel in der Nähe ist ein Goldvorkommen, bei dem gerade ein Minentrupp unterwegs ist. Momentan ist es aber zu gefährlich weiterzuarbeiten. Die Arbeiter sollten zurückkommen mit dem geborgenen Gold",
        position = GetPosition("lighthouseNPC")
    }
    local page4 = AP {
        title = "Leuchtturmwärter",
        text = "Das Problem: Der Leuchtturm ist kaputt, das letzte Schiff weg. Ich kann weder reparieren noch ein Signal entzünden. Bitte helft, ein Zeichen zu setzen, sonst finden die Arbeiter nie zurück.",
        position = GetPosition("lighthouse"),
    }

    briefing.finished = function ()
        ChangePlayer("lighthouse",6)
        StartSimpleJob("isLighthouseBurning")
    end

    StartBriefing(briefing);
end

function BriefingLighthouseSuccess()
    local briefing = {};
    local AP = AddPages(briefing);

    local page1 = AP {
        title = "Leuchtturmwärter",
        text = "Was tut Ihr da?! Mein schöner Leuchtturm… Nun, als Signal reicht es wohl. Eure Belohnung bekommt ihr, sobald die Arbeiter anlanden.",
        position = GetPosition("lighthouseNPC")
    }

    briefing.finished = function ()
        StartCountdown(300, getLighouseReward, false)
    end

    StartBriefing(briefing);
end