local UserInputService = game:GetService("UserInputService")
local CombatEvent = game.ReplicatedStorage:WaitForChild("Remotes").CombatEvent

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        CombatEvent:FireServer()
    end
end)