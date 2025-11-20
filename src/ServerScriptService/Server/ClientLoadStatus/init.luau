--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)

local PlayerCache = require(ReplicatedStorage.Shared.Util.PlayerCache)

local GameEnums = require(ReplicatedStorage.Shared.GameEnums)

local logger = Logging:getLogger("Server")

local serverComm = require(script.Parent.ServerComm)

local playerLoadStatusCache: PlayerCache.PlayerCache<GameEnums.GameLoadStatus> =
	PlayerCache.new(GameEnums.GameLoadStatus.Loading)

local function setLoadStatus(player: Player, newStatus: GameEnums.GameLoadStatus)
	assert(GameEnums.tGameLoadStatus(newStatus))
	logger:debug("Client %s load status %s", player.Name, newStatus)
	playerLoadStatusCache:Set(player, newStatus)
end
serverComm:BindFunction("SetLoadStatus", setLoadStatus)

local ClientLoadStatus = {}

ClientLoadStatus.PlayerCache = playerLoadStatusCache

return ClientLoadStatus
