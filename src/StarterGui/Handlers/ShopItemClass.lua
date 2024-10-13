local ShopItemClass = {}

ShopItemClass.__index = ShopItemClass

function ShopItemClass.new()
    local self = setmetatable({}, ShopItemClass)
    return self
end

local function cloneFrame()
    
end

function ShopItemClass:Init()
end

function ShopItemClass:OnPress()
end
return ShopItemClass