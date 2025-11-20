--!strict
--[=[
	@class Server
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Features = require(ReplicatedStorage.Shared.Features)

local Server = {}

function Server.Init()
	-- TODO: Asynchronous init
	for _, feature in Features do
		if feature.Service and feature.Service.Init then
			print("Initializing feature:", feature.Name)
			feature.Service.Init()
		end
	end
end

function Server.Start()
	-- TODO: Asynchronous start
	for _, feature in Features do
		if feature.Service and feature.Service.Start then
			print("Starting feature:", feature.Name)
			feature.Service.Start()
		end
	end
end

function Server.Main()
	print("Hello, world from server")
	-- TODO: Promise chain
	Server.Init()
	Server.Start()
end

return Server
