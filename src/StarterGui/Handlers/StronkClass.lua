local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local profileModule = require(script.Parent.ProfileData)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)
local guiAnimation = require(script.Parent.guiAnimation)

local NotEnough = ReplicatedStorage.Assets.NotEnoughTears
local StronkFrame = ReplicatedStorage.Assets.StronkFrame
local Container = Players.LocalPlayer.PlayerGui.PhoneGui.Stronk.Frame.Container
local Lock = ReplicatedStorage.Assets.StronkLock
local Transitions = Players.LocalPlayer.PlayerGui.Transitions

local increment1 = 1.17
local increment2 = 1.32
local StronkClass = {}

StronkClass.__index = StronkClass

function StronkClass.new(title : string, currency : string, value : string, level : number , image : string, baseCost: number, baseIncome: number, unlockLevel, index : number)
    local self = setmetatable({}, StronkClass)
    self.Title = title
    self.Currency = currency
    self.Value = value
    self.Level = level
    self.Image = image
    self.Index = index

    self._BaseCost = baseCost
    self._BaseIncome = baseIncome

    self.Cost = self._BaseCost * math.pow(increment2, self.Level)
    self.Income = self._BaseIncome * math.pow(increment1, self.Level)
    self.NextIncome = self._BaseIncome * math.pow(increment1, self.Level + 1)

    self._Unlocked = false
    self._UnlockLevel = unlockLevel
    return self
end

local function setData(newFrame, self)
	newFrame.Title.Text = self.Title
    newFrame.BuyButton.Text = FormatNumbers.FormatCompact(self.Cost) .. " " .. self.Currency
    newFrame.CurrentIncome.Text = FormatNumbers.FormatCompact(self.Income) .. " " .. self.Value .. " / S"
    newFrame.NextIncome.Text = FormatNumbers.FormatCompact(self.NextIncome).. " " .. self.Value .. " / S"
    newFrame.Level.Text = "Lv. " .. self.Level
    newFrame.ImageLabel.Image = self.Image
    return newFrame
end

local function cloneFrame(self)
    local newFrame = StronkFrame:Clone()
    setData(newFrame, self)
    return newFrame
end

function StronkClass:Init()
    local profile = profileModule.GetProfile()
    local playerLevel = profile.Level
    self.Instance = cloneFrame(self)
    self.Instance.Parent = Container
    if self._UnlockLevel > playerLevel then
        self:Lock()
    else
        self:InitButton()
    end
end

function StronkClass:InitButton()
    self.Instance.BuyButton.Activated:Connect(function()
        self:OnPress()
    end)
end
local Stronk_Buy : RemoteEvent = ReplicatedStorage.Remotes.Stronk_Buy

function StronkClass:OnPress()
    local Data = profileModule.GetProfile()
	if Data[self.Currency] < self.Cost then
		local text = "Not enough " .. self.Currency 
		guiAnimation.createDynamicPopup(NotEnough, Transitions, text)
		return
	end
	
    self.Level += 1
    Stronk_Buy:FireServer(self)
    self:UpdateStats()
    self:UpdateFrame()
end

function StronkClass:Lock()
    local newLock = Lock:Clone()
    newLock.Parent = self.Instance
    newLock.LevelsRequired.Text = self._UnlockLevel .. " Levels required"
    newLock.LockButton.Activated:Connect(function()
        local profile = profileModule.GetProfile()
        if profile.Level >= self._UnlockLevel then
            self:Unlock()
        else
            local text = "Level too low"
            guiAnimation.createDynamicPopup(NotEnough, Transitions, text)
        end
    end)
end

function StronkClass:Unlock()
    local lock = self.Instance:FindFirstChild("StronkLock")
    lock:Destroy()
    self:InitButton()
end

function StronkClass:UpdateStats()
    self.Cost = self._BaseCost * math.pow(increment2, self.Level)
    self.Income = self._BaseIncome * math.pow(increment1, self.Level)
    self.NextIncome = self._BaseIncome * math.pow(increment1, self.Level + 1)
end

function StronkClass:UpdateFrame()
    setData(self.Instance, self)
end

--TO DO : add the StronkClassLock in replicatedStorage

return StronkClass