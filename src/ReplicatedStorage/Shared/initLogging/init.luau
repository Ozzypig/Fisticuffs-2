--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logging = require(ReplicatedStorage.Packages.Logging)

local function initLogging()
	-- TODO: Configure via instance attribute
	Logging:basicConfig({
		level = Logging.Level.Debug,
		format = "[%(name)s:%(level)s] %(message)s",
	})
end

return initLogging
