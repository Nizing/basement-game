local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerManager = require(ServerScriptService.Libraries.PlayerManager)

local products = {
    [2317860444] = function(player)
        for i = 10, 0, -1 do
			task.wait(1)
			ReplicatedStorage.Remotes.Nuke_Countdown:FireAllClients(i)
        end
        
		for _, House in pairs(game.Workspace:GetChildren()) do
			if House.Name == "Template" then
				for _, HousePart in pairs(House:GetDescendants()) do
					if HousePart:IsA("BasePart") then
						HousePart.Anchored = false
					end
				end
			end
		end
        return true
    end,
    [2463459939] = function(player)
        PlayerManager:AddMoney(player, 1000)
        return true
    end,
    [2463595781] = function(player)
        PlayerManager:AddMoney(player, 10000)
        return true
    end,
    [2463624333] = function(player)
        PlayerManager:AddMoney(player, 1000000)
        return true
    end,
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

