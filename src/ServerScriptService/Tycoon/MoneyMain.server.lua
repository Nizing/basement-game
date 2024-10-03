local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
local Libraries = ServerScriptService.Libraries
local Tycoon = ServerScriptService.Tycoon

local PlayerManager = require(Libraries.PlayerManager)
local MoneyHandler = require(Tycoon.MoneyHandler)


local Cry_Remote : RemoteEvent = Remotes.Cry_Remote
local Convert_Tears : RemoteEvent = Remotes.Convert_Tears
local Buy_Video : RemoteEvent = Remotes.Buy_Video
local Get_Profile : RemoteFunction = Remotes.Get_Profile


Cry_Remote.OnServerEvent:Connect(function(player)
	MoneyHandler.giveById(player, 1 , "Tears")
end)

Get_Profile.OnServerInvoke = function(player)
	local Data = PlayerManager:GetData(player)
	return Data
end

Convert_Tears.OnServerEvent:Connect(function(player, tears, money)
	MoneyHandler.removeById(player, tears, "Tears")
	MoneyHandler.giveMoney(player, money)
end)

Buy_Video.OnServerEvent:Connect(function(player, money, videoId)
	MoneyHandler.removeMoney(player, money)
	MoneyHandler.addToTable(player, videoId, "VideoIds")
	Buy_Video:FireClient(player)
end)

--Passive income
for _, player in pairs(Players:GetPlayers()) do
	task.spawn(function()
		while true do
			local items = PlayerManager:GetById(player, "ItemCount")
			local multiplier = items / 5
			MoneyHandler.giveMoney(player, math.ceil(1 * multiplier))
			task.wait(1)
		end
	end)
end

game.Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		while true do
			local items = PlayerManager:GetById(player, "ItemCount")
			local multiplier = items / 5
			MoneyHandler.giveMoney(player, math.ceil(1 * multiplier))
			task.wait(1)
		end
	end)
end)






