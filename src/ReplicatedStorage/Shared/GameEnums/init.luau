--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

local ServerStatus = require(script.ServerStatus)

export type ServerStatus = ServerStatus.ServerStatus

local GameEnums = {
	ServerStatus = ServerStatus,
	tServerStatus = t.keyOf(ServerStatus),
}

return GameEnums
