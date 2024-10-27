--Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer


local PlayerGui = player:WaitForChild("PlayerGui")

local PhoneGui = PlayerGui.PhoneGui
local Transitions = PlayerGui.Transitions
--Frames
local PhoneFrame = PhoneGui.PhoneFrame
local VideosFrame = PhoneGui.VideosFrame
local WatchingFrame = PhoneGui.WatchingFrame
local StronkFrame = PhoneGui.Stronk
--Phone
local Apps = PhoneFrame.Apps
local NoobTube : ImageButton = Apps.NoobTube
local StronkWorkout : ImageButton = Apps.StronkWorkout
--local MyDietPal : ImageButton = Apps.MyDietPal
--local Looksmaxing : ImageButton = Apps.Looksmaxing

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
local guiAnimation = require(Handlers.guiAnimation)
local StronkClass = require(Handlers.StronkClass)
local TroveModule = require(Packages.Trove)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)


local LocalAssets = PlayerGui.Assets
local Assets = ReplicatedStorage.Assets
local Remotes = ReplicatedStorage.Remotes

local NotEnoughTears = Assets.NotEnoughTears
local NotEnoughMoney = Assets.NotEnoughMoney
local MoneyPopUp = Assets.MoneyPopUp

local Convert_Tears : RemoteEvent = Remotes.Convert_Tears
local Buy_Video : RemoteEvent= Remotes.Buy_Video

local PhoneHandler = {}

local Trove = TroveModule.new()


local function ChangeGui(currentFrame, newFrame)
    currentFrame.Visible = false
    newFrame.Visible = true
end


function PhoneHandler.init()
    local Phone : Tool = player:WaitForChild("Backpack"):FindFirstChild("Phone") or player.Character:FindFirstChild("Phone")
    Phone.Activated:Connect(function()
        if PhoneGui.Enabled == false then
            PhoneHandler.Open()
        else
            PhoneHandler.Close()
        end
    end)
    NoobTube.Activated:Connect(PhoneHandler.OpenVideos)
    StronkWorkout.Activated:Connect(PhoneHandler.OpenStronk)
    PhoneHandler.VideosInit()
    --Videos
    BackButton.Activated:Connect(PhoneHandler.Back)

end

function PhoneHandler.Open()
    PhoneGui.Enabled = true
    PhoneFrame.Visible = true
    guiAnimation.popupFrame(PhoneFrame, 1)

    VideosFrame.Visible = false
    WatchingFrame.Visible = false
    StronkFrame.Visible = false
    
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

function PhoneHandler.OpenStronk()
    ChangeGui(PhoneFrame, StronkFrame)
end

Buy_Video.OnClientEvent:Connect(function()
    PhoneHandler.VideosReset()
    task.wait()
    PhoneHandler.VideosInit()
end)

local function createUnlockFrame(Data)
    local newUnlockFrame = ReplicatedStorage.Assets.UnlockFrame:Clone()
    newUnlockFrame.Label.Text = "Unlock for: ".. FormatNumbers.FormatCompact(Data.Cost).. "$"

    newUnlockFrame.BuyButton.Activated:Connect(function()
        local profile = ProfileData.GetProfile()
        if profile.Money >= Data.Cost then
            Buy_Video:FireServer(Data.Cost, Data.id)
            newUnlockFrame:Destroy()
        else
            LocalAssets.MistakeSound:Play()
            guiAnimation.popUpNotEnough(newUnlockFrame, NotEnoughMoney)
        end
    end)

    newUnlockFrame.CancelButton.Activated:Connect(function()
        newUnlockFrame:Destroy()
    end)
    return newUnlockFrame 
end

function PhoneHandler.VideosInit()

	local profile = ProfileData.GetProfile(player)
	for _, Data in pairs(VideosData) do
		local newFrame = Assets.Video:Clone()
		newFrame.Parent = VideosScrollingFrame

        newFrame.Title.Text = Data.Title
		newFrame.Input.Text = FormatNumbers.FormatCompact(Data.input).."😭 Tears = ".. FormatNumbers.FormatCompact(Data.output * profile.globalMultiplier * profile.RebirthMultiplier).." Money 💸"  
        
        newFrame.Channel.Text = Data.Channel
        newFrame.Views.Text = Data.Views .. " • " .. Data.Date
        newFrame.ImageLabel.Image = Data.Thumbnail

		if table.find(profile.VideoIds, Data.id) then
			
            
			newFrame.ImageButton.Activated:Connect(function()
				local profile = ProfileData.GetProfile()

				if Data.input <= profile.Tears then
					PhoneHandler.onVideoClick(Data)
				else
					LocalAssets.MistakeSound:Play()
                   
                    guiAnimation.createDynamicPopup(NotEnoughTears, newFrame)
				end
			end)            
		else --if it is not unlocked
			local lock = ReplicatedStorage.Assets.Lock:Clone()
			lock.Parent = newFrame
			

            lock.LockButton.Activated:Connect(function()
                local newUnlockFrame = createUnlockFrame(Data)
                newUnlockFrame.Parent = VideosFrame
            end)
		end
	end
