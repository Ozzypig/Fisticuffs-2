--!strict
--[=[
	@class Server
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)

local GameEnums = require(ReplicatedStorage.Shared.GameEnums)
local LoadUtil = require(ReplicatedStorage.Shared.LoadUtil)

local Server = {}

local _ClientLoadStatus = require(script.ClientLoadStatus)
local ServerLoadStatus = require(script.ServerLoadStatus)

local logger = Logging:getLogger("Server")

function Server.Init(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Service", "Init")
end

function Server.Start(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Service", "Start")
end

function Server.Main(): Promise.Promise<>
	LoadUtil.InitLogging()
	ServerLoadStatus.Set(GameEnums.GameLoadStatus.Starting)
	local promise = Promise.resolve()
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Server.Init)
		:andThenCall(Server.Start)
		:andThenCall(ServerLoadStatus.Set, GameEnums.GameLoadStatus.Started)
	promise:catch(function()
		ServerLoadStatus.Set(GameEnums.GameLoadStatus.Crashed)
	end)
	return promise
end

return Server
