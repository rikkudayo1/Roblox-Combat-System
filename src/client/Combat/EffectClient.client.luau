local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EffectRemote = ReplicatedStorage:WaitForChild("Remotes").EffectEvent

local effectFolder = ReplicatedStorage:FindFirstChild("Fx")
EffectRemote.OnClientEvent:Connect(function(action, hrp)
    if hrp then
        if action == "hit" then
            local hitFxFolder = effectFolder.Hit
            for _,v in ipairs(hitFxFolder:GetChildren()) do
                local fx = v:Clone()
                fx.Name = v.Name
                fx.Parent = hrp
                fx:Emit(20)
                Debris:AddItem(fx, 0.5)
            end
        end
    end
end)