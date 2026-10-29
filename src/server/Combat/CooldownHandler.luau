local UserState = require(script.Parent.UserState)

local CooldownHandler = {}

local function GetCooldown(player: Player)
    local user = UserState.GetUser(player.UserId)
    if not user then return end
    return user.cooldowns
end

function CooldownHandler.GetRemaining(player: Player, cd_type: string)
    local cooldowns = GetCooldown(player)
    if not cooldowns then return 0 end

    local remaining = (cooldowns[cd_type] or 0) - os.clock()
    if remaining <= 0 then
        cooldowns[cd_type] = nil
        return 0
    end
    return remaining
end

function CooldownHandler.IsOnCooldown(player: Player, cd_type: string)
    return CooldownHandler.GetRemaining(player, cd_type) > 0
end

function CooldownHandler.StartCD(player: Player, cd_type: string, duration: number)
    local cooldowns = GetCooldown(player)
    if not cooldowns then return false, 0 end
    local remaining = CooldownHandler.GetRemaining(player, cd_type)
    if remaining > 0 then
        return false, remaining
    end
    cooldowns[cd_type] = os.clock() + duration
    return true, 0
end

function CooldownHandler.Clear(player: Player, cd_type: string)
    local cooldowns = GetCooldown(player)
    if cooldowns then
        cooldowns[cd_type] = nil
    end
end

return CooldownHandler