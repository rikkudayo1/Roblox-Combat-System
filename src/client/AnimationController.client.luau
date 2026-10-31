local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local AnimationHandler = require(ReplicatedStorage.Shared.Animation.AnimationHandler)
local AnimationRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AnimationEvent")

local function SetupCharacter(character)
    AnimationHandler.LoadRig(character)
end

player.CharacterAdded:Connect(SetupCharacter)

if player.Character then
    task.spawn(SetupCharacter, player.Character)
end

AnimationRemote.OnClientEvent:Connect(function(character, category, name)
    if not character then return end
    AnimationHandler.Play(character, category, name)
end)