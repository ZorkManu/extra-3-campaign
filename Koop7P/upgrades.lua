function UpgradeEnemies()
    local TimerMultiplier = Counter.GetTick("TIMER") + Difficulty * 120
    if TimerMultiplier == 4200 then
        ResearchTechnology(Technologies.T_EvilArmor1,8)
        ResearchTechnology(Technologies.T_EvilSpears1,8)
    end
    if TimerMultiplier == 4800 then
        ResearchTechnology(Technologies.T_BloodRush,8)
        ResearchTechnology(Technologies.T_HeroicShoes,8)
        ResearchTechnology(Technologies.T_HeroicArmor,8)
    end
    if TimerMultiplier == 1200 then
        ResearchTechnology(Technologies.T_BetterTrainingArchery,8)
        ResearchTechnology(Technologies.T_BetterTrainingBarracks,8)
        ResearchTechnology(Technologies.T_LeatherArcherArmor,8)
        ResearchTechnology(Technologies.T_LeatherMailArmor,8)
        ResearchTechnology(Technologies.T_HeroicShoes,8)
        ResearchTechnology(Technologies.T_HeroicArmor,8)
        ResearchTechnology(Technologies.T_HeroicWeapon,8)
    end
    if TimerMultiplier == 2400 then
        ResearchTechnology(Technologies.T_MasterOfSmithery,8)
        ResearchTechnology(Technologies.T_Fletching,8)
        ResearchTechnology(Technologies.T_FleeceArmor,8)
        ResearchTechnology(Technologies.T_ChainMailArmor,8)
        ResearchTechnology(Technologies.T_SoftArcherArmor,8)
        ResearchTechnology(Technologies.T_WoodAging,8)
        ResearchTechnology(Technologies.T_LeadShot,8)
    end
    if TimerMultiplier == 3000 then
        ResearchTechnology(Technologies.T_IronCasting,8)
        ResearchTechnology(Technologies.T_BodkinArrow,8)
        ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,8)
        ResearchTechnology(Technologies.T_PlateMailArmor,8)
        ResearchTechnology(Technologies.T_PaddedArcherArmor,8)
        ResearchTechnology(Technologies.T_Turnery,8)
        ResearchTechnology(Technologies.T_Sights,8)
    end
    if TimerMultiplier == 3800 then
        ResearchTechnology(Technologies.T_SilverSwords,8)
        ResearchTechnology(Technologies.T_SilverPlateArmor,8)
        ResearchTechnology(Technologies.T_SilverLance,8)
        ResearchTechnology(Technologies.T_SilverBullets,8)
        ResearchTechnology(Technologies.T_SilverArrows,8)
        ResearchTechnology(Technologies.T_SilverArcherArmor,8)
        return true
    end
end

function P4StartUpgrades()
	for i = 1, 2 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 4)
	end
end

function UpgradeP4()
    local TimerMultiplier = Counter.GetTick("TIMER")
    if TimerMultiplier == 1200 then
        ResearchTechnology(Technologies.T_BetterTrainingArchery,4)
        ResearchTechnology(Technologies.T_BetterTrainingBarracks,4)
        ResearchTechnology(Technologies.T_LeatherArcherArmor,4)
        ResearchTechnology(Technologies.T_LeatherMailArmor,4)
    end
    if TimerMultiplier == 2400 then
        ResearchTechnology(Technologies.T_MasterOfSmithery,4)
        ResearchTechnology(Technologies.T_Fletching,4)
        ResearchTechnology(Technologies.T_FleeceArmor,4)
        ResearchTechnology(Technologies.T_ChainMailArmor,4)
        ResearchTechnology(Technologies.T_SoftArcherArmor,4)
        ResearchTechnology(Technologies.T_WoodAging,4)
        ResearchTechnology(Technologies.T_LeadShot,4)
    end
    if TimerMultiplier == 30000 then
        ResearchTechnology(Technologies.T_IronCasting,4)
        ResearchTechnology(Technologies.T_BodkinArrow,4)
        ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,4)
        ResearchTechnology(Technologies.T_PlateMailArmor,4)
        ResearchTechnology(Technologies.T_PaddedArcherArmor,4)
        ResearchTechnology(Technologies.T_Turnery,4)
        ResearchTechnology(Technologies.T_Sights,4)
    end
    if TimerMultiplier == 3200 then
        Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 4)
        Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle, 4)
        return true
    end
end