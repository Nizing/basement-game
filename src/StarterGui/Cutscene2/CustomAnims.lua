local idleAnimationId = "http://www.roblox.com/asset/?id=507766388"
local walkAnimationId = "http://www.roblox.com/asset/?id=913402848"
local runAnimationId = "http://www.roblox.com/asset/?id=913376220"
local sitAnimationId = "http://www.roblox.com/asset/?id=2506281703"

local CustomAnims = {}

local function stopAllAnim(humanoid)
	for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

local function loadAnimation(Id, Humanoid) 
	local newAnimation = Instance.new("Animation")
	newAnimation.AnimationId = Id
	local track = Humanoid.Animator:LoadAnimation(newAnimation)
	return track
end

function CustomAnims.AddAnimations(Humanoid)
	local idleTrack = loadAnimation(idleAnimationId, Humanoid)
	local runTrack = loadAnimation(runAnimationId, Humanoid)
	idleTrack:Play()
	
	Humanoid.Running:Connect(function(speed)
		if speed > 0 then
			stopAllAnim(Humanoid)
			runTrack:Play()
		elseif speed == 0 then
			stopAllAnim(Humanoid)
			idleTrack:Play()
		end
	end)
	
end

return CustomAnims
