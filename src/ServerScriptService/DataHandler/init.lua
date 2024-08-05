local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")


local ProfileService = require(ServerScriptService.Libraries.ProfileService)
local Template = require(script.Template)
local Manager = require(ServerScriptService.Libraries.PlayerManager)

local ProfileStore = ProfileService.GetProfileStore("Production", Template)

local DataHandler = {}

function DataHandler.LoadData(player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)
	if profile == nil then
		player:Kick("Data issue. If issue persists please contact us")
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		Manager.Profiles[player] = nil
		player:Kick("Data issue. If issue persists please contact us")
	end)

	if player:IsDescendantOf(Players) == true then
		Manager.Profiles[player] = profile
	else
		profile:Release()
	end

end

function DataHandler.Release(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	profile:Release()
end

return DataHandler
