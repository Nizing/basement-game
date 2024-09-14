local Camera = game.Workspace.CurrentCamera

local Dialogue = require(script.Dialogues)
local Images = require(script.Images)

local ButtonSound = script.Button

local CutScene = {}

local default = 0.1
local default2 = 2.5

function startGame()
	print("remote fired")
	--fire remote to start
end

function CutScene.Play(SpeakerLabel, ImageLabel, TextLabel, SkipButton)
	local skip = false
	Camera.CameraType = Enum.CameraType.Scriptable
	local ActionsDicModule = require(script.ActionsDic)
	local CameraDicModule = require(script.CameraDic)

	local newCrush = ActionsDicModule.CreateCharacter()

	local ActionsDic = ActionsDicModule.returnActions(newCrush)
	local CameraDic = CameraDicModule.returnCameraDic(newCrush)

	SkipButton.Activated:Connect(function()
		skip = true
	end)

	for j, v in pairs(Dialogue) do
		if skip == true then
			startGame()
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
				startGame()
				break
			end

			task.wait(default / CameraDic[j].Speed)

			ButtonSound:Play()
			TextLabel.Text = string.sub(v.Message, 1, i)
		end
		task.wait(default2)
	end
	startGame()
end

return CutScene
