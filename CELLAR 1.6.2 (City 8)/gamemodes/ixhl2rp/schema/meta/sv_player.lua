local playerMeta = FindMetaTable("Player")

function playerMeta:AddCombineDisplayMessage(text, color, ...)
	if (self:IsCombine()) then
		netstream.Start(self, "CombineDisplayMessage", text, color or false, {...})
	end
end
