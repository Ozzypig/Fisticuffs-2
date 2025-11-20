--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local CmdrServer

local CmdrService = {}

function CmdrService.Init()
	print("CmdrService initialized")
	CmdrServer = require(ServerScriptService.ServerPackages.Cmdr)
end

function CmdrService.Start()
	CmdrServer:RegisterDefaultCommands()
end

return CmdrService
