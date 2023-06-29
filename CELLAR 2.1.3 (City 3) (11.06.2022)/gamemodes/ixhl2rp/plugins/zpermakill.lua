local PLUGIN = PLUGIN

PLUGIN.name = "Permakill Mode"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

do
	ix.command.Add("PKModeOn", {
		description = "Включить режим PK",
		privilege = "Manage PK Mode",
		adminOnly = true,
		OnRun = function(self, client)
			local state = GetNetVar("pkmode", false)
			if !state then
				SetNetVar("pkmode", true)
				ix.chat.Send(nil, "notice", "Активирован режим PK. Не покидайте сервер до окончания.")
				return
			end
			return "Режим PK активен!"
		end
	})

	ix.command.Add("PKModeOff", {
		description = "Выключить режим PK",
		privilege = "Manage PK Mode",
		adminOnly = true,
		OnRun = function(self, client)
			local state = GetNetVar("pkmode", false)
			if state then
				SetNetVar("pkmode", false)
				ix.chat.Send(nil, "notice", "Режим PK был деактивирован.")
				return
			end
			return "Режим PK не активен!"
		end
	})
end

if SERVER then
	function PLUGIN:CanPlayerUseCharacter(client)
		local pkmode = GetNetVar("pkmode", false)
		local character = client:GetCharacter()

		if character and pkmode and !client:IsAdmin() then
			return false, "Невозможно сменить персонажа, пока активен режим 'PK'"
		end
	end

	local function TransferItem(item, invID)
		local succ, err = pcall(function()
			local owner = item:GetOwner()

			item.Dropped = true

			if item:GetData("equip") then
				if item.OnUnequipped then
					item:OnUnequipped(owner)
				end
				if item.Unequip then
					item:Unequip(owner)
				end
			end

			item:Transfer(invID)
		end)

		if !succ and err then
			print("Failed to transfer item: ", item, err)
		end

		return succ
	end

	local decayTime = 1800 * 2
	function PLUGIN:PlayerDisconnected(client)
		local pkmode = GetNetVar("pkmode", false)
		local character = client:GetCharacter()

		if pkmode and character then
			local charInventory = character:GetInventory()
			local equipment = character:GetEquipment()
			local money = character:GetMoney()

			local container = ents.Create("ix_drop")
			container:SetPos(client:GetShootPos())
			container:Spawn()

			local uniqueID = "ixDecay" .. container:EntIndex()

			container:CallOnRemove("ixDecayRemove", function(container)
				ix.storage.Close(container:GetInventory())

				if timer.Exists(uniqueID) then
					timer.Remove(uniqueID)
				end
			end)

			timer.Create(uniqueID, decayTime, 1, function()
				if IsValid(container) then
					container:Remove()
				else
					timer.Remove(uniqueID)
				end
			end)

			local inventory = ix.inventory.Create(ix.config.Get("inventoryWidth") * 2, ix.config.Get("inventoryHeight") * 2, os.time())
			inventory.vars.isBag = false
			inventory.vars.isDrop = true
			inventory.vars.entity = container
			inventory.noSave = true

			function inventory.OnAuthorizeTransfer(_, _, _, item)
				if item.Dropped then
					return true
				end
			end

			container:SetInventory(inventory)
			container:SetMoney(money)

			character:SetMoney(0)

			for _, v in pairs(charInventory:GetItems()) do
				TransferItem(v, inventory:GetID())
			end
			for _, v in pairs(equipment:GetItems()) do
				TransferItem(v, inventory:GetID())
			end
		end
	end
else
	function PLUGIN:LoadFonts()
		surface.CreateFont("ixPKNotice", {
			font = "Roboto",
			extended = true,
			size = math.max(ScreenScale(8), 24),
			weight = 500,
			antialias = true,
		})
	end

	local lp
	local clr, text = Color(225, 64, 64), "РЕЖИМ 'PK' АКТИВЕН"

	function PLUGIN:HUDPaint()
		lp = lp or LocalPlayer()
		local pkmode = GetNetVar("pkmode", false)
		local w, h = ScrW() / 2, ScrH()

		if lp and pkmode and lp:GetCharacter() then
			surface.SetTextColor(clr)
			surface.SetFont("ixPKNotice")

			local offset_x, offset_y = surface.GetTextSize(text)

			surface.SetTextPos(w - offset_x / 2, h - 16 - offset_y)
			surface.DrawText(text)
		end
	end
end