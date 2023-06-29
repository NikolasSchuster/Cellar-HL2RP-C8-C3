local CITIZEN_MODELS = {
	[1] = {"models/cmbfdr/group01/male_01.mdl",
	"models/cmbfdr/group01/male_02.mdl",
	"models/cmbfdr/group01/male_03.mdl",
	"models/cmbfdr/group01/male_04.mdl",
	"models/cmbfdr/group01/male_05.mdl",
	"models/cmbfdr/group01/male_06.mdl",
	"models/cmbfdr/group01/male_07.mdl",
	"models/cmbfdr/group01/male_08.mdl",
	"models/cmbfdr/group01/male_09.mdl",
	"models/cmbfdr/group01/male_10.mdl",
	"models/cmbfdr/group01/male_11.mdl",
	"models/cmbfdr/group01/male_12.mdl",
	"models/cmbfdr/group01/male_13.mdl",
	"models/cmbfdr/group01/male_14.mdl",
	"models/cmbfdr/group01/male_15.mdl",
	"models/cmbfdr/group01/male_16.mdl",
	"models/cmbfdr/group01/male_17.mdl",
	"models/cmbfdr/group01/male_18.mdl"},
	[2] = {"models/cmbfdr/group01/female_01.mdl",
	"models/cmbfdr/group01/female_02.mdl",
	"models/cmbfdr/group01/female_03.mdl",
	"models/cmbfdr/group01/female_04.mdl",
	"models/cmbfdr/group01/female_05.mdl",
	"models/cmbfdr/group01/female_06.mdl",
	"models/cmbfdr/group01/female_07.mdl",
	"models/cmbfdr/group01/female_08.mdl",
	"models/cmbfdr/group01/female_09.mdl",
	"models/cmbfdr/group01/female_10.mdl",
	"models/cmbfdr/group01/female_11.mdl",
	"models/cmbfdr/group01/female_12.mdl",
	"models/cmbfdr/group01/female_13.mdl",
	"models/cmbfdr/group01/female_14.mdl",
	"models/cmbfdr/group01/female_15.mdl",
	"models/cmbfdr/group01/female_16.mdl",
	"models/cmbfdr/group01/female_17.mdl",
	"models/cmbfdr/group01/female_18.mdl"}
}

--- Loads factions from a directory.
-- @realm shared
-- @string directory The path to the factions files.
function ix.faction.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		FACTION = ix.faction.teams[niceName] or {index = table.Count(ix.faction.teams) + 1, isDefault = false}
			if (PLUGIN) then
				FACTION.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory.."/"..v, "shared")

			if (!FACTION.name) then
				FACTION.name = "Unknown"
				ErrorNoHalt("Faction '"..niceName.."' is missing a name. You need to add a FACTION.name = \"Name\"\n")
			end

			if (!FACTION.description) then
				FACTION.description = "noDesc"
				ErrorNoHalt("Faction '"..niceName.."' is missing a description. You need to add a FACTION.description = \"Description\"\n")
			end

			if (!FACTION.color) then
				FACTION.color = Color(150, 150, 150)
				ErrorNoHalt("Faction '"..niceName.."' is missing a color. You need to add FACTION.color = Color(1, 2, 3)\n")
			end

			team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color or Color(125, 125, 125))

			FACTION.models = FACTION.models or CITIZEN_MODELS
			FACTION.uniqueID = FACTION.uniqueID or niceName

			for _, v2 in pairs(FACTION.models) do
				if (isstring(v2)) then
					util.PrecacheModel(v2)
				elseif (istable(v2)) then
					util.PrecacheModel(v2[1])
				end
			end

			if (!FACTION.GetModels) then
				function FACTION:GetModels(client, gender)
					return self.models[gender]
				end
			end

			ix.faction.indices[FACTION.index] = FACTION
			ix.faction.teams[niceName] = FACTION
		FACTION = nil
	end
end