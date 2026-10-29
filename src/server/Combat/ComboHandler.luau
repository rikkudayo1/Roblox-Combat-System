local UserState = require(script.Parent.UserState)

local ComboHandler = {}

local function GetUser(player: Player)
    return UserState.GetUser(player.UserId)
end

function ComboHandler.AddCombo(player: Player)
    local user = GetUser(player)
    if not user then return end
    user.combo += 1
    if user.combo == 6 then
        user.combo = 1
    end
    return user.combo
end

function ComboHandler.GetCombo(player: Player)
    local user = GetUser(player)
    if not user then return nil end
    return user.combo
end

function ComboHandler.ResetCombo(player: Player)
    local user = GetUser(player)
    if not user then return end
    user.combo = 0
    return user.combo
end

return ComboHandler