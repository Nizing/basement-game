local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local profileModule = require(script.Parent.ProfileData)

local walkSpeed = 16  -- Default walk speed
local sprintSpeed = 32  -- Sprint speed

local isSprinting = false
local id = "948490372"
-- Function to start sprinting

local function onSprint()
    local profile = profileModule.GetProfile()
    if profile.Sprint == false then 
        MarketplaceService:PromptGamePassPurchase(player, id)
        return
    end
    if not isSprinting then
        isSprinting = true
        local SprintLabel = player.PlayerGui.MainGui.SprintFrame.SprintLabel
         SprintLabel.Text = "Sprint: On"
        humanoid.WalkSpeed = sprintSpeed
    else
        isSprinting = false
        local SprintLabel = player.PlayerGui.MainGui.SprintFrame.SprintLabel
        SprintLabel.Text = "Sprint: Off"
        humanoid.WalkSpeed = walkSpeed
    end
end
-- UserInputService for keyboard input
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftShift then
        onSprint()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftShift then
        onSprint()
    end
end)

local sprintButton = player.PlayerGui.MainGui.SprintFrame.SprintButton
sprintButton.Activated:Connect(onSprint)
sprintButton.TouchTap:Connect(onSprint)
