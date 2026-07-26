function BriefingStart()
end

function BriefingHQ()
end

function BriefingEnterMercius()
    GUI.DestroyMinimapPulse(GetPosition("Dario").X,GetPosition("Dario").Y)
    Explore.Hide("explDario")
    Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
end