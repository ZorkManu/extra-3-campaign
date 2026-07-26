function BriefingStart()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Varg","Varg","Freunde! Die Zeit unserer Rache ist gekommen. @cr Nevassa diese Festungsstadt steht kurz vor ihrem Fall.", true)
    ASP("Varg","Varg","Folklung war ein Rückschlag. Ein kleiner. Ein… unglücklicher. @cr Aber jetzt zeigen wir dem Neuen Reich, dass Mauern uns nicht aufhalten!", true)
    ASP("Varg","Varg","He du! Hast du den Weg ausgekundschaftet?", true)
    ASP("sunkenbridge","Barbar A","Ja, hab ich. Zur Festungsstadt geht es über diesen Landstrich. Hier gab es Regenschauer, der Weg wurde geflutet. @cr Wir müssen warten, bis der Winter alles festfriert.", false)
    ASP("Varg","Varg","Natürlich warten wir. Ich *wollte* schon immer Geduld üben. @cr Dieser Region steht eine kurze Kälteperiode bevor. Dann schlagen wir schnell und heftig zu!", true)
    ASP("b2","Barbar B","Und womit? Wir haben kein Gold für Truppen. Wollen wir die Festung mit vier Mann und dem alten Greis da einnehmen?", true)
    ASP("exbarbarian","Alter Barbar","Das hab ich gehört! Ich bin zu alt, ja. Aber in eurem Alter hatte ich mehr Mumm als ihr vier zusammen.", true)
    ASP("Varg","Varg","Großes Maul für jemanden im Ruhestand. Aber keine Sorge. @cr Wir machen es so, wie Barbaren es am besten können.", true)
    ASP("b3", "Barbar C", "Plündern!", true)
    ASP("Varg","Varg","Siehst du? Der hier denkt schon mit.", true)
    ASP("mine3","Varg","Hier gibt es Gold- und Eisenminen. Bis der Winter kommt, füllen wir unsere Taschen und unsere Lager. @cr Wenn jemand fragt: Wir \"sichern\" nur Ressourcen.", false)
    ASP("Varg","Missionsbeschreibung","Baut eine Armee auf, bis der Winter startet. Tipp: Nutzt Vargs Fähigkeit um Gebäude zu plündern!", false)
    
    briefing.finished = function ()
        pillageMinesQuest()
        StartCountdown(1140 - Difficulty*60, BriefingWinter, true)
    end
    
    StartBriefing(briefing);
end

function BriefingWinter()
    StartWinter(90)
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Varg","Varg","Der See gefriert. Endlich ein Boden, der nicht nachgibt wie die Ausreden unserer Feinde.", true)
    ASP("Varg","Varg","Dieser Winter ist kurz – also keine Müdigkeit vortäuschen. @cr Auf in die Schlacht, Männer!", true)
    
    briefing.finished = function ()
        beginInvadeNevassa()
    end
    
    StartBriefing(briefing);
end

function BriefingDefenseNevassa()
    LookAt("Yuki", "Varg")
    LookAt("Varg", "Yuki")
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Yuki","Yuki","Hallo! @cr Ungebetene Besucher vor meinem Tor?", true)
    ASP("Varg","Varg","Aus dem Weg, Weib. Nevassa fällt heute. @cr Und ich lasse mir nicht noch einmal eine Stadt vor der Nase zuschlagen.", true)
    ASP("Yuki","Yuki","*lächelt* Oh, du bist ja richtig wütend. Das gefällt mir. @cr Aber durch dieses Tor kommst du nicht.", true)
    ASP("Varg","Varg","Die hat wohl ihren Verstand verloren. @cr Männer! Wir holen sie in die Realität zurück!", true)
    
    briefing.finished = function ()
        NEVASSA_REACHED = true
        StartCountdown(60, islandAttacker ,false)
        StartSimpleJob("controlYuki")
        StartSimpleJob("checkForDefenders")
    end
    
    StartBriefing(briefing);
end

