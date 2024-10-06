local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Remotes = ReplicatedStorage.Remotes

local Play_Cutscene : RemoteEvent = Remotes.Play_Cutscene

local server_cutscene = {}

local benches = game.Workspace:WaitForChild("benches")

local function findBench(Index)
	for _, v in pairs(benches:GetChildren()) do
		if v:GetAttribute("Index") == Index then
			return v
		end
	end
end

function server_cutscene.startCutScene(player, spawn)
	local bench = findBench(spawn:GetAttribute("Index"))
	player:LoadCharacter()
	player.Character:PivotTo(bench.Seat.CFrame)
	Play_Cutscene:FireClient(player, bench)
	task.wait(1)
	player.Character.PrimaryPart.Anchored = true
end

function server_cutscene.endCutScene(c_player, tycoon)
		c_player.Character.PrimaryPart.Anchored = false
		c_player.Character.Humanoid.Sit = false

		local new_phone = ServerStorage.Phone:Clone()
		new_phone.Parent = c_player.Backpack
		local tycoonSpawn = tycoon:SetSpawn(c_player)
		task.wait(0.1)
		c_player.Character:PivotTo(tycoonSpawn.CFrame * CFrame.new(0 , 2 ,0))
end



return server_cutscene