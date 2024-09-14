local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Main_Folder = script.Parent

local ButtonSound = Main_Folder.Button
local BGM = Main_Folder.BGM
local VineBoom = Main_Folder.VineBoom
local FartSounds = Main_Folder.Fart
local Laughing = Main_Folder.Laughing

local Cutscene = game.Workspace.Cutscene
local Rigs = ReplicatedStorage.Rigs
--Paths
local Paths = Cutscene.Path
--Camera
local Camera = game.Workspace.CurrentCamera
--Modules
local Images = require(Main_Folder.Images)
local CameraShaker = require(Main_Folder.CameraShaker)
local CustomAnim = require(script.CustonAnims)

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	Camera.CFrame = Camera.CFrame * shakeCf
end)
camShake:Start()

local function playSounds()
	FartSounds:Play()
	VineBoom:play()
	Laughing:Play()
end

local function stopSounds()
	FartSounds:Stop()
	VineBoom:Stop()
	Laughing:Stop()
end

local function addFace(i, face_string, CrushCharacter)
	CrushCharacter.Head.face.Texture = Images[face_string]
end

local ActionsDic = {}

function ActionsDic.returnActions(CrushCharacter)
	local Actions = {
		[1] = function()
			BGM:Play()
			BGM.TimePosition = 7
		end,
		[6] = function()
			CrushCharacter.Humanoid:MoveTo(Paths.Path1.Position)
		end,
		[7] = function()
			CrushCharacter.Humanoid:MoveTo(Paths.Path2.Position)
		end,
		[10] = function()
			CrushCharacter.Humanoid:MoveTo(Paths.Path3.Position)
		end,
		[15] = function()
			BGM:Stop()
			playSounds()
			camShake:StartShake(2, 8, 0, 0)
			addFace(15, "Disgusted Crush", CrushCharacter)
		end,

		[18] = function()
			camShake:Stop()
			stopSounds()
		end,
		[19] = function()
			playSounds()
			camShake:Start()
			camShake:StartShake(2, 8, 0, 0)
		end,

		[22] = function()
			stopSounds()
			camShake:Stop()
		end,
		[23] = function()
			playSounds()
			camShake:Start()
			camShake:StartShake(2, 8, 0, 0)
		end,
		[25] = function()
			stopSounds()
			camShake:Stop()
		end,
		[27] = function()
			CustomAnim.StandUp(CrushCharacter.Humanoid)
			CrushCharacter.Humanoid:MoveTo(Paths.Path4.Position)
		end,
	}
	return Actions
end

function ActionsDic.CreateCharacter()
	local Character = Rigs.Crush:Clone()
	Character.Parent = Cutscene
	Character:SetPrimaryPartCFrame(Paths.SpawnPoint.CFrame)
	CustomAnim.Init(Character.Humanoid)

	return Character
end

return ActionsDic
