local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Play_Cutscene : RemoteEvent = Remotes.Play_Cutscene

local Camera = game.Workspace.CurrentCamera

local Dialogue = require(script.Dialogues)
local Images = require(script.Images)
local ActionsDicModule = require(script.ActionsDic)
local CameraDicModule = require(script.CameraDic)
local Trove = require(ReplicatedStorage.Packages.Trove)

local playerGui = script.Parent
local AssetsFolder = playerGui.Assets
local ButtonSound = AssetsFolder.Button
local End_Cutscene : BindableEvent = AssetsFolder.End_Cutscene

local player = game.Players.LocalPlayer
local trove = Trove.new()

local CutScene = {}

local default = 0.05 -- 0.1
local default2 = 2.5 --2.5

function startGame(trash)
	End_Cutscene:Fire()
	Play_Cutscene:FireServer()
	Camera.CameraType = Enum.CameraType.Custom
	--delete temp objects
	
	trove:Clean()
	ActionsDicModule.StopEverything()
end

local function getCutsceneAssets(bench : Model)
	task.wait(0.5)
	local newAssets : Model = ReplicatedStorage.Cutscene_Assets:Clone()
    newAssets:PivotTo(bench.PrimaryPart.CFrame)
    newAssets.Parent = game.Workspace
    return newAssets
end

function CutScene.Play(SpeakerLabel, ImageLabel, TextLabel, SkipButton, bench)
	local skip = false
	local trash = {}
	local newAssets = getCutsceneAssets(bench)
	trove:Add(newAssets)
	Camera.CameraType = Enum.CameraType.Scriptable
	

	local newCrush = ActionsDicModule.CreateCharacter(newAssets, bench)
	trove:Add(newCrush)
	local ActionsDic = ActionsDicModule.returnActions(newCrush, newAssets)
	local CameraDic = CameraDicModule.returnCameraDic(newCrush, newAssets)

	SkipButton.Activated:Connect(function()
		skip = true
	end)

	trove:Connect(player.Character.Humanoid.Died, function()
		playerGui.CutsceneGui.onDeath.Visible = true
	end)

	for j, v in pairs(Dialogue) do
		if skip == true then
			startGame(trash)
			return
		end

		if CameraDic[j] then
			Camera.CFrame = CFrame.new(CameraDic[j].Position, CameraDic[j].LookPosition)
		end
		if ActionsDic[j] then
			ActionsDic[j]()
		end

		SpeakerLabel.Text = v.Speaker
		ImageLabel.Image = Images[v.Speaker]

		for i = 1, string.len(v.Message) do
			if skip == true then
				startGame(trash)
				return
			end

			task.wait(default / CameraDic[j].Speed)

			ButtonSound:Play()
			TextLabel.Text = string.sub(v.Message, 1, i)
		end
		task.wait(default2)
	end
	startGame(trash)
end

local TweenService = game:GetService("TweenService")

function CutScene.cutsceneTransition(Frame)
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

return CutScene
