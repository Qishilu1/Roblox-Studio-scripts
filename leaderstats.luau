local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Tworzymy / otwieramy bazę
local BazaGracza = DataStoreService:GetDataStore("KopalniaZapis_V2") -- Zmieniono nazwę na V2, aby zresetować uszkodzony zapis z 0

local function stworzStatystyki(player)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local hiddenstats = Instance.new("Folder")
	hiddenstats.Name = "hiddenstats"
	hiddenstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 1
	level.Parent = leaderstats

	local cap = Instance.new("IntValue")
	cap.Name = "Cap"
	cap.Value = 0
	cap.Parent = hiddenstats

	local maxCap = Instance.new("IntValue")
	maxCap.Name = "MaxCap"
	maxCap.Value = 10
	maxCap.Parent = hiddenstats

	local exp = Instance.new("IntValue")
	exp.Name = "Exp"
	exp.Value = 0
	exp.Parent = hiddenstats

	local maxExp = Instance.new("IntValue")
	maxExp.Name = "MaxExp"
	maxExp.Value = 100
	maxExp.Parent = hiddenstats

	-- ODCZYT DANYCH
	local pobraneDane = nil

	local sukces, err = pcall(function()
		pobraneDane = BazaGracza:GetAsync(player.UserId)
	end)

	if sukces and pobraneDane ~= nil then
		-- Bezpieczny odczyt z domyślnymi wartościami (or)
		coins.Value = pobraneDane.Coins or 0
		level.Value = pobraneDane.Level or 1
		cap.Value = pobraneDane.Cap or 0
		maxCap.Value = pobraneDane.MaxCap or 10
		exp.Value = pobraneDane.Exp or 0
		maxExp.Value = pobraneDane.MaxExp or 100
	elseif not sukces then
		warn("Błąd podczas odczytu danych dla " .. player.Name .. ": " .. tostring(err))
	end
end

Players.PlayerAdded:Connect(stworzStatystyki)

for _, player in pairs(Players:GetPlayers()) do
	stworzStatystyki(player)
end

-- ZAPIS DANYCH PRZY WYJŚCIU
Players.PlayerRemoving:Connect(function(player)

	local leaderstats = player:FindFirstChild("leaderstats")
	local hiddenstats = player:FindFirstChild("hiddenstats")

	if leaderstats and hiddenstats then
		local TabelaDane = {
			Coins = leaderstats.Coins.Value,
			Level = leaderstats.Level.Value,
			Cap = hiddenstats.Cap.Value,
			MaxCap = hiddenstats.MaxCap.Value, -- Poprawiono nazwy kluczy
			Exp = hiddenstats.Exp.Value,
			MaxExp = hiddenstats.MaxExp.Value
		}

		local sukces, err = pcall(function()
			BazaGracza:SetAsync(player.UserId, TabelaDane)
		end)

		if sukces then
			print("Pomyślnie zapisano dane gracza: " .. player.Name)
		else
			warn("Błąd podczas zapisywania danych gracza: " .. player.Name .. " | " .. tostring(err))
		end
	end
end)
