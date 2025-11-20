--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)
local Logging = require(ReplicatedStorage.Packages.Logging)

local Features = require(ReplicatedStorage.Shared.Features)

local LoadUtil = {}

function LoadUtil.InitLogging()
	-- TODO: Configure via instance attribute
	Logging:basicConfig({
		level = Logging.Level.Debug,
		format = "[%(name)s:%(level)s] %(message)s",
	})
end

function LoadUtil.EachFeatureCallAsync(logger: any, moduleName: string, methodName: string): Promise.Promise<>
	local promises: { Promise.Promise<> } = {}
	for _, feature in Features do
		local module = feature[moduleName]
		if module and typeof(module[methodName]) == "function" then
			table.insert(
				promises,
				Promise
					.try(module[methodName]) --
					:andThenCall(logger.debug, logger, "Initialized %s", feature.Name)
			)
		end
	end
	return Promise.all(promises)
end

return LoadUtil
