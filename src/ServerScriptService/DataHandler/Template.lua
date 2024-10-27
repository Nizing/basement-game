

local Template = {
	Tears = 0,
	Physique = 0,
	Diet = 0,
	Looks = 0,
	Money = 0,
	Level = 0,
	ItemCount = 0,
	UnlockIds = {},
	DoorIds = {},
	VideoIds = {1},
	RebirthMultiplier = 1,

	globalMultiplier = 1,
	Sprinting = false
}

Template.Upgrades = {
	[1] = 0, -- Levels
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
}

Template.ClientLevels = {
	[1] = 0, -- Levels
	[2] = 0,
	[3] = 0,
	[4] = 0
}

Template.StronkLevels = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0
}

Template.PassiveIncomes = {
	["Tears"] = nil,
	["Physique"] = nil,
	["Looks"] = nil,
	["Diet"] = nil
}

Template.Multipliers = {
	["Money"] = 0.6,
	["Tears"] = 1,
	["Physique"] = 1,
	["Looks"] = 1,
	["Diet"] = 1,
}





return Template

