local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

local NotEnoughMoney : RemoteEvent = Remotes.Not_Enough_Money

local Handlers = script.Parent

local guiAnimations = require(Handlers.guiAnimation)
local NotEnoughMoneyLabel = ReplicatedStorage.Assets.NotEnoughMoney

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local TransitionsGui = PlayerGui.Transitions

local LocalAssets = PlayerGui.Assets


NotEnoughMoney.OnClientEvent:Connect(function()
    LocalAssets.MistakeSound:Play()
    guiAnimations.createDynamicPopup(NotEnoughMoneyLabel, TransitionsGui)
end)

