--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logging = require(ReplicatedStorage.Packages.Logging)

local CmdrClient
local logger = Logging:getLogger("CmdrController")

local CmdrController = {}

function CmdrController.Init()
	-- https://eryn.io/Cmdr/guide/Setup.html
	CmdrClient = (require :: any)(ReplicatedStorage:WaitForChild("CmdrClient"))
	logger:debug("Required CmdrClient")
end

function CmdrController.Start()
	CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
	logger:debug("Set activation keys")
end

return CmdrController
