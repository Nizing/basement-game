local ServerScriptService = game:GetService("ServerScriptService")

local Libraries = ServerScriptService.Libraries

local PlayerManager = require(Libraries.PlayerManager)

local MoneyHandler = {}

function MoneyHandler.giveMoney(player: Player, number: IntValue)
	PlayerManager:AddMoney(player, number)
end
--important
function MoneyHandler.giveMoney_Multiplier(player: Player, number: IntValue)
	PlayerManager:AddMoney(player, number * PlayerManager:GetMultiplier(player , "Money"))
end

function MoneyHandler.removeMoney(player: Player, number: IntValue)
	PlayerManager:AddMoney(player, number * -1)
end

function MoneyHandler.giveById_Multiplier(player: Player, number: IntValue, Id : string)
	local Multiplier = PlayerManager:GetMultiplier(player, Id)
	PlayerManager:AddById(player, number * Multiplier, Id)
end

function MoneyHandler.removeById(player: Player, number: IntValue, Id : string)
	PlayerManager:AddById(player, number * -1, Id)
end

function MoneyHandler.addToTable(player: Player, number: IntValue, Table : string)
	PlayerManager:AddToTable(player, number, Table)
end

function MoneyHandler.setUpgradeLevel(player : Player, level : IntValue, index)
	PlayerManager:SetValueInTableByIndex(player, level, "Upgrades", index)
end

function MoneyHandler.setLevelUpLevel(player : Player, level : IntValue, index)
	PlayerManager:SetValueInTableByIndex(player, level, "ClientLevels", index)
	local currLevel = 0
	
	for _, v in pairs(PlayerManager:GetById(player, "ClientLevels")) do
		currLevel += v
	end
	PlayerManager:SetById(player, currLevel, "Level")
end

function MoneyHandler.setMultiplier(player : Player , Currency : string, Income : number)
	PlayerManager:SetValueInTableByIndex(player, Income, "Multipliers", Currency)
end





return MoneyHandler
