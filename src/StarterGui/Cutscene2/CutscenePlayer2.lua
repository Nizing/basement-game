local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local MainGui = playerGui.MainGui
local TransitionGui = playerGui.Transitions

local CutsceneFolder = script.Parent
local ActionsDicModule = require(CutsceneFolder.ActionsDic)
local CameraDicModule = require(CutsceneFolder.CameraDic)
local Dialogues = require(CutsceneFolder.Dialogues)
local CustomAnimations = require(CutsceneFolder.CustomAnims)
local Images = require(CutsceneFolder.Images)
local Trove = require(ReplicatedStorage.Packages.Trove)

local Camera = game.Workspace.CurrentCamera
local clickSoundId = "rbxassetid://110201071969580"

local CutscenePlayer2 = {}

local default_speed = 0.05 --0.5
local wait_time = 2.5 -- 2.5
local trove = Trove.new()
local function CloneAssets(PivotPoint : Model)
	local newAssets : Model = ReplicatedStorage.Cutscene_Assets2:Clone()
	newAssets:PivotTo(PivotPoint.PrimaryPart.CFrame - Vector3.new(0, 3, 0))
	newAssets.Parent = game.Workspace
	return newAssets
end

local function setPlayer(CFramePart)
	player.Character:PivotTo(CFramePart.CFrame)
	player.Character.Humanoid.WalkSpeed = 0
end

local function playSound(id, Parent)
	task.spawn(function()
		local newSound = Instance.new("Sound")
		newSound.SoundId = id
		if Parent then newSound.Parent = Parent end
		newSound:Play()
		task.wait(newSound.TimeLength + 2)
		newSound:Destroy()
	end)
end

local function setOriginalPlayer()
	player.Character.Humanoid.WalkSpeed = 16
	Camera.CameraType = Enum.CameraType.Custom
	player.Character.Head.face.Texture = Images["OriginalFace"]
end
local Rebirth_Remote : RemoteEvent = ReplicatedStorage.Remotes.Rebirth_Remote
local function Rebirth(DialoguesFrame, ttrove)
	ttrove:Clean()
	DialoguesFrame.Parent.Enabled = false
	MainGui.Enabled = true
	ActionsDicModule.StopEverything()
	setOriginalPlayer()
	CutscenePlayer2.cutsceneTransition(TransitionGui.TransitionFrame)
	Rebirth_Remote:FireServer()
end

function CutscenePlayer2.Test(DialoguesFrame, CFramePart)
	local SpeakerLabel = DialoguesFrame.SpeakerLabel
	local DialogueLabel = DialoguesFrame.DialogueLabel
	local ImageLabel = DialoguesFrame.ImageLabel
	local SkipButton = DialoguesFrame.SkipButton
	
	local skip = false
	SkipButton.Activated:Connect(function()
		skip = true
	end)
	--Clone assets and make objects
	setPlayer(CFramePart)
	local newAssets = CloneAssets(player.Character)
	trove:Add(newAssets)
	local newCrush = newAssets.Crush
	CustomAnimations.AddAnimations(newCrush.Humanoid)
	local ActionsDic = ActionsDicModule.returnActions(newCrush, newAssets)
	local CameraDic = CameraDicModule.returnCameraDic(newCrush, newAssets)
	--Start Cutscene
	Camera.CameraType = Enum.CameraType.Scriptable
	
	for j, v in pairs(Dialogues) do
		--Change camera
		if CameraDic[j] then Camera.CFrame = CameraDic[j].Shot end 
		--Make the Characters Move
		if ActionsDic[j] then ActionsDic[j]() end
		SpeakerLabel.Text = v.Speaker
		ImageLabel.Image = Images[v.Speaker]
		for i = 1, string.len(v.Message) do
			if skip == true then Rebirth(DialoguesFrame, trove) return end
			task.wait(default_speed / CameraDic[j].Speed)
			playSound(clickSoundId, CutsceneFolder)
			DialogueLabel.Text = string.sub(v.Message, 1, i)
		end
		task.wait(wait_time)
	end
	Rebirth(DialoguesFrame, trove)
end

function CutscenePlayer2.cutsceneTransition(Frame)
	local goal = {}
	local goal2 = {}
	goal.BackgroundTransparency = 0
	goal2.BackgroundTransparency = 1

	local tweenInfo1 = TweenInfo.new(0.1)
	local tweenInfo2 = TweenInfo.new(2)
	local track1 = TweenService:Create(Frame, tweenInfo1, goal)
	local track2 = TweenService:Create(Frame, tweenInfo2, goal2)
	track1:Play()
	task.wait(tweenInfo1.Time + 0.5)
	track2:Play()
end

return CutscenePlayer2
