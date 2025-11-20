--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Comm = require(ReplicatedStorage.Packages.Comm)

local serverComm = Comm.ServerComm.new(ReplicatedStorage, "Server")

return serverComm
