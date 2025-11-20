--!strict
--[=[
	@class Client
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)

local initLogging = require(ReplicatedStorage.Shared.initLogging)
local Features = require(ReplicatedStorage.Shared.Features)

local Client = {}

local logger = Logging:getLogger("Client")

function Client.Init(): Promise.Promise<>
	local promises: { Promise.Promise<> } = {}
	for _, feature in Features do
		if feature.Controller and feature.Controller.Init then
			table.insert(
				promises,
				Promise
					.try(feature.Controller.Init) --
					:andThenCall(logger.debug, logger, "Initialized %s", feature.Name)
			)
		end
	end
	return Promise.all(promises)
end

function Client.Start(): Promise.Promise<>
	local promises: { Promise.Promise<> } = {}
	for _, feature in Features do
		if feature.Controller and feature.Controller.Start then
			table.insert(
				promises,
				Promise
					.try(feature.Controller.Start) --
					:andThenCall(logger.debug, logger, "Started %s", feature.Name)
			)
		end
	end
	return Promise.all(promises)
end

function Client.Main()
	initLogging()
	return Promise.resolve()
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Client.Init)
		:andThenCall(Client.Start)
end

return Client
