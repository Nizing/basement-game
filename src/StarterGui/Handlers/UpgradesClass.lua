local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Handlers = script.Parent
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)
local ProfileDataModule = require(Handlers.ProfileData)
local guiAnimation = require(script.Parent.guiAnimation)

local Container = Players.LocalPlayer.PlayerGui.UpgradesGui.Frame.Container
local frame = game.ReplicatedStorage.Assets.UpgradesFrame

local NotEnough = ReplicatedStorage.Assets.NotEnoughTears
local Transitions = Players.LocalPlayer.PlayerGui.Transitions


local Upgrades = {}

Upgrades.__index = Upgrades

-- m = level
-- Income = math.pow(1.5 , m - 3)
-- Cost  = math.pow(1.55 , m)
function Upgrades.new(title, currency, level, onClick, increment, costIncrement, startBase, startCost, index, imageLabel)
	local self = setmetatable({}, Upgrades)
    
	self.Level = level

	self._StartBase = startBase
	self._StartCost = startCost
	self._Increment = increment
	self._CostIncrement = costIncrement
    

	self.Income = self._StartBase * math.pow(self._Increment, self.Level)
	self.NextIncome = self._StartBase * math.pow(self._Increment, self.Level + 1)
	self.Cost = math.floor(self._StartCost * math.pow(self._CostIncrement, self.Level))

	self.Title = title
	self.Currency = currency
	self.Image = imageLabel
	self.onClick = onClick

    self._index = index
	return self
end

local function setData(newFrame, self)
	newFrame.CurrentTitle.Text = self.Title .. FormatNumbers.FormatCompact(self.Income)
	newFrame.NextTitle.Text = "Next " .. self.Title .. FormatNumbers.FormatCompact(self.NextIncome)
	newFrame.BuyButton.Text = self.Currency .. " required: " .. FormatNumbers.FormatCompact(self.Cost)
	newFrame.Level.Text = "Level: " .. self.Level
	newFrame.ImageLabel.Image = self.Image
end

function Upgrades:CloneFrame()
	local newFrame = frame:Clone()
	setData(newFrame, self)
	return newFrame
end

function Upgrades:UpdateFrame()
	setData(self.Instance, self)
end

function Upgrades:Init()
	self.Instance = self:CloneFrame()
	self.Instance.Parent = Container

	self.Instance.BuyButton.Activated:Connect(function()
		self:OnPress()
	end)
end
local Buy_Upgrade : RemoteEvent = ReplicatedStorage.Remotes.Buy_Upgrade
function Upgrades:OnPress()
    local Data = ProfileDataModule.GetProfile()
	if Data[self.Currency] < self.Cost then
		local text = "Not enough " .. self.Currency 
		guiAnimation.createDynamicPopup(NotEnough, Transitions, text)
		return 
	end
	
	self.Level += 1
	Buy_Upgrade:FireServer(self.Currency, self.Cost , self.Level , self._index)
	self:UpdateStats()
	self:UpdateFrame()
	self.onClick(self)
end

function Upgrades:UpdateStats()
	self.Income = self._StartBase * math.pow(self._Increment, self.Level)
	self.NextIncome = self._StartBase * math.pow(self._Increment, self.Level + 1)
	self.Cost = math.floor(self._StartCost * math.pow(self._CostIncrement, self.Level))
end

return Upgrades
