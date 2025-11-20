--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)

local ClientLoadStatus = require(game:GetService("ServerScriptService").Server.ClientLoadStatus)

local GameEnums = require(ReplicatedStorage.Shared.GameEnums)

local SpawningComponent = Component.new({
	Tag = "Spawning",
})

local function now(): number
	return workspace.DistributedGameTime
end

function SpawningComponent:Construct()
	assert(self.Instance:IsA("Player"))
	self.Spawning = false
	self.Player = self.Instance
	self.Trove = Trove.new()
end

function SpawningComponent:GetRespawnTime(): number
	return 2
end

function SpawningComponent:Spawn()
	self.Player:LoadCharacter()
end

function SpawningComponent:RespawnAfter(respawnDelay: number)
	self:CancelRespawn()
	self.RespawnPromise = Promise.delay(respawnDelay):andThen(function()
		if self.Spawning then
			self:Spawn()
		end
	end)
	self.Trove:AddPromise(self.RespawnPromise)
end

function SpawningComponent:CancelRespawn()
	if self.RespawnPromise then
		self.Trove:Remove(self.RespawnPromise)
		self.RespawnPromise = nil
	end
end

function SpawningComponent:_onCharacter(newCharacter: Instance)
	local humanoid = newCharacter and newCharacter:WaitForChild("Humanoid", 10)
	assert(humanoid, "Humanoid not found on character")
	assert(humanoid:IsA("Humanoid"), "Character's Humanoid is not a Humanoid")
	local conn
	conn = humanoid.Died:Connect(function()
		self.LastDeath = now()
		self.Trove:Remove(conn)
		if self.Spawning then
			local respawnTime = self:GetRespawnTime()
			self:RespawnAfter(respawnTime)
		end
	end)
	self.Trove:Add(conn)
end

function SpawningComponent:Despawn()
	if self.Player.Character then
		self.Player.Character:Destroy()
		self.Player.Character = nil
	end
end

function SpawningComponent:SetSpawning(isSpawning: boolean, immediate: boolean)
	self.Spawning = isSpawning
	if isSpawning and not self.Player.Character then
		if immediate then
			self:Spawn()
		else
			local timeSinceDeath = now() - (self.LastDeath or 0)
			local respawnDelay = math.max(0, self:GetRespawnTime() - timeSinceDeath)
			self:RespawnAfter(respawnDelay)
		end
	elseif not isSpawning and immediate and self.Player.Character then
		self:CancelRespawn()
		self:Despawn()
	end
end

function SpawningComponent:EnableSpawningOnLoad()
	local function onLoaded()
		self:SetSpawning(true)
	end
	local loadStatus = ClientLoadStatus.PlayerCache:Get(self.Player)
	if loadStatus == GameEnums.GameLoadStatus.Started then
		onLoaded()
	else
		self.Trove:AddPromise(
			Promise.fromEvent(ClientLoadStatus.PlayerCache.Changed, function(changedPlayer: Player, newStatus: any)
				return changedPlayer == self.Player and newStatus == GameEnums.GameLoadStatus.Started
			end):andThenCall(onLoaded)
		)
	end
end

function SpawningComponent:Start()
	self:EnableSpawningOnLoad()

	self.Trove:Connect(self.Player.CharacterAdded, function(newCharacter)
		self:_onCharacter(newCharacter)
	end)
	if self.Player.Character then
		self:_onCharacter(self.Player.Character)
	end
end

function SpawningComponent:Stop()
	self.Trove:Clean()
end

return SpawningComponent
