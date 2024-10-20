local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local guiAnimation = require(script.Parent.guiAnimation)
local profileModule = require(script.Parent.ProfileData)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)

local DietPopUp = ReplicatedStorage.Assets.DietPopUp
local Start_Cooking = ReplicatedStorage.Remotes.Start_Cooking
local Add_Diet = ReplicatedStorage.Remotes.Add_Diet

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui

local TransitionsGui = PlayerGui.Transitions
local StovetopGui = PlayerGui.StovetopGui
local StovetopFrame = StovetopGui.Frame

local Slider = StovetopFrame .Slider

local Bar = Slider.Bar
local CookButton = Slider.Cook
local Perfect = Slider.Perfect

local Container = StovetopFrame.Container
local StopButton = Container.Stop
local Errors = Container.Errors
local Rawness = Container.Rawness
local FoodButton = Container.Food


local j = 0
local function generateBar()
	while true do
		for i = 0, 0.95, 0.01 do
			j = i
			task.wait(0.01)
			Bar.Position = UDim2.new(i, 0, -0.03 ,0)
		end

		for i = 0.95, 0 , -0.01 do
			j = i
			task.wait(0.01)
			Bar.Position = UDim2.new(i, 0, -0.03 ,0)
		end
	end
end

local RawImage  = "rbxassetid://120001179131370"
local CookedImage = "rbxassetid://114640031677027"
local thread

Start_Cooking.OnClientEvent:Connect(function()
    player.Character.Humanoid.WalkSpeed = 0
    StovetopGui.Enabled = true
    guiAnimation.popupFrame(StovetopFrame, 1)
    Container.Food.Image = RawImage

    thread = coroutine.create(function()
        generateBar()
    end)
    coroutine.resume(thread)
end)

local GoodHeat = 5
local MaxErrors = 5
local MaxHeat = 7
local currHeat = 0
local currErrors = 0

canTake = false



CookButton.Activated:Connect(function()
	if j > Perfect.Position.X.Scale - 0.1 and j < Perfect.Position.X.Scale + 0.1 then
		currHeat += 1
        Rawness.Text = currHeat .. "/" .. GoodHeat.. " Done"
		if currHeat >= GoodHeat and canTake == false then
			canTake = true
            Container.Food.Image = CookedImage
        end
		local newPosition = UDim2.new(math.random(1, 8) / 10, 0 ,0 ,0)
		Perfect.Position = newPosition
    else
        currErrors += 1
        Errors.Text = currErrors .. "/" .. MaxErrors .. " Errors"
	end

    if currErrors >= MaxErrors or currHeat >= MaxHeat then
        player.Character.Humanoid.Health = 0 --just fucking kill the player fucking retard
        coroutine.close(thread)
        canTake = false
        StovetopGui.Enabled = false
    end
end)

FoodButton.Activated:Connect(function()
    if canTake == true then
        canTake = false
        Container.Food.Image = RawImage
        currErrors = 0
        currHeat = 0
        Rawness.Text = currHeat .. "/" .. GoodHeat .. " Done"
        Errors.Text = currErrors .. "/" .. MaxErrors .. " Errors"
        Add_Diet:FireServer()
        local profile = profileModule.GetProfile()
        local text = "+ ".. FormatNumbers.FormatCompact(profile.Multipliers.Diet) .. " Diet"
        guiAnimation.createDynamicPopup(DietPopUp, TransitionsGui, text)
    else
        print("STILL RAW")
    end
end)

local originalPosition = StovetopFrame.Position
local originalSize = StovetopFrame.Size
StopButton.Activated:Connect(function()
    coroutine.close(thread)
    guiAnimation.closeFrame(StovetopFrame, 1, originalPosition, originalSize)
    StovetopGui.Enabled = false
    player.Character.Humanoid.WalkSpeed = 16
end)




