--!strict
--[=[
	@class Server
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)

local initLogging = require(ReplicatedStorage.Shared.initLogging)
local Features = require(ReplicatedStorage.Shared.Features)

local Server = {}

local logger = Logging:getLogger("Server")

function Server.Init(): Promise.Promise<>
	local promises: { Promise.Promise<> } = {}
	for _, feature in Features do
		if feature.Service and feature.Service.Init then
			table.insert(
				promises,
				Promise
					.try(feature.Service.Init) --
					:andThenCall(logger.debug, logger, "Initialized %s", feature.Name)
			)
		end
	end
	return Promise.all(promises)
end

function Server.Start(): Promise.Promise<>
	local promises: { Promise.Promise<> } = {}
	for _, feature in Features do
		if feature.Service and feature.Service.Start then
			table.insert(
				promises,
				Promise
					.try(feature.Service.Start) --
					:andThenCall(logger.debug, logger, "Started %s", feature.Name)
			)
		end
	end
	return Promise.all(promises)
end

function Server.Main(): Promise.Promise<>
	initLogging()
	return Promise.resolve()
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Server.Init)
		:andThenCall(Server.Start)
end

return Server
