DAYORNIGHT = "night"
WINTER = false
DAYNIGHTCHANGED = false
CYCLELENGTH = 300

function checkForNight()
    if IsNighttime() then
        if DAYORNIGHT == "day" then
            DAYNIGHTCHANGED = false
        end
        DAYORNIGHT = "night"
    else
        if DAYORNIGHT == "night" then
            DAYNIGHTCHANGED = false
        end
        DAYORNIGHT = "day"
    end
end

function killGhosts()
    if DAYNIGHTCHANGED == true then
        return
    end
    if DAYORNIGHT == "day" then
        for i = 3, 4 do
            local leaderIds = GetPlayerLeaderIds(i)
            for j = 1, table.getn(leaderIds) do
                local currentLeaderId = leaderIds[j]
                Logic.GetSoldiersAttachedToLeader(currentLeaderId)
                local soldiers = { Logic.GetSoldiersAttachedToLeader(currentLeaderId) }

                for k = 2, table.getn(soldiers) do
                    SetHealth( soldiers[k], 0 )
                end

                SetHealth( currentLeaderId, 0 )
            end
        end
    else
        initPlayerThreeAndFourSpawner()
        initGhostSpawnerIsland()
        GHOST_SPAWNER_TIMER = GHOST_SPAWNER_TIMER + 1
    end
    DAYNIGHTCHANGED = true
end

function GetPlayerLeaderIds(_player)
    local leaderIds = {}
    local firstLeaderId = Logic.GetNextLeader(_player, 0)
    if firstLeaderId == 0 then
        return leaderIds
    end

    local currentLeaderId = firstLeaderId
    repeat
        table.insert(leaderIds, currentLeaderId)
        currentLeaderId = Logic.GetNextLeader(_player, currentLeaderId)
    until currentLeaderId == firstLeaderId

    return leaderIds
end