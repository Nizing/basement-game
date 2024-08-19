local CollectionService = game:GetService("CollectionService")
local StarterGui = script.Parent

local MainGui = StarterGui.MainGui
local SettingsGui = StarterGui.SettingsGui

local CryFrame = MainGui.CryFrame
local LevelFrame = MainGui.LevelFrame
local MoneyFrame = MainGui.MoneyFrame
local TearsFrame = MainGui.TearsFrame


local CryButton : ImageButton = CryFrame.CryButton
local LevelLabel = LevelFrame.LevelLabel
local MoneyLabel = MoneyFrame.MoneyLabel
local TearsLabel = TearsFrame.TearsLabel


local Handlers = StarterGui.Handlers

local MainGuiHandler = require(Handlers.MainGui)


MainGuiHandler.Labels_init(LevelLabel, MoneyLabel, TearsLabel)

CryButton.Activated:Connect(function(inputObject, clickCount)
    MainGuiHandler.onCry()
end)



for _, Button in pairs(CollectionService:GetTagged("GuiTween")) do
    Button.MouseEnter:Connect(function(x, y)
        MainGuiHandler.HoverEnter(Button)
    end)
    Button.MouseLeave:Connect(function(x, y)
        MainGuiHandler.HoverLeave(Button)
    end)
end



