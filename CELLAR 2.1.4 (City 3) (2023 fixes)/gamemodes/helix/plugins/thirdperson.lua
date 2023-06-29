
PLUGIN.name = "Third Person"
PLUGIN.description = "Provides a customizable third-person camera."
PLUGIN.author = "Zombine, `impulse, LegAz"

ix.config.Add("thirdperson", true, "Allow third-person camera in the server.", nil, {
	category = "server"
})

do
	local function IsHidden()
		return !ix.config.Get("thirdperson")
	end

	ix.option.Add("thirdpersonEnabled", ix.type.bool, false, {
		category = "thirdperson",
		bNetworked = true,
		hidden = IsHidden(),
		OnChanged = function(oldValue, value)
			if (CLIENT) then
				hook.Run("ThirdPersonToggled", oldValue, value)
			end
		end
	})

	if (CLIENT) then
		ix.option.Add("thirdpersonVertical", ix.type.number, 6, {
			category = "thirdperson", min = 0, max = 10,
			hidden = IsHidden()
		})

		ix.option.Add("thirdpersonHorizontal", ix.type.number, 10, {
			category = "thirdperson", min = -25, max = 25,
			hidden = IsHidden()
		})

		ix.option.Add("thirdpersonDistance", ix.type.number, 45, {
			category = "thirdperson", min = 0, max = 60,
			hidden = IsHidden()
		})

		ix.option.Add("thirdpersonCrouchOffset", ix.type.number, 6, {
			category = "thirdperson", min = 0, max = 10,
			hidden = IsHidden()
		})
	end
end

