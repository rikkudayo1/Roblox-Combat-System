local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local AnimationRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("AnimationEvent")

local CombatAnim = {
    [1] = 79417307183804,
    [2] = 129139231421145,
    [3] = 113012951504307,
    [4] = 121809376023644,
    [5] = 116521964430922,
}

local tracks = {}

local function SetupCharacter(character)
    table.clear(tracks)

    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")

    for combo, assetId in pairs(CombatAnim) do
        local animation = Instance.new("Animation")
        animation.AnimationId =
            "rbxassetid://" .. tostring(assetId)

        local track = animator:LoadAnimation(animation)
        track.Priority = Enum.AnimationPriority.Action

        tracks[combo] = track
    end
end

if player.Character then
    task.spawn(SetupCharacter, player.Character)
end

player.CharacterAdded:Connect(SetupCharacter)

AnimationRemote.OnClientEvent:Connect(function(animType, combo)
    if animType ~= "combat" then
        return
    end
    local track = tracks[combo]

    if not track then
        warn("Missing animation for combo:", combo)
        return
    end
    track:Play(0.05)
end)