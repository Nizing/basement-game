local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gamepassHandler = {}

function gamepassHandler.configGamepass(button : GuiButton)
    local id = button:GetAttribute("GamepassId")
    button.Activated:Connect(function()
        MarketplaceService:PromptGamePassPurchase(player, id)
    end)
end

function gamepassHandler.configDevProduct(button : GuiButton)
    local id = button:GetAttribute("DevProductId")
    button.Activated:Connect(function()
        MarketplaceService:PromptProductPurchase(player, id)
    end)
end

return gamepassHandler