function BriefingInvasionWon()
    LookAt("Yuki", "Varg")
    LookAt("Varg", "Yuki")
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Yuki","Yuki","*lächelt unverändert* Ich hab's mir anders überlegt. Ihr dürft doch rein.", true)
    ASP("Varg","Varg","Jetzt wohl doch nicht mehr so übermütig, was? Männer, fasst sie!", true)
    ASP("Yuki","Yuki","*lächelt noch breiter* Oh, nein nein. Das verschieben wir. @cr Ich habe noch ein paar Shuriken übrig und die würden so schön in euren Rücken passen.", true)
    ASP("Varg","Varg","Was...?", true)
    ASP("Yuki","Yuki","Wir treffen uns gleich in der Stadt. @cr Bitte beeilt euch, ja? *lächelt*", true)
    ASP("Varg","Varg","*Macht die mir etwa Angst? Nein... unmöglich.* @cr Beeilt euch? Wer denkt die, wer sie ist…", true)
    
    StartBriefing(briefing);
end

function BriefingEndTownFight()
    LookAt("Yuki", "Varg")
    LookAt("Varg", "Yuki")
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Yuki","Yuki","Das habt ihr toll gemacht! @cr Ich wusste doch, ich kann mich auf euch verlassen.", true)
    ASP("Varg","Varg","Verlass dich nicht zu früh. Wir sind keine Freunde. @cr Nur weil hier aggressive, durchsichtige Truppen herumlaufen, sind wir noch lange keine Verbündeten!", true)
    ASP("Yuki","Yuki","*lächelt* Doch. Zumindest solange du leben willst. @cr Diese \"Geister\" haben dir gerade den Rückzug abgeschnitten. Alleine kommst du hier nicht raus.", true)
    ASP("Varg","Varg","*Was zur Hölle ist bloß falsch mit der?!* @cr Woher wusstest du überhaupt von den Truppen hinter uns?", true)
    ASP("Yuki","Yuki","Betriebsgeheimnis.", true)
    ASP("Yuki","Yuki","Kommen wir zur Lage: Nevassa wird seit Längerem belagert. @cr Ihr kamt mir gerade recht starke Arme, schwache Diplomatie.", true)
    ASP("ghosthq1","Yuki","Im Westen ist ein Friedhof. Das erklärt die Geister: sie kommen regelmäßig \"zu Besuch\".", false)
    ASP("nventrance","Yuki","Im Osten hausiert das Nebelvolk. Keine Ahnung, wie die unsere Säuberung vor ein paar Jahren überlebt haben. @cr Sie sind noch schüchtern… aber das wird sich ändern.", false)
    ASP("Yuki","Yuki","Aktiv gegen das Nebelvolk vorzugehen, würde ich aufschieben. Ohne Schwefel und ohne Gewehre ist es einfach nicht dasselbe.", true)
    ASP("Varg","Varg","Pah! Gewehre. @cr Wer so etwas braucht, ist kein echter Krieger. Und dieses komische Feuerwerk…", true)
    ASP("Yuki","Yuki","Für echte Krieger waren die Hosen deiner Männer eben ziemlich voll. @cr Aber keine Sorge: Wenn das Nebelvolk die Schussrohre nur sieht, kippen sie reihenweise um. *lächelt*", true)
    ASP("sulfurBase","Yuki","Im Westen gibt es ein großes Schwefelvorkommen. Wir bauen dort ab, aber die Arbeiter halten nicht mehr lange durch. @cr *lächelt* Wie praktisch, dass ich hier tapfere Krieger gefunden habe, die sich des Problems annehmen.", false)
    ASP("Varg","Varg","Schon gut. Wir machen das. @cr Aber danach nehmen wir uns Nevassa und das nicht ohne Gewalt.", true)
    ASP("Yuki","Yuki","Sehr gut. @cr Und wenn du mich enttäuschst, dekorieren meine Shuriken eure prächtig glänzenden Glatzen.", true)
    ASP("Varg","Varg","*Mittlerweile macht die mir ein bisschen Angst.*", true)
    ASP("Varg","Missionsbeschreibung","Rettet die Schwefelarbeiter und verteidigt die Stadt. Passt aber auf, Ihr werdet schon bald angegriffen.", false)

    briefing.finished = function ()
        StartCountdown(300 + gvDiffLVL*20, initPlayerThreeAndFourSpawner, false)
        StartCountdown(450 + gvDiffLVL*20, initPlayerFiveSpawner, false)
    end
    
    StartBriefing(briefing);
end

