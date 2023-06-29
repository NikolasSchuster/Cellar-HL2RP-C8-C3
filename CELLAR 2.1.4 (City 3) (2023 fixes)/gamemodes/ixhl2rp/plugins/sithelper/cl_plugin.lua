local PLUGIN = PLUGIN

local bShowPreview = false
local sitAngle = Angle(0, 0, 0)
local sitPreview = NULL
local sitOption = 1

concommand.Add("+sit", function(player, cmd, args)
	bShowPreview = true

	sitAngle = Angle(0, LocalPlayer():EyeAngles().y + 180, 0)
	sitPreview = ClientsideModel(player:GetModel(), RENDERGROUP_OPAQUE)
	sitPreview:SetNoDraw(true)
end)

concommand.Add("-sit", function(player)
	bShowPreview = false
	SafeRemoveEntity(sitPreview)

	local localPlayer = LocalPlayer()
	local eyePos = localPlayer:EyePos()
	local obb = PLUGIN.OBB[sitOption] or PLUGIN.OBB[0]

	local character = localPlayer:GetCharacter()
	if character and character:GetGender() == GENDER_FEMALE then
		obb = PLUGIN.OBBF[sitOption] or obb
	end

	local sitTrace = util.TraceHull({
		start = eyePos,
		endpos = eyePos + localPlayer:EyeAngles():Forward() * 60,
		filter = localPlayer,
		mins = obb[1],
		maxs = obb[2]
	})

	local downTrace = util.TraceHull({
		start = sitTrace.HitPos,
		endpos = sitTrace.HitPos - Vector(0, 0, 100),
		filter = localPlayer,
		mins = obb[1],
		maxs = obb[2]
	});

	-- Trying to sit too far away or something is blocking us from sitting, deny it
	if (!downTrace.Hit or downTrace.AllSolid or downTrace.HitNormal.z <= 0.75) then
		return
	end

	net.Start("ixPlayerSit")
		net.WriteVector(downTrace.HitPos)
		net.WriteAngle(sitAngle)
		net.WriteUInt(sitOption, 5)
	net.SendToServer()
end)

do
	local mat = Material("debug/debugdrawflat")

	function PLUGIN:PostDrawTranslucentRenderables()
		if (!bShowPreview) then
			return
		end

		if (!IsValid(sitPreview)) then
			return
		end

		local anim = sitPreview:LookupSequence(self.sitStances[sitOption])

		if (anim <= -1) then
			return
		end

		local localPlayer = LocalPlayer()
		local eyePos = localPlayer:EyePos()
		local obb = self.OBB[sitOption] or self.OBB[0]

		local character = localPlayer:GetCharacter()
		if character and character:GetGender() == GENDER_FEMALE then
			obb = self.OBBF[sitOption] or obb
		end

		local sitTrace = util.TraceHull({
			start = eyePos,
			endpos = eyePos + localPlayer:EyeAngles():Forward() * 60,
			filter = localPlayer,
			mins = obb[1],
			maxs = obb[2]
		})

		local downTrace = util.TraceHull({
			start = sitTrace.HitPos,
			endpos = sitTrace.HitPos - Vector(0, 0, 100),
			filter = localPlayer,
			mins = obb[1],
			maxs = obb[2]
		})

		local bCanSit = self:CanSit(localPlayer, downTrace.HitPos, sitOption)

		if (!downTrace.Hit or downTrace.HitNormal.z <= 0.75) then
			bCanSit = false
		end

		render.MaterialOverride(mat)

		local sitOffset = self.sitOffsets[sitOption] or vector_origin

		local character = localPlayer:GetCharacter()
		if character and character:GetGender() == GENDER_FEMALE then
			sitOffset = self.sitOffsetsF[sitOption] or sitOffset
		end

		local forwardOffset = sitOffset.x
		local previewPos = (downTrace.Hit and downTrace.HitPos or sitTrace.HitPos)
		local previewOffsetPos = previewPos + sitAngle:Forward() * forwardOffset + Vector(0, 0, sitOffset.z)

		render.SetColorModulation(bCanSit and 0 or 1, bCanSit and 1 or 0, 0, 1)
		render.SetBlend(0.2)
		sitPreview:SetPos(previewOffsetPos)
		sitPreview:SetAngles(sitAngle)
		sitPreview:SetSequence(anim)
		sitPreview:DrawModel()

		render.MaterialOverride(nil)
	end
end

function PLUGIN:PlayerBindPress(player, bind, bPressed)
	if (!bShowPreview or !IsValid(sitPreview)) then return end
	bind = bind:lower()

	if (bind:find("invnext") or bind:find("invprev")) then
		return true
	elseif (bind:find("+attack2") and bPressed) then
		sitOption = math.Clamp(sitOption - 1, 1, #PLUGIN.sitStances)
		return true
	elseif (bind:find("+attack") and bPressed) then
		sitOption = math.Clamp(sitOption + 1, 1, #PLUGIN.sitStances)
		return true
	end
end

function PLUGIN:InputMouseApply(cmd)
	if (!bShowPreview or !IsValid(sitPreview)) then return end
	local scrollDelta = cmd:GetMouseWheel()

	if (scrollDelta == 0) then return end

	local bPos = cmd:GetMouseWheel() > 0

	sitAngle.y = math.NormalizeAngle(sitAngle.y + (bPos and 4 or -4))
end
