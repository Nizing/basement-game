local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local guiAnimation = require(script.Parent.guiAnimation)
local profileModule = require(script.Parent.ProfileData)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)

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

    local profile = profileModule.GetProfile()
    local Tears = profile.Multipliers.Tears * profile.globalMultiplier * profile.RebirthMultiplier
    local text = "+" .. FormatNumbers.FormatCompact(Tears) .. " Tears"
    guiAnimation.createDynamicPopup(TearsPopUp, Transitions, text)
    task.wait(0.5)
    newAnimation:Destroy()
    newSound:Destroy()
end


return Animations