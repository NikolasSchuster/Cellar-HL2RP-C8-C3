
PLUGIN.name = "No Whitelist Check"
PLUGIN.author = "LegAz"
PLUGIN.description = "Remove whitelist check when player selects character or being transfered to another faction."

local helix = GM or GAMEMODE

function helix:CanPlayerUseCharacter(client, character)
	local banned = character:GetData("banned")

	if (banned) then
		if (isnumber(banned)) then
			if (banned < os.time()) then
				return
			end

			return false, "@charBannedTemp"
		end

		return false, "@charBanned"
	end
end

ix.command.Add("PlyTransfer", {
	description = "@cmdPlyTransfer",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.text
	},
	OnRun = function(self, client, target, name)
		local faction = ix.faction.teams[name]

		if (!faction) then
			for _, v in pairs(ix.faction.indices) do
				if (ix.util.StringMatches(L(v.name, client), name)) then
					faction = v
					break
				end
			end
		end

		if (faction) then
			target.vars.faction = faction.uniqueID
			target:SetFaction(faction.index)

			if (faction.OnTransferred) then
				faction:OnTransferred(target)
			end

			for _, v in ipairs(player.GetAll()) do
				v:NotifyLocalized("cChangeFaction", client:GetName(), target:GetName(), L(faction.name, v))
			end
		else
			return "@invalidFaction"
		end
	end
})
