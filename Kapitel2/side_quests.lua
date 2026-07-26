CURRENTNECROPOS = {}
ARMORQUESTSTARTED = false
KERBEROSUPGRADED = false
BANDITQUESTSTARTED = false

function initKerberosArmorSideQuest()
    StartSimpleJob("teleportInTower")
    StartSimpleJob("teleportOutTower")
end

function teleportInTower()
    if IsNear("Kerberos", "TowerEntrance", 200) then
        local teleportPosOut = GetPosition("NecroSp1")
        SetPosition("Kerberos", teleportPosOut)
        if ARMORQUESTSTARTED == false then
            StartSimpleJob("checkStatue")
        end
    end
    local FirstLeaderID = Logic.GetNextLeader(1, 0)
    local CurrentLeaderID = FirstLeaderID
    local tpKardinel = false
    repeat
        if CurrentLeaderID ~= 0 then
        if IsNear(CurrentLeaderID, "TowerEntrance", 200) then
            local teleportPosOut = GetPosition("NecroSp1")
                if CurrentLeaderID == GetEntityId("Kardinel") then
                    DestroyEntity(GetEntityId("Kardinel"))
                    DestroyEntity(GetEntityId("Feuerzahn"))
                    createKardinel("NecroSp1")
                    tpKardinel = true
                else
                    SetPosition(CurrentLeaderID, teleportPosOut)
                end
            end
        end
        if tpKardinel == false then
            CurrentLeaderID = Logic.GetNextLeader(1,CurrentLeaderID)
        else
            tpKardinel = false
        end
    until FirstLeaderID == CurrentLeaderID

    if ESCAPEDCASTLE or KERBEROSUPGRADED then
        return true
    end
end

function teleportOutTower()
    if IsNear("Kerberos", "TowerExit", 200) then
        local teleportPosOut = GetPosition("TowerEntranceBack")
        TeleportSettler(GetEntityId("Kerberos"), teleportPosOut.X,teleportPosOut.Y)
    end
    local FirstLeaderID = Logic.GetNextLeader(1, 0)
    local CurrentLeaderID = FirstLeaderID
    local tpKardinel = false
    repeat
        if CurrentLeaderID ~= 0 then
            if IsNear(CurrentLeaderID, "TowerExit", 200) then
            local teleportPosOut = GetPosition("TowerEntranceBack")
                if CurrentLeaderID == GetEntityId("Kardinel") then
                    TeleportSettler(GetEntityId("Kardinel"),teleportPosOut.X,teleportPosOut.Y)
                    TeleportSettler(GetEntityId("Feuerzahn"),teleportPosOut.X,teleportPosOut.Y)
                    tpKardinel = true
                else
                    TeleportSettler(CurrentLeaderID, teleportPosOut.X,teleportPosOut.Y)
                    CurrentLeaderID = Logic.GetNextLeader(1,CurrentLeaderID)
                end
            end
        end
        if tpKardinel == false then
            CurrentLeaderID = Logic.GetNextLeader(1,CurrentLeaderID)
        else
            tpKardinel = false
        end
    until FirstLeaderID == CurrentLeaderID

    if ESCAPEDCASTLE or KERBEROSUPGRADED and AreEntitiesInArea( 1, 0, GetPosition("KerberosMovePoint"), 4000, 1) == false then
        return true
    end
end

function checkStatue()
    if IsNear("Kerberos", "KerberosMovePoint",500) then
        BriefingArmor()
        return true
    end
end

function armorQuest()
    ChangePlayer("Kerberos",2)
    StartSimpleJob("moveKerberosToArmorStand")
    ARMORQUESTSTARTED = true
end

function moveKerberosToArmorStand()
    if IsNear("Kerberos", "KerberosMovePoint",200) then
        StartSimpleHiResJob("haltKerberos")
        StartCountdown(60,upgradeKerberos,true)
        for i = 1, Difficulty do
            CURRENTNECROPOS[i] = math.random(1,4)
            CreateMilitaryGroup(4, Entities.CU_Evil_Queen, 0, GetPosition("NecroSp" .. i), "Necro" .. i)
            Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlNecroArmorQuest" , 1, {}, {i})
        end
        return true
    end
    Move("Kerberos", "KerberosMovePoint")
