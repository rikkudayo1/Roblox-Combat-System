local UserState = require(script.Parent.Combat.UserState)
local ComboHandler = require(script.Parent.Combat.ComboHandler)
local CooldownHandler = require(script.Parent.Combat.CooldownHandler)
local HitboxHandler = require(script.Parent.Combat.HitboxHandler)
local MovementHandler = require(script.Parent.Combat.MovementHandler)
local CombatRemote = game.ReplicatedStorage:WaitForChild("Remotes").CombatEvent
local AnimationRemote = game.ReplicatedStorage:WaitForChild("Remotes").AnimationEvent

CombatRemote.OnServerEvent:Connect(function(player)
    local user = UserState.GetUser(player.UserId)
    if not user then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local combat_on_cd = CooldownHandler.IsOnCooldown(player, "combat")
    local isRecovering = user.recoveryUntil > 0

    if not combat_on_cd and not isRecovering then
        local combo = ComboHandler.AddCombo(player)
        CooldownHandler.StartCD(player, "combat", 0.5)
        HitboxHandler.StartHitbox(
            combo,
            Vector3.new(8,8,8),
            hrp.CFrame * CFrame.new(0, 0, -3),
            10,
            0.5,
            false,
            {character}
        )
        AnimationRemote:FireAllClients(character, "Combat", combo)
        if combo == 5 then
            MovementHandler.ApplyRecovery(player, 1.5)
        else
            MovementHandler.ApplyRecovery(player, 0.35)
        end
    end
end)