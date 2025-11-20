--!strict
--[=[
	@class Server
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.Packages.t)
local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Comm = require(ReplicatedStorage.Packages.Comm)

local GameEnums = require(ReplicatedStorage.Shared.GameEnums)
local LoadUtil = require(ReplicatedStorage.Shared.LoadUtil)

local Server = {}

local serverComm = Comm.ServerComm.new(ReplicatedStorage, "Server")
local statusProperty = serverComm:CreateProperty("LoadStatus", GameEnums.ServerStatus.Loading)
local logger = Logging:getLogger("Server")

local tSetStatus = t.tuple(GameEnums.tServerStatus)
function Server.SetStatus(newStatus: GameEnums.ServerStatus)
	assert(tSetStatus(newStatus))
	statusProperty:Set(newStatus)
	logger:debug("Status changed to %s", newStatus)
end

function Server.Init(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Service", "Init")
end

function Server.Start(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Service", "Start")
end

function Server.Main(): Promise.Promise<>
	LoadUtil.InitLogging()
	local promise = Promise.resolve()
		:andThenCall(Server.SetStatus, GameEnums.ServerStatus.Starting)
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Server.Init)
		:andThenCall(Server.Start)
		:andThenCall(Server.SetStatus, GameEnums.ServerStatus.Started)
	promise:catch(function()
		Server.SetStatus(GameEnums.ServerStatus.Crashed)
	end)
	return promise
end

return Server
