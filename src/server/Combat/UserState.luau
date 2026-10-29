local UserState = {}
local UsersTable = {}

local function CreateState()
    return {
        damage = 10,
        combo = 0,
        stun = false,
        cooldowns = {
            combat = 0,
        },
    }
end

function UserState.AddUser(userid)
    if UsersTable[userid] then
        return UsersTable[userid]
    end
    UsersTable[userid] = CreateState()
    return UsersTable[userid]
end

function UserState.GetUser(userid)
    return UsersTable[userid]
end

function UserState.RemoveUser(userid)
    UsersTable[userid] = nil
end

function UserState.ResetUser(userid)
    UsersTable[userid] = CreateState()
    return UsersTable[userid]
end

return UserState