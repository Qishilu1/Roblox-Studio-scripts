local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local gracz = Players.LocalPlayer

local folderDrzwi = workspace:WaitForChild("Drzwi")

local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local DYSTANS_OTWARCIA = 12


local systemDrzwi = {}


for _, drzwiModel in ipairs(folderDrzwi:GetChildren()) do


	local hinge = drzwiModel.PrimaryPart or drzwiModel:WaitForChild("Hinge", 5)

	if hinge then
		systemDrzwi[drzwiModel] = {
			zawias = hinge,
			zamknieteCFrame = hinge.CFrame,
			otwarte = false
		}
	else
		warn("Błąd ładowania: Nawet po 5 sekundach nie znaleziono klocka Hinge w modelu: " .. drzwiModel.Name)
	end
end


while true do
	task.wait(0.1)

	local postac = gracz.Character
	if postac and postac:FindFirstChild("HumanoidRootPart") then
		local rootPart = postac.HumanoidRootPart

		for model, dane in pairs(systemDrzwi) do

			local dystans = (rootPart.Position - dane.zawias.Position).Magnitude

			if dystans <= DYSTANS_OTWARCIA then
				-- OTWIERANIE
				if not dane.otwarte then
					dane.otwarte = true

					local relatywnaPozycja = dane.zawias.CFrame:ToObjectSpace(rootPart.CFrame)
					local kat = -90
					if relatywnaPozycja.Z > 0 then kat = 90 end

					local celCFrame = dane.zamknieteCFrame * CFrame.Angles(0, math.rad(kat), 0)
					TweenService:Create(dane.zawias, tweenInfo, {CFrame = celCFrame}):Play()
				end
			else
				-- ZAMYKANIE
				if dane.otwarte then
					dane.otwarte = false
					TweenService:Create(dane.zawias, tweenInfo, {CFrame = dane.zamknieteCFrame}):Play()
				end
			end

		end
	end
end
