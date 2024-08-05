local Players = game:GetService("Players")
local ServerScripService = game:GetService("ServerScriptService")


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

Players.PlayerAdded:Connect(function(player)
	onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				wait(3)
				player:LoadCharacter()
			end)
		end
	end)
end)
Players.PlayerRemoving:Connect(onPlayerRemoving)





