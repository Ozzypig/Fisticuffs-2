--!strict
--[=[
	@class Client
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Comm = require(ReplicatedStorage.Packages.Comm)

local LoadUtil = require(ReplicatedStorage.Shared.LoadUtil)
local GameEnums = require(ReplicatedStorage.Shared.GameEnums)

local Client = {}

local clientComm = Comm.ClientComm.new(ReplicatedStorage, true, "Server")
local statusProperty = clientComm:GetProperty("LoadStatus", nil, nil)
local setLoadStatus = clientComm:GetFunction("SetLoadStatus")
local logger = Logging:getLogger("Client")

function Client.WaitForServerStatus(desiredStatus: GameEnums.GameLoadStatus): Promise.Promise<>
	if statusProperty:IsReady() and statusProperty:Get() == desiredStatus then
		return Promise.resolve()
	end
	return statusProperty
		:OnReady()
		:andThenCall(Promise.fromEvent, statusProperty.Changed, function(newStatus: GameEnums.GameLoadStatus)
			assert(newStatus ~= GameEnums.GameLoadStatus.Crashed, "Server crashed")
			return newStatus == desiredStatus
		end)
end

function Client.Init(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Controller", "Init")
end

function Client.Start(): Promise.Promise<>
	return LoadUtil.EachFeatureCallAsync(logger, "Controller", "Start")
end

function Client.Main()
	LoadUtil.InitLogging()
	return Promise
		.resolve()
		:andThenCall(Client.WaitForServerStatus, GameEnums.GameLoadStatus.Started)
		:catch(function(rejectValue: any)
			logger:critical("Server failed to start: %s", tostring(rejectValue))
		end)
		:andThenCall(logger.debug, logger, "Main")
		:andThenCall(Client.Init)
		:andThenCall(Client.Start)
		-- Report to server that client has loaded
		:andThenCall(setLoadStatus, GameEnums.GameLoadStatus.Started)
end

return Client
