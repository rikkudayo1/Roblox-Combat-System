local Players = game:GetService("Players")
local UserState = require(script.Parent.Combat.UserState)

Players.PlayerAdded:Connect(function(player)
    local state = UserState.AddUser(player.UserId)
    print(state)
end)

Players.PlayerRemoving:Connect(function(player)
    UserState.RemoveUser(player.UserId)
    print("Player removed : "..player.Name)
end)