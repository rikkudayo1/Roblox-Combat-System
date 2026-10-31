local RunService = game:GetService("RunService")

local AnimationData = require(script.Parent.AnimationData)

local AnimationHandler = {}

-- Stores animations separately for every rig.
local tracks = {}

local PRIORITIES = {
    Combat = Enum.AnimationPriority.Action,
    Movement = Enum.AnimationPriority.Movement,
    Actions = Enum.AnimationPriority.Action,
    Emotes = Enum.AnimationPriority.Action,
}

-- Find the Animator belonging to a rig.
local function GetAnimator(rig)
    local controller =
        rig:FindFirstChildOfClass("Humanoid")
        or rig:FindFirstChildOfClass("AnimationController")

    if not controller then
        warn("No Humanoid or AnimationController found:", rig.Name)
        return nil
    end

    local animator = controller:FindFirstChildOfClass("Animator")

    -- Only create the Animator on the server.
    if not animator and RunService:IsServer() then
        animator = Instance.new("Animator")
        animator.Parent = controller
    end

    if not animator then
        warn("Animator not found:", rig.Name)
        return nil
    end

    return animator
end

-- Load animations for a specific rig.
function AnimationHandler.LoadRig(rig)
    if tracks[rig] then
        return tracks[rig]
    end

    if not rig:IsDescendantOf(workspace) then
        warn("Rig must be inside Workspace before loading:", rig.Name)
        return nil
    end

    local animator = GetAnimator(rig)

    if not animator then
        return nil
    end

    local rigTracks = {}

    for category, animations in pairs(AnimationData) do
        rigTracks[category] = {}

        for name, assetId in pairs(animations) do
            local animation = Instance.new("Animation")

            animation.AnimationId =
                "rbxassetid://" .. tostring(assetId)

            local track = animator:LoadAnimation(animation)

            track.Priority =
                PRIORITIES[category] or Enum.AnimationPriority.Action

            rigTracks[category][name] = track
        end
    end

    tracks[rig] = rigTracks

    return rigTracks
end

-- Play an animation on a specific rig.
function AnimationHandler.Play(
    rig,
    category,
    name,
    fadeTime,
    speed
)
    local rigTracks = tracks[rig]

    if not rigTracks then
        rigTracks = AnimationHandler.LoadRig(rig)
    end

    if not rigTracks then
        return nil
    end

    local categoryTracks = rigTracks[category]

    if not categoryTracks then
        warn("Unknown category:", category)
        return nil
    end

    local track = categoryTracks[name]

    if not track then
        warn("Animation not found:", category, name)
        return nil
    end

    track:Play(
        fadeTime or 0.1,
        1,
        speed or 1
    )

    return track
end

-- Stop a specific animation.
function AnimationHandler.Stop(
    rig,
    category,
    name,
    fadeTime
)
    local rigTracks = tracks[rig]

    if not rigTracks then
        return
    end

    local categoryTracks = rigTracks[category]

    if not categoryTracks then
        return
    end

    local track = categoryTracks[name]

    if track and track.IsPlaying then
        track:Stop(fadeTime or 0.1)
    end
end

-- Stop all animations on a specific rig.
function AnimationHandler.StopAll(rig, fadeTime)
    local rigTracks = tracks[rig]

    if not rigTracks then
        return
    end

    for _, categoryTracks in pairs(rigTracks) do
        for _, track in pairs(categoryTracks) do
            if track.IsPlaying then
                track:Stop(fadeTime or 0.1)
            end
        end
    end
end

-- Change the playback speed.
function AnimationHandler.SetSpeed(
    rig,
    category,
    name,
    speed
)
    local rigTracks = tracks[rig]

    if not rigTracks then
        return
    end

    local categoryTracks = rigTracks[category]

    if not categoryTracks then
        return
    end

    local track = categoryTracks[name]

    if track then
        track:AdjustSpeed(speed)
    end
end

-- Unload all tracks belonging to a rig.
function AnimationHandler.UnloadRig(rig)
    local rigTracks = tracks[rig]

    if not rigTracks then
        return
    end

    AnimationHandler.StopAll(rig, 0)

    for _, categoryTracks in pairs(rigTracks) do
        for _, track in pairs(categoryTracks) do
            track:Destroy()
        end
    end

    tracks[rig] = nil
end

return AnimationHandler