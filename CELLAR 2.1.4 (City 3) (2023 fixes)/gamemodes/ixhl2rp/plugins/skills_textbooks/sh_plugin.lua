
PLUGIN.name = "Skills Textbooks"
PLUGIN.author = "LegAz"
PLUGIN.description = "Adds skills textbooks."

ix.util.Include("sh_preperations.lua")

function PLUGIN:InitializedConfig()
	for k, v in pairs(ix.skills.list) do
		local preItemID = k .. "_textbook_volume"
		local preItemName = v.name .. " textbook #%d"
		local minReadTime = ix.config.Get("skillsTextbooksMinReadTime", 3600)
		local skillXP = ix.config.Get("skillsTextbooksMinXP", 500)

		for i = 1, ix.config.Get("skillsTextbooksVolumeCount", 3) do
			local itemID = preItemID .. i
			skillXP = skillXP * i

			ix.item.Register(itemID, "base_skills_textbooks", false, nil)

			if (ix.item.list[itemID]) then
				ix.item.list[itemID].name = string.format(preItemName, i)
				ix.item.list[itemID].model = v.textbookModel or ix.item.list[itemID].model
				ix.item.list[itemID].skillID = k
				ix.item.list[itemID].skillXP = skillXP
				ix.item.list[itemID].volume = i
				ix.item.list[itemID].studyTime = minReadTime * i
			end
		end
	end
end
