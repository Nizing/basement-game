local Players = game:GetService("Players")
local playerGui = script.Parent.Parent

local LevelUpGui = playerGui.LevelUpGui
local LevelUpFrame = LevelUpGui.LevelUpFrame
local ItemsLabel = LevelUpFrame.ItemsLabel
local LevelUpButton : TextButton = LevelUpFrame.LevelUpButton

local ProfileData = require(playerGui.Handlers.ProfileData)
local player = Players.LocalPlayer

local LevelUp = {}

function LevelUp.Init(seat)
    seat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if seat.Occupant and seat.Occupant.Parent.Name == player.Name then
            LevelUp.Open()
            while seat.Occupant do
                task.wait(0.1)
            end
            LevelUp.Close()
        end
    end)
    
    LevelUpButton.Activated:Connect(function()
        
    end)
end

local AreasData = {
    {itemCount = 10, Cost = 200},
    {itemCount = 20, Cost = 200},
    {itemCount = 40, Cost = 200}
    
}

function LevelUp.Open()
    local profile = ProfileData.GetProfile()
    LevelUpGui.Enabled = true
    local playerLevel = profile.Level
    ItemsLabel.Text = profile.ItemCount .. "/".. AreasData[playerLevel + 1].itemCount .."Items Bought"
    LevelUpButton.Text = "Level up for: "..AreasData[playerLevel + 1].Cost
end
function LevelUp.Close()
    LevelUpGui.Enabled = false
end

function LevelUp.ButtonClick()
    print("still works ?")
    --add one level
    --remove money 
end

return LevelUp