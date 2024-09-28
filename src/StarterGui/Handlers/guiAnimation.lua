local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")


local playerGui = script.Parent.Parent
local Transitions = playerGui.Transitions

local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local guiAnimation = {}

local RNG  = Random.new()
local popUp_Info = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)

function guiAnimation.popUpNotEnough(Button, copyLabel)
    --local RelativePosition =    Mouse.X,Mouse.Y) - Button.AbsolutePosition
    print(Mouse.X)
    local newLabel = copyLabel:Clone()
    newLabel.Position = UDim2.new(0, Mouse.X - Button.AbsolutePosition.X + math.random(350, 600) , 0, Mouse.Y - Button.AbsolutePosition.Y + math.random(150, 300))
    newLabel.Parent = Transitions
    
    task.wait(0.3)
    newLabel:Destroy()
end



return guiAnimation