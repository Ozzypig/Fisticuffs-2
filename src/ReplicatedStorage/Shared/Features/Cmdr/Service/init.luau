--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logging = require(ReplicatedStorage.Packages.Logging)

local CmdrServer
local logger = Logging:getLogger("CmdrService")

local CmdrService = {}

function CmdrService.Init()
	CmdrServer = require(ServerScriptService.ServerPackages.Cmdr)
	logger:debug("Required Cmdr")
end

function CmdrService.Start()
	CmdrServer:RegisterDefaultCommands()
	logger:debug("Registered default commands")
end

return CmdrService
