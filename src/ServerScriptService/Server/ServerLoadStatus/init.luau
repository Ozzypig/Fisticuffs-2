--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.Packages.t)
local Logging = require(ReplicatedStorage.Packages.Logging)

local GameEnums = require(ReplicatedStorage.Shared.GameEnums)

local logger = Logging:getLogger("Server")
local serverComm = require(script.Parent.ServerComm)

local statusProperty = serverComm:CreateProperty("LoadStatus", GameEnums.GameLoadStatus.Loading)

local ServerLoadStatus = {}

local tSetStatus = t.tuple(GameEnums.tGameLoadStatus)
function ServerLoadStatus.Set(newStatus: GameEnums.GameLoadStatus)
	assert(tSetStatus(newStatus))
	statusProperty:Set(newStatus)
	logger:debug("Status changed to %s", newStatus)
end

return ServerLoadStatus
