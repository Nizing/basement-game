local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerManager = require(ServerScriptService.Libraries.PlayerManager)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)

local RebirthButton = {}

RebirthButton.__index = RebirthButton

function RebirthButton.new(tycoon, instance)
    local self = setmetatable({}, RebirthButton)
    self.Tycoon = tycoon
    self.Instance = instance
    self._RebirthPopUp = ReplicatedStorage.Remotes.Rebirth_PopUp
    return self
end

function RebirthButton:Init()
    self:CreateBillboardGui()
    local deb = false
    self.Instance.PromptPart.Touched:Connect(function(hit)
        if deb == true then return end
        deb = true
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player and player.Name == self.Tycoon.Owner.Name then
            self:Press(player)
        end
        task.wait(0.5)
        deb = false
    end)
end
local Not_Enough_Money = ReplicatedStorage.Remotes.Not_Enough_Money
local Level_Too_Low = ReplicatedStorage.Remotes.Level_Too_Low
function RebirthButton:Press(player)
    
    if PlayerManager:GetMoney(player) < self.Instance:GetAttribute("Cost") then
        Not_Enough_Money:FireClient(player)
	end
    local level = PlayerManager:GetLevel(player)
    if PlayerManager:GetMoney(player) >= self.Instance:GetAttribute("Cost") then
        if self.Instance:GetAttribute("Level") and level < self.Instance:GetAttribute("Level") then Level_Too_Low:FireClient(player) return end
        self._RebirthPopUp:FireClient(player, self.Instance.CFramePart)
    end
end


function RebirthButton:CreateBillboardGui()
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "InfoGui"
    billboardGui.Size = UDim2.new(5, 0, 1.5, 0)
    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    billboardGui.AlwaysOnTop = false
    billboardGui.MaxDistance = 40  -- Set a realistic max distance
    billboardGui.LightInfluence = 1  -- Ensure consistent visibility

	local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.7
    frame.BackgroundColor3 = Color3.fromRGB(156, 156, 156)
    frame.Parent = billboardGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(60, 0)
	UICorner.Parent = frame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Montserrat  -- Changed to Montserrat
	--YOU CAN SET IT AS MEDIUM ONLY LIKE THIS IDK
	local fontFace = nameLabel.fontFace
	fontFace.Weight = Enum.FontWeight.Medium
	nameLabel.FontFace = fontFace

    nameLabel.Text = self.Instance:GetAttribute("Display") or "Unnamed"
    nameLabel.Parent = frame

    local costLabel = Instance.new("TextLabel")
    costLabel.Size = UDim2.new(1, 0, 0.5, 0)
    costLabel.Position = UDim2.new(0, 0, 0.5, 0)
    costLabel.BackgroundTransparency = 1
    costLabel.TextColor3 = Color3.new(1, 1, 0)
    costLabel.TextScaled = true
    costLabel.Font = Enum.Font.Montserrat  -- Changed to Montserrat
	--YOU CAN SET IT AS MEDIUM ONLY LIKE THIS IDK
	local fontFace2 = costLabel.fontFace
	fontFace2.Weight = Enum.FontWeight.Medium
	costLabel.FontFace = fontFace2

    costLabel.Text = "$" .. (FormatNumbers.FormatCompact(self.Instance:GetAttribute("Cost")) or 0)
    costLabel.Parent = frame

    billboardGui.Parent = self.Instance.PromptPart
end


return RebirthButton