local PLUGIN = PLUGIN

PLUGIN.name = "Subscription"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")

ix.inventory.Register("vault", 3, 5, true)

function PLUGIN:CanPlayerUseCharacter(client, character)
	local faction = character:GetFaction()

	if (ix.faction.indices[faction].bSubscriber) then
		local bHasWhitelist = client:HasWhitelist(faction)

		if (!bHasWhitelist) then
			return false, "@noWhitelist"
		end
	end
end

do
	local PLAYER = FindMetaTable("Player")

	function PLAYER:IsDonator()
		return self:GetNetVar("donator") == true
	end
end

do
	local COMMAND = {
		description = "Открыть персональный контейнер",
		alias = "хранилище"
	}

	function COMMAND:OnRun(client)
		if !client:IsDonator() then
			return
		end

		local index = client:GetData("vault")

		if !index or index == 0 then
			return
		end

		ix.inventory.Restore(index, 3, 5, function(inventory)
			inventory.vars.isBag = true

			ix.storage.Open(client, inventory, {
				name = "Хранилище",
				entity = client,
				searchText = "Открываю...",
				OnPlayerClose = function()
					ix.item.inventories[index] = nil
				end
			})
		end)
	end

	ix.command.Add("vault", COMMAND)
end

do
	local command = {}
	command.help	= ""
	command.command = "donate"
	command.arguments = {"steamid", "months"}
	command.permissions = {"Manage Donator Subscriptions"}

	function command:Execute(player, silent, arguments)
		local steamid = arguments[1]
		local months = tonumber(arguments[2] or 1)

		if steamid then
			if string.find(steamid, "ANON") then
				steamid = AnonIDToSteamID64(steamid)
			end

			if string.find(steamid, "STEAM") then
				steamid = util.SteamIDTo64(steamid)
			end

			PLUGIN:SetDonateSubscription(steamid, os.time() + (2592000 * months), function(found)
				if found then
					player:Notify("Подписка для указанного игрока была успешно активирована.")
				else
					player:Notify("Игрок с указанным SteamID не найден.")
				end
			end)
		end
	end
	serverguard.command:Add(command)

	command = {}
	command.help	= ""
	command.command = "donatetime"
	command.arguments = {"steamid", "months"}
	command.permissions = {"Manage Donator Subscriptions"}

	function command:Execute(player, silent, arguments)
		local steamid = arguments[1]
		local addMonths = tonumber(arguments[2] or 1)

		if steamid and addMonths > 0 then
			if string.find(steamid, "ANON") then
				steamid = AnonIDToSteamID64(steamid)
			end

			if string.find(steamid, "STEAM") then
				steamid = util.SteamIDTo64(steamid)
			end

			PLUGIN:AddDonateSubscription(steamid, (2592000 * months), function(found)
				if found then
					player:Notify("Подписка для указанного игрока была успешно изменена.")
				else
					player:Notify("Игрок с указанным SteamID не найден.")
				end
			end)
		end
	end

	serverguard.command:Add(command)

	command = {}
	command.help	= ""
	command.command = "donateban"
	command.arguments = {"steamid"}
	command.permissions = {"Manage Donator Subscriptions"}

	function command:Execute(player, silent, arguments)
		local steamid = arguments[1]

		if steamid then
			if string.find(steamid, "ANON") then
				steamid = AnonIDToSteamID64(steamid)
			end

			if string.find(steamid, "STEAM") then
				steamid = util.SteamIDTo64(steamid)
			end

			PLUGIN:ResetDonateSubscription(steamid, function(found)
				if found then
					player:Notify("Подписка для указанного игрока была успешно аннулирована.")
				else
					player:Notify("Игрок с указанным SteamID не найден.")
				end
			end)
		end
	end

	serverguard.command:Add(command)
end

do
	ix.command.Add("WipeVault", {
		description = "Очищает донатное хранилище указанного персонажа.",
		superAdminOnly = true,
		arguments = {
			ix.type.character
		},
		OnRun = function(self, client, target)
			local index = target:GetPlayer():GetData("vault", 0) or 0

			if index == 0 then
				return "Хранилище не найдено."
			end

			local inventory_instance = ix.item.inventories[index]

			if inventory_instance then
				ix.storage.Close(inventory_instance)
			end
			
			local query = mysql:Delete("ix_items")
				query:Where("inventory_id", index)
			query:Execute()

			return string.format("Хранилище игрока %s было успешно очищено.", target:GetName())
		end
	})

	ix.command.Add("WipeVaultOffline", {
		description = "Очищает донатное хранилище указанного игрока (SteamID 32/64 или AnonID).",
		superAdminOnly = true,
		arguments = {
			ix.type.string
		},
		OnRun = function(self, client, text)
			local steamid64
			
			if text:match("STEAM_(%d+):(%d+):(%d+)") then
				steamid64 = util.SteamIDTo64(text)
			elseif text:match("ANON:(%d+)") then
				steamid64 = AnonIDToSteamID64(text)
			elseif text:match("(%d+)") then
				steamid64 = text
			end

			if steamid64 then
				local query = mysql:Select("ix_players")
					query:Select("data")
					query:Where("steamid", steamid64)
					query:Limit(1)
					query:Callback(function(result)
						if istable(result) and #result > 0 then
							local data = util.JSONToTable(result[1].data or "[]")
							local index = tonumber(data.vault) or 0

							if index == 0 then
								return client:Notify("Хранилище указанного игрока не найдено.")
							end

							local inventory_instance = ix.item.inventories[index]

							if inventory_instance then
								ix.storage.Close(inventory_instance)
							end
							
							local itemQuery = mysql:Delete("ix_items")
								itemQuery:Where("inventory_id", index)
							itemQuery:Execute()

							return client:Notify(string.format("Хранилище %s было успешно очищено.", text))
						end
					end)
				query:Execute()
			end
		end
	})
end