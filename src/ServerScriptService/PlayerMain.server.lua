local Players = game:GetService("Players")
local ServerScripService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")


local PlayerManager = require(ServerScripService.Libraries.PlayerManager)
local DataHandler = require(ServerScripService.DataHandler)

local function onPlayerAdded(player)
	DataHandler.LoadData(player)
	PlayerManager.spawnLeaderstats(player)
end

local function onPlayerRemoving(player)
	DataHandler.Release(player)
end

for player in Players:GetPlayers() do
	task.spawn(onPlayerAdded , player)
end

local function addPhone(player)
	local new_phone = ServerStorage.Phone:Clone()
	new_phone.Parent = player.Backpack
end
Players.PlayerAdded:Connect(function(player)
	onPlayerAdded(player)

	player.CharacterAdded:Connect(function(character)
		
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				task.wait(3)
				player:LoadCharacter()
				addPhone(player)
			end)
		end
	end)
end)
Players.PlayerRemoving:Connect(onPlayerRemoving)





