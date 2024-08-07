local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BridgeNet = require(ReplicatedStorage.Libraries.BridgeNet)

local Bridge = BridgeNet.CreateBridge("Bridge")



local PlayerManager = {}

PlayerManager.Profiles = {}

function PlayerManager.spawnLeaderstats(player: Player)
	local profile = PlayerManager.Profiles[player]

	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local Money = Instance.new("IntValue", leaderstats)
	Money.Value = profile.Data.Money
	Money.Name = "Money"
	
	local Level = Instance.new("IntValue" , leaderstats)
	Level.Value = profile.Data.Level
	Level.Name = "Level"

	return leaderstats
end

local function refreshLeaderstats(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local profile = PlayerManager.Profiles[player]
		local Money = leaderstats:FindFirstChild("Money")
		Money.Value = profile.Data.Money
		
		local Level = leaderstats:FindFirstChild("Level")
		Level.Value = profile.Data.Level
	end
end

function PlayerManager:GetMoney(player: Player)
	
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data.Money
end

function PlayerManager:AddMoney(player: Player, value: IntValue)
	
	local profile = self.Profiles[player]
	if not profile then return end
	profile.Data.Money += value
	refreshLeaderstats(player)
	return profile
end

function PlayerManager:GetLevel(player: Player)

	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data.Level
end

function PlayerManager:AddUnlockId(player: Player, unlockId : string)
	local profile = self.Profiles[player]
	if not profile then return end
	if not table.find(profile.Data.UnlockIds, unlockId) then
		table.insert(profile.Data.UnlockIds, unlockId)
	end
	
	return profile
end

function PlayerManager:GetUnlockIds(player: Player)
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data.UnlockIds
end

function PlayerManager:AddDoorId(player: Player, unlockId : string)
	local profile = self.Profiles[player]
	if not profile then return end
	if not table.find(profile.Data.UnlockIds,unlockId) then
		table.insert(profile.Data.UnlockIds, unlockId)
	end
	
	return profile
end

function PlayerManager:GetDoorIds(player: Player)
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data.DoorIds
end



return PlayerManager