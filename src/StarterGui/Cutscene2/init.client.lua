local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

local Assets = playerGui.Assets

local CutsceneGui = script.Parent.CutsceneGui
local MainGui = playerGui.MainGui
local TransitionsGui = playerGui.Transitions
local CutscenePlayer2 = require(script.CutscenePlayer2)

Assets.Start_Cutscene2.Event:Connect(function(CFramePart)
    CutscenePlayer2.cutsceneTransition(TransitionsGui.TransitionFrame)
    CutsceneGui.Enabled = true
    MainGui.Enabled = false
    CutscenePlayer2.Test(CutsceneGui.DialogueFrame, CFramePart)
end)

