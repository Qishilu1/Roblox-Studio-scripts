local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()

local playerGui = player:WaitForChild("PlayerGui")

local sklepGui = playerGui:WaitForChild("SklepGui")
local shop_window = sklepGui:WaitForChild("PickaxeFrameShop")
local close_button = shop_window:WaitForChild("CloseMenu")

local npc = workspace.Lobby.EQ_Shop:WaitForChild("Sprzedawca", 5)

if not npc or not npc:WaitForChild("HumanoidRootPart", 5) then
	warn("Nie znaleziono sprzedawcy w EQ Shop")
	return
end

local npcRoot = npc.HumanoidRootPart
local distance_open = 10

shop_window.AnchorPoint = Vector2.new(0.5, 0.5)
shop_window.Position = UDim2.new(0.5, 0, 1.5, 0)
shop_window.Visible = true

local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = Lighting

local tweenOpenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenCloseInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local isOpen = false
local manuallyClosed = false

local function openShop()
	isOpen = true
	TweenService:Create(shop_window, tweenOpenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	TweenService:Create(blurEffect, tweenOpenInfo, {Size = 18}):Play()
end

local function closeShop()
	isOpen = false
	TweenService:Create(shop_window, tweenCloseInfo, {Position = UDim2.new(0.5, 0, 1.5, 0)}):Play()
	TweenService:Create(blurEffect, tweenCloseInfo, {Size = 0}):Play()
end

close_button.MouseButton1Click:Connect(function()
	if isOpen then
		manuallyClosed = true
		closeShop()
	end
end)

while true do
	task.wait(0.1)

	local character = player.Character

	if character and character:FindFirstChild("HumanoidRootPart") then
		local rootPart = character.HumanoidRootPart

		local distance = (rootPart.Position - npcRoot.Position).Magnitude

		if distance <= distance_open then
			if not isOpen and not manuallyClosed then
				openShop()
			end
		else
			if manuallyClosed then
				manuallyClosed = false
			end

			if isOpen then
				closeShop()
			end
		end
	end
end
