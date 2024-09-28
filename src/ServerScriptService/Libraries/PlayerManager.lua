local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
local Update_Client = Remotes.Update_Client



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

local function updateClient(player: Player, Data)
	Update_Client:FireClient(player, Data)
end

function PlayerManager:GetData(player :  Player)
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data
	
end
function PlayerManager:AddById(player: Player, value: IntValue, Id)
	local profile = self.Profiles[player]
	if not profile then return end
	profile.Data[Id] += value
	refreshLeaderstats(player)
	updateClient(player, profile.Data)
	return profile
end

function PlayerManager:AddToTable(player: Player, value: IntValue, Table: table)
	local profile = self.Profiles[player]
	if not profile then return end
	if not table.find(profile.Data[Table], value) then
		table.insert(profile.Data[Table], value)
	end
	return profile
end


function PlayerManager:GetTears(player: Player)
	
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data.Tears
end

function PlayerManager:AddTears(player: Player, value: IntValue)
	
	local profile = self.Profiles[player]
	if not profile then return end
	profile.Data.Tears += value
	refreshLeaderstats(player)
	updateClient(player, profile.Data)
	return profile
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
	updateClient(player, profile.Data)
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

function PlayerManager:VideoUnlock(player : Player, index)
	local profile = self.Profiles[player]
	if not profile then return end
	profile.Data.Videos[index] = false
end





return PlayerManager