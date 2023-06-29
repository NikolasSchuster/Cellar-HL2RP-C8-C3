PLUGIN.name = "Factions Use Resctiction"
PLUGIN.author = "Vintage Thief & maxxoft"
PLUGIN.description = "Restricting +use for certain factions."


if CLIENT then
	
hook.Add("PlayerBindPress", "BirdUse", function( ply, bind, pressed )
    local char = ply:GetCharacter()
    if !char then return end
	local faction = char:GetFaction()
    if faction == FACTION_BIRD and string.find(bind, "use") then
        return true
	elseif faction == FACTION_ZOMBIE and string.find(bind, "use") then
		return true
    end
end)
	
end