ix.limb = ix.limb or {}
ix.limb.bones = {
	["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine1"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
	["ValveBiped.Bip01_Neck1"] = HITGROUP_HEAD
}

function ix.limb:BoneToHitGroup(bone)
	return self.bones[bone] or HITGROUP_CHEST
end

function ix.limb:IsActive()
	return ix.config.Get("limbSystemEnabled")
end

if CLIENT then
	function ix.limb:GetColor(health)
		if health > 75 then
			return Color(166, 243, 76, 255)
		elseif health > 50 then
			return Color(233, 225, 94, 255)
		elseif health > 25 then
			return Color(233, 173, 94, 255)
		else
			return Color(222, 57, 57, 255)
		end
	end
end

do
	local charMeta = ix.meta.character

	function charMeta:Limbs()
		return self.limbobject
	end

	function charMeta:IsAnyDamagedLimb()
		local limbData = self:GetLimbData()

		if #limbData > 0 then
			return true
		else
			return false
		end
	end

	function charMeta:GetLimbHealth(limb, asFraction)
		return 100 - self:GetLimbDamage(limb, asFraction)
	end

	function charMeta:GetLimbDamage(limb, asFraction)
		if !ix.limb:IsActive() then
			return 0
		end

		local limbs = self:Limbs()

		if !limbs then
			return 0
		end

		if isnumber(limb) then
			limb = limbs:GetByHitgroup(limb)
			
			if limb then
				limb = limb:Name()
			end
		end

		local limbData = self:GetLimbData()

		if istable(limbData) then
			if limbData[limb] then
				if asFraction then
					return limbData[limb] / 100
				else
					return limbData[limb]
				end
			end
		end

		return 0
	end
end

if CLIENT then
	net.Receive("ixHealLimbDamage", function()
		local id = net.ReadUInt(32)
		local character = ix.char.loaded[id]

		if character then
			local limb = net.ReadString()
			local amount = net.ReadFloat()
			local limbData = character:GetLimbData()

			if limbData[limb] == 100 then
				limbData[limb] = nil
			end

			hook.Run("PlayerLimbDamageHealed", LocalPlayer(), limb, amount, character)
		end
	end)
end

