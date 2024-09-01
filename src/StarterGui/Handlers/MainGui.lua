local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage.Remotes
local Handlers = script.Parent

local Animations = require(Handlers.Animations)
local ProfileData = require(Handlers.ProfileData)

local Cry_Remote : RemoteEvent = Remotes.Cry_Remote
local Update_Client : RemoteEvent = Remotes.Update_Client

local Player = Players.LocalPlayer
local MainGui = {}


--Cry system
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
--Tweening for hovers
local function TweenGuis(Button : ImageButton, size) 
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
        
        LevelLabel.Text = "Level: ".. Data.Level
        MoneyLabel.Text = "Money: ".. Data.Money
        TearsLabel.Text = "Tears: ".. Data.Tears
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

return MainGui