local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gamepassBought : RemoteEvent = ReplicatedStorage.Remotes.GamePass_Bought
local gamepassHandler = {}

function gamepassHandler.configGamepass(button)
    local id = button:GetAttribute("GamepassId")
    button.Activated:Connect(function()
        MarketplaceService:PromptGamePassPurchase(player, id)
        gamepassBought:FireServer()
    end)
end

function gamepassHandler.configDevProduct(button)
    local id = button:GetAttribute("DevProductId")
    button.Activated:Connect(function()
        MarketplaceService:PromptProductPurchase(player, id)
    end)
end

return gamepassHandler