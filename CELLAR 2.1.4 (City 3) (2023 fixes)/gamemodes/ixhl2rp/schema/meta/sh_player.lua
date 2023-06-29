local PLAYER = FindMetaTable("Player")

function PLAYER:IsDispatch()
	return self:Team() == FACTION_DISPATCH
end