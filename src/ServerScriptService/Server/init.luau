--!strict
--[=[
	@class Server
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)

local initLogging = require(ReplicatedStorage.Shared.initLogging)
local Features = require(ReplicatedStorage.Shared.Features)

local Server = {}

local logger = Logging:getLogger("Server")

function Server.Init()
	-- TODO: Asynchronous init
	for _, feature in Features do
		if feature.Service and feature.Service.Init then
			logger:debug("Initializing %s", feature.Name)
			feature.Service.Init()
		end
	end
end

function Server.Start()
	-- TODO: Asynchronous start
	for _, feature in Features do
		if feature.Service and feature.Service.Start then
			logger:debug("Starting %s", feature.Name)
			feature.Service.Start()
		end
	end
end

function Server.Main()
	initLogging()
	logger:debug("Main")
	-- TODO: Promise chain
	Server.Init()
	Server.Start()
end

return Server
