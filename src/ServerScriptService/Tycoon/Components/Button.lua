local PlayerManager = require(game:GetService("ServerScriptService").Libraries.PlayerManager)

local Button = {}

Button.__index = Button

function Button.new(tycoon, instance)
	local self = setmetatable({}, Button)
	self.Tycoon = tycoon
	self.Instance = instance
	return self
end

function Button:Init()
	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(...)
		self:Press(...)
	end)
end

function Button:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	prompt.ActionText = self.Instance:GetAttribute("Display")
	prompt.ObjectText = "$".. self.Instance:GetAttribute("Cost")
	
	prompt.Parent = self.Instance	
	return prompt
end

function Button:Press(player)
	local id = self.Instance:GetAttribute("Id")
	local cost = self.Instance:GetAttribute("Cost")
	local money = PlayerManager:GetMoney(player)
			--If its a door
	if player == self.Tycoon.Owner and money >= cost then
		if self.Instance:GetAttribute("Level") then
			PlayerManager:AddMoney(player, -cost)
			self.Tycoon:PublishTopic("DoorButton", id)
			self.Instance:Destroy()
		else -- if its not a door
			PlayerManager:AddMoney(player, -cost)
			self.Tycoon:PublishTopic("Button", id)
			self.Instance:Destroy()
		end
	end
end

return Button
