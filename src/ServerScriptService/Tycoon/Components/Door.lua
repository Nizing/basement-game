local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local PlayerManager = require(ServerScriptService.Libraries.PlayerManager)

local Door = {}

Door.__index = Door

function Door.new(tycoon, instance)
	local self = setmetatable({}, Door)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Hinge = instance.Hinge
	
	self.State = false
	self.Unlocked = false -- save this
	return self
end

function Door:Init()
	self.Prompt = self:MakePrompt()
	self.Prompt.Triggered:Connect(function(...)
		self:Press(...)
	end)
end

function Door:MakePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	
	prompt.ActionText = self.Instance:GetAttribute("Display")
	prompt.ObjectText = self.Instance:GetAttribute("Level").."Levels Needed"

	prompt.Parent = self.Instance.Base	
	return prompt
end

function Door:Open()
	local goalOpen = {}
	goalOpen.CFrame = self.Hinge.CFrame * CFrame.Angles(0, math.rad(270), 0)
	local tweenInfo = TweenInfo.new(.7)
	local TweenOpen = TweenService:Create(self.Hinge, tweenInfo, goalOpen)
	return TweenOpen
	
end

function Door:Close()
	local goalClose = {}
	goalClose.CFrame = self.Hinge.CFrame * CFrame.Angles(0, 0, 0)
	local tweenInfo = TweenInfo.new(.7)
	local TweenClose = TweenService:Create(self.Hinge, tweenInfo, goalClose)
	return TweenClose
end

function Door:Press(player)
	local level = PlayerManager:GetLevel(player)
	if level > self.Instance:GetAttribute("Level") then
		
		if self.State == false then
			self:Open():Play()
			self.State = true
		else
			self:Close():Play()
			self.State = false
		end
	end
end





return Door