function BriefingSulfurBase(_NpcDescription, _HeroId)
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local HeroName = GetEntityName(_HeroId)
    
    if HeroName == "Yuki" then
        ASP("Yuki","Yuki","Hallo! Geht es euch gut? @cr Bitte sagt ja – sonst muss ich mich noch ernsthaft sorgen.", true)
        ASP("alchemist","Verängstigter Aufseher","Kommandantin Yuki! Ich wusste doch, Ihr würdet uns retten kommen!", true)
        ASP("alchemist","Verängstigter Aufseher","Die Geisterkrieger belagern uns schon seit Tagen! Wir können nicht mehr lange durchhalten.", true)
        ASP("Yuki","Yuki","Die Geisterbasis haben wir bereits zerstört – die Belagerung sollte vorbei sein. @cr Aber das Nebelvolk wartet auch noch auf uns. *lächelt* @cr Ich übernehme hier – ich möchte sie kippen sehen.", true)
        ASP("alchemist","Verängstigter Aufseher","Das Nebelvolk auch noch…? Ich wusste nur von den Geistern...", true)
        ASP("monk","Verängstigter Aufseher","Ich hoffe, dem Kloster östlich der Stadt ist nichts zugestoßen.", false)
        ASP("Yuki","Yuki","Das Kloster? Stimmt. @cr Ich wüsste zu gern, was die zu unserem Geisterproblem sagen.", true)
        ASP("alchemistMove","Verängstigter Aufseher","Bevor ich es vergesse: Hinter dem Friedhof wurde Geröll aufgeschichtet. Wir könnten das für Euch sprengen.", false)
        ASP("Yuki","Yuki","Jemand versucht sich wohl vor uns zu verstecken. @cr Nach dem Kloster schaue ich mir das an.", true)
        ASP("Yuki","Missionsbeschreibung","Sucht das Kloster auf.", false)
    elseif HeroName == "Varg" then
        ASP("Varg","Varg","Ihr da! Lebt ihr noch oder muss ich euch erst wachrütteln?", true)
        ASP("alchemist","Verängstigter Aufseher","I-Ihr seid... ein Barbar! Was macht Ihr hier?!", true)
        ASP("Varg","Varg","Ich helfe. Frag nicht warum, es ist kompliziert. @cr Die Geisterbasis haben wir bereits zerstört – die Belagerung sollte vorbei sein.", true)
        ASP("alchemist","Verängstigter Aufseher","Die Geisterkrieger... sie sind wirklich weg? Wir dachten, wir würden hier sterben!", true)
        ASP("Varg","Varg","Ja, die sind erledigt. @cr Gut, ich übernehme hier. Gibt es noch andere Probleme?", true)
        ASP("alchemist","Verängstigter Aufseher","Wir sind gerettet! Ich verstehe zwar nicht, warum ein Barbar uns hilft, aber... danke.", true)
        ASP("monk","Verängstigter Aufseher","Ich hoffe, dem Kloster östlich der Stadt ist nichts zugestoßen.", false)
        ASP("Varg","Varg","Kloster? Was soll das sein?", true)
        ASP("alchemist","Verängstigter Aufseher","Ein Kloster... vielleicht wissen die etwas über diese Geister, die uns geplagt haben.", true)
        ASP("Varg","Varg","Jetzt wird's immer verrückter. @cr Aber gut, ich schaue mir das Kloster an.", true)
        ASP("alchemistMove","Verängstigter Aufseher","Bevor ich es vergesse: Hinter dem Friedhof wurde Geröll aufgeschichtet. Wir könnten das für Euch sprengen.", false)
        ASP("Varg","Varg","Jemand versteckt sich also? @cr Nach dem Kloster schaue ich mir das an.", true)
        ASP("Varg","Missionsbeschreibung","Sucht das Kloster auf.", false)
    end

    briefing.finished = function()
        churchQuest()
        Move("alchemist","alchemistMove")
        StartSimpleJob("checkAlchemistMove")
    end

    StartBriefing(briefing);
end

