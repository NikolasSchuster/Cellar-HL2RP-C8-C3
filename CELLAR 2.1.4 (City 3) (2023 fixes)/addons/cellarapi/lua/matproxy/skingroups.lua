SKINGROUPS = SKINGROUPS or {}

matproxy.Add({
	name = "SkinGroup",
	init = function(self, mat, values)
		self.skinID = values.id
		self.skinMax = values.baseframes or 0 
		
		SKINGROUPS[mat:GetName()] = SKINGROUPS[mat:GetName()] or {self.skinID, self.skinMax}
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

		if ent.GetSkingroup then
			if !ent.skingroups then
				ent.skingroups = true
			end
			
			local var1 = ent:GetSkingroup(self.skinID)

			if isnumber(var1) then
				mat:SetInt("$frame", math.Clamp(var1, 0, self.skinMax))
			end
		end
	end 
})
