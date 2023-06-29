local PLAYER = FindMetaTable("Player")

function PLAYER:IsDispatch()
	local faction = self:Team()
	return faction == FACTION_OTA or Schema:IsPlayerCombineRank(self, {"dl", "cc", "sc"})
end