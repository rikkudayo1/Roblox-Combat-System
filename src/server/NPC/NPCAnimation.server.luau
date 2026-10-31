local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationHandler = require(ReplicatedStorage.Shared.Animation.AnimationHandler)

for _, rig in ipairs(workspace:WaitForChild("NPCs"):GetChildren()) do
    AnimationHandler.LoadRig(rig)
end
