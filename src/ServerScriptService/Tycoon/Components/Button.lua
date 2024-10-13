local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerManager = require(game:GetService("ServerScriptService").Libraries.PlayerManager)
local FormatNumbers = require(ReplicatedStorage.FormatNumbers)

local Button = {}
Button.__index = Button

function Button.new(tycoon, instance)
    local self = setmetatable({}, Button)
    self.Tycoon = tycoon
    self.Instance = instance
    return self
end

function Button:Init()
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

function Button:CreateBillboardGui()
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

    billboardGui.Parent = self.Instance
end

local UnlockSoundId = "rbxassetid://18709793931"
function playSound(Id, player)
	local newSound = Instance.new("Sound")
	newSound.SoundId = Id
	newSound.Parent = player.Character
	newSound:Play()
	newSound.Ended:Connect(function()
		newSound:Destroy()
	end)
end
local Remotes = ReplicatedStorage.Remotes
local Not_Enough_Money : RemoteEvent = Remotes.Not_Enough_Money
local Level_Too_Low : RemoteEvent = Remotes.Level_Too_Low
local Update_Phone : RemoteEvent = Remotes.Update_Phone
function Button:Press(player)
    local id = self.Instance:GetAttribute("Id")
    local cost = self.Instance:GetAttribute("Cost")
    local money = PlayerManager:GetMoney(player)
    local level = PlayerManager:GetLevel(player)

    if player == self.Tycoon.Owner and money < cost then 
		Not_Enough_Money:FireClient(player)
	end
	
    if player == self.Tycoon.Owner and money >= cost then
		-- If it's a door
        if self.Instance:GetAttribute("door") then
            if level < self.Instance:GetAttribute("Level") and level < self.Instance:GetAttribute("Level") then Level_Too_Low:FireClient(player) return end
            playSound(UnlockSoundId, player)
            PlayerManager:AddMoney(player, -cost)
            self.Tycoon:PublishTopic("DoorButton", id)
            self.Instance:Destroy()
        else -- if it's not a door
            
            if self.Instance:GetAttribute("Level") and level < self.Instance:GetAttribute("Level") then Level_Too_Low:FireClient(player) return end

            playSound(UnlockSoundId, player)
            PlayerManager:AddMoney(player, -cost)
            PlayerManager:AddById(player, 1, "ItemCount")
            self.Tycoon:PublishTopic("Button", id)
            self.Instance:Destroy()
        end
    end
end


return Button