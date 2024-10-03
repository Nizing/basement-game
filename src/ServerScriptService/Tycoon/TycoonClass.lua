local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local template = game:GetService("ServerStorage").Template
local componentFolder = script.Parent.Components
local tycoonStorage = game:GetService("ServerStorage").tycoonStorage
local HouseTemplates = game:GetService("ServerStorage").HouseTemplates

local Libraries = ServerScriptService.Libraries

local PlayerManager = require(Libraries.PlayerManager)



local function newModel(model, cframe, Owner)
	local newModel = model:Clone()
	newModel:PivotTo(cframe)
	newModel.Parent = workspace

	for _, v : Model in pairs(newModel.MainTemplate.LevelUpSpots:GetChildren()) do
		v:SetAttribute("Owner", Owner.Name)
	end
	
	return newModel
end
local Floors = game.Workspace.DefaultHouses.HousesFloor

local function removeTemplate(index)
	for _, v in pairs(Floors:GetChildren()) do
		if v:GetAttribute("Index") == index then
			v.Parent = HouseTemplates
		end
	end
end

local function addTemplateBack(index)
	for _, v in pairs(HouseTemplates:GetChildren()) do
		if v:GetAttribute("Index") == index then
			v.Parent = Floors
		end
	end
end


local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player : Player, spawnpoint: Instance, index : number)
	local self = setmetatable({}, Tycoon)
	self.Owner = player
	
	self._topicEvent = Instance.new("BindableEvent")
	self._spawn = spawnpoint
	self._index = spawnpoint:GetAttribute("Index")
	return self
end

function Tycoon:Init()
	self.Model = newModel(template, self._spawn.CFrame, self.Owner)
	self._spawn:SetAttribute("Occupied", true)
	self:LockAll()
	removeTemplate(self._index)
	--self:LoadUnlocks()
end

function Tycoon:SetSpawn(player)
	if self.Owner.Name == player.Name then
		self.Owner.RespawnLocation = self.Model.MainTemplate.Spawn
		
		return self.Owner.RespawnLocation
	end
end

function Tycoon:LoadUnlocks()
	for _, id in ipairs(PlayerManager:GetUnlockIds(self.Owner)) do
		self:PublishTopic("Button", id)
	end
	for _, id in ipairs(PlayerManager:GetDoorIds(self.Owner)) do
		self:PublishTopic("DoorButton", id)
	end

end

function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, "Unlockable") then
			self:Lock(instance)
		else
			if CollectionService:HasTag(instance, "DoorUnlockable") then
				self:LockDoor(instance)
			else
				self:AddComponents(instance)
			end
		end
	end
end

function Tycoon:Lock(instance)
	instance.Parent = tycoonStorage
	self:CreateComponents(instance, componentFolder.Unlockable)
end

function Tycoon:LockDoor(instance)
	self:CreateComponents(instance, componentFolder.DoorUnlockable)
end

function Tycoon:Unlock(instance, id)
	PlayerManager:AddUnlockId(self.Owner, id)
	CollectionService:RemoveTag(instance, "Unlockable")
	self:AddComponents(instance)
	instance.Parent = self.Model
end

function Tycoon:UnlockDoor(instance, id)
	PlayerManager:AddDoorId(self.Owner, id)
	CollectionService:RemoveTag(instance, "DoorUnlockable")
	self:AddComponents(instance)
end

function Tycoon:AddComponents(instance)
	for _, tag in ipairs(CollectionService:GetTags(instance)) do
		local component = componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponents(instance, component)
		end
	end
end

function Tycoon:CreateComponents(instance, componentScript)
	local compModule = require(componentScript)
	local newComp = compModule.new(self, instance)
	newComp:Init()
end

function Tycoon:PublishTopic(topicName, ...)
	self._topicEvent:Fire(topicName, ...)
end

function Tycoon:SubscribeTopic(topicName, callback)
	local connection = self._topicEvent.Event:Connect(function(name, ...)
		if name == topicName then
			callback(...)
		end
	end)
	return connection
end

function Tycoon:Destroy()
	addTemplateBack(self._index)
	self.Model:Destroy()
end



return Tycoon
