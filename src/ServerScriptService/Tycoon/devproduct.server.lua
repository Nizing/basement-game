local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerManager = require(ServerScriptService.Libraries.PlayerManager)

local products = {
    [1] = function(player)
        PlayerManager:AddMoney(player, 123)
        return true
    end
}

MarketplaceService.ProcessReceipt = function(info)
    local player = Players:GetPlayerByUserId(info.PlayerId)
    if not player then 
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local success, result = pcall(products[info.ProductId], player)
    if not success or not result then
        warn("Error for product" .. result)
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    return Enum.ProductPurchaseDecision.PurchaseGranted
end

