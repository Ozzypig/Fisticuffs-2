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

local children: { Instance } = script:GetChildren()

-- ensure consistent loading order by requiring in alphabetical order
table.sort(children, function(childLHS, childRHS)
	return childLHS.Name < childRHS.Name
end)

for _, child in children do
	assert(child:IsA("ModuleScript"), "Expected only ModuleScripts in Features folder.")
	-- :: any cast silences "unsupported require path" warning
	local feature = (require :: any)(child)
	assert(typeof(feature) == "table", "Feature module did not return a table.")
	feature.Name = child.Name
	assert(tFeature(feature))
	-- :: Feature cast is safe here due to the type check above
	table.insert(Features, feature :: Feature)
end

return Features
