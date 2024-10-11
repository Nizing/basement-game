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

function guiAnimation.createDynamicPopup(template, parent, customText)
   
    local popup = template:Clone()
    
    local screenGui = parent
    if customText and popup:IsA("TextLabel") then popup.Text = customText end
    if customText and popup:FindFirstChildOfClass("TextLabel") and popup:FindFirstChild("TextLabel") then popup.TextLabel.Text = customText end
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

function guiAnimation.popupFrame(frame, duration)
	-- Store the original position and size
	local originalPosition = frame.Position
	local originalSize = frame.Size

	-- Calculate the starting position (below the screen)
	local startPosition = UDim2.new(
		originalPosition.X.Scale, 
		originalPosition.X.Offset, 
		1, -- Start from the bottom of the screen
		frame.AbsoluteSize.Y -- Offset by the frame's height
	)

	-- Set initial state: at the starting position with zero height
	frame.Position = startPosition
	frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 0)
    local goal = {Size = originalSize, Position = originalPosition}
	-- Create and play the size tween

	local tween = game:GetService("TweenService"):Create(
		frame,
		TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		goal
	)
	tween:Play()
end

function guiAnimation.closeFrame(frame, duration, originalPosition, originalSize)
    -- Store the original position and size
    

    -- Calculate the ending position (below the screen)
    local endPosition = UDim2.new(
        originalPosition.X.Scale, 
        originalPosition.X.Offset, 
        1, -- End at the bottom of the screen
        frame.AbsoluteSize.Y -- Offset by the frame's height
    )

    -- Create and play the size tween
    local sizeTween = game:GetService("TweenService"):Create(
        frame,
        TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 0)}
    )
    sizeTween:Play()

    -- Create and play the position tween
    local positionTween = game:GetService("TweenService"):Create(
        frame,
        TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = endPosition}
    )
    positionTween:Play()

    -- Wait for the tweens to complete before returning
    task.wait(duration)

    -- Reset the frame's position and size to their original values
    frame.Position = originalPosition
    frame.Size = originalSize
end

function guiAnimation.animateGUI(gui)
    -- Set initial properties
    gui.BackgroundTransparency = 1
    gui.Size = UDim2.new(0, 0, 0, 0)
    gui.Visible = true
    
    -- Create tweening info
    local tweenInfo = TweenInfo.new(
        0.5, -- Duration
        Enum.EasingStyle.Back, -- Easing style
        Enum.EasingDirection.Out -- Easing direction
    )
    
    -- Create property table for tweening
    local properties = {
        BackgroundTransparency = 0,
        Size = UDim2.new(0.5, 0, 0.5, 0) -- Adjust this to your desired final size
    }
    
    -- Create and play the tween
    local tween = TweenService:Create(gui, tweenInfo, properties)
    tween:Play()
end

function guiAnimation.animateGUIClose(gui)
    -- Create tweening info
    local tweenInfo = TweenInfo.new(
        0.5, -- Duration
        Enum.EasingStyle.Back, -- Easing style
        Enum.EasingDirection.In -- Easing direction
    )
    
    -- Create property table for tweening
    local properties = {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }
    
    -- Create and play the tween
    local tween = TweenService:Create(gui, tweenInfo, properties)
    tween:Play()
    task.wait(0.5)
    -- Hide the GUI after the animation completes
end

function guiAnimation.ButtonOnClick(button)
    
    -- Store the original properties
    local originalSize = button.Size
    local originalPosition = button.Position

    -- Calculate the animated properties
    local animatedSize = UDim2.new(
        originalSize.X.Scale * 1.1, originalSize.X.Offset * 1.1,
        originalSize.Y.Scale * 1.1, originalSize.Y.Offset * 1.1
    )
    local animatedPosition = UDim2.new(
        originalPosition.X.Scale, originalPosition.X.Offset - 5,
        originalPosition.Y.Scale, originalPosition.Y.Offset - 5
    )

    -- Create and play the animation
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, {
        Size = animatedSize,
        Position = animatedPosition
    })
    tween:Play()

    -- Return to original state
    tween.Completed:Connect(function()
        local reverseTween = TweenService:Create(button, tweenInfo, {
            Size = originalSize,
            Position = originalPosition
        })
        reverseTween:Play()
    end)
end



return guiAnimation