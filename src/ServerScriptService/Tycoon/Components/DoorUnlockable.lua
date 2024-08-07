local DoorUnlockable = {}
DoorUnlockable.__index = DoorUnlockable

function DoorUnlockable.new(tycoon, instance)
	local self = setmetatable({}, DoorUnlockable)
	self.Tycoon = tycoon
	self.Instance = instance
	return self
end

function DoorUnlockable:Init()
	self.Subscription = self.Tycoon:SubscribeTopic("DoorButton", function(...)
		self:onButtonPressed(...)
	end)
end

function DoorUnlockable:onButtonPressed(id)
	if id == self.Instance:GetAttribute("UnlockId") then
		self.Tycoon:UnlockDoor(self.Instance, id)
		self.Subscription:Disconnect()
	end
end

return DoorUnlockable