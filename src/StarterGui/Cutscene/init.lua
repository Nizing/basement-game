local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Play_Cutscene : RemoteEvent = Remotes.Play_Cutscene

local Camera = game.Workspace.CurrentCamera

local Dialogue = require(script.Dialogues)
local Images = require(script.Images)

local playerGui = script.Parent
local AssetsFolder = playerGui.Assets
local ButtonSound = AssetsFolder.Button
local End_Cutscene : BindableEvent = AssetsFolder.End_Cutscene

local CutScene = {}

local default = 0.1 -- 0.1
local default2 = 2.5 --2.5

function startGame(trash)
	Play_Cutscene:FireServer()
	Camera.CameraType = Enum.CameraType.Custom
	--delete temp objects
	for _, v in pairs(trash) do
		v:Destroy() 
	end
	End_Cutscene:Fire()
end

local function getCutsceneAssets(bench : Model)
	task.wait(1)
	local newAssets : Model = ReplicatedStorage.Cutscene_Assets:Clone()
    newAssets:PivotTo(bench.PrimaryPart.CFrame)
    newAssets.Parent = game.Workspace
    return newAssets
end

function CutScene.Play(SpeakerLabel, ImageLabel, TextLabel, SkipButton, bench)
	local skip = false
	local trash = {}
	local newAssets = getCutsceneAssets(bench)
	table.insert(trash, newAssets)
	Camera.CameraType = Enum.CameraType.Scriptable
	local ActionsDicModule = require(script.ActionsDic)
	local CameraDicModule = require(script.CameraDic)

	local newCrush = ActionsDicModule.CreateCharacter(newAssets, bench)
	table.insert(trash, newCrush)
	local ActionsDic = ActionsDicModule.returnActions(newCrush, newAssets)
	local CameraDic = CameraDicModule.returnCameraDic(newCrush, newAssets)

	SkipButton.Activated:Connect(function()
		skip = true
	end)

	for j, v in pairs(Dialogue) do
		if skip == true then
			startGame(trash)
			break
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
				break
			end

			task.wait(default / CameraDic[j].Speed)

			ButtonSound:Play()
			TextLabel.Text = string.sub(v.Message, 1, i)
		end
		task.wait(default2)
	end
	startGame(trash)
end

return CutScene
