local ServerScriptService = game:GetService("ServerScriptService")

local Libraries = ServerScriptService.Libraries

local PlayerManager = require(Libraries.PlayerManager)

local MoneyHandler = {}

function MoneyHandler.giveMoney(player: Player, number: IntValue)
	PlayerManager:AddMoney(player, number)
end

return MoneyHandler
