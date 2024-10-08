local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local StarterGui = script.Parent

local MainGui = StarterGui.MainGui
local SettingsGui = StarterGui.SettingsGui


local CryFrame = MainGui.CryFrame
local LevelFrame = MainGui.LevelFrame
local MoneyFrame = MainGui.MoneyFrame
local TearsFrame = MainGui.TearsFrame

local CryButton : ImageButton = CryFrame.CryButton
local Next : TextButton = TearsFrame.Next
local Back : TextButton = TearsFrame.Back

local LevelLabel = LevelFrame.LevelLabel
local MoneyLabel = MoneyFrame.MoneyLabel
local TearsLabel = TearsFrame.TearsLabel


local Handlers = StarterGui.Handlers

local MainGuiHandler = require(Handlers.MainGui)
local PhoneHandler = require(Handlers.PhoneHandler)
local gamepassHandler = require(Handlers.gamepassHandler)

local Assets = StarterGui.Assets
local End_Cutscene : BindableEvent = Assets.End_Cutscene

local Update_Phone : RemoteEvent = ReplicatedStorage.Remotes.Update_Phone


--Labels Updating
MainGuiHandler.Labels_init(LevelLabel, MoneyLabel, TearsLabel)

Next.Activated:Connect(function()
    MainGuiHandler.Next(TearsFrame)
end)

Back.Activated:Connect(function()
    MainGuiHandler.Back(TearsFrame)
end)



--Cry
CryButton.Activated:Connect(MainGuiHandler.onCry)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.C then
        MainGuiHandler.onCry()
    end
end)

--Collections
local function initColletions()

    local function onGuiTween(Button)
        local OriginalSize = Button.Size
        Button.MouseEnter:Connect(function(x, y)
            MainGuiHandler.HoverEnter(Button)
        end)
        Button.MouseLeave:Connect(function(x, y)
            MainGuiHandler.HoverLeave(Button, OriginalSize)
        end)
    end

    for _, Button in pairs(CollectionService:GetTagged("GuiTween")) do
       onGuiTween(Button)
    end
   
    
    
    for _, Button : TextButton in pairs(CollectionService:GetTagged("Close")) do
        Button.Activated:Connect(function()
            MainGuiHandler.CloseAncestor(Button)
        end)
    end
    --monetization
    for _, Button in pairs(CollectionService:GetTagged("GamepassButton")) do
        gamepassHandler.configGamepass(Button)
    end
    CollectionService:GetInstanceAddedSignal("GamepassButton"):Connect(gamepassHandler.configGamepass)

    for _, Button in pairs(CollectionService:GetTagged("DevProductButton")) do
        gamepassHandler.configDevProduct(Button)
    end
    CollectionService:GetInstanceAddedSignal("GamepassButton"):Connect(gamepassHandler.configDevProduct)
end

--Phone
End_Cutscene.Event:Connect(function()
    task.wait(1)
    PhoneHandler.init()
    initColletions()
end)

Update_Phone.OnClientEvent:Connect(function()
    PhoneHandler.updateLocks()
end)








