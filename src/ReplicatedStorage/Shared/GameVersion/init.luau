--!strict
--[=[
	Returns the current game version as a string.

	@class GameVersion
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameVersion = ReplicatedStorage.GameVersion

return GameVersion.Value:match("^%s*([^%s]*)%s*$")
