local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local template = game:GetService("ServerStorage").Template
local componentFolder = script.Parent.Components
local tycoonStorage = game:GetService("ServerStorage").tycoonStorage

local Libraries = ServerScriptService.Libraries

local PlayerManager = require(Libraries.PlayerManager)



local function newModel(model, cframe)
	local newModel = model:Clone()
	newModel:SetPrimaryPartCFrame(cframe)
	
	newModel.Parent = workspace
	return newModel
end

local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player : Player, spawnpoint: Instance)
	local self = setmetatable({}, Tycoon)
	self.Owner = player
	
	self._topicEvent = Instance.new("BindableEvent")
	self._spawn = spawnpoint
	return self
end

function Tycoon:Init()
	
	self.Model = newModel(template, self._spawn.CFrame)
	self.Owner.RespawnLocation = self.Model.MainTemplate.Spawn
	self.Owner:LoadCharacter()
	self._spawn:setAttribute("Occupied", true)
	self:LockAll()
	self:LoadUnlocks()
	
	
end

function Tycoon:LoadUnlocks()
	for _, id in ipairs(PlayerManager:GetUnlockIds(self.Owner)) do
		self:PublishTopic("Button", id)
	end
end

function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, "Unlockable") then
			self:Lock(instance)
		else
			self:AddComponents(instance)
		end
	end
end

function Tycoon:Lock(instance)
	instance.Parent = tycoonStorage
	self:CreateComponents(instance, componentFolder.Unlockable)
end

function Tycoon:Unlock(instance, id)
	PlayerManager:addUnlockId(self.Owner, id)
	CollectionService:RemoveTag(instance, "Unlockable")
	self:AddComponents(instance)
	instance.Parent = self.Model
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
	self.Model:Destroy()
end

return Tycoon
