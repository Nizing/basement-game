local ServerScriptService = game:GetService("ServerScriptService")
local PlayerManager = require(ServerScriptService.Libraries.PlayerManager)
return {
    [1] = function(player)
        PlayerManager:AddById(player, 2, "MoneyMultiplier")
    end
}