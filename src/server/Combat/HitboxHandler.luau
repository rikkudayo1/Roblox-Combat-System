local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Hitbox = require(ReplicatedStorage.Packages.hitbox)
local EffectRemote = ReplicatedStorage.Remotes.EffectEvent
local AnimationRemote = ReplicatedStorage.Remotes.AnimationEvent
local HitboxHandler = {}

function HitboxHandler.StartHitbox(combo: number, size: Vector3, position: CFrame, damage: number, lifetime: number, show: boolean, blacklist)
    -- ex:  Hitbox.box(Vector3.new(8, 8, 4), character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    local hitbox = Hitbox.box(size, position, {
        Lifetime = lifetime,
        Debug = show,
        Blacklist = blacklist, -- {} arr of chars
    })
    hitbox.OnHit:Connect(function(hitCharacters)
        for _, hitChar in hitCharacters do
            local hrp = hitChar:FindFirstChild("HumanoidRootPart")
            local humanoid = hitChar:FindFirstChildOfClass("Humanoid")
            if humanoid and hrp then
                humanoid:TakeDamage(damage)
                EffectRemote:FireAllClients("hit", hrp)
                AnimationRemote:FireAllClients(hitChar, "Hitted", (combo%3)+1)
                print("Hit:", hitChar.Name)
            end
        end
    end)

    hitbox:Start()
end

return HitboxHandler