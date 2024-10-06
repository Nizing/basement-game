local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chair = {}

Chair.__index = Chair

function Chair.new(tycoon, instance)
	local self = setmetatable({}, Chair)
	self.Tycoon = tycoon
	self.Instance = instance
    self.Seat = instance.Seat
	return self
end
local Open_Upgrades : RemoteEvent = ReplicatedStorage.Remotes.Open_Upgrades
function Chair:Init()
    self.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if self.Seat.Occupant == nil then return end
        if self.Seat.Occupant.Parent.Name == self.Tycoon.Owner.Name then
           Open_Upgrades:FireClient(self.Tycoon.Owner, "Open", self.Seat)
        end
    end)
end





return Chair