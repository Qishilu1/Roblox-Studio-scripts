local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wyciaganie myszki
local mouse = player:GetMouse()

-- Zadeklarowanie zmiennej dla wskaznika
local wskaznik = script.Parent

-- Podpinanie funkcji pod zdarzenie '.Activated' narzędzia
wskaznik.Activated:Connect(function()
	local new_block = Instance.new("Part")

	new_block.Size = Vector3.new(1, 1, 1)

	new_block.Anchored = true

	new_block.BrickColor = BrickColor.new("Really red")

	new_block.CFrame = mouse.Hit

	new_block.Parent = workspace
end)
