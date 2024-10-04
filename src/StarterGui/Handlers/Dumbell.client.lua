local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local initClient : RemoteEvent = ReplicatedStorage.Remotes:WaitForChild("initDumbell")
local addStrength : RemoteEvent = ReplicatedStorage.Remotes:WaitForChild("Give_Strength")

local Handlers = script.Parent
local guiAnimations = require(Handlers.guiAnimation)

local Assets = ReplicatedStorage.Assets
local StrengthPopUp = Assets.StrengthPopUp

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local TranstionGui = PlayerGui.Transitions

local function onClick()
    guiAnimations.createDynamicPopup(StrengthPopUp, TranstionGui)
end

initClient.OnClientEvent:Connect(function(Instance : Tool)
    local deb = false
    Instance.Activated:Connect(function()
        if deb == false then
            deb = true
            addStrength:FireServer()
            onClick()
            task.wait(0.7)
            deb = false
        end
    end)
end)



