local Me = game.Players.LocalPlayer.Character

local CameraDic = {}

function CameraDic.returnCameraDic(CrushCharacter, Assets)
	local Cameras = Assets.Cameras
	local CutScene = {
		
		[1] = {Position = Cameras.Outside1.Position, LookPosition = Me.Head.Position, Speed = 1},
		[2] = {Position = Cameras.Outside2.Position, LookPosition = Me.Head.Position, Speed = 1},
		[3] = {Position = Cameras.Outside3.Position, LookPosition = Me.Head.Position, Speed = 1},
		[4] = {Position = Cameras.Outside4.Position, LookPosition = Me.Head.Position, Speed = 1},
		[5] = {Position = Cameras.Outside1.Position, LookPosition = Me.Head.Position, Speed = 1},
		[6] = {Position = Cameras.Outside5.Position, LookPosition = CrushCharacter.Head.Position, Speed = 1},
		[7] = {Position = Cameras.Outside6.Position, LookPosition = CrushCharacter.Head.Position, Speed = 1},
		[8] = {Position = Cameras.Outside1.Position, LookPosition = Me.Head.Position, Speed = 1},
		[9] = {Position = Cameras.Outside6.Position, LookPosition = CrushCharacter.Head.Position, Speed = 1},

		[10] = {Position = Cameras.Outside7.Position, LookPosition = Cameras.Inside1.Position, Speed = 1},
		[11] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 1},
		[12] = {Position = Cameras.Outside1.Position, LookPosition = Me.Head.Position, Speed = 1},
		[13] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 1},
		[14] = {Position = Cameras.Outside3.Position, LookPosition = Me.Head.Position, Speed = 1},
		--Explosions
		[15] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[16] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[17] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[18] = {Position = Cameras.Outside2.Position, LookPosition = Me.Head.Position, Speed = 1},
		[19] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[20] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[21] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[22] = {Position = Cameras.Outside2.Position, LookPosition = Me.Head.Position, Speed = 1},
		[23] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[24] = {Position = Cameras.Outside8.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[25] = {Position = Cameras.Outside2.Position, LookPosition = Me.Head.Position, Speed = 1},

		--
		[26] = {Position = Cameras.Outside9.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[27] = {Position = Cameras.Outside3.Position, LookPosition = Cameras.Inside1.Position, Speed = 2},
		[28] = {Position = Cameras.Outside1.Position, LookPosition = Me.Head.Position, Speed = 1}
	}

	return CutScene
end

return CameraDic

