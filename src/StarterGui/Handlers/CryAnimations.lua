local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local guiAnimation = require(script.Parent.guiAnimation)

local TearsPopUp = ReplicatedStorage.Assets.TearsPopUp
local player = Players.LocalPlayer
local Transitions = player.PlayerGui.Transitions
local Animations = {}

local CryId = "rbxassetid://18991841924"
local CrySoundId = "rbxassetid://18996955548"

function Animations.CryAnimation(player : Player)
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")

    local newAnimation = Instance.new("Animation")
    newAnimation.AnimationId = CryId
    local newSound = Instance.new("Sound")
    newSound.SoundId = CrySoundId
    newSound.Parent = humanoid
    

    local character = player.Character
    local humanoid = character.Humanoid
    local Animator = humanoid:WaitForChild("Animator")
    
    local Cry = Animator:LoadAnimation(newAnimation)
    Cry:Play()
    newSound:Play()
    guiAnimation.createDynamicPopup(TearsPopUp, Transitions)
    task.wait(1)
    newAnimation:Destroy()
    newSound:Destroy()
end


return Animations