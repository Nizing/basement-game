local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage.Remotes
local Handlers = script.Parent

local CryAnimations = require(Handlers.CryAnimations)
local ProfileData = require(Handlers.ProfileData)
local CurrencyData = require(Handlers.CurrencyData)

local Cry_Remote : RemoteEvent = Remotes.Cry_Remote
local Update_Client : RemoteEvent = Remotes.Update_Client

local Player = Players.LocalPlayer
local MainGui = {}

--
local function ChangeGui(currentFrame, newFrame)
    currentFrame.Visible = false
    newFrame.Visible = true
end
--Cry system
local crydeb = false
local crydeb_int = 0.1
function MainGui.onCry()
    if crydeb == false then
        crydeb = true
        Cry_Remote:FireServer()
        CryAnimations.CryAnimation(Player)
        task.wait(crydeb_int)
        crydeb = false
    else
        return false
    end
end

local function playSound(id)
    local newSound = Instance.new("Sound")
    newSound.SoundId = id
    newSound.Parent = Handlers
    newSound:Play()
    newSound.Ended:Wait()
    newSound:Destroy()
end
--Tweening for hovers
local function TweenGuis(Button, size)
    if Button:IsA("ImageButton") then
        Button.Activated:Connect(function()
            local ButtonSoundId = "rbxassetid://109770729188561"
            playSound(ButtonSoundId)
        end)
    end
    

    local goal = {}
    goal.Size = size --{1.177, 0},{1.15, 0}
    local Tweeninfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    local Tween = TweenService:Create(Button, Tweeninfo, goal)
    Tween:Play()
end

--Init
function MainGui.Labels_init(LevelLabel : TextLabel, MoneyLabel : TextLabel, TearsLabel : TextLabel)
    MainGui.UpdateGuis(LevelLabel, MoneyLabel, TearsLabel)

    Update_Client.OnClientEvent:Connect(function(Data)
        
        --Update the first two
        LevelLabel.Text = "Level: ".. Data.Level
        MoneyLabel.Text = "Money: ".. Data.Money
        --Check which gui is displaying, then if it matches with the data update, if not keep the same.
        local TearsFrame = TearsLabel.Parent
        local currentIndex = TearsFrame:GetAttribute("Index")
        local currentIndexData = CurrencyData[currentIndex]
       if currentIndex == currentIndexData.index then
            
            TearsLabel.Text = currentIndexData.Title .. Data[currentIndexData.Id] 
        end
    end)
end

function MainGui.CloseAncestor(Button)
    local gui = Button:FindFirstAncestorOfClass("ScreenGui")
    gui.Enabled = false
end

--First time update
function MainGui.UpdateGuis(LevelLabel : TextLabel, MoneyLabel : TextLabel, TearsLabel : TextLabel)

    local Data = ProfileData.GetProfile()
    LevelLabel.Text = "Level: ".. Data.Level
    MoneyLabel.Text = "Money: ".. Data.Money
    TearsLabel.Text = "Tears: ".. Data.Tears

end
--Hover Animations
function MainGui.HoverEnter(Button)
    local size = Button.Size + UDim2.new(0, 15 , 0 , 15)
    TweenGuis(Button, size)
end

function MainGui.HoverLeave(Button, OriginalSize : UDim2)
    TweenGuis(Button, OriginalSize)
end
--Tears and othe currencies
local max = 5
local function showNewFrameInMainGui(currentIndex, Frame :  Frame)
    local profile = ProfileData.GetProfile()
    local Data = CurrencyData[currentIndex]
    Frame.TearsLabel.Text = Data.Title.. profile[Data.Id]
    Frame.BackgroundColor3 = Data.BackgroundColor
    Frame.ImageLabel.Image = Data.ImageLabel
end

function MainGui.Next(Frame : Frame)
    local currentIndex = Frame:GetAttribute("Index")
    currentIndex += 1
    if currentIndex >= max then currentIndex = 1 end
    Frame:SetAttribute("Index", currentIndex)
    showNewFrameInMainGui(currentIndex, Frame)
end

function MainGui.Back(Frame)
    local currentIndex = Frame:GetAttribute("Index")
    currentIndex -= 1
    if currentIndex <= 0 then currentIndex = max - 1 end
    Frame:SetAttribute("Index", currentIndex)
    showNewFrameInMainGui(currentIndex, Frame)
end


--
return MainGui