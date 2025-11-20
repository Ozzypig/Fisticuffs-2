--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)
local Logging = require(ReplicatedStorage.Packages.Logging)

export type PlayerCache<T> = {
	Changed: Signal.Signal<Player, T>,
	Set: (self: PlayerCache<T>, player: Player, value: T) -> (),
	Clear: (self: PlayerCache<T>, player: Player) -> (),
	Get: (self: PlayerCache<T>, player: Player) -> T,
	Destroy: (self: PlayerCache<T>) -> (),
}

local logger = Logging:getLogger("PlayerCache")

local PlayerCache = {}
PlayerCache.All = {}

function PlayerCache.new<T>(defaultValue: T): PlayerCache<T>
	local cache: { [Player]: T } = {}
	local changedSignal: Signal.Signal<Player, T> = Signal.new()
	local this = {
		Changed = changedSignal,
		Set = function(_self, player: Player, value: T)
			if player.Parent then
				local oldValue: T? = cache[player]
				cache[player] = value
				if oldValue ~= value then
					changedSignal:Fire(player, value)
				end
			else
				logger:warn("Setting PlayerCache for player %s failed because they left", player.Name)
			end
		end,
		Clear = function(_self, player: Player)
			local oldValue: T? = cache[player]
			cache[player] = nil
			if oldValue ~= nil then
				changedSignal:Fire(player, defaultValue)
			end
		end,
		Get = function(_self, player: Player): T
			return cache[player] or defaultValue
		end,
		Destroy = function(self)
			PlayerCache.All[self] = nil
			for player: Player, _value: T in cache do
				self:Clear(player)
			end
		end,
	}
	PlayerCache.All[this] = true
	return this
end

local function onPlayerRemoving(player: Player)
	for cache in PlayerCache.All do
		cache:Clear(player)
	end
end
Players.PlayerRemoving:Connect(onPlayerRemoving)

return PlayerCache