function BriefingAlchemist(_NpcDescription, _HeroId)
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    local HeroName = GetEntityName(_HeroId)
    
    if HeroName == "Yuki" then
        ASP("alchemist","Verängstigter Aufseher","Kommandantin Yuki! Ich habe etwas Wichtiges entdeckt.", true)
        ASP("alchemist","Verängstigter Aufseher","Hinter dem Friedhof liegt Geröll aus verfallenden Mauern und Ruinen. @cr Ich habe dort Menschen gesehen – Truppen, die sich dahinter verstecken.", true)
        ASP("Yuki","Yuki","Menschen hinter den Mauern? @cr Konntet Ihr erkennen, wer das ist?", true)
        ASP("alchemist","Verängstigter Aufseher","Ich konnte Wappen erkennen... sie sehen nicht nach königstreuen Truppen aus. @cr Die haben sich sehr vorsichtig bewegt, als würden sie nicht entdeckt werden wollen.", true)
        ASP("Yuki","Yuki","Feinde also. *lächelt* @cr Wer sich so versteckt, hat meist etwas zu verbergen.", true)
        ASP("alchemist","Verängstigter Aufseher","Mit 2000 Schwefel könnte ich das Geröll sprengen und den Weg freimachen. @cr Dann könnt Ihr sehen, was sich dahinter verbirgt.", true)
        ASP("Yuki","Yuki","Sehr gut. Beschaffen wir den Schwefel und statten wir denen mal einen Besuch ab", true)
    elseif HeroName == "Varg" then
        ASP("alchemist","Verängstigter Aufseher","Der Barbar... ich habe etwas Wichtiges entdeckt.", true)
        ASP("alchemist","Verängstigter Aufseher","Hinter dem Friedhof liegt Geröll aus verfallenden Mauern und Ruinen. @cr Ich habe dort Menschen gesehen – Truppen, die sich dahinter verstecken.", true)
        ASP("Varg","Varg","Truppen? Wer versteckt sich da?", true)
        ASP("alchemist","Verängstigter Aufseher","Ich konnte die Farbe ihrer Wappenröcke erkennen... sie waren pink. @cr Mehr weiß ich nicht.", true)
        ASP("Varg","Varg","Pinke Mäntel... das kenne ich. @cr Was machen die hier?", true)
        ASP("alchemist","Verängstigter Aufseher","Mit 2000 Schwefel könnte ich das Geröll sprengen und den Weg freimachen. @cr Dann könnt Ihr sehen, was sich dahinter verbirgt.", true)
        ASP("Varg","Varg","Gut. Wir beschaffen den Schwefel und du machst den Weg frei. @cr Ich will wissen, was die hier zu suchen haben.", true)
    end

    briefing.finished = function ()
        TributeEndgameBarrier()
    end

    StartBriefing(briefing)
end

function BriefingMonk()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("monk","Mönch","Ihr... ihr seid gekommen! Ich dachte, wir wären verloren.", true)
    ASP("Varg","Varg","Was ist hier passiert? Das Kloster sieht aus, als hätte ein Sturm durchgeblasen.", true)
    ASP("monk","Mönch","Vor einigen Wochen... Mary de Morfichet kam hierher. @cr Sie bat um Einlass, sprach von einer Pilgerreise. Wir ließen sie herein – welcher Fehler!", true)
    ASP("monk","Mönch","Sie führte ein Ritual durch, mitten in der Kirche. @cr Die Wände begannen zu bluten, die Symbole an den Wänden verfärbten sich schwarz...", true)
    ASP("Yuki","Yuki","*lächelt* Klingt nach einer interessanten Frau.", true)
    ASP("monk","Mönch","Sie entweihte die Kirche und riss ein Loch in die Welt – einen Riss zur Unterwelt! @cr Seitdem strömen Geister an die Oberfläche, Seelen, die es nicht in den Himmel geschafft haben. @cr Sie haben keinen eigenen Willen, werden nur von ihrer Verzweiflung getrieben.", true)
    ASP("monk","Mönch","Und das Nebelvolk... es wurde wiederbelebt. In fleischlicher Form, wie vor Jahren strömen sie erneut durch unser schönes Reich.", true)
    ASP("Yuki","Yuki","Diese Nebelkrieger, die wir gesehen haben... sie hatten eine dunkle Aura um sich. @cr Und als wir in ihre Nähe kamen, brach die Nacht ein – mitten am Tag.", true)
    ASP("monk","Mönch","Die Elite des Teufels... einzelne, die zu seinen mächtigsten Dienern wurden. @cr Ihre Aura ist tödlich für alle, die nicht in der Unterwelt gelebt haben. @cr Aber sie selbst... sie sind nur durch Rituale lenkbar.", true)
    ASP("Varg","Varg","Lenkbar durch Rituale? @cr Dann können wir doch selbst ein Ritual durchführen – und diese Aura gegen Mary verwenden!", true)
    ASP("monk","Mönch","N-Nein! Das ist Wahnsinn! @cr Solche Rituale sind verboten, sie öffnen Tore, die geschlossen bleiben sollten!", true)
    ASP("Yuki","Yuki","*lächelt* Und was ist mit dem Tor, das Mary bereits geöffnet hat? @cr Wir müssen mit ihren eigenen Waffen kämpfen.", true)
    ASP("Varg","Varg","Der Mönch hat recht – es ist gefährlich. @cr Aber wenn wir nichts tun, wird es nur schlimmer. Wir haben keine Wahl.", true)
    ASP("monk","Mönch","*seufzt* Ihr habt... recht. @cr Es gibt ein verbotenes Ritual, beschrieben in einem Buch in der Krypta des Klosters. @cr Aber ich warne euch: Das Ritual lockt das Nebelvolk magisch an. Sie werden alles tun, um es zu stoppen.", true)
    ASP("monk","Mönch","Ihr müsst gewappnet sein. @cr Das Kloster muss um jeden Preis beschützt werden, bis das Ritual beendet ist. @cr Wenn sie es unterbrechen... die Folgen wären katastrophal.", true)
    ASP("Yuki","Missionsbeschreibung","Führt das verbotene Ritual durch und verteidigt das Kloster gegen das Nebelvolk, bis das Ritual abgeschlossen ist.", true)

    briefing.finished = function ()
        monasteryDefense()
    end

    StartBriefing(briefing)
