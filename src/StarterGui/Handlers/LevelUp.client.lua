local LevelUpClass = require(script.Parent.LevelUpClass)
local ProfileModule = require(script.Parent.ProfileData)

local profile = ProfileModule.GetProfile()

local Data = {
	[1] = {
		Title = "Level up with Tears",
		Cost = 60, 
		Level = profile.ClientLevels[1],
		Image = "rbxassetid://19003295395",
		Currency = "Tears",
	},
	[2] = {
		Title = "Level up with Strength",
		Cost = 40, 
		Level = profile.ClientLevels[2],
		Image = "rbxassetid://18981874946",
		Currency = "Physique",
	},
	[3] = {
		Title = "Level up with Looks",
		Cost = 30, 
		Level = profile.ClientLevels[3],
		Image = "rbxassetid://70774566978748",
		Currency = "Looks",
	},
	[4] = {
		Title = "Level up with Diet",
		Cost = 15,
		Level = profile.ClientLevels[4],
		Image = "rbxassetid://109631826263073",
		Currency = "Diet",
	}
}


for i, page in pairs(Data) do
    local newLevelUp = LevelUpClass.new(page.Title, page.Cost,page.Level ,page.Image , page.Currency, i)
	newLevelUp:Init()
end


