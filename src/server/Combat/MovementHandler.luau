local UserState = require(script.Parent.UserState)
local MovementHandler = {}

function MovementHandler.ApplyRecovery(player: Player, duration: number)
    local state = UserState.GetUser(player.UserId)
    local character = player.Character

    if not state or not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local expiration = os.clock() + duration
    state.recoveryUntil = expiration
    humanoid.WalkSpeed = 4

    task.delay(duration, function()
        if player.Character ~= character then return end
        if state.recoveryUntil ~= expiration then return end

        state.recoveryUntil = 0
        humanoid.WalkSpeed = 16
    end)
end

return MovementHandler