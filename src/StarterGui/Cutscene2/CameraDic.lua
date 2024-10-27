local CameraDic = {}

function CameraDic.returnCameraDic(CrushCharacter, Assets)
	local Cameras = Assets.Cameras
	local CutScene = {
		{Shot = Cameras.Camera1_p.CFrame, Speed = 1},
		{Shot = Cameras.Camera4.CFrame, Speed = 1},
		{Shot = Cameras.Camera3.CFrame, Speed = 1},
		{Shot = Cameras.Camera1_p.CFrame, Speed = 1},
		{Shot = Cameras.Camera1_g.CFrame, Speed = 1},
		--5
		{Shot = Cameras.Camera2_g.CFrame, Speed = 1},
		{Shot = Cameras.Camera3_g.CFrame, Speed = 1},
		{Shot = Cameras.Camera1_g.CFrame, Speed = 1},
		{Shot = Cameras.Camera2_p.CFrame, Speed = 1},
		{Shot = Cameras.Camera3_g.CFrame, Speed = 1},
		--5
		{Shot = Cameras.Camera1_p.CFrame, Speed = 1},
		{Shot = Cameras.Camera2_p.CFrame, Speed = 1},
		{Shot = Cameras.Camera2_g.CFrame, Speed = 1},
		{Shot = Cameras.Camera1_p.CFrame, Speed = 1},
		{Shot = Cameras.Camera3_p.CFrame, Speed = 1},
		--5
		{Shot = Cameras.Camera1_g.CFrame, Speed = 1},
		{Shot = Cameras.Camera1_p.CFrame, Speed = 1} 
	}
	return CutScene
end

return CameraDic