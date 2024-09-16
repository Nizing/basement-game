--Ids
local playerGui = script.Parent.Parent.Parent
local AssetsFolder = playerGui.Assets
local RunAnim = AssetsFolder.RunAnim
local IdleAnim = AssetsFolder.Animation1
local SitAnim = AssetsFolder.SitAnim



local CustomAnims = {}

local function stopAllAnim(humanoid)
	for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

function CustomAnims.Init(humanoid: Humanoid, bench)
	local runTrack = humanoid.Animator:LoadAnimation(RunAnim)
	local IdleTrack = humanoid.Animator:LoadAnimation(IdleAnim)
	local sitTrack = humanoid.Animator:LoadAnimation(SitAnim)
	local seat1 = bench.Seat1

	

	humanoid.Running:Connect(function(speed)
		if speed > 0 then
			stopAllAnim(humanoid)
			runTrack:Play()
		elseif speed == 0 then
			stopAllAnim(humanoid)
			IdleTrack:Play()
		end
	end)

	local done = false
	seat1.Touched:Connect(function(hit)
		if done == true then
			return
		end

		if hit.Parent:FindFirstChild("Humanoid") then
			humanoid.Parent:SetPrimaryPartCFrame(seat1.CFrame * CFrame.new(0, 1.35, 0))
			stopAllAnim(humanoid)
			sitTrack:Play()
			runTrack:Stop()
			humanoid.Sit = true
			task.wait(0.1)
			humanoid.Parent.HumanoidRootPart.Anchored = true
			
			done = true
		end
	end)
end

function CustomAnims.StandUp(humanoid: Humanoid)
	stopAllAnim(humanoid)
	humanoid.Sit = false
	humanoid.Parent.HumanoidRootPart.Anchored = false
end

return CustomAnims
