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

function guiAnimation.createDynamicPopup(template, parent)
   
    local popup = template:Clone()
    
    local screenGui = parent
    
    -- Set random position
    local randomX = math.random(10, 90) / 100  -- Random value between 0.1 and 0.9
    local randomY = math.random(10, 90) / 100  -- Random value between 0.1 and 0.9
    popup.Position = UDim2.new(randomX, 0, randomY, 0)
    
    popup.AnchorPoint = Vector2.new(0.5, 0.5)
    popup.Parent = screenGui

    -- Initial size (small)
    popup.Size = UDim2.new(0, 0, 0, 0)

    -- Appear with size tween
    local tweenAppear = TweenService:Create(popup, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 200, 0, 100)  -- Adjust this size as needed
    })
    tweenAppear:Play()

    -- Optional: Add some rotation or other effects
    local tweenRotate = TweenService:Create(popup, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Rotation = math.random(-10, 10)  -- Slight random rotation
    })
    tweenRotate:Play()

    -- Wait for 2 seconds
    task.wait(.6)

    -- Disappear with size and transparency tween
    local tweenDisappear = TweenService:Create(popup, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        Transparency = 1  -- Fade out
    })
    tweenDisappear:Play()

    tweenDisappear.Completed:Connect(function()
        popup:Destroy()
    end)
end



return guiAnimation