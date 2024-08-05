local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")


local Libraries = ServerScriptService.Libraries

local PlayerManager = require(Libraries.PlayerManager)

local Tycoon = require(script.Parent.TycoonClass)


local function FindSpawn()
	for _, spawnPoint in ipairs(game.Workspace.SpawnPoints:GetChildren()) do
		if(spawnPoint:GetAttribute("Occupied") == false) then
			return spawnPoint
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	local tycoon = Tycoon.new(player, FindSpawn())
	tycoon:Init()
end)
