--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

local GameLoadStatus = require(script.GameLoadStatus)

export type GameLoadStatus = GameLoadStatus.GameLoadStatus

local GameEnums = {
	GameLoadStatus = GameLoadStatus,
	tGameLoadStatus = t.keyOf(GameLoadStatus),
}

return GameEnums
