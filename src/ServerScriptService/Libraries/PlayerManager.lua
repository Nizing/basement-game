local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage.Remotes
local Update_Client = Remotes.Update_Client

local PlayerManager = {}

PlayerManager.Profiles = {}

local gamepasses = {
	
	[948423417] = function(player)
        PlayerManager:SetById(player, 2, "globalMultiplier")
    end,

	[948490372] = function(player)
		PlayerManager:SetById(player, true, "Sprinting")
	end

}

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

function PlayerManager:Loaded(player: Player)
	if self.Profiles[player] then return true end
	return false
end

function PlayerManager:RegisterGamepasses(player)
	for id, passfunction in pairs(gamepasses) do
		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, id) then
			passfunction(player)
		end
	end
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

function PlayerManager:SetById(player: Player, value: IntValue, Id)
	local profile = self.Profiles[player]
	if not profile then return end
	profile.Data[Id] = value
	refreshLeaderstats(player)
	updateClient(player, profile.Data)
	return profile
end

function PlayerManager:GetById(player: Player, Id)
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data[Id]
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
	if not table.find(profile.Data.DoorIds, unlockId) then
		table.insert(profile.Data.DoorIds, unlockId)
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
--Use this for upgrades and levels
function PlayerManager:SetValueInTableByIndex(player : Player, value : IntValue, Table, index)
	local profile = self.Profiles[player]
	if not profile then return end

	profile.Data[Table][index] = value
end

function PlayerManager:GetMultiplier(player : Player, Index : string)
	local profile = self.Profiles[player]
	if not profile then return end
	return profile.Data.Multipliers[Index]
end

function PlayerManager:OnRebirth(player)
	local profile = self.Profiles[player]
	if not profile then return end
	local Data = profile.Data

	Data.Money = 0
	Data.Tears = 0
	Data.Physique = 0
	Data.Looks = 0
	Data.Diet = 0
	Data.Level = 0
	Data.ItemCount = 0

	table.clear(Data.UnlockIds)
	table.clear(Data.DoorIds)
	table.clear(Data.VideoIds)
	table.insert(Data.VideoIds, 1)

	
	for i, _ in pairs(Data.Upgrades) do
		Data.Upgrades[i] = 0
	end

	for i, _ in pairs(Data.ClientLevels) do
		Data.ClientLevels[i] = 0
	end

	for i, _ in pairs(Data.StronkLevels) do
		Data.StronkLevels[i] = 0
	end



	table.clear(Data.PassiveIncomes)

	Data.Multipliers.Money = 0.6
	Data.Multipliers.Tears = 1
	Data.Multipliers.Physique = 1
	Data.Multipliers.Looks = 1
	Data.Multipliers.Diet = 1

end

return PlayerManager