if (CLIENT) then
	local playerMeta = FindMetaTable("Player")

	-- current camera info
	local camera = {
		position = Vector(0, 0, 0),
		angle = Angle(0, 0, 0),
		fov = 0,
		targetFOV = 0,
		punch = Angle(0, 0, 0),
		punchScale = 1,
		bBlocked = false,

		left = {},
		right = {},
		center = {
			lerp = 0.05
		},
		focus = {
			lerp = 0.025
		}
	}

	function playerMeta:CanOverrideView()
		if (hook.Run("ShouldDisableThirdperson", self) == true) then
			return false
		end

		if ((IsValid(ix.gui.characterMenu) and !ix.gui.characterMenu:IsClosing() and ix.gui.characterMenu:IsVisible()) or
			(IsValid(ix.gui.menu) and ix.gui.menu:GetCharacterOverview())) then
			return false
		end

		local entity = Entity(self:GetLocalVar("ragdoll", 0))

		if (
			ix.option.Get("thirdpersonEnabled", false) and
			!IsValid(self:GetVehicle()) and
			ix.config.Get("thirdperson", false) and
			self:GetCharacter() and
			!self:GetNetVar("actEnterAngle") and
			!IsValid(entity) and
			self:Alive() and
			self:GetMoveType() != MOVETYPE_NOCLIP
		) then
			return true
		end

		return false
	end

	function PLUGIN:CalcView(client, origin, angle, fov)
		if (!client:CanOverrideView() or client:GetViewEntity() != LocalPlayer()) then
			camera.angle = client:EyeAngles()
			return
		end

		local frameTime = FrameTime()
		local vertical = ix.option.Get("thirdpersonVertical", 6)
		local horizontal = ix.option.Get("thirdpersonHorizontal", 10)
		local distance = ix.option.Get("thirdpersonDistance", 45)
		local crouchHeight = ix.option.Get("thirdpersonCrouchOffset", 6)

		camera.left.x, camera.center.x, camera.focus.x, camera.right.x = distance * 0.33, distance, distance * 0.33, distance * 0.33 -- distance
		camera.left.y, camera.center.y, camera.focus.y, camera.right.y = horizontal, horizontal, horizontal, 32 -- horizontal
		camera.left.z, camera.center.z, camera.focus.z, camera.right.z = vertical, vertical, vertical, vertical -- vertical
		camera.focus.crouch = crouchHeight == 0 and vertical or crouchHeight -- crouch offset
		camera.targetFOV = self.zoomed and 70 or 0 -- fov
		camera.punch = client:GetViewPunchAngles() -- viewpunch

		if (!client:GetNetVar("brth", false) and client:KeyDown(IN_SPEED)) then
			if (client:KeyDown(IN_FORWARD) or client:KeyDown(IN_BACK) or client:KeyDown(IN_MOVELEFT) or client:KeyDown(IN_MOVERIGHT)) then
				camera.targetFOV = fov + 5
			end
		end

		if (client:KeyDown(IN_DUCK)) then
			camera.position.z = Lerp(frameTime * 5, camera.position.z, camera.focus.crouch)
		else
			camera.position.z = Lerp(frameTime * 5, camera.position.z, camera.center.z)
		end

		camera.fov = Lerp(frameTime * 7, camera.fov, camera.targetFOV == 0 and fov or camera.targetFOV)
		camera.position.x = Lerp(camera.center.lerp, camera.position.x, camera.center.x)
		camera.position.y = Lerp(camera.center.lerp, camera.position.y, camera.center.y)

		local offset = origin - (camera.angle:Forward() * camera.position.x) + (camera.angle:Right() * camera.position.y) + (camera.angle:Up() * camera.position.z)

		-- check if the camera will hit something
		local collisionTrace = util.TraceHull({
			start = client:EyePos() - camera.angle:Forward() * 4,
			endpos = offset,
			mins = Vector(-4, -4, -4),
			maxs = Vector(4, 4, 4),
			filter = function(entity)
				return entity != client or entity:GetOwner() != client
			end
		})

		if (collisionTrace.Hit) then
			offset = collisionTrace.HitPos
			camera.bBlocked = collisionTrace.HitPos:Distance(client:EyePos()) <= 15
		else
			camera.bBlocked = false
		end

		if (camera.bBlocked) then
			return
		end

		-- from camera pos to aim pos
		local camTrace = util.TraceLine({
			start = offset + (camera.angle:Forward() * distance * 1.2),
			endpos = offset + (camera.angle:Forward() * 32768),
			filter = client,
			mask = MASK_OPAQUE
		})

		local entTrace = util.TraceLine({
			start = offset + (camera.angle:Forward() * distance * 1.2),
			endpos = offset + (camera.angle:Forward() * 32768),
			filter = client,
			mask = MASK_SHOT
		})

		local finalPos = IsValid(entTrace.Entity) and entTrace.HitPos or camTrace.HitPos

	--[[
		local clearTrace = util.TraceLine({
			start = client:EyePos(),
			endpos = finalPos,
			mask = MASK_SHOT,
			filter = client
		})

		if (clearTrace.Fraction <= 0.9) then
			CrosshairBlocked = true
		else
			CrosshairBlocked = false
		end
	]]

		client:SetEyeAngles((finalPos - client:EyePos()):Angle(), true)

		local angles = camera.angle + (camera.punch * camera.punchScale)
		local view = {}

		view.origin = offset
		view.angles = angles
		view.fov = camera.fov
		view.drawviewer = true
		client.ixCameraPosition = offset
		client.ixCameraAngle = angles

		return view
	end

	function PLUGIN:InputMouseApply(_, x, y, angle)
		local client = LocalPlayer()

		if (!client:CanOverrideView()) then
			return
		end

		local weapon = client:GetActiveWeapon()

		if (IsValid(weapon) and weapon:GetClass() == "weapon_physgun" and client:KeyDown(IN_USE)) then
			return false
		end

		camera.angle.p = math.Clamp(math.NormalizeAngle(camera.angle.p + y / 50), -90, 90)
		camera.angle.y = math.NormalizeAngle(camera.angle.y - (x / 50))

		if (!camera.bBlocked) then
			return true
		end
	end

	function PLUGIN:CreateMove(cUserCmd)
		if (!LocalPlayer():CanOverrideView()) then
			return
		end

		local desiredYaw = camera.angle.y
		local currentYaw = LocalPlayer():EyeAngles().y
		local offsetYaw = desiredYaw - currentYaw
		local correctedYaw = Vector(cUserCmd:GetForwardMove(), cUserCmd:GetSideMove(), 0)
		local moveLength = correctedYaw:Length()

		correctedYaw = correctedYaw:Angle().y
		correctedYaw = Angle(0, correctedYaw - offsetYaw, 0)
		correctedYaw = correctedYaw:Forward()
		cUserCmd:SetForwardMove(correctedYaw.x * moveLength)
		cUserCmd:SetSideMove(correctedYaw.y * moveLength)
	end

	hook.Add("PlayerEnterSequence", "ixBlockCameraOnAct", function()
		camera.bBlocked = true
	end)

	concommand.Add("ix_togglethirdperson", function()
		if (ix.config.Get("thirdperson", false)) then
			ix.option.Set("thirdpersonEnabled", !ix.option.Get("thirdpersonEnabled"))
		end
	end)
end
