local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Nuke_Countdown = ReplicatedStorage.Remotes.Nuke_Countdown
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local NukeGui = playerGui.NukeGui



Nuke_Countdown.OnClientEvent:Connect(function(Number)
    NukeGui.Enabled = true
    NukeGui.TextLabel.Text = "Nuke Incoming: " .. Number
    if Number == 0 then
        NukeGui.TextLabel.Text = "Im sorry"
        task.wait(2)
        NukeGui.Enabled = false
    end
end)

