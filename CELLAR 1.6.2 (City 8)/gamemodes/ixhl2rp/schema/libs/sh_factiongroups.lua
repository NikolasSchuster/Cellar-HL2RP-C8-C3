FACTION_GROUP_NONE = 0
FACTION_GROUP_CWU = 1
FACTION_GROUP_COMBINE = 2
FACTION_GROUP_REBEL = 3
FACTION_GROUP_OTA = 4

Schema.factionGroups = Schema.factionGroups or {}

function Schema:SetFactionGroup(faction, group)
	self.factionGroups[faction] = group
end

function Schema:GetFactionGroup(faction)
	return self.factionGroups[faction] or 0
end

do
	local CHAR = ix.meta.character
	local PLAYER = FindMetaTable("Player")

	function CHAR:IsCityAdmin()
		local faction = self:GetFaction()
		return faction == FACTION_ADMIN or faction == FACTION_ADMIN_HEAD
	end

	function PLAYER:IsCityAdmin()
		local faction = self:Team()
		return faction == FACTION_ADMIN or faction == FACTION_ADMIN_HEAD
	end

	function CHAR:IsCombine()
		local faction = self:GetFaction()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_COMBINE or Schema:GetFactionGroup(faction) == FACTION_GROUP_OTA
	end

	function PLAYER:IsCombine()
		local faction = self:Team()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_COMBINE or Schema:GetFactionGroup(faction) == FACTION_GROUP_OTA
	end

	function CHAR:IsOTA()
		local faction = self:GetFaction()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_OTA
	end

	function PLAYER:IsOTA()
		local faction = self:Team()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_OTA
	end

	function CHAR:IsCWU()
		local faction = self:GetFaction()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_CWU
	end

	function PLAYER:IsCWU()
		local faction = self:Team()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_CWU
	end

	function CHAR:IsRebel()
		local faction = self:GetFaction()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_REBEL
	end

	function PLAYER:IsRebel()
		local faction = self:Team()
		return Schema:GetFactionGroup(faction) == FACTION_GROUP_REBEL
	end
end