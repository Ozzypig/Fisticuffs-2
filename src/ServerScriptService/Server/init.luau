--!strict
--[=[
	@class Server
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)

local LoadUtil = require(ReplicatedStorage.Shared.LoadUtil)

local Server = {}

local logger = Logging:getLogger("Server")

function Server.Init(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Service", "Init")
end

function Server.Start(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Service", "Start")
end

function Server.Main(): Promise.Promise<>
	LoadUtil.InitLogging()
	return Promise.resolve()
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Server.Init)
		:andThenCall(Server.Start)
end

return Server
