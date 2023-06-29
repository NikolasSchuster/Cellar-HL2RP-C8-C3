
PLUGIN.name = "Thirdperson No Abuse"
PLUGIN.author = "LegAz"
PLUGIN.description = "Hide players that only visible through firstperson."

if (CLIENT) then
	-- mat type of glass in cinema on rp_city3
	MAT_GLASS2 = 45

	local notSolidMatTypes = {
		[MAT_GLASS] = true,
		[MAT_GLASS2] = true
	}
	local notSolidTextures = {
		["TOOLS/TOOLSNODRAW"] = true,
		["METAL/METALBAR001C"] = true,
		["METAL/METALGATE001A"] = true,
		["METAL/METALGATE004A"] = true,
		["METAL/METALGRATE011A"] = true,
		["METAL/METALGRATE016A"] = true,
		["METAL/METALCOMBINEGRATE001A"] = true,
		["maps/rp_city3/glass/combinepodglass001a_12539_462_-284"] = true
	}
	local notSolidModels = {
		["models/props_wasteland/exterior_fence002c.mdl"] = true,
		["models/props_wasteland/exterior_fence002b.mdl"] = true,
		["models/props_wasteland/exterior_fence003a.mdl"] = true,
		["models/props_wasteland/exterior_fence001b.mdl"] = true
	}

	function PLUGIN:PlayerModelChanged(client)
		client.ixHeadBonePos = nil
	end

	function PLUGIN:PrePlayerDraw(dPlayer, flags)
		if (dPlayer:Team() == FACTION_DISPATCH) then return end

		local client = LocalPlayer()
		local clientPos = client:GetShootPos()
		local allPlayers = player.GetAll()

		if (client:GetNetVar("actEnterAngle")) then
			clientPos = client.ixHeadBonePos

			if (!clientPos) then
				local headBone

				for i = 0, client:GetBoneCount() - 1 do
					local name = client:GetBoneName(i)

					if (string.find(name:lower(), "head")) then
						headBone = i

						break
					end
				end

				clientPos = headBone and client:GetBonePosition(headBone) or client:GetPos()
				client.ixHeadBonePos = clientPos
			end
		end

		if (!dPlayer:IsDormant() and client:GetMoveType() != MOVETYPE_NOCLIP and client:CanOverrideView()) then
			local bBoneHit = false

			-- it's very heavy way for client to check if another player can be seen, but it's the most accurate we have
			for i = 0, dPlayer:GetBoneCount() - 1 do
				local bonePos = dPlayer:GetBonePosition(i)
				local traceLine = util.TraceLine({
					start = clientPos,
					endpos = bonePos,
					filter = allPlayers,
					mask = MASK_SHOT_HULL
				})

				local entity = traceLine.Entity
				local entityClass = IsValid(entity) and entity:GetClass()

				if (traceLine.HitPos == bonePos) then
					bBoneHit = true

					break
				elseif (
					(notSolidMatTypes[traceLine.MatType] or notSolidTextures[traceLine.HitTexture]) or
					((entity and (entityClass == "prop_dynamic" or entityClass == "prop_physics")) and notSolidModels[entity:GetModel()])
				) then
					local traceLine2 = util.TraceLine({
						start = bonePos,
						endpos = clientPos,
						filter = allPlayers,
						mask = MASK_SHOT_HULL
					})

					if (traceLine.Entity == traceLine2.Entity) then
						bBoneHit = true

						break
					end
				end
			end

			if (!bBoneHit) then
				if (!dPlayer.ixIsHidden) then
					dPlayer:DrawShadow(false)

					dPlayer.ixIsHidden = true
				end

				return true
			elseif (dPlayer.ixIsHidden and bBoneHit) then
				dPlayer:DrawShadow(true)

				dPlayer.ixIsHidden = false
			end
		elseif (dPlayer.ixIsHidden) then
			dPlayer:DrawShadow(true)

			dPlayer.ixIsHidden = false
		end
	end

	for _, v in ipairs(weapons.GetList()) do
        v.Old_DrawWorldModel = v.Old_DrawWorldModel or v.DrawWorldModel
        
        function v:DrawWorldModel(flags)
            local owner = self:GetOwner()

            if (IsValid(owner) and owner:IsPlayer() and owner != LocalPlayer() and owner.ixIsHidden) then
                self:DrawShadow(false)

                return
            end

            self:Old_DrawWorldModel(flags)
        end
    end
end