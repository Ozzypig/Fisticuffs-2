--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

local tFeatureModule = t.strictInterface({
	Init = t.callback,
	Start = t.callback,
})
export type FeatureModule = {
	Init: () -> (),
	Start: () -> (),
}

local tFeature = t.strictInterface({
	Name = t.string,
	Service = t.optional(tFeatureModule),
	Controller = t.optional(tFeatureModule),
})
export type Feature = {
	Name: string,
	Service: any,
	Controller: any,
}

local Features: { Feature } = {}

for _, child in script:GetChildren() do
	if child:IsA("ModuleScript") then
		-- :: any cast silences "unsupported require path" warning
		local feature = (require :: any)(child)
		assert(typeof(feature) == "table", "Feature module did not return a table.")
		feature.Name = child.Name
		local isValid, err = tFeature(feature)
		if isValid then
			-- :: Feature cast is safe here due to the type check above
			Features[child.Name] = feature :: Feature
		else
			error(("Feature '%s' is malformed: %s"):format(child.Name, err))
		end
	else
		error(("Unexpected child '%s' in Features folder; expected only ModuleScripts."):format(child.Name))
	end
end

table.sort(Features, function(featureLHS: Feature, featureRHS: Feature): boolean
	return featureLHS.Name < featureRHS.Name
end)

return Features
