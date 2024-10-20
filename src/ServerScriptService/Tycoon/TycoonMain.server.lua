local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")


local Libraries = ServerScriptService.Libraries
local Remotes = ReplicatedStorage.Remotes
--Remotes
local Play_Cutscene : RemoteEvent = Remotes.Play_Cutscene

local PlayerManager = require(Libraries.PlayerManager)

local Tycoon = require(script.Parent.TycoonClass)
local CutsceneModule = require(script.Parent.server_cutscene)

local function FindSpawn()
	for _, spawnPoint in ipairs(game.Workspace.SpawnPoints:GetChildren()) do
		if(spawnPoint:GetAttribute("Occupied") == false) then
			return spawnPoint
		end
	end
end


Players.PlayerAdded:Connect(function(player)
	local spawn = FindSpawn()
	local tycoon = Tycoon.new(player, spawn)
	tycoon:Init()
	
	CutsceneModule.startCutScene(player , spawn)
	--Cutscene ended
	Play_Cutscene.OnServerEvent:Once(function(c_player)
		if c_player == player then
			CutsceneModule.endCutScene(c_player, tycoon)
		end
	end)
end)
