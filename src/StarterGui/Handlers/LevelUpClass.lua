
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumbers = require(ReplicatedStorage.FormatNumbers)
local ProfileModule = require(script.Parent.ProfileData)
local guiAnimation = require(script.Parent.guiAnimation)
local frame = ReplicatedStorage.Assets.LevelUpFrame
local player = Players.LocalPlayer
local Container = player.PlayerGui.LevelUp.Frame.Container.Folder

local NotEnough = ReplicatedStorage.Assets.NotEnoughTears
local Transitions = player.PlayerGui.Transitions



local LevelUpClass = {}

LevelUpClass.__index = LevelUpClass

function LevelUpClass.new(title, cost,  level, image, currency, index)
	local self = setmetatable({}, LevelUpClass)
	self.Title = title
	self.Level = level
	self._InitialCost = cost
	self.Cost = self._InitialCost * math.pow(3.4, self.Level)
	self.Currency = currency
	self._index = index 
	
	self.Image = image
	return self
end

function LevelUpClass:Init()
	self.Instance = self:CloneFrame()
	self.Instance.Parent = Container
	self.Instance.LevelUp.Activated:Connect(function() 
		self:OnPress()
	end)
end

local function setData(newFrame, self)
	newFrame.Title.Text = self.Title
	newFrame.Cost.Text = FormatNumbers.FormatCompact(self.Cost)
	newFrame.Level.Text = self.Level
	newFrame.ImageLabel.Image = self.Image
end

function LevelUpClass:CloneFrame()
	local newFrame = frame:Clone()
	setData(newFrame, self)
	return newFrame
end

function LevelUpClass:UpdateStats()
	self.Cost = self._InitialCost *  math.pow(3.4 , self.Level)
end

function LevelUpClass:UpdateFrame()
	setData(self.Instance, self)
end
local Level_Up : RemoteEvent = ReplicatedStorage.Remotes.Level_Up
function LevelUpClass:OnPress()
	local Data = ProfileModule.GetProfile()
	if Data[self.Currency] < self.Cost then
		local text = "Not enough " .. self.Currency 
		guiAnimation.createDynamicPopup(NotEnough, Transitions, text)
		return 
	end
	self.Level += 1
	Level_Up:FireServer(self.Currency, self.Cost, self.Level, self._index)
	self:UpdateStats()
	self:UpdateFrame()
end

return LevelUpClass
