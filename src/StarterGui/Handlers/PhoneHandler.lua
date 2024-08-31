--Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Phone : Tool = player:WaitForChild("Backpack"):FindFirstChild("Phone") or player.Character:FindFirstChild("Phone")

local PlayerGui = player:WaitForChild("PlayerGui")

local PhoneGui = PlayerGui.PhoneGui
--Frames
local PhoneFrame = PhoneGui.PhoneFrame
local VideosFrame = PhoneGui.VideosFrame
local WatchingFrame = PhoneGui.WatchingFrame
--Phone
local PhoneButton : TextButton = PhoneFrame.PhoneButton
--Videos
local VideosScrollingFrame = VideosFrame.VideosScrollingFrame
--Watching

local ConcentrateButton = WatchingFrame.ConcentrateButton
local StopButton = WatchingFrame.StopButton

--ReplicatedStorage
local Packages = game.ReplicatedStorage.Packages
local VideosData = require(PlayerGui.Handlers.VideosData)
local ProfileData = require(PlayerGui.ProfileData)
local TroveModule = require(Packages.Trove)

local Assets = ReplicatedStorage.Assets
local Remotes = ReplicatedStorage.Remotes

local Convert_Tears = Remotes.Convert_Tears

local PhoneHandler = {}

local Trove = TroveModule.new()
local Open = PhoneGui.Enabled

local function closeAllGuis()
    for _, Gui in pairs(PlayerGui:GetChildren()) do
        Gui.Enabled = false
    end
end

local function ChangeGui(currentFrame, newFrame)
    currentFrame.Visible = false
    newFrame.Visible = true
end


function PhoneHandler.init()

    Phone.Activated:Connect(function()
        if Open == false then
            PhoneHandler.Open()
        else
            PhoneHandler.Close()
        end
    end)

    PhoneButton.Activated:Connect(function()
        PhoneHandler.OpenVideos()
    end)


end

function PhoneHandler.Open()
    Open = true
    PhoneGui.Enabled = true
    PhoneFrame.Visible = true

    VideosFrame.Visible = false
    WatchingFrame.Visible = false
    
end

function PhoneHandler.Close()
    Open = false
    PhoneGui.Enabled = false
end

function PhoneHandler.OpenVideos()
    ChangeGui(PhoneFrame, VideosFrame)
end


function PhoneHandler.VideosInit()
    for _, Data in pairs(VideosData) do
        local newFrame = Assets.Video:Clone()
        newFrame.Title.Text = Data.Title
        newFrame.Channel = Data.Channel
        newFrame.Date = Data.Date
        newFrame.Views = Data.Views

        newFrame.Parent = VideosScrollingFrame
        --newFrame.ImageLabel = Data.Thumbnail
        newFrame.ImageButton.Activated:Connect(function()
            PhoneHandler.onVideoClick()
        end)
    end
end

function PhoneHandler.onVideoClick()
    ChangeGui(VideosFrame, WatchingFrame)
    local perc = 0
    
    
    Trove:Connect(ConcentrateButton.Activated, function()
        perc += 10
        WatchingFrame.SliderFrame.Slider.size = UDim2.fromScale(perc / 100, 1)
    end)

    Trove:Connect(StopButton.Activated , function()
        ChangeGui(WatchingFrame, VideosFrame)
        Trove:Clean()
    end)

end



return PhoneHandler