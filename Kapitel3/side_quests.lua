YUKISPOKEN = false
KARDINELSPOKEN = false
VARGSPOKEN = false

function initNPCs()
    CreateNPC {
        name = "Trader1",
        callback = BriefingTrader1,
    }
    CreateNPC {
        name = "Trader2",
        callback = BriefingTrader2,
    }
    CreateNPC {
        name = "Trader3",
        callback = BriefingTrader3,
    }
    CreateNPC {
        name = "Trader4",
        callback = BriefingTrader4,
    }
    CreateNPC {
        name = "Trader5",
        callback = BriefingTrader5,
    }
    CreateNPC {
        name = "Trader6",
        callback = BriefingTrader6,
    }
    CreateNPC {
        name = "monasteryguardian",
        callback = BriefingMonasteryGuardian,
    }
    CreateNPC {
        name = "Catapultmaker",
        callback = BriefingCatapultmaker,
    }
    CreateNPC {
        name = "TownFarmer",
        callback = BriefingTownFarmer,
    }
    if GDB.GetString("Shagsworthquest") == "1" then
        CreateMilitaryGroup(8, Entities.PU_LeaderRifle2, 0, GetPosition("ShagsworthSpawn"), "Shagsworth")
        CreateMilitaryGroup(8, Entities.CU_AggressiveDog1, 0, GetPosition("ScoobSpawn"), "Scoob")
        LookAt("Shagsworth","flowers")
        LookAt("Scoob","flowers")
        CreateNPC {
            name = "Shagsworth",
            callback = BriefingShagsworth,
        }
    end
    CreateNPC {
        name = "Smelter",
        callback = BriefingSmelter,
    }
    CreateNPC {
        name = "LighthouseKeeper",
        callback = BriefingLighthouse
    }
end

function Tribute1()
    AddTribute({
        playerId = 1,
        text = "Zahlt ".. Difficulty .."000 Taler für Luntenschloss!",
        cost = {Gold = 1000*Difficulty},
        Callback = function ()
            ResearchTechnology(Technologies.GT_Matchlock, 1 )
        end
    })
end

function Tribute2()
    AddTribute({
        playerId = 1,
        text = "Zahlt ".. Difficulty .."00 Silber für Pferdezucht!",
        cost = {Silver = 100*Difficulty},
        Callback = function ()
            ResearchTechnology(Technologies.GT_Strategies, 1 )
        end
    })
end

function Tribute3()
    AddTribute({
        playerId = 1,
        text = "Zahlt 1000 Taler für 2000 Eisen",
        cost = {Gold = 1000},
        Callback = function ()
            AddIron(2000)
        end
    })
end

function Tribute4()
    AddTribute({
        playerId = 1,
        text = "Zahlt 1000 Taler für 2000 Lehm",
        cost = {Gold = 1000},
        Callback = function ()
            AddClay(2000)
        end
    })
end

function Tribute5()
    AddTribute({
        playerId = 1,
        text = "Zahlt 1000 Taler für 2000 Holz",
        cost = {Gold = 1000},
        Callback = function ()
            AddWood(2000)
        end
    })
end

function Tribute6()
    AddTribute({
        playerId = 1,
        text = "Zahlt 1000 Taler für 2000 Stein",
        cost = {Gold = 1000},
        Callback = function ()
            AddStone(2000)
        end
    })
end

function TributeLighthouse()
    AddTribute({
        playerId = 1,
        text = "Gebt dem Leuchthauswärter 500 Kohle, um ein starkes Signal auszusenden.",
        cost = {Coal = 500},
        Callback = function ()
            Message("Leuchthauswärter: Das Feuer ist eintfacht. Mal schauen, was die uns schicken.")
            StartCountdown(600,reeinforcementsSturmbach,false)
        end
    })
end

