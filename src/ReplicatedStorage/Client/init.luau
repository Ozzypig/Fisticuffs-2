--!strict
--[=[
	@class Client
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logging = require(ReplicatedStorage.Packages.Logging)

local initLogging = require(ReplicatedStorage.Shared.initLogging)
local Features = require(ReplicatedStorage.Shared.Features)

local Client = {}

local logger = Logging:getLogger("Client")

function Client.Init()
	-- TODO: Asynchronous init
	for _, feature in Features do
		if feature.Controller and feature.Controller.Init then
			logger:debug("Initializing %s", feature.Name)
			feature.Controller.Init()
		end
	end
end

function Client.Start()
	-- TODO: Asynchronous start
	for _, feature in Features do
		if feature.Controller and feature.Controller.Start then
			logger:debug("Starting %s", feature.Name)
			feature.Controller.Start()
		end
	end
end

function Client.Main()
	initLogging()
	logger:debug("Main")
	-- TODO: Promise chain
	Client.Init()
	Client.Start()
end

return Client
