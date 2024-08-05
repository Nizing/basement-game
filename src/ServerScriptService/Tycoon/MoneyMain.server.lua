local ServerScriptService = game:GetService("ServerScriptService")
local Libraries = ServerScriptService.Libraries
local Tycoon = ServerScriptService.Tycoon

local PlayerManager = require(Libraries.PlayerManager)
local Moneyhandler = require(Tycoon.MoneyHandler)

game.Players.PlayerAdded:Connect(function(player)
	while true do
		Moneyhandler.giveMoney(player, 10)
		task.wait(1)
	end
end)




