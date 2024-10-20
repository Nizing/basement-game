local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mirror = {}
Mirror.__index = Mirror

function Mirror.new(tycoon, instance)
    local self = setmetatable({}, Mirror)
    self.Tycoon = tycoon
    self.Instance = instance
    self.ProximityPart = instance.ProximityPart

    self._EnterRemote = ReplicatedStorage.Remotes.LooksmaxEnter
    
    return self
end

function Mirror:CreatePrompt()
    local newPrompt = Instance.new("ProximityPrompt")
    newPrompt.HoldDuration = 1
    newPrompt.ObjectText = "Looksmax"
    newPrompt.Parent = self.ProximityPart
    return newPrompt
end

function Mirror:Init()
    self.Prompt = self:CreatePrompt()
    self.Prompt.Triggered:Connect(function(playerWhoTriggered)
        if playerWhoTriggered.Name == self.Tycoon.Owner.Name then
            
            self._EnterRemote:FireClient(playerWhoTriggered)
        end
    end)
end



return Mirror 