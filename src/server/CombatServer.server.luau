local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Hitbox = require(ReplicatedStorage.Packages.hitbox)
local UserState = require(script.Parent.Combat.UserState)
local ComboHandler = require(script.Parent.Combat.ComboHandler)
local CooldownHandler = require(script.Parent.Combat.CooldownHandler)

local CombatRemote = game.ReplicatedStorage:WaitForChild("Remotes").CombatEvent
local AnimationRemote = game.ReplicatedStorage:WaitForChild("Remotes").AnimationEvent

local function StartHitbox(character, damage)
    local hitbox = Hitbox.box(Vector3.new(8, 8, 4), character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3), {
        Lifetime = 0.5,
        Debug = true,
        Blacklist = {character},
    })

    hitbox.OnHit:Connect(function(hitCharacters)
        for _, hitChar in hitCharacters do
            local humanoid = hitChar:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:TakeDamage(damage)
                print("Hit:", hitChar.Name)
            end
        end
    end)

    hitbox:Start()
end

CombatRemote.OnServerEvent:Connect(function(player)
    local user = UserState.GetUser(player.UserId)
    if not user then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local combat_on_cd = CooldownHandler.IsOnCooldown(player, "combat")

    if not combat_on_cd then
        local combo = ComboHandler.AddCombo(player)
        CooldownHandler.StartCD(player, "combat", 0.5)
        StartHitbox(character, user.damage)

        AnimationRemote:FireClient(player, "combat", combo)
    end
end)