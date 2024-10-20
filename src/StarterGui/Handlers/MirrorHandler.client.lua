local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local guiAnimation = require(script.Parent.guiAnimation)
local profileModule = require(script.Parent.ProfileData)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)

local player = Players.LocalPlayer
local MirrorGui = player.PlayerGui.MirrorGui
local MirrorFrame = MirrorGui.Frame
local Reflection = MirrorFrame.Reflection

local LooksmaxEnter : RemoteEvent = ReplicatedStorage.Remotes.LooksmaxEnter
local Add_Looks : RemoteEvent = ReplicatedStorage.Remotes.Add_Looks


Reflection.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)


local originalButton = ReplicatedStorage.Assets.Dirt


local LooksPopUp = ReplicatedStorage.Assets.LooksPopUp
local Transitions = player.PlayerGui.Transitions

local numButtons = 6
local clickedButtons = 0

function onButtonClicked(clonedButton)
	clickedButtons += 1
	clonedButton:Destroy()
	
	if clickedButtons == numButtons then
		Add_Looks:FireServer()
        local profile = profileModule.GetProfile()
        local text = "+ " .. FormatNumbers.FormatCompact(profile.Multipliers.Looks) .. " Looks"
        guiAnimation.createDynamicPopup(LooksPopUp, Transitions, text)
		return "Finished"
	end
end

local function playRound()
    clickedButtons = 0
    for _, v in pairs(MirrorFrame.Container:GetChildren()) do
        v:Destroy()
    end
    
    for i = 1, numButtons, 1 do

		local clonedButton = originalButton:Clone()
		clonedButton.Position = UDim2.new(math.random(10, 90) / 100, 0, math.random(10, 90) / 100, 0)
		clonedButton.Size = UDim2.new(math.random(20, 30) / 100, 0 , math.random(20, 30) / 100, 0)
		clonedButton.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        clonedButton.Parent = MirrorFrame.Container

        clonedButton.Activated:Once(function()
			local res = onButtonClicked(clonedButton)
			if res == "Finished" then
				playRound()
			end
		end)
    end
end

LooksmaxEnter.OnClientEvent:Connect(function()
    print("??")
    MirrorGui.Enabled = true
    guiAnimation.popupFrame(MirrorFrame, 1)
    player.Character.Humanoid.WalkSpeed = 0
    playRound()
end)

local originalPosition = MirrorFrame.Position
local originalSize = MirrorFrame.Size

MirrorGui.Frame.Stop.Activated:Connect(function()
    guiAnimation.closeFrame(MirrorFrame, 1 , originalPosition, originalSize)
    MirrorGui.Enabled = false
    player.Character.Humanoid.WalkSpeed = 16
end)