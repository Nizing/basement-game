local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
local Libraries = ServerScriptService.Libraries
local Tycoon = ServerScriptService.Tycoon

local PlayerManager = require(Libraries.PlayerManager)
local Moneyhandler = require(Tycoon.MoneyHandler)


local Cry_Remote : RemoteEvent = Remotes.Cry_Remote
local Get_Profile : RemoteFunction = Remotes.Get_Profile

Cry_Remote.OnServerEvent:Connect(function(player)
	Moneyhandler.giveTears(player, 1)
end)

Get_Profile.OnServerInvoke = function(player)
	local Data = PlayerManager:GetData(player)
	return Data
end





