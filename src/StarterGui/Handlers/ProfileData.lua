local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Get_Profile : RemoteFunction = ReplicatedStorage.Remotes.Get_Profile
local Get_Loaded : RemoteFunction = ReplicatedStorage.Remotes.Get_Loaded
local player = Players.LocalPlayer

local Profile = {}

function Profile.Loaded()
    return Get_Loaded:InvokeServer(player)
end

function Profile.GetProfile()
    local Data = Get_Profile:InvokeServer(player)
    return Data
end

return Profile