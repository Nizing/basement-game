local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage.Remotes
local Handlers = script.Parent

local Animations = require(Handlers.Animations)
local Cry_Remote : RemoteEvent = Remotes.Cry_Remote
local Get_Profile : RemoteFunction = Remotes.Get_Profile
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

    Update_Client.OnClientEvent:Connect(function(Data_2)
        
        LevelLabel.Text = "Level: ".. Data_2.Level
        MoneyLabel.Text = "Money: ".. Data_2.Money
        TearsLabel.Text = "Tears: ".. Data_2.Tears
    end)
end

--Useless kinda
function MainGui.UpdateGuis(LevelLabel : TextLabel, MoneyLabel : TextLabel, TearsLabel : TextLabel)

    local Data = Get_Profile:InvokeServer()
    LevelLabel.Text = "Level: ".. Data.Level
    MoneyLabel.Text = "Money: ".. Data.Money
    TearsLabel.Text = "Tears: ".. Data.Tears

end
--Animations
function MainGui.HoverEnter(Button : ImageButton)
    local position = UDim2.new(-0.08, 0, -0.08, 0) 
    local size = Button.Size + UDim2.new(0.2, 0 , 0.2 , 0)
    TweenGuis(Button, size)
end

function MainGui.HoverLeave(Button : ImageButton)
    local position = UDim2.new(0.067, 0, 0.067, 0) -- {0.067, 0},{0.067, 0}
    local size = Button.Size - UDim2.new(0.2, 0 , 0.2 , 0) --{0.843, 0},{0.933, 0}
    TweenGuis(Button, size)
end

function MainGui.FrameHoverEnter(Frame : Frame)
    local position = UDim2.new(0.067, 0, 0.067, 0) --{0.067, 0},{0.067, 0}
    local size = UDim2.new(0.843, 0, 0.933, 0) --{0.843, 0},{0.933, 0}
    TweenGuis(Frame, position, size)
end

function MainGui.FrameHoverLeave(Frame : Frame)
    local position = UDim2.new(0.067, 0, 0.067, 0) --{0.067, 0},{0.067, 0}
    local size = UDim2.new(0.062, 0, 0.112, 0) --{0.062, 0},{0.112, 0}
    TweenGuis(Frame, position, size)
end







return MainGui