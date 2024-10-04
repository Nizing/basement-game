local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Tool = ServerStorage.Dumbell

local Dumbells = {}
Dumbells.__index = Dumbells

function Dumbells.new(tycoon, instance)
    local self = setmetatable({}, Dumbells)
    self.Tycoon = tycoon
    self.Instance = instance
    self.ProximityPart = instance.ProximityPart

    self._initClient = ReplicatedStorage.Remotes.initDumbell
    self._StrengthGainEvent = ReplicatedStorage.Remotes.Give_Strength
    self._AnimationTrash = {}
    return self
end

local function playAnimation(player, animationId)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                local animation = Instance.new("Animation")
                animation.AnimationId = animationId
                local animTrack = animator:LoadAnimation(animation)
                animTrack:Play()
                return animTrack
            end
        end
    end 
end



function Dumbells:CreatePrompt()
    local newPrompt = Instance.new("ProximityPrompt")
    newPrompt.HoldDuration = 2
    newPrompt.ObjectText = "Pick up Dumbell"
    newPrompt.Parent = self.ProximityPart
    return newPrompt
end
local IdleAnimation = "rbxassetid://74501629614531"
local RepAnimationId = "rbxassetid://70658993444211"

function Dumbells:Init()
    self.Prompt = self:CreatePrompt()
    self.Prompt.Triggered:Connect(function(playerWhoTriggered)
        if playerWhoTriggered.Name == self.Tycoon.Owner.Name then
            self.Dumbell = self:Press(playerWhoTriggered)

            self.Dumbell.Equipped:Connect(function()
                table.insert(self._AnimationTrash, playAnimation(playerWhoTriggered, IdleAnimation))
            end)

            self.Dumbell.Unequipped:Connect(function()
                for _, track in pairs(self._AnimationTrash) do
                    track:Stop()
                end
            end)
        end
    end)
    self._StrengthGainEvent.OnServerEvent:Connect(function(player)
        if player.Name == self.Tycoon.Owner.Name then
            playAnimation(player, RepAnimationId)
        end
    end)
end

function Dumbells:Press(player)
    if player.Backpack:FindFirstChild("Dumbell") then return end
    local newDumbell = Tool:Clone()
    newDumbell.Name = "Dumbell"
    newDumbell.Parent = player.Backpack
    self._initClient:FireClient(player, newDumbell) 
    return newDumbell
end

return Dumbells