--!strict
--[=[
	@class Client
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)

local LoadUtil = require(ReplicatedStorage.Shared.LoadUtil)
local initLogging = require(ReplicatedStorage.Shared.initLogging)

local Client = {}

local logger = Logging:getLogger("Client")

function Client.Init(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Controller", "Init")
end

function Client.Start(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Controller", "Start")
end

function Client.Main()
	initLogging()
	return Promise.resolve()
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Client.Init)
		:andThenCall(Client.Start)
end

return Client
