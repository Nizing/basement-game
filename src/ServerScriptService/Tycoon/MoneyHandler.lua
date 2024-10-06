local ServerScriptService = game:GetService("ServerScriptService")

local Libraries = ServerScriptService.Libraries

local PlayerManager = require(Libraries.PlayerManager)

local MoneyHandler = {}

function MoneyHandler.giveMoney(player: Player, number: IntValue)
	PlayerManager:AddMoney(player, number)
end

function MoneyHandler.removeMoney(player: Player, number: IntValue)
	PlayerManager:AddMoney(player, number * -1)
end

function MoneyHandler.giveById(player: Player, number: IntValue, Id : string)
	PlayerManager:AddById(player, number, Id)
end

function MoneyHandler.addToTable(player: Player, number: IntValue, Table : string)
	PlayerManager:AddToTable(player, number, Table)
end

function MoneyHandler.setUpgradeLevel(player : Player, level : IntValue, index)
	PlayerManager:SetValueInTableByIndex(player, level, "Upgrades", index)
end

function MoneyHandler.removeById(player: Player, number: IntValue, Id : string)
	PlayerManager:AddById(player, number * -1, Id)
end





return MoneyHandler