end

function haltKerberos()
    if Counter.Tick2("moveKerberos", 60) then
        return true
    end
    Logic.GroupStand(GetEntityId("Kerberos"))
end

function controlNecroArmorQuest(_NecroNo)
    Logic.SetEntityScriptingValue(GetEntityId("Necro" .. _NecroNo),72,1)
    CUtil.SetEntityDisplayName(GetEntityId("Necro" .. _NecroNo), "Nekromant")
    if IsDead("Necro" .. _NecroNo) or KERBEROSUPGRADED then
        DestroyEntity(GetEntityId("Necro" .. _NecroNo))
        return true
    end
    if IsNear("Necro".. _NecroNo, "ghostweaponspawn" .. CURRENTNECROPOS[_NecroNo], 300) then
        CURRENTNECROPOS[_NecroNo] = math.random(1,4)
        UseNecroAbility("Necro" .. _NecroNo)
    else
        Move("Necro".._NecroNo, "ghostweaponspawn" .. CURRENTNECROPOS[_NecroNo])
    end
end

function upgradeKerberos()
    ChangePlayer("Kerberos",1)
    KERBEROSUPGRADED = true
    ResearchTechnology( Technologies.T_HeroicArmor, 1)
end

function checkForBootsChest()
    if IsNear("Kerberos","chestBoots",200) then
        Message("Kerberos: Was machen meine Schuhe hier?! Kardinel was hat das zu bedeuten?")
        StartCountdown(3,function ()
            Message("Kardinel: Ähhm, müssen wohl bei der Reinigung den Abfluss runter gefallen sein.")
        end,false)
        StartCountdown(7,function ()
            Message("Kerberos: Du weißt, dass ich Leute schon für weniger getötet hab oder? Du hast Glück, dass es gerade Wichtigeres gibt.")
        end,false)
        local chestPos = GetPosition("chestBoots")
        Logic.CreateEntity( Entities.XD_ChestOpen, chestPos.X, chestPos.Y, 260, 0 )
        Logic.DestroyEntity( GetEntityId("chestBoots") )
        ResearchTechnology( Technologies.T_HeroicShoes)
        return true
    end
end

function createBanditDefArmy()
    Armies[CONST_ARMY_INDEX] = {
        player = 2,
        id = GetFirstFreeArmySlot(2),
        strength = 8,
        position = GetPosition("banditSpawn"),
        rodeLength = 3000
    }
    
    SetupArmy(Armies[CONST_ARMY_INDEX])
    
    local troopDescription = {}
    troopDescription.maxNumberOfSoldiers = 10
    troopDescription.minNumberOfSoldiers = 1
    troopDescription.experiencePoints = HIGH_EXPERIENCE
    troopDescription.leaderType = Entities.CU_BanditLeaderSword1
    
    for j = 1, 2 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end

    troopDescription.leaderType = Entities.CU_BanditLeaderBow1
    
    for j = 1, 2 do
        EnlargeArmy(Armies[CONST_ARMY_INDEX], troopDescription)
    end
    
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "controlArmyDefendAndSwap" , 1, {}, {CONST_ARMY_INDEX})
    CONST_ARMY_INDEX = CONST_ARMY_INDEX + 1
end

function controlArmyDefendAndSwap(_id)
    if IsDead(Armies[_id]) then
        Explore.Hide("explBandits")
        return true
    end
    if BANDITQUESTSTARTED == true then
        for i = 0, table.getn(Armies[_id].IDs) do
            if AreEntitiesInArea(1,0,GetPosition(Armies[_id].IDs[i]),1000,1) and IsDead("spawnerBanditAttack") then
                ChangePlayer("mercTowerBandits", 1)
                gvMercTechsCheated = 1
                ResearchTechnology( Technologies.T_BanditCulture, 1)
                gvMercenaryTower.Cooldown.BuyLeaderBanditSword = 0
	            gvMercenaryTower.Cooldown.BuyLeaderBanditBow = 0
                for j = 0, table.getn(Armies[_id].IDs) do
                    ChangePlayer(Armies[_id].IDs[1],1)
                end
                Explore.Hide("explBandits")
                return true
            end
        end
    end
    Defend(Armies[_id])
end