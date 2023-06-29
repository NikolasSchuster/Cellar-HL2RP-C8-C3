local PLUGIN = PLUGIN

PLUGIN.name = "Subscription"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")

ix.inventory.Register("vault", 3, 5, true)

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