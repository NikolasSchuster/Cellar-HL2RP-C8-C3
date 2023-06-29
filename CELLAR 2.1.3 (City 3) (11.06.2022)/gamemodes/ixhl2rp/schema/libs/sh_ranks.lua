Schema.ranks = Schema.ranks or {}

local storedRanks = {}
local storedSpecials = {}

function Schema.ranks:GetStoredRanks()
	return storedRanks
end

function Schema.ranks:GetStoredSpecials()
	return storedSpecials
end

function Schema.ranks.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		RANK = {}
			ix.util.Include(directory.."/"..v)

			RANK.name = RANK.name or "Undefined"
			RANK.tag = RANK.tag or niceName
			RANK.weight = RANK.weight or 1

			if RANK.special then
				storedSpecials[niceName] = RANK
			else
				storedRanks[niceName] = RANK
			end
		RANK = nil
	end
end

Schema.ranks.LoadFromDir(Schema.folder.."/schema/ranks")