
PLUGIN.name = "Head Bob"
PLUGIN.author = "kurozael & LegAz"
PLUGIN.description = "Head bobbing cutten from the Clockwork framework."

ix.lang.AddTable("english", {
	optHeadBobSacle = "Head bob scale",
	optdHeadBobSacle = "How much intensive the head bobs.",
})
ix.lang.AddTable("russian", {
	optHeadBobSacle = "Интенсивность покачивания головы",
	optdHeadBobSacle = "Насколько более или менее интенсивно покачивание головы.",
})

if (CLIENT) then
	local hookRun = hook.Run
	local ixOptionGet = ix.option.Get
	local mathApproach = math.Approach
	local mathSin = math.sin
	local mathCos = math.cos
	local mathClamp = math.Clamp

	ix.option.Add("headBobSacle", ix.type.number, 1, {
		category = "general", min = 0, max = 1, decimals = 1
	})

	local function CanDoHeadBob(client)
		if (hookRun("ShouldHeadbob", client) == false or
			GetViewEntity() != client or
			client:GetMoveType() == MOVETYPE_NOCLIP or
			ixOptionGet("headBobSacle", 1) == 0 or
			client:CanOverrideView() or
			(IsValid(ix.gui.characterMenu) and !ix.gui.characterMenu:IsClosing()) or
			(client:GetLocalVar("bIsHoldingObject", false) and client:KeyDown(IN_ATTACK2))
		) then
			return false
		end

	--[[
		-- Tactial Leaning addon has compatibility issue
		if (client.TFALean) then
			if (bSecondEnterence == 1) then
				bSecondEnterence = 0

				return false
			end

			bSecondEnterence = 1
		end
	]]

		return true
	end

	function PLUGIN:PlayerAdjustheadBobInfo(client, info)
		local scale = ix.option.Get("headBobSacle", 1)

		if (client:IsRunning()) then
			info.speed = (info.speed * 4) * scale
			info.roll = (info.roll * 2) * scale * 2
		elseif (client:GetVelocity():Length2DSqr() > 0) then
			info.speed = (info.speed * 3) * scale
			info.roll = (info.roll * 1) * scale * 2
		else
			info.roll = info.roll * scale
		end
	end

	function PLUGIN:CalcView(client, origin, angles, fov)
		if (CanDoHeadBob(client)) then
			local realFrameTime = RealFrameTime()
			local approachTime = realFrameTime * 2
			local info = {}
				info.speed = 1
				info.yaw = 0.5
				info.roll = 0.1

			if (!self.headBobAngle) then
				self.headBobAngle = 0
			end

			if (!self.headBobInfo) then
				self.headBobInfo = info
			end

			hookRun("PlayerAdjustheadBobInfo", client, info)

			self.headBobInfo.yaw = mathApproach(self.headBobInfo.yaw, info.yaw, approachTime)
			self.headBobInfo.roll = mathApproach(self.headBobInfo.roll, info.roll, approachTime)
			self.headBobInfo.speed = mathApproach(self.headBobInfo.speed, info.speed, approachTime)
			self.headBobAngle = self.headBobAngle + (self.headBobInfo.speed * realFrameTime)

			angles.y = angles.y + mathSin(self.headBobAngle) * self.headBobInfo.yaw
			angles.r = angles.r + mathCos(self.headBobAngle) * self.headBobInfo.roll

			local velocity = client:GetVelocity()

			if (!self.velocitySmooth) then self.velocitySmooth = 0 end
			if (!self.walkTimer) then self.walkTimer = 0 end
			if (!self.lastStrafeRoll) then self.lastStrafeRoll = 0 end

			self.velocitySmooth = mathClamp(self.velocitySmooth * 0.9 + velocity:Length() * 0.1, 0, 700)
			self.walkTimer = self.walkTimer + self.velocitySmooth * realFrameTime * 0.05

			self.lastStrafeRoll = (self.lastStrafeRoll * 3) + (RenderAngles():Right():DotProduct(velocity) * 0.0001 * self.velocitySmooth * 0.3)
			self.lastStrafeRoll = self.lastStrafeRoll * 0.25
			angles.r = angles.r + self.lastStrafeRoll

			if (!client:OnGround()) then
				angles.p = angles.p + mathCos(self.walkTimer * 0.5) * self.velocitySmooth * 0.000002 * self.velocitySmooth
				angles.r = angles.r + mathSin(self.walkTimer) * self.velocitySmooth * 0.000002 * self.velocitySmooth
				angles.y = angles.y + mathCos(self.walkTimer) * self.velocitySmooth * 0.000002 * self.velocitySmooth
			end
		end
	end
end
