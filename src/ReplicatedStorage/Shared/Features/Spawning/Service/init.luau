--!strict

local Players = game:GetService("Players")

return {
	Init = function()
		-- Turn off automatic character loading (this feature handles it manually)
		if Players.CharacterAutoLoads then
			warn(
				"Spawning feature handles character loading manually. Set CharacterAutoLoads false to disable this warning."
			)
			Players.CharacterAutoLoads = false
		end
	end,
	Start = function()
		(require :: any)(script.Components.Spawning)

		local function onPlayerAdded(player: Player)
			player:AddTag("Spawning")
		end
		Players.PlayerAdded:Connect(onPlayerAdded)
		for _, player in Players:GetPlayers() do
			onPlayerAdded(player)
		end
	end,
}
