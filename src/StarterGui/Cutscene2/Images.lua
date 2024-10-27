local player = game.Players.LocalPlayer
local LocalPlayerImage = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local Images = {
	["OriginalFace"] = player.Character.Head.face.Texture,
	[player.Name] = LocalPlayerImage,
	["Crush"] = "rbxassetid://80083310057465",
	["Disgusted Crush"] = "rbxassetid://83542285898589",
	["Girl"] = "rbxassetid://80083310057465",
	["He Who Knows"] = "rbxassetid://82259517426462"
}



return Images

