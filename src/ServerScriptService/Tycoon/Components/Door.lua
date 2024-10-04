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
	
	self.Open = false
	
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
	
	prompt.Parent = self.Instance.Base	
	return prompt
end

--CFrame.Angles(0, math.rad(270), 0) = open
--CFrame.Angles(0, 0, 0) = close
function Door:Tween(radians)
	local goal = {}
	goal.CFrame = self.Hinge.CFrame * CFrame.Angles(0, math.rad(radians), 0) 
	local tweenInfo = TweenInfo.new(.7)
	local Tween = TweenService:Create(self.Hinge, tweenInfo, goal)
	return Tween
end

function Door:Press(player)
	if self.Open == false then
		self:Tween(270):Play()
		self.Open = true
		self.Prompt.ActionText = "Close Door"
	else
		
		self:Tween(-270):Play()
		self.Open = false
		self.Prompt.ActionText = "Open Door"
	end
end

return Door
