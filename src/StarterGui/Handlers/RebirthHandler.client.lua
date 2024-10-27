local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rebirth_PopUp : RemoteEvent = ReplicatedStorage.Remotes.Rebirth_PopUp

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local Assets = playerGui.Assets

local Handlers = script.Parent
local guiAnimation = require(Handlers.guiAnimation)

local MainGui = playerGui.MainGui
local RebirthFrame = MainGui.RebirthPopUpFrame

local CFramePart
Rebirth_PopUp.OnClientEvent:Connect(function(cframePart)
    RebirthFrame.Visible = true
    guiAnimation.popupFrame(RebirthFrame, 1)
    CFramePart = cframePart
end)

local originalPosition = RebirthFrame.Position
local originalSize = RebirthFrame.Size
RebirthFrame.No.Activated:Connect(function()
    guiAnimation.closeFrame(RebirthFrame, 1, originalPosition, originalSize)
    RebirthFrame.Visible = false
end)

RebirthFrame.Yes.Activated:Connect(function()
    Assets.Start_Cutscene2:Fire(CFramePart)
    RebirthFrame.Visible = false
end)