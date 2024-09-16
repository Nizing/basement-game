local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
--Remotes
local Play_Cutscene : RemoteEvent = Remotes.Play_Cutscene

local PlayerGui = script.Parent.Parent
local CutsceneGui : ScreenGui = PlayerGui.CutsceneGui
local Maingui : ScreenGui = PlayerGui.MainGui
local DialogueFrame = CutsceneGui.DialogueFrame

local ImageLabel = DialogueFrame.ImageLabel
local SpeakerLabel = DialogueFrame.SpeakerLabel
local DialogueLabel = DialogueFrame.DialogueLabel
local SkipButton = DialogueFrame.SkipButton

local CutsceneModule = require(PlayerGui.Cutscene)

local AssetsFolder = PlayerGui.Assets
local End_Cutscene : BindableEvent = AssetsFolder.End_Cutscene

Play_Cutscene.OnClientEvent:Connect(function(bench)
    Maingui.Enabled = false
    CutsceneGui.Enabled = true
    CutsceneModule.Play(SpeakerLabel, ImageLabel, DialogueLabel, SkipButton, bench)
end)

End_Cutscene.Event:Connect(function()
    CutsceneGui.Enabled = false
   Maingui.Enabled = true
end)


