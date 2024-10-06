local Deletable = {}

Deletable.__index = Deletable

function Deletable.new(tycoon, instance)
	local self = setmetatable({}, Deletable)
	self.Tycoon = tycoon
	self.Instance = instance
	return self
end

function Deletable:Init()
	self.Subscription = self.Tycoon:SubscribeTopic("Button", function(...)
		self:onButtonPressed(...)
	end)
end

function Deletable:onButtonPressed(id)
	if id == self.Instance:GetAttribute("UnlockId") then
		self.Instance:Destroy()
		self.Subscription:Disconnect()
	end
end



return Deletable
