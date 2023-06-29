local PLUGIN = PLUGIN
PLUGIN.name = "Recognition"
PLUGIN.author = "Chessnut, Alan Wake"
PLUGIN.description = "Adds the ability to recognize people and make fake names."

local character = ix.meta.character

function character:DoesRecognize(id)
	if (!isnumber(id) and id.GetID) then
		id = id:GetID()
	end
	return hook.Run("IsCharacterRecognized", self, id)
end
local PerviousRecognize = function(char,id)
	if (char.id == id) then
		return true
	end

	local other = ix.char.loaded[id]

	if (other) then
		local faction = ix.faction.indices[other:GetFaction()]

		if (faction and faction.isGloballyRecognized) then
			return true
		end
	end

	local recognized = char:GetData("rgn", "")

	if (recognized != "" and recognized:find(","..id..",")) then
		return true
	end
end
function PLUGIN:IsCharacterRecognized(char, id) -- char кто знает, id кого знает
	if PerviousRecognize(char,id) then
		return true
	end

	local fakenames = char:GetData("aw_KnowFakeNames",{})
	if fakenames[id] then
		return true
	end
end
function debug.dumptotable()
	local level = 1
	local tbl = {}
	while true do
		local info = debug.getinfo(level,"Sln")
		if !info or !info.name then break end

		tbl[info.name] = true

		level = level + 1
	end
	return tbl
end
local CharMeta = ix.meta.character
ix.meta.character.OriginalGetName = ix.meta.character.GetName

function ix.meta.character:GetName()
	local tbl = debug.dumptotable()
	-- tbl = (tbl.Name or tbl.Nick)

	if CLIENT and tbl.GetName then
		local char = LocalPlayer():GetCharacter()
		if !char then
			return self:OriginalGetName()
		end
		if PerviousRecognize(char,self:GetID()) then
			return self:OriginalGetName()
		end

		local fakenames = char:GetData("aw_KnowFakeNames",{})
		local fakename = fakenames[self:GetID()]

		if LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP and LocalPlayer():IsAdmin() then
			
			return (fakename and self:OriginalGetName().." ("..fakename..")") or self:OriginalGetName()

		end

		return fakename or self:OriginalGetName()
	end
	return self:OriginalGetName()
end

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")