local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Open_Upgrades : RemoteEvent = Remotes.Open_Upgrades

local Handlers = script.Parent
local guiAnimation = require(Handlers.guiAnimation)
local UpgradesClass = require(Handlers.UpgradesClass)
local ProfileModule = require(Handlers.ProfileData)


local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local UpgradesGui = PlayerGui.UpgradesGui

local Update_Multiplier : RemoteEvent = ReplicatedStorage.Remotes.Update_Multiplier
local profile = ProfileModule.GetProfile()
local Data = {
	[1] = {
		FunTitle = "Economic independence",
		Title = "Passive income: ",
		Currency = "Tears",
		Level = profile.Upgrades[1],
		Increment = 1.20,
		CostIncrement = 1.23,
		StartingBase  = 0.6,
		StartingCost = 10,
		onClick = function(self)
			Update_Multiplier:FireServer("Money", self.Income)
		end,
		ImageLabel = "rbxassetid://97739496716020"
		
	},
	[2] = {
		FunTitle = "Venting",
		Title = "Tears per cry: ",
		Currency = "Tears",
		Level = profile.Upgrades[2],
		Increment = 1.35,
		CostIncrement = 1.38,
		StartingBase  = 1.5,
		StartingCost = 5,
		onClick = function(self)
			Update_Multiplier:FireServer(self.Currency, self.Income)
		end,
		ImageLabel = "rbxassetid://19003295395"
	},
	[3] = {
		FunTitle = "Creatine",
		Title = "Strength per rep ",
		Currency = "Physique",
		Level = profile.Upgrades[3],
		Increment = 1.37,
		CostIncrement = 1.41,
		StartingBase  = 1.6,
		StartingCost = 4,
		onClick = function(self)
			Update_Multiplier:FireServer(self.Currency, self.Income)
		end,
		ImageLabel = "rbxassetid://18981874946"
	},
	[4] = {
		FunTitle = "Mewing",
		Title = "Looksmaxing ability ",
		Currency = "Looks",
		Level = profile.Upgrades[4],
		Increment = 1.39,
		CostIncrement = 1.42,
		StartingBase = 1.6,
		StartingCost = 3,
		onClick = function(self)
			Update_Multiplier:FireServer(self.Currency, self.Income)
		end,
		ImageLabel = "rbxassetid://18981820239"
	}
}

for i, Data in pairs(Data) do
	local newUpgrade = UpgradesClass.new(Data.Title, Data.Currency, Data.Level, Data.onClick, Data.Increment, Data.CostIncrement,Data.StartingBase, Data.StartingCost, i, Data.ImageLabel, Data.FunTitle)
	newUpgrade:Init()
end

local originalPosition = UpgradesGui.Frame.Position
local originalSize = UpgradesGui.Frame.Size
Open_Upgrades.OnClientEvent:Connect(function(State : string, SeatInstance)
	if UpgradesGui.Enabled == true then return end
	UpgradesGui.Frame.Position = originalPosition
	UpgradesGui.Frame.Size = originalSize

    if State == "Open" then
		
        UpgradesGui.Enabled = true
        guiAnimation.popupFrame(UpgradesGui.Frame, 1)
    end

    SeatInstance:GetPropertyChangedSignal("Occupant"):Once(function()
        if SeatInstance.Occupant == nil then
			
            guiAnimation.closeFrame(UpgradesGui.Frame, 1, originalPosition, originalSize)
            UpgradesGui.Enabled = false
        end
    end)
end)






	

