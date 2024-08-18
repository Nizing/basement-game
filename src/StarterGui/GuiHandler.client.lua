local StarterGui = script.Parent

local MainGui = StarterGui.MainGui
local SettingsGui = StarterGui.SettingsGui

local CryFrame = MainGui.CryFrame

local CryButton : ImageButton = CryFrame.CryButton

local Handlers = StarterGui.Handlers

local MainGuiHandler = require(Handlers.MainGui)



CryButton.Activated:Connect(function(inputObject, clickCount)
    MainGuiHandler.onCry()
end)

CryButton.MouseEnter:Connect(function(x, y)
    MainGuiHandler.CryHoverEnter(CryButton)
end)

CryButton.MouseLeave:Connect(function(x, y)
    MainGuiHandler.CryHoverLeave(CryButton)
end)