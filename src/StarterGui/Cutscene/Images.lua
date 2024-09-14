local player = game.Players.LocalPlayer
local LocalPlayerImage = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local Images = {
	[player.Name] = LocalPlayerImage,
	["Crush"] = "rbxassetid://80083310057465",
	["Disgusted Crush"] = "rbxassetid://83542285898589"
}



return Images

