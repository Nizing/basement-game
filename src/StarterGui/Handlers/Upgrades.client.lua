local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Open_Upgrades : RemoteEvent = Remotes.Open_Upgrades

local Handlers = script.Parent
local guiAnimation = require(Handlers.guiAnimation)
local UpgradesClass = require(Handlers.UpgradesClass)


local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local UpgradesGui = PlayerGui.UpgradesGui

local Data = {
	[1] = {
		Title = "Passive income: ",
		Currency = "Tears", 
		Increment = 1.20,
		CostIncrement = 1.25,
		StartingBase  = 0.6,
		StartingCost = 10,
		onClick = function(self)
			
		end,
		
	},
	[2] = {
		Title = "Tears per cry: ",
		Currency = "Tears",
		Increment = 1.35,
		CostIncrement = 1.4,
		StartingBase  = 1.5,
		StartingCost = 5,
		onClick = function()
			
		end,
	},
	[3] = {
		Title = "Strength per rep ",
		Currency = "Strength",
		Increment = 1.35,
		CostIncrement = 1.4,
		StartingBase  = 1.6,
		StartingCost = 4,
		onClick = function()
			print("do the thing")
		end,
	},
	[4] = {
		Title = "Looksmaxing ability ",
		Currency = "Looks",
		Increment = 1.35,
		CostIncrement = 1.4,
		StartingBase = 1.6,
		StartingCost = 3,
		onClick = function()
			print("do the thing")
		end,
	}
}

for i, Data in pairs(Data) do
	local newUpgrade = UpgradesClass.new(Data.Title, Data.Currency, Data.onClick, Data.Increment, Data.CostIncrement,Data.StartingBase, Data.StartingCost, i)
	newUpgrade:Init()
end

Open_Upgrades.OnClientEvent:Connect(function(State : string, SeatInstance)
    if State == "Open" then
        UpgradesGui.Enabled = true
        guiAnimation.popupFrame(UpgradesGui.Frame, 1)
    end

    SeatInstance:GetPropertyChangedSignal("Occupant"):Once(function()
        if SeatInstance.Occupant == nil then
            guiAnimation.closeFrame(UpgradesGui.Frame, 1)
            UpgradesGui.Enabled = false
        end
    end)
end)

local UpgradesClass = require(script.Parent.UpgradesClass)




	

