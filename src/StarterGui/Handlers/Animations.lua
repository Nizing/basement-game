local Animations = {}

local CryId = "rbxassetid://18991841924"
local CrySoundId = "rbxassetid://18996955548"
function Animations.CryAnimation(player : Player)
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")

    local newAnimation = Instance.new("Animation")
    newAnimation.AnimationId = CryId
    local newSound = Instance.new("Sound")
    newSound.SoundId = CrySoundId
    newSound.Parent = humanoid
    

    local character = player.Character
    local humanoid = character.Humanoid
    local Animator = humanoid:WaitForChild("Animator")
    
    local Cry = Animator:LoadAnimation(newAnimation)
    Cry:Play()
    newSound:Play()
    
    task.wait(2)
    newAnimation:Destroy()
    newSound:Destroy()
end


return Animations