function reeinforcementsSturmbach()
    local pos = GetPosition("reeinfSturmbach")
    if SCHWARZACTIVE == 1 then
        CreateMilitaryGroup(8, Entities.PU_Travelling_Salesman, 0, pos, "GoldCaravan" )
        CreateMilitaryGroup(8, Entities.PU_Travelling_Salesman, 0, pos, "IronCaravan" )
        CreateMilitaryGroup(8, Entities.PU_Travelling_Salesman, 0, pos, "WoodCaravan" )
        CreateMilitaryGroup(8, Entities.PU_Travelling_Salesman, 0, pos, "SulfurCaravan" )
        Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlCaravan", 1, {}, {"Gold"})
        StartCountdown(2, function ()
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlCaravan", 1, {}, {"Iron"})
        end,false)
        StartCountdown(4, function ()
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlCaravan", 1, {}, {"Wood"})
        end,false)
        StartCountdown(6, function ()
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlCaravan", 1, {}, {"Sulfur"})
        end,false)
    elseif GDB.GetString("mayorSturmbach") == "Schwarz" then
        AI.Entity_CreateFormation(1, Entities.PU_LeaderBow4, nil, 12, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
        AI.Entity_CreateFormation(1, Entities.PU_LeaderSword4, nil, 12, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
        AI.Entity_CreateFormation(1, Entities.PU_LeaderRifle2, nil, 8, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
        AI.Entity_CreateFormation(1, Entities.CU_VeteranMajor, nil, 2, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
    else
        AI.Entity_CreateFormation(1, Entities.PU_LeaderBow4, nil, 12, pos.X, pos.Y, pos.X*100, pos.Y*100, 3, 0)
    end
    Camera.ScrollSetLookAt(pos.X,pos.Y)
    Message("Hilfe aus Sturmbach ist eingetroffen!")
end

function controlCaravan(_res)
    if IsDead(_res .. "Caravan") then
        return true
    end
    if IsNear(_res .. "Caravan", "p1hq") then
        if _res == "Gold" then
            AddGold(600)
        elseif _res == "Iron" then
            AddIron(1000)
        elseif _res == "Wood" then
            AddWood(1000)
        else
            AddSulfur(600)
        end
        DestroyEntity(_res .. "Caravan")
        return true
    end
    Move(_res .. "Caravan", "p1hq")
end

function YukiLurkMission()
    if IsNear("Yuki","YukiMovePoint",200) then
        BriefingYukiLurkMission()
        return true
    end
    Move("Yuki","YukiMovePoint")
end

function moveYukiInLurkPos()
    if IsNear("Yuki","YukiLurkPos",200) then
        LookAt("Yuki","Monastery")
        StartSimpleJob("createSmoke")
        CreateNPC {
            name = "Yuki",
            callback = BriefingYukiLurking
        }
        return true
    end
    Move("Yuki","YukiLurkPos")
end

function createSmoke()
    if YUKISPOKEN == true then
        return true
    end
    if Counter.Tick2("createSmoke",2) then
        Logic.CreateEffect( GGL_Effects.FXBuildingSmoke, GetPosition("Yuki").X, GetPosition("Yuki").Y, 1 );
    end
end

function moveGuardianBack()
    if IsNear("monasteryguardian","monasteryguardianpos",200) then
        LookAt("monasteryguardian","gateinnerback")
        return true
    end
    Move("monasteryguardian","monasteryguardianpos")
end

function waitForVargQuest()
    if VARGSPOKEN == true then
        StartSimpleJob("moveShagsNorth")
        return true
    end
end

function moveShagsNorth()
    if IsNear("Shagsworth","VargGateKeeper",200) then
        LookAt("Shagsworth","VargGateKeeper")
        LookAt("VargGateKeeper","Shagsworth")
        CreateNPC {
            name = "Shagsworth",
            callback = BriefingShagsworthGate,
        }
        return true
    end
    Move("Shagsworth","VargGateKeeper")
    Move("Scoob","Shagsworth")
end

function necroSidequest()
    CreateMilitaryGroup(6,Entities.CU_Evil_Queen,0,GetPosition("bonepit"),"necrobone")
    StartSimpleJob("checkForNecroBone")
end

function checkForNecroBone()
    if AreEnemiesInArea(6, GetPosition("necrobone"),300) then
        UseNecroAbility("necrobone")
        Message("Torwächter: In was wurde ich hier wieder reingezerrt...")
        StartCountdown(2, createNecroBoneArmy, false)
        StartSimpleJob("checkForBonepit")
        return true
    end
end

function checkForNecroBonePit()
    if IsDead("ghostvargspawner1") and IsDead("ghostvargspawner2") and AreEnemiesInArea(1, "ghostvargspawn2",4500) == false then
        StartSimpleJob("moveShagsworthPit")
    end
end

function moveShagsworthPit()
    if IsNear("Shagsworth","ShagsworthPos",200) then
        LookAt("Shagsworth","ghostvargspawn2")
        LookAt("Scoob","ghostvargspawn2")
        CreateNPC {
            name = "Shagsworth",
            callback = BriefingShagsworthPit,
        }
        return true
    end
    Move("Shagsworth","ShagsworthPos")
    Move("Scoob","ScoobPos")
end