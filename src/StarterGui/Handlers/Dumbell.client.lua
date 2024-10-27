local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local initClient : RemoteEvent = ReplicatedStorage.Remotes:WaitForChild("initDumbell")
local addStrength : RemoteEvent = ReplicatedStorage.Remotes:WaitForChild("Give_Strength")

local Handlers = script.Parent
local guiAnimations = require(Handlers.guiAnimation)
local ProfileModule = require(Handlers.ProfileData)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)

local Assets = ReplicatedStorage.Assets
local StrengthPopUp = Assets.StrengthPopUp

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local TranstionGui = PlayerGui.Transitions

local function onClick(Physique)
    local text = "+".. FormatNumbers.FormatCompact(Physique).. " Strength"
    guiAnimations.createDynamicPopup(StrengthPopUp, TranstionGui, text)
end

initClient.OnClientEvent:Connect(function(Instance : Tool)
    local deb = false
    Instance.Activated:Connect(function()
        local profile = ProfileModule.GetProfile()
        local Physique = profile.Multipliers.Physique * profile.globalMultiplier * profile.RebirthMultiplier
        if deb == false then
            deb = true
            addStrength:FireServer()
            onClick(Physique)
            task.wait(0.7)
            deb = false
        end
    end)
end)



