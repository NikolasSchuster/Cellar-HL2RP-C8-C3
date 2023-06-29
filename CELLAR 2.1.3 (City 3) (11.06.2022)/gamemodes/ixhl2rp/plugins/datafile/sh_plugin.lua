
local PLUGIN = PLUGIN

PLUGIN.name = "Datafile"
PLUGIN.author = "James"
PLUGIN.description = "Adds citizen datafiles."

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

do
	local COMMAND = {}
	COMMAND.description = "View the datafile of someone."
	COMMAND.arguments = {
		ix.type.string,
		bit.bor(ix.type.string, ix.type.optional)
	}
	COMMAND.argumentNames = {"CitizenID", "RegID (optional)"}

	function COMMAND:OnRun(client, citizenid, regid)
		return PLUGIN:HandleDatafile(client, {citizenid, regid})
	end

	ix.command.Add("Datafile", COMMAND)

	COMMAND = {}
	COMMAND.arguments = {ix.type.player}
	COMMAND.superAdminOnly = true

	function COMMAND:OnRun(client, target)
		PLUGIN:ClearDatafile(target)
	end

	ix.command.Add("ClearDatafile", COMMAND)

	COMMAND = {}
	COMMAND.description = "Manage the datafile of someone."
	COMMAND.arguments = {ix.type.player}

	function COMMAND:OnRun(client, target)
		local permission = PLUGIN:ReturnPermission(client)

		if (permission == DATAFILE_PERMISSION_ELEVATED) then
			PLUGIN:ReturnDatafile(target, nil, true, function(result)
				netstream.Start(client, "CreateManagementPanel", target, result)
			end)
		else
			return "@datafileNotAuthorizedManage"
		end
	end

	ix.command.Add("ManageDatafile", COMMAND)

	COMMAND = {}
	COMMAND.description = "Make someone their datafile (un)restricted."
	COMMAND.arguments = {
		ix.type.player,
		bit.bor(ix.type.string, ix.type.optional)
	}

	function COMMAND:OnRun(client, target, reason)
		if (!reason or reason == "") then
			reason = nil
		end

		if (PLUGIN:ReturnPermission(client) >= DATAFILE_PERMISSION_FULL) then
			if (reason) then
				PLUGIN:SetRestricted(true, reason, target, client)

				return target:Name() .. "'s file has been restricted."
			else
				PLUGIN:SetRestricted(false, "", target, client)

				return target:Name() .. "'s file has been unrestricted."
			end
		else
			return "You do not have access to this datafile!"
		end
	end

	ix.command.Add("RestrictDatafile", COMMAND)

	/*
	COMMAND = {}
	COMMAND.description = "Rewards SC to a group of units. * = all units, PT-# = reward a PT."
	COMMAND.arguments = {
		ix.type.number,
		ix.type.string,
		ix.type.string
	}

	function COMMAND:OnCheckAccess(client)
		return client:Team() == FACTION_OVERWATCH
	end

	function COMMAND:OnRun(client, amount, reason, targets)
		amount = math.ceil(amount)

		if (amount <= 0 or reason == "") then
			return "@invalidArg", 1
		end

		if (targets == "*") then
			for _, v in ipairs(player.GetAll()) do
				if (v:Team() == FACTION_MPF) then
					PLUGIN:AddEntry("civil", reason, amount, v, client)
				end
			end

			client:Notify("All active units have been rewarded with " .. amount .. " SC.")
		else
			local patrolTeam = targets:lower():match("pt%-(%d+)")

			if (patrolTeam) then
				local pluginTable = ix.plugin.list["patrolmenu"]

				if (pluginTable) then
					local team = pluginTable.teams[tonumber(patrolTeam)]

					if (team) then
						for k, _ in pairs(team) do
							if (IsValid(k) and k:Team() == FACTION_MPF) then
								PLUGIN:AddEntry("civil", reason, amount, k, client)
							end
						end

						client:Notify("PT-" .. patrolTeam .. " has been rewarded with " .. amount .. " SC.")
					end
				else
					ErrorNoHalt("[Helix] Patrol Menu plugin is missing!\n")
				end
			end
		end
	end

	ix.command.Add("MassReward", COMMAND)
	*/
end

-- luacheck: globals DATAFILE_PERMISSION_NONE DATAFILE_PERMISSION_MINOR DATAFILE_PERMISSION_MEDIUM DATAFILE_PERMISSION_FULL DATAFILE_PERMISSION_ELEVATED
DATAFILE_PERMISSION_NONE = 0
DATAFILE_PERMISSION_MINOR = 1
DATAFILE_PERMISSION_MEDIUM = 2
DATAFILE_PERMISSION_FULL = 3
DATAFILE_PERMISSION_ELEVATED = 4

-- All the categories possible. Yes, the names are quite annoying.
PLUGIN.Categories = {
	["med"] = true,     -- Medical note.
	["union"] = true,   -- Union (CWU, WI, UP) type note.
	["civil"] = true,    -- Civil Protection/CTA type note.
	["reg"] = true
}

-- Permissions for the numerous factions.
PLUGIN.Permissions = PLUGIN.Permissions or {}

-- All the civil statuses. Just for verification purposes.
PLUGIN.CivilStatus = {
	["Anti-Citizen"] = -50,
	["Citizen"] = 0,
	["Black"] = 5,
	["Brown"] = 15,
	["Red"] = 20,
	["Green"] = 30,
	["Blue"] = 45,
	["White"] = 65,
	["Gold"] = 80,
	["Platinum"] = 100
}

PLUGIN.Default = {
	GenericData = {
		bol = false,
		bol_reason = "",
		restricted = false,
		restricted_reason = "",
		status = "Citizen",
		last_seen = os.time(),
		aparts = "N/A"
	},
	CivilianData = {
		category = "union", -- med, union, civil
		text = "TRANSFERRED TO DISTRICT WORKFORCE.",
		date = os.time(),
		points = 0,
		poster_name = "Overwatch",
		poster_steam = 0
	},
	CombineData = {
		category = "union", -- med, union, civil
		text = "INSTATED AS CIVIL PROTECTOR.",
		date = os.time(),
		points = 0,
		poster_name = "Overwatch",
		poster_steam = 0
	},
}
