--Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local Phone : Tool = player:WaitForChild("Backpack"):FindFirstChild("Phone") or player.Character:FindFirstChild("Phone")

local PlayerGui = player:WaitForChild("PlayerGui")

local PhoneGui = PlayerGui.PhoneGui
--Frames
local PhoneFrame = PhoneGui.PhoneFrame
local VideosFrame = PhoneGui.VideosFrame
local WatchingFrame = PhoneGui.WatchingFrame
--Phone
local Apps = PhoneFrame.Apps
local NoobTube : ImageButton = Apps.NoobTube
local StronkWorkout : ImageButton = Apps.StronkWorkout
local MyDietPal : ImageButton = Apps.MyDietPal
local Meditation : ImageButton = Apps.Meditation

--Videos
local VideosScrollingFrame = VideosFrame.VideosScrollingFrame
local BackButton : TextButton = VideosFrame.BackButton
--Watching

local ConcentrateButton = WatchingFrame.ConcentrateButton
local StopButton = WatchingFrame.StopButton

--ReplicatedStorage
local Packages = game.ReplicatedStorage.Packages
local Handlers = PlayerGui.Handlers
local VideosData = require(Handlers.VideosData)
local ProfileData = require(Handlers.ProfileData)
local TroveModule = require(Packages.Trove)

local Assets = ReplicatedStorage.Assets
local Remotes = ReplicatedStorage.Remotes

local Convert_Tears = Remotes.Convert_Tears

local PhoneHandler = {}

local Trove = TroveModule.new()


local function ChangeGui(currentFrame, newFrame)
    currentFrame.Visible = false
    newFrame.Visible = true
end

function PhoneHandler.init()

    Phone.Activated:Connect(function()
        if PhoneGui.Enabled == false then
            PhoneHandler.Open()
        else
            PhoneHandler.Close()
        end
    end)
    NoobTube.Activated:Connect(PhoneHandler.OpenVideos)
    
    PhoneHandler.VideosInit()
    --Videos
    BackButton.Activated:Connect(PhoneHandler.Back)

end

function PhoneHandler.Open()
    PhoneGui.Enabled = true
    PhoneFrame.Visible = true

    VideosFrame.Visible = false
    WatchingFrame.Visible = false
    
end

function PhoneHandler.Close()
    PhoneGui.Enabled = false
end

function PhoneHandler.Back()
    ChangeGui(VideosFrame, PhoneFrame)
end

function PhoneHandler.OpenVideos()
    ChangeGui(PhoneFrame, VideosFrame)
end

function PhoneHandler.VideosInit()
    for _, Data in pairs(VideosData) do
        local newFrame = Assets.Video:Clone()
        newFrame.Title.Text = Data.Title
        newFrame.Channel.Text = Data.Channel
        newFrame.Date.Text = Data.Date
        newFrame.Views.Text = Data.Views

        newFrame.Parent = VideosScrollingFrame
        --newFrame.ImageLabel = Data.Thumbnail
        newFrame.ImageButton.Activated:Connect(function()
            local profile = ProfileData.GetProfile()
            
            if Data.input < profile.Tears then
                PhoneHandler.onVideoClick(Data)
            else
                print("not enough tears")
            end
            
        end)
    end
end

function PhoneHandler.onVideoClick(Data)
    ChangeGui(VideosFrame, WatchingFrame)
    local perc = 0
    
    
    Trove:Connect(ConcentrateButton.Activated, function()
        perc += 100 / Data.Duration

        if perc > 100 then
            Convert_Tears:FireServer(Data.input, Data.output)
            WatchingFrame.SliderFrame.Slider.Size = UDim2.fromScale(0, 1)
            
            ChangeGui(WatchingFrame, VideosFrame)
            Trove:Clean()
            return
        end

        WatchingFrame.SliderFrame.Slider.Size = UDim2.fromScale(perc / 100, 1)
    end)

    Trove:Connect(StopButton.Activated , function()
        ChangeGui(WatchingFrame, VideosFrame)
        Trove:Clean()
    end)

end



return PhoneHandler