end

function BriefingDefenseSuccess()

end

--side_quests
function BriefingSmith()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Varg","Varg","Du siehst mir aus wie eine armseliger Bauer. Irgendwelche letzen Worte?", true)
    ASP("smith","Rüstungsschmied","So so wartet doch. I-Ich kann Euch nützlich sein. Ich war einmal Rüstungsschmied und habe mich hier zurückgezogen, aber ich kann die Rüstung Eurer Truppen verstärken.", true)
    ASP("Varg","Varg","Jetzt bin ich aber überrascht. Also los an die Arbeit, wenn es nützt verschone ich dich sogar.", true)
    ASP("smith","Rüstungsschmied","A-Alles klar, ich s-setzt mich gleich dran. Ich kann Eure Rüstung nur leicht verstärken, aber mit ".. 600*Difficulty .. " Eisen könnte ich noch mehr verstärken.", true)
    ASP("Varg","Varg",300*Difficulty .. "",true)
    ASP("smith","Rüstungsschmied","A-aber...", true)
    ASP("Varg","Varg","Du solltest dich besser anstrengen, wenn du leben willst.", true)

    briefing.finished = function ()
        ResearchTechnology(Technologies.T_LeatherMailArmor)
        smithTribute()
    end
    
    StartBriefing(briefing);
end

function BriefingSilverSmith()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("Varg","Varg","Eine Silberschmiede? Und dann auch noch unbeaufsichtigt. Die Schmiede von Nevassa wissen wohl nicht mit Silber umzugehen. Damit können wir sicher einiges anstellen.", true)

    briefing.finished = function ()
        ChangePlayer("silversmith",1)
        initSilverNPC()
    end
    
    StartBriefing(briefing);
end

function BriefingSilverNPC()
    local briefing = {};
    local AP, ASP = AddPages(briefing);

    ASP("exbarbarian","Alter Barbar","Varg, dass du zu mir kommst kann nur eins bedeuten!", true)
    ASP("Varg","Varg","Ja ich brauche Silber. Ich habe eine Silberschmiede gefunden und könnte etwas gebrauchen. Du weißt ja was das für eine Wirkung auf unsere Männer haben kann.", true)
    ASP("exbarbarian","Alter Barbar","Da habe ich das richtige Angebot für dich. " .. 5000*Difficulty .. " Gold wäre da doch angemessen.", true)
    ASP("Varg","Varg",5000*Difficulty .." ?! Du willst dir wohl einene goldene Rente finanzieren!", true)
    ASP("exbarbarian","Alter Barbar","Du weißt genau wie ich, was dieser Stoff wert ist. Plündere halt noch ein paar Dörfer oder so... Mein Angebot steht.", true)

    briefing.finished = function ()
        silverTribute()
    end
    
    StartBriefing(briefing);
end