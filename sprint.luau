local UIS = game:GetService("UserInputService")

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


UIS.InputBegan:Connect(function(input, gameProcessed)
	local currentSpeed = humanoid.WalkSpeed

	if gameProcessed then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			player.Character.Humanoid.WalkSpeed = currentSpeed + 16
		end
	end


end)

UIS.InputEnded:Connect(function(input, gameProcessed)
	local currentSpeed = humanoid.WalkSpeed - 16
	if gameProcessed then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			player.Character.Humanoid.WalkSpeed = currentSpeed
		end
	end

end)