end

function PhoneHandler.VideosReset()
    for _, Video in pairs(VideosScrollingFrame:GetChildren()) do
        if Video:IsA("Frame") then
            Video:Destroy()
        end
    end
end

local function playVideo(Playing, Pause)
    Playing.Visible = true
    Pause.Visible = false
end

local function pauseVideo(Playing, Pause)
    Playing.Visible = false
    Pause.Visible = true
end

function PhoneHandler.onVideoClick(Data)
    ChangeGui(VideosFrame, WatchingFrame)
    local PlayingLabel = WatchingFrame.ConcentrateButton.Playing 
    local PauseLabel = WatchingFrame.ConcentrateButton.Pause
    PlayingLabel.Visible = false
    PauseLabel.Visible = true
    local perc = 0
    WatchingFrame.SliderFrame.Slider.Size = UDim2.fromScale(0, 1)

    WatchingFrame.YoutubeLabel.Text = Data.Title
    WatchingFrame.Thumbnail.Image = Data.Thumbnail

    Trove:Connect(ConcentrateButton.Activated, function()
        if PauseLabel.Visible == false then return end

        playVideo(PlayingLabel, PauseLabel)
        local dummyperc = perc
        repeat 
            perc += 1
            WatchingFrame.SliderFrame.Slider.Size = UDim2.fromScale(math.clamp(perc / 100, 0 , 1) , 1)
            task.wait(0.03)
        until perc >= 100 / Data.Duration + dummyperc
        dummyperc = perc
        pauseVideo(PlayingLabel, PauseLabel)
        --Give the player the moneyyyy
        if perc >= 100 then
            local profile = ProfileData.GetProfile()
            ChangeGui(WatchingFrame, VideosFrame)
            Convert_Tears:FireServer(Data.input, Data.output)
            WatchingFrame.SliderFrame.Slider.Size = UDim2.fromScale(0, 1)

            local text = "+ ".. FormatNumbers.FormatCompact(Data.output * profile.globalMultiplier * profile.RebirthMultiplier).. " Money"
            task.spawn(function()
                guiAnimation.createDynamicPopup(MoneyPopUp, Transitions, text)
            end)
            
            Trove:Clean()
            return
        end
    end)

    Trove:Connect(StopButton.Activated , function()
        ChangeGui(WatchingFrame, VideosFrame)
        Trove:Clean()
    end)

end

--Stronk
local profile = ProfileData.GetProfile()
local StronkData = {
    [1] = {
        Title = "TurboCry" ,
        Currency = "Money",
        Value = "Tears",
        Level = profile.StronkLevels[1],
        Image = "rbxassetid://19003295395",
        BaseCost = 1000,
        BaseIncome = 10,
        UnlockLevel = 1,
        
    },
    [2] = {
        Title = "Stereoids",
        Currency = "Money",
        Value = "Physique",
        Level = profile.StronkLevels[2],
        Image = "rbxassetid://18981874946",
        BaseCost = 10000,
        BaseIncome = 20,
        UnlockLevel = 5,
    },
    [3] = {
        Title = "Bonesmashing",
        Currency = "Money",
        Value = "Looks",
        Level = profile.StronkLevels[3],
        Image = "rbxassetid://70774566978748",
        BaseCost = 100000,
        BaseIncome = 40,
        UnlockLevel = 10,
    },
    [4] = {
        Title = "Cheat day",
        Currency = "Money",
        Value = "Diet",
        Level = profile.StronkLevels[4],
        Image = "rbxassetid://109631826263073",
        BaseCost = 1000000,
        BaseIncome = 50,
        UnlockLevel = 25,
    }
}
local profile = ProfileData.GetProfile()
for i, page in ipairs(StronkData) do
    local Income = page.BaseIncome * profile.globalMultiplier * profile.RebirthMultiplier
    local newStronk = StronkClass.new(page.Title, page.Currency, page.Value, page.Level, page.Image, page.BaseCost, Income, page.UnlockLevel, i)
    newStronk:Init()
end





return PhoneHandler