local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Formatowanie liczb (K, M, B...)
local function formatNumber(number)
	local suffixes = {"", "K", "M", "B", "T", "Q", "Qi"}
	local i = 1

	while number >= 1000 and i < #suffixes do
		number = number / 1000
		i = i + 1
	end

	return string.format("%.1f", number):gsub("%.0", "") .. suffixes[i]
end

local gui = script.Parent

-- Ładowanie elementów UI
local avatarImage = gui:WaitForChild("AA_AvatarImage")
local nickText = gui:WaitForChild("AB_NickText")

local goldFrame = gui:WaitForChild("AC_GoldFrame")
local goldText = goldFrame:WaitForChild("GoldText")

local capacityFrame = gui:WaitForChild("AD_CapacityFrame")
local capacityText = capacityFrame:WaitForChild("CapacityText")
local capacityFill = capacityFrame:WaitForChild("Fill")

local itemsBar = gui:WaitForChild("AF_ItemsBar")

local hotbarSlots = {
	[1] = itemsBar:WaitForChild("Slot1"),
	[2] = itemsBar:WaitForChild("Slot2"),
	[3] = itemsBar:WaitForChild("Slot3"),
	[4] = itemsBar:WaitForChild("Slot4"),
	[5] = itemsBar:WaitForChild("Slot5"),
	[6] = itemsBar:WaitForChild("Slot6")
}

local levelFrame = gui:WaitForChild("AG_MiningLevel")
local levelText = levelFrame:WaitForChild("TextLabel")

nickText.Text = player.DisplayName

-- Miniatura gracza
local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
if isReady then
	avatarImage.Image = content
end

-- Aktualizacja interfejsu po wczytaniu statystyk
local function updateStats()
	local leaderstats = player:WaitForChild("leaderstats")
	local hiddenstats = player:WaitForChild("hiddenstats")

	local coins = leaderstats:WaitForChild("Coins")
	local cap = hiddenstats:WaitForChild("Cap")
	local maxCap = hiddenstats:WaitForChild("MaxCap")

	coins.Changed:Connect(function(newValue)
		goldText.Text = "Gold: " .. formatNumber(newValue)
	end)
	goldText.Text = "Gold: " .. formatNumber(coins.Value)

	local function refreshCapacity()
		local currentCap = cap.Value
		local max = maxCap.Value

		capacityText.Text = "Capacity: " .. formatNumber(currentCap) .. " / " .. formatNumber(max)

		local fillPercentage = 0
		if max > 0 then
			fillPercentage = math.clamp(currentCap / max, 0, 1)
		end

		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local celAnimacji = {Size = UDim2.new(fillPercentage, 0, 1, 0)}

		TweenService:Create(capacityFill, tweenInfo, celAnimacji):Play()
	end

	cap.Changed:Connect(refreshCapacity)
	maxCap.Changed:Connect(refreshCapacity)
	refreshCapacity()
end

if player:FindFirstChild("leaderstats") and player:FindFirstChild("hiddenstats") then
	updateStats()
else
	player.ChildAdded:Connect(function()
		if player:FindFirstChild("leaderstats") and player:FindFirstChild("hiddenstats") then
			updateStats()
		end
	end)
end

-- Hotbar
local originalSizes = {}
for _, slot in pairs(hotbarSlots) do
	originalSizes[slot] = slot.Size
end

local tweenInfoFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local currentSelectedSlot = nil

local function selectSlot(index)
	if currentSelectedSlot == index then
		currentSelectedSlot = nil
	else
		currentSelectedSlot = index
	end

	for i, slot in pairs(hotbarSlots) do
		local stroke = slot:FindFirstChild("UIStroke")
		local baseSize = originalSizes[slot]

		if i == currentSelectedSlot then
			local enlargedSize = UDim2.new(
				baseSize.X.Scale * 1.15, baseSize.X.Offset * 1.15,
				baseSize.Y.Scale * 1.15, baseSize.Y.Offset * 1.15
			)

			TweenService:Create(slot, tweenInfoFast, {Size = enlargedSize}):Play()

			if stroke then
				TweenService:Create(stroke, tweenInfoFast, {
					Color = Color3.fromRGB(255, 215, 0),
					Thickness = 3
				}):Play()
			end
		else
			TweenService:Create(slot, tweenInfoFast, {Size = baseSize}):Play()

			if stroke then
				TweenService:Create(stroke, tweenInfoFast, {
					Color = Color3.fromRGB(100, 100, 100),
					Thickness = 2
				}):Play()
			end
		end
	end
end

for i, slot in pairs(hotbarSlots) do
	if slot:IsA("GuiButton") then
		slot.MouseButton1Click:Connect(function()
			selectSlot(i)
		end)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.One then selectSlot(1) end
	if input.KeyCode == Enum.KeyCode.Two then selectSlot(2) end
	if input.KeyCode == Enum.KeyCode.Three then selectSlot(3) end
	if input.KeyCode == Enum.KeyCode.Four then selectSlot(4) end
	if input.KeyCode == Enum.KeyCode.Five then selectSlot(5) end
	if input.KeyCode == Enum.KeyCode.Six then selectSlot(6) end
end)

selectSlot(nil)
