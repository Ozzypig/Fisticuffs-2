--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CmdrClient

local CmdrController = {}

function CmdrController.Init()
	-- https://eryn.io/Cmdr/guide/Setup.html
	CmdrClient = (require :: any)(ReplicatedStorage:WaitForChild("CmdrClient"))
	print("CmdrController initialized")
end

function CmdrController.Start()
	CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
	print("CmdrController started")
end

return CmdrController
