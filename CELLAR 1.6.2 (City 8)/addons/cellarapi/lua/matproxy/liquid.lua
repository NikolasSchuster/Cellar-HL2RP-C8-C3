local nocolor = Vector()

matproxy.Add({
	name = "LiquidProx",
	init = function(self, mat, values)

	end,
	bind = function(self, mat, ent)
		if !IsValid(ent) then return end

		mat:SetVector("$color2", ent:GetNetVar("clr") or nocolor)
	end 
})
