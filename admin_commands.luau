local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local prefiks = "!"

local ADMINS_ID = {
	[233166093] = true,
}

-- Główna funkcja sprawdzająca komendy
local function checkCommand(player, Message)
	if not ADMINS_ID[player.UserId] and not RunService:IsStudio() then
		print("Nie masz uprawnień do tej komendy")
		return
	end

	if Message:sub(1, prefiks:len()) == prefiks then
		Message = Message:gsub(prefiks, "", 1)
		local args = Message:split(" ")

		local command = args[1]:lower()

		-- KOMENDA: SETSPEED
		if command == "setspeed" then
			if args[2] and args[3] then
				local targetPlayer = Players:FindFirstChild(args[2])
				local newSpeed = tonumber(args[3])

				if newSpeed then
					if targetPlayer and targetPlayer.Character then
						targetPlayer.Character.Humanoid.WalkSpeed = newSpeed
						return
					else
						print("Podano złego gracza")
						return
					end
				else
					print("Podano złą prędkość")
					return
				end
			else
				print("Nie podano poprawnych warunków")
				return
			end

			-- KOMENDA: KICK
		elseif command == "kick" then
			local targetPlayer = Players:FindFirstChild(args[2])
			if not targetPlayer then
				print("Nie znaleziono gracza")
				return
			end

			local reason = table.concat(args, " ", 3)
			if reason == "" then reason = "Nie podano powodu." end

			targetPlayer:Kick("Zostałeś wyrzucony przez Admina!\nPowód: " .. reason)
			print("Wyrzucono gracza: " .. targetPlayer.Name)
			return

				-- KOMENDA: BAN / TEMPBAN
		elseif command == "ban" or command == "tempban" then
			local targetPlayer = Players:FindFirstChild(args[2])
			if not targetPlayer then
				print("Nie znaleziono gracza na serwerze.")
				return
			end

			local duration = -1
			local reasonStartIndex = 3

			if command == "tempban" then
				local hours = tonumber(args[3])
				if hours then
					duration = hours * 3600
					reasonStartIndex = 4
				else
					print("Podaj poprawną liczbę godzin")
					return
				end
			end

			local reason = table.concat(args, " ", reasonStartIndex)
			if reason == "" then reason = "Złamanie regulaminu." end

			local banConfig = {
				UserIds = { targetPlayer.UserId },
				Duration = duration,
				DisplayReason = reason,
				PrivateReason = "Zbanowany przez Admina (UserId: " .. player.UserId .. ")",
				ApplyToUniverse = true,
				ExcludeAltAccounts = false
			}

			local success, err = pcall(function()
				Players:BanAsync(banConfig)
			end)

			if success then
				print("Zbanowano gracza: " .. targetPlayer.Name)
			else
				warn("Błąd podczas banowania: " .. tostring(err))
			end
			return

				-- KOMENDA: UNBAN
		elseif command == "unban" then
			local targetNameOrId = args[2]
			if not targetNameOrId then
				print("Podaj nick lub UserId gracza do odbanowania!")
				return
			end

			local targetUserId = tonumber(targetNameOrId)

			-- Jeśli podano nick zamiast liczbowego ID, zamieniamy nick na UserId Robloxa
			if not targetUserId then
				local getSuccess, idResult = pcall(function()
					return Players:GetUserIdFromNameAsync(targetNameOrId)
				end)

				if getSuccess then
					targetUserId = idResult
				else
					print("Nie znaleziono konta Roblox o nicku: " .. tostring(targetNameOrId))
					return
				end
			end

			-- Konfiguracja Unbana
			local unbanConfig = {
				UserIds = { targetUserId },
				ApplyToUniverse = true
			}

			local success, err = pcall(function()
				Players:UnbanAsync(unbanConfig)
			end)

			if success then
				print("Pomyślnie odbanowano gracza o UserId: " .. targetUserId)
			else
				warn("Błąd podczas odbanowywania: " .. tostring(err))
			end
			return

		else
			print("Błędna komenda")
			return
		end
	end
end


-- SYSTEM PODPINANIA CZATU
local function onPlayerAdded(player)
	player.Chatted:Connect(function(Message)
		checkCommand(player, Message)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
