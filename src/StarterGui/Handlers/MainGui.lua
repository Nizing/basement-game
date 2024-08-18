local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage.Remotes
local Handlers = script.Parent

local Animations = require(Handlers.Animations)
local Cry_Remote = Remotes.Cry_Remote

local Player = Players.LocalPlayer
local MainGui = {}



local crydeb = false
local crydeb_int = 0.1
function MainGui.onCry()
    if crydeb == false then
        crydeb = true
        Cry_Remote:FireServer()
        Animations.CryAnimation(Player)
        task.wait(crydeb_int)
        crydeb = false
    else
        return false
    end
end

function MainGui.CryHoverEnter(Button : ImageButton)
    local goal = {}
    goal.Position = UDim2.new(0.04, 0, 0.04, 0) --{-0.08, 0},{-0.08, 0}
    goal.Size = UDim2.new(1.03, 0, 0.909, 0)--{1.177, 0},{1.15, 0}
    local Tweeninfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    local Tween = TweenService:Create(Button, Tweeninfo, goal)

    
    Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Tween:Play()
end

function MainGui.CryHoverLeave(Button : ImageButton)
    local goal = {}
    goal.Position = UDim2.new(0.067, 0, 0.067, 0) --{0.067, 0},{0.067, 0}
    goal.Size = UDim2.new(0.843, 0, 0.933, 0) --{0.843, 0},{0.933, 0}
    local Tweeninfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    local Tween = TweenService:Create(Button, Tweeninfo, goal)
    
    
    Button.ImageColor3 = Color3.fromRGB(227, 227, 227)
    Tween:Play()
end


return MainGui