matproxy.Add({
	name = "SecondaryVisorColor",

	init = function(self, mat, values)
		self.ResultTo = values.resultvar
	end,

	bind = function(self, mat, ent)
		if !IsValid(ent) then return end

		if ent.ProxyOwner then
			if IsValid(ent.ProxyOwner) then
				ent = ent.ProxyOwner
			end
		end
		
		if ent:IsRagdoll() then
			local owner = ent:GetRagdollOwner()

			if IsValid(owner) then 
				ent = owner
			end
		end

		if ent.GetSecondaryVisorColor then
			local col = ent:GetSecondaryVisorColor()
			if isvector(col) then
				mat:SetVector(self.ResultTo, col)
			end
		end
	end 
})
