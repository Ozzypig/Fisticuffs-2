--!strict
--[=[
	@class Client
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Features = require(ReplicatedStorage.Shared.Features)

local Client = {}

function Client.Init()
	-- TODO: Asynchronous init
	for _, feature in Features do
		if feature.Controller and feature.Controller.Init then
			print("Initializing feature:", feature.Name)
			feature.Controller.Init()
		end
	end
end

function Client.Start()
	-- TODO: Asynchronous start
	for _, feature in Features do
		if feature.Controller and feature.Controller.Start then
			print("Starting feature:", feature.Name)
			feature.Controller.Start()
		end
	end
end

function Client.Main()
	print("Hello, world from client")
	-- TODO: Promise chain
	Client.Init()
	Client.Start()
end

return Client
