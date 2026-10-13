local Players = game:GetService("Players")
local player = Players.LocalPlayer
local kilof = script.Parent
local kamien = workspace.Trening.Trening_Kamien:WaitForChild("Part")

local kopanieEvent = game.ReplicatedStorage:WaitForChild("KopanieEvent")

local moznaKopac = true

kilof.Activated:Connect(function()
	if moznaKopac == false then return end

	local character = player.Character

	if character ~= nil then
		local distance = (character.HumanoidRootPart.Position - kamien.Position).Magnitude

		if distance < 10 then
			moznaKopac = false

			kopanieEvent:FireServer()

			task.wait(0.5)
			moznaKopac = true
		end
	end
end)
