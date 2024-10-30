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
local Buy_Upgrade : RemoteEvent = Remotes.Buy_Upgrade
local Update_Multiplier : RemoteEvent = Remotes.Update_Multiplier
local Add_Strength : RemoteEvent = Remotes.Give_Strength
local Add_Looks : RemoteEvent = Remotes.Add_Looks
local Add_Diet : RemoteEvent = Remotes.Add_Diet
local Level_Up : RemoteEvent = Remotes.Level_Up
local Stronk_Buy : RemoteEvent = Remotes.Stronk_Buy
local GamePass_Bought : RemoteEvent = Remotes.GamePass_Bought
local Get_Profile : RemoteFunction = Remotes.Get_Profile
local Get_Loaded : RemoteFunction = Remotes.Get_Loaded




Cry_Remote.OnServerEvent:Connect(function(player)
	MoneyHandler.giveById_Multiplier(player, 1 , "Tears")
end)

Add_Strength.OnServerEvent:Connect(function(player)
	MoneyHandler.giveById_Multiplier(player, 1, "Physique")
end)

Add_Looks.OnServerEvent:Connect(function(player)
	MoneyHandler.giveById_Multiplier(player, 1 , "Looks")
end)

Add_Diet.OnServerEvent:Connect(function(player)
	MoneyHandler.giveById_Multiplier(player, 1,"Diet")
end)

Get_Profile.OnServerInvoke = function(player)
	local Data = PlayerManager:GetData(player)
	return Data
end

Get_Loaded.OnServerInvoke = function(player)
	local Data = PlayerManager:Loaded(player)
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

Buy_Upgrade.OnServerEvent:Connect(function(player : Player, Currency : string, Cost : number, level : number, index  : number)
	MoneyHandler.removeById(player, Cost, Currency)
	MoneyHandler.setUpgradeLevel(player, level, index)
end)

Level_Up.OnServerEvent:Connect(function(player : Player, Currency : string, Cost : number, level : number, index : number)
	MoneyHandler.removeById(player, Cost, Currency)
	MoneyHandler.setLevelUpLevel(player, level, index)
end)

Update_Multiplier.OnServerEvent:Connect(function(player : Player, Currency : string, Income : number)
	MoneyHandler.setMultiplier(player, Currency, Income)
end)

GamePass_Bought.OnServerEvent:Connect(function(player)
	PlayerManager:RegisterGamepasses(player)
end)

Stronk_Buy.OnServerEvent:Connect(function(player: Player, Data)
	local Cost = Data.Cost
	local Currency = Data.Currency
	local Level = Data.Level
	local Index = Data.Index
	local Value = Data.Value
	local Income = Data.NextIncome

	MoneyHandler.removeById(player, Cost, Currency)
	MoneyHandler.setStronkLevel(player, Level, Index)
	MoneyHandler.setPassiveIncome(player, Value, Income)
end)

local function passiveIncome(player)
	repeat
		task.wait(0.1)
	until PlayerManager:Loaded(player)
	
	while true do
		if not player then break end
		local items = PlayerManager:GetById(player, "ItemCount")
		local multiplier = items
		if not multiplier then return end
		MoneyHandler.giveMoney_Multiplier(player, 1 * multiplier)
		for Currency, Income in pairs(PlayerManager:GetById(player, "PassiveIncomes")) do
			if Income then
				MoneyHandler.giveById(player, Income, Currency)
			end
		end
		task.wait(1)
	end
end
--Passive income
for _, player in pairs(Players:GetPlayers()) do
	task.spawn(function()
		passiveIncome(player)
	end)
end

game.Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		passiveIncome(player)
	end)
end)






