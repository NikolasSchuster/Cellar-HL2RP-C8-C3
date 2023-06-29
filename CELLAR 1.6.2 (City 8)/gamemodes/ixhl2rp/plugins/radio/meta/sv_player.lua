local PLAYER = FindMetaTable("Player")

function PLAYER:SetChannels()
	ix.radio:SetPlayerChannels(self)
end