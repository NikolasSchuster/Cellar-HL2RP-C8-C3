local PLUGIN = PLUGIN

PLUGIN.name = "Enhanced Observer"
PLUGIN.author = ""
PLUGIN.description = ""

if CLIENT then
	ix.option.Add("observerShowItemESP", ix.type.bool, true, {
		category = "observer",
		hidden = function()
			return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
		end
	})

	ix.option.Add("observerShowVendor", ix.type.bool, true, {
		category = "observer",
		hidden = function()
			return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
		end
	})

	surface.CreateFont("ixESPMainText", {
		font = "Arial",
		weight = 700,
		size = ScreenScale(7),
		extended = true,
	})

	surface.CreateFont("ixESPText", {
		font = "Arial",
		weight = 700,
		size = ScreenScale(5.5),
		extended = true,
	})

	PLUGIN.esp = {}
	PLUGIN.esp.updateTime = 1

	function PLUGIN.esp:GetESPInfo()
		return self.ESPInfo
	end

	local colorWhite = Color(255, 255, 255, 255)
	local grayColor = Color(150, 150, 150, 170)

	function PLUGIN.esp:DrawAdminESP()
		local curTime = UnPredictedCurTime()

		if !PLUGIN.NextGetESPInfo or curTime >= PLUGIN.NextGetESPInfo then
			PLUGIN.NextGetESPInfo = curTime + PLUGIN.esp.updateTime
			self.ESPInfo = {}
			
			PLUGIN.esp:GetAdminESPInfo(self.ESPInfo)
		end
		
		for k, v in pairs(self.ESPInfo or {}) do
			local position = v.position:ToScreen()
			local text, color, height, font
			
			if position then
				if isstring(v.text) then
					ix.util.DrawText(v.text, position.x, position.y, v.color or colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				else			
					for k2, v2 in ipairs(v.text) do	
						local barValue
						local maximum = 100

						if isstring(v2) then
							text = v2
							color = v.color
						else
							text = v2.text
							color = v2.color

							local barNumbers = v2.bar

							if istable(barNumbers) then
								barValue = barNumbers.value
								maximum = barNumbers.max
							else
								barValue = barNumbers
							end
						end
						
						if k2 > 1 then
							font = "ixESPText"
							height = draw.GetFontHeight("ixESPText")
						else
							font = "ixESPMainText"
							height = draw.GetFontHeight("ixESPMainText")
						end

						if v2.icon then
							local icon = "icon16/exclamation.png"
							local width = surface.GetTextSize(text)
	
							if v2.icon then
								icon = v2.icon
							end

							surface.SetDrawColor(colorWhite)
							surface.SetMaterial(icon)
							surface.DrawTexturedRect(position.x - (width * 0.40) - height, position.y - height * 0.5, height, height)
						end

						if barValue then
							local barHeight = height * 0.80
							local barColor = v2.barColor or PLUGIN:GetValueColor(barValue)
							local progress = 100 * (barValue / maximum)

							if progress < 0 then
								progress = 0
							end

							draw.RoundedBox(6, position.x - 50, position.y - (barHeight * 0.45), 100, barHeight, grayColor)
							draw.RoundedBox(6, position.x - 50, position.y - (barHeight * 0.45), math.floor(progress), barHeight, barColor)
						end

						if isstring(text) then
							ix.util.DrawText(text, position.x, position.y, color or colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, font, alpha)
						end

						position.y = position.y + height
					end
				end			
			end
		end
	end
	
	local colors = {
		[1] = Color(0, 255, 255, 255),
		[2] = Color(100, 180, 255, 255),
	}
	function PLUGIN.esp:GetAdminESPInfo(info)
		for k, v in ipairs(player.GetAll()) do
			if v:GetCharacter() and v != LocalPlayer() then			
				local physBone = v:LookupBone("ValveBiped.Bip01_Head1")
				local position = nil
									
				if physBone then
					local bonePosition = v:GetBonePosition(physBone)
							
					if bonePosition then
						position = bonePosition + Vector(0, 0, 16)
					end
				else
					position = v:GetPos() + Vector(0, 0, 80)
				end

				local topText = {v:Name()}

				hook.Run("GetStatusInfo", v, topText)

				local text = {
					{
						text = table.concat(topText, " "), 
						color = team.GetColor(v:Team())
					}
				};

				hook.Run("GetPlayerESPInfo", v, text);

				table.insert(info, {
					position = position,
					text = text
				})
			end
		end

		if ix.option.Get("observerShowItemESP", true) then
			for k, v in ipairs(ents.FindByClass("ix_item")) do 
				local itemTable = v:GetItemTable()

				if itemTable then
					local itemName = itemTable:GetName()

					table.insert(info, {
						position = v:GetPos(),
						text = {
							{
								text = "Item",
								color = colors[1]
							},
							{
								text = itemName,
								color = colors[1]
							}
						}
					})
				end
			end
		end

		if ix.option.Get("observerShowVendor", true) then
			for k, v in ipairs(ents.FindByClass("ix_vendor")) do 
				table.insert(info, {
					position = v:GetPos(),
					text = {
						{
							text = "Vendor",
							color = colors[2]
						},
						{
							text = v:GetDisplayName(),
							color = colors[2]
						}
					}
				})
			end
		end
	end

	function PLUGIN:GetStatusInfo(player, text)
		if player:GetMoveType() == MOVETYPE_NOCLIP then
			table.insert(text, "[Observer]")
		end
	end

	function PLUGIN:GetPlayerESPInfo(player, text)
		if IsValid(player) then
			local weapon = player:GetActiveWeapon()
			local health = player:Health()
			local colorWhite = Color(255, 255, 255, 255)
			local colorRed = Color(255, 0, 0, 255)
			local colorHealth = self:GetValueColor(health)
			local icon = serverguard and (serverguard.ranks:GetRank(serverguard.player:GetRank(player)).texture or "icon16/user.png") or "icon16/user.png"

			icon = Material(hook.Run("GetPlayerIcon", player) or icon)

			local character = player:GetCharacter()

			if character then
				table.insert(text, {
					text = "Level: "..character:GetLevel(), 
					color = Color(170, 170, 170, 255),
				})
			end

			table.insert(text, {
				text = player:AnonSteamName() or "Anon", 
				color = Color(170, 170, 170, 255), 
				icon = icon
			})

			if player:Alive() and health > 0 then
				table.insert(text, {
					text = "HP: ["..health.."]", 
					color = colorHealth, 
					bar = {
						value = health,
						max = player:GetMaxHealth()
					}
				})

				if IsValid(weapon) then			
					local raised = player:IsWepRaised()
					local color = colorWhite

					if raised then
						color = colorRed
					end
					
					if weapon.GetPrintName then
						local printName = weapon:GetPrintName()

						if printName then
							table.insert(text, {
								text = printName, 
								color = color
							})
						end
					end
				end
			end
		end
	end

	function PLUGIN:GetValueColor(value)
		local red = math.floor(255 - (value * 2.55))
		local green = math.floor(value * 2.55)
		
		return Color(red, green, 0, 255)
	end

	function PLUGIN:HUDPaint()
		local client = LocalPlayer()

		if (ix.option.Get("observerESP", true) and client:GetMoveType() == MOVETYPE_NOCLIP and
			!client:InVehicle() and CAMI.PlayerHasAccess(client, "Helix - Observer", nil)) then

			PLUGIN.esp:DrawAdminESP()
		end
	end
end