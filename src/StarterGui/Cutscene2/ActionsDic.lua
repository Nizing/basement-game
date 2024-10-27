local Players = game:GetService("Players")
local CutsceneFolder = script.Parent
local Images = require(CutsceneFolder.Images)
local CameraShaker = require(CutsceneFolder.CameraShaker)
local MangoPhonkId = "rbxassetid://85374717554779"
local BGMId = "rbxassetid://107567937652662"
--local SheKnowsId = 

local Camera = game.Workspace.CurrentCamera
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	Camera.CFrame = Camera.CFrame * shakeCf
end)

local player = Players.LocalPlayer
local ActionsDic = {}

local function changeFace(Character , Image)
	Character.Head.face.Texture = Image
end

local function makeSound(id, Parent, startTime)
	local newSound = Instance.new("Sound")
	newSound.SoundId = id
	if Parent then newSound.Parent = Parent end
	if startTime then newSound.TimePosition = startTime end
	return newSound
end

local function playSound(id, Parent, startTime)
	task.spawn(function()
		local newSound = makeSound(id, Parent, startTime)
		newSound:Play()
		task.wait(newSound.TimeLength)
		newSound:Destroy()
	end)
end

local MangoPhonkTrack = makeSound(MangoPhonkId, CutsceneFolder , 55)
local BGM = makeSound(BGMId, CutsceneFolder)
function ActionsDic.returnActions(CrushCharacter, Assets) 
	local Paths = Assets.Paths
	
	local Actions = {
		[1] = function()
			BGM:Play()
		end,
		[2] = function()
			CrushCharacter.Humanoid:MoveTo(Paths.Path1.Position)
		end,
		[12] = function()
			changeFace(player.Character, Images["He Who Knows"])
			BGM:Stop()
			BGM:Destroy()
			MangoPhonkTrack:Play()
			camShake:Start()
			camShake:StartShake(2, 8, 0, 0)
		end,
		[16] = function()
			CrushCharacter.Humanoid:MoveTo(Paths.Path2.Position)
		end,
		[17] = function()
			camShake:Stop()
		end
	}
	return Actions
end

function ActionsDic.StopEverything()
	BGM:Stop()
	MangoPhonkTrack:Stop()
	camShake:Stop()
end

return ActionsDic