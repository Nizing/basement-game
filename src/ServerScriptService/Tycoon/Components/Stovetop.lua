local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stovetop = {}
Stovetop.__index = Stovetop

function Stovetop.new(tycoon, instance)
    local self = setmetatable({}, Stovetop)
    self.Tycoon = tycoon
    self.Instance = instance
    self.ProximityPart = instance.ProximityPart

    self._EnterRemote = ReplicatedStorage.Remotes.Start_Cooking
    
    return self
end

function Stovetop:CreatePrompt()
    local newPrompt = Instance.new("ProximityPrompt")
    newPrompt.HoldDuration = 1
    newPrompt.MaxActivationDistance = 15
    newPrompt.ObjectText = "Start cooking"
    newPrompt.Parent = self.ProximityPart
    return newPrompt
end

function Stovetop:Init()
    self.Prompt = self:CreatePrompt()
    self.Prompt.Triggered:Connect(function(playerWhoTriggered)
        if playerWhoTriggered.Name == self.Tycoon.Owner.Name then
            print("wtf")
            self._EnterRemote:FireClient(playerWhoTriggered)
        end
    end)
end



return Stovetop 