

local Template = {
	Tears = 0,
	Physique = 0,
	Diet = 0,
	Looks = 0,
	Money = 100,
	Level = 0,
	ItemCount = 0,
	UnlockIds = {},
	DoorIds = {},
	VideoIds = {1},
}

Template.Upgrades = {
	[1] = 0, -- Levels
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

Template.ClientLevels = {
	[1] = 0, -- Levels
	[2] = 0,
	[3] = 0,
	[4] = 0
}

Template.Multipliers = {
	["Money"] = 0.6,
	["Tears"] = 1,
	["Physique"] = 1,
	["Looks"] = 1,
	["Diet"] = 1,
}


return Template

