-- 1

function PLUGIN:EntityFireBullets(entity, bulletInfo)

end

do
	local modify = {
	["$pp_colour_addr"] = 0, 
	["$pp_colour_addg"] = 0, 
	["$pp_colour_addb"] = 0, 
	["$pp_colour_brightness"] = 0, 
	["$pp_colour_contrast"] = 1, 
	["$pp_colour_colour"] = 1, 
	["$pp_colour_mulr"] = 0, 
	["$pp_colour_mulg"] = 0, 
	["$pp_colour_mulb"] = 0
	}

	local oldST, dmg
	dmg = 0

	function PLUGIN:RenderScreenspaceEffects()
		local character = LocalPlayer():GetCharacter()
		if character then
			local st = SysTime()

			oldST = oldST or st
			local delta = st - oldST
			oldST = st
			
			modify["$pp_colour_colour"] = math.max(((character:GetBlood() - 2000) / 3000), 0)

			DrawColorModify(modify)
			DrawBloom(0.2, dmg, 6, 16, 1, 0, 1, 1, 1)

			if dmg > 0 then
				dmg = Lerp(delta * 10, dmg, 0)
			end
		end
	end

	net.Receive("ixShockPain", function()
		local data = net.ReadUInt(3) or 1
		dmg = dmg + data
	end)
end

do
	local oldST
	local targetAng = Angle()
	function PLUGIN:CalcView(client, origin, angles, fov)
		if !IsValid(client) then
			return
		end

		local character = client:GetCharacter()

		if !character or client:GetLocalVar("ragdoll", 0) != 0 then
			return
		end

		local shockLevel = character:GetShock()

		if shockLevel <= 1 and !character:IsFeelPain() then
			return
		end

		local delta
		local st = SysTime()

		oldST = oldST or st
		delta = math.min(st - oldST, FrameTime(), 1 / 30)
		oldST = st

		local mulDelta = math.max((shockLevel - 50) / 12000, 0)
		local mulRand = math.abs((1 - mulDelta) - 0.3)
		local rand = 15 * mulRand 

		targetAng = LerpAngle(delta * (10 + (20 * mulDelta)), targetAng, Angle(math.Rand(-rand, rand), math.Rand(-rand, rand), 0))
		targetAng.r = 0

		local eyeAngle = client:EyeAngles()
		eyeAngle = LerpAngle(delta * (10 * mulDelta), eyeAngle, eyeAngle + targetAng)
		eyeAngle.r = 0

		
		client:SetEyeAngles(eyeAngle)
	end
end

local function DrawDebugString(text, x, y, align)
	text = tostring(text)

	local color = Color(255, 255, 255)
	if text == "true" then
		color = Color(50, 200, 50)
	elseif text == "false" then
		color = Color(200, 50, 50)
	end

	return select(2, draw.SimpleText(text, "TargetIDSmall", x, y, color, align, 0))
end

local function GetSizeOfTextTable(tbl)
	surface.SetFont("TargetIDSmall")
	local x, y = surface.GetTextSize("NULL")
	return table.Count(tbl) * y
end


local colorBG = Color(255, 255, 255, 150)
debugTexBG = debugTexBG or nil
debugTex = debugTex or {}

function PLUGIN:CharacterLoaded(character)
	debugTexBG = LDATA_HUMAN_MALE.bodytexture
	debugTex = {}
	for k, limb in pairs(LDATA_HUMAN_MALE.stored or {}) do
		if limb:IsHidden() then continue end

		debugTex[#debugTex + 1] = {limb:Name(), limb:Texture()}
	end
end

do
	local EFFECT = {}
	local gravity = Vector(0, 0, -500)

	local function ParticleCollides(particle, position, normal)
		if !particle.Painted then
			if math.random() <= 0.01 then
				util.Decal("Blood", position + normal, position - normal)
				particle.Painted = true
			end
		end
	end

	function EFFECT:Init(data)
		local pos = data:GetOrigin()
		local ang = data:GetAngles()
		self.Emitter = ParticleEmitter(pos)

		local lcol = render.GetLightColor(pos) * 255
		lcol.r = math.Clamp(lcol.r, 50, 150)

		for i = 1, 5 do
			local smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1,6), pos + VectorRand()*2)
			smoke:SetVelocity(ang:Up())
			smoke:SetDieTime(FrameTime() * 4)
			smoke:SetStartAlpha(math.random(200,255))
			smoke:SetStartSize(math.random(5,10))
			smoke:SetEndSize(0)
			smoke:SetColor(255, 0, 0)
			smoke:SetGravity(vector_origin)
		end

		for i = 1, 5 do
			local smoke = self.Emitter:Add("effects/blooddrop", pos + VectorRand()*2)
			smoke:SetVelocity((ang:Up()*-math.Rand(.5, 1) + ang:Forward()*math.Rand(-1, 1) + ang:Right()*math.Rand(-1, 1)) * 15)
			smoke:SetDieTime(math.Rand(.8, .12))
			smoke:SetStartSize(1)
			smoke:SetEndSize(3)
			smoke:SetColor(255, 0, 0)
			smoke:SetGravity(gravity)
			smoke:SetCollideCallback(ParticleCollides)
			smoke:SetCollide(true)
		end

		self.Emitter:Finish()
	end

	function EFFECT:Think()
		return false
	end

	function EFFECT:Render()
	end

	effects.Register(EFFECT, "bleeding")
end

do
	local bleedingPlayers = {}

	net.Receive("ixBleedingEffect", function()
		local ply = net.ReadEntity()

		bleedingPlayers[ply] = ply:GetNetVar("isBleeding") or nil
	end)

	timer.Create("ixBleedingEffects", 0.25, 0, function()
		for v, _ in pairs(bleedingPlayers) do
			if !IsValid(v) then continue end

			local doll = v:GetNetVar("doll") and Entity(v:GetNetVar("doll"))
			doll = IsValid(doll) and doll or nil

			local object = v:GetNetVar("doll") and doll or v
			local boneID = v:GetNetVar("bleedingBone")
			if !object or !boneID then continue end


			local pos, ang = object:GetBonePosition(boneID)
			local effectData = EffectData()
				effectData:SetOrigin(pos or (v:GetPos() + Vector(0,0,32)))
				effectData:SetAngles(ang or Angle())
			util.Effect("bleeding", effectData, true, true)
		end
	end)
end

do
	local crit_material = Material("cellar/ui/crit.png")
	local size = 32
	local mid  = size / 2
	local abs = math.abs
	local use = string.upper(input.LookupBinding("+use"))

	local focus_stick = 0
	local focus_range = 25
	local focus_ent = nil
	local focused_ent = nil

	surface.CreateFont("ixCrit", {
		font = "Roboto Lt",
		size = 18,
		weight = 500,
		antialias = true,
		extended = true
	})
	surface.CreateFont("ixCritBlur", {
		font = "Roboto Lt",
		size = 18,
		weight = 500,
		blursize = 2,
		antialias = true,
		extended = true
	})

	local critCount = 0
	local critPlayers = {}

	net.Receive("ixCritUse", function()
		Derma_Query("Добивая этого персонажа, Вы безвозвратно заблокируете его, получив весь инвентарь погибшего. Этот процесс займет 15 секунд. Вы точно уверены в этом?", "Добить персонажа", "Добить", function() 
			net.Start("ixCritApply")
				net.WriteBool(true)
			net.SendToServer()

			end, "Отмена", function() 

			net.Start("ixCritApply")
			net.SendToServer()
		end)
	end)

	timer.Create("ixCritUpdate", 5, 0, function()
		for _, client in ipairs(player.GetAll()) do
			critPlayers[client] = client:GetNetVar("crit", nil)
		end

		critCount = table.Count(critPlayers)
	end)

	net.Receive("ixCritData", function()
		local client = net.ReadEntity()
		local state = net.ReadBool() or nil

		critPlayers[client] = state
		critCount = table.Count(critPlayers)
	end)

	local function IsOffScreen(scrpos)
		return not scrpos.visible or scrpos.x < 0 or scrpos.y < 0 or scrpos.x > ScrW() or scrpos.y > ScrH()
	end

	local function UseCriticalButton()
		net.Start("ixCritUse")
			net.WriteEntity(focused_ent)
		net.SendToServer()
		
		focused_ent = nil
		return true
	end

	function PLUGIN:PlayerBindPress(client, bind, pressed)
		if IsValid(focused_ent) and focus_stick >= CurTime() then
			if bind:find("attack") and pressed then
				return true
			elseif bind:find("+use") and pressed then
				return UseCriticalButton()
			end
		end
	end

	function PLUGIN:HUDPaint()
		if critCount == 0 then
			return
		end

		surface.SetMaterial(crit_material)

		local plypos = LocalPlayer():GetPos()
		local midscreen_x = ScrW() / 2
		local midscreen_y = ScrH() / 2
		local pos, scrpos, d
		local focus_ent = nil
		local focus_d, focus_scrpos_x, focus_scrpos_y = 0, midscreen_x, midscreen_y

		for but, _ in pairs(critPlayers) do
			if IsValid(but) and but:IsPlayer() then
				local doll = but:GetNetVar("doll") and Entity(but:GetNetVar("doll"))
				if IsValid(doll) then
					but = doll
				end

				local boneID = but:LookupBone("ValveBiped.Bip01_Head1")

				pos = but:GetPos()

				if boneID then
					pos = but:GetBonePosition(boneID)
				end

				scrpos = pos:ToScreen()

				if !IsOffScreen(scrpos) then
					d = pos - plypos
					d = d:Dot(d) / (100 ^ 2)

					if d < 1 then
						surface.SetDrawColor(255, 255, 255, 255 * (1 - d))
						surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)

						if d > focus_d then
							local x = abs(scrpos.x - midscreen_x)
							local y = abs(scrpos.y - midscreen_y)
							if (x < focus_range and y < focus_range and
								 x < focus_scrpos_x and y < focus_scrpos_y) then

								if focus_stick < CurTime() or but == focused_ent then
									focus_ent = but
								end
							end
						end
					end
				end
			else
				critPlayers[but] = nil
				critCount = table.Count(critPlayers)
			end

			if IsValid(focus_ent) then
				focused_ent = focus_ent
				focus_stick = CurTime() + 0.1

				local text = string.format("НАЖМИТЕ [%s] ЧТОБЫ ДОБИТЬ", use)
				local x = scrpos.x
				local y = scrpos.y + 16
				surface.SetFont("ixCrit")

				local tX, tY = surface.GetTextSize(text)
				x = x - tX/2
				
				surface.SetFont("ixCritBlur")
				surface.SetTextColor(0, 0, 0, 255)
				surface.SetTextPos(x, y)
				surface.DrawText(text)

				surface.SetFont("ixCrit")
				surface.SetTextColor(255, 255, 255, 255)
				surface.SetTextPos(x, y)
				surface.DrawText(text)
			end
		end
	end
end

hook.Add("prone.CanExit", "bsBrokenLegs", function(player)
	local character = player:GetCharacter()

	if character then
		local rightLeg = character:GetLimbDamage(HITGROUP_RIGHTLEG)
		local leftLeg = character:GetLimbDamage(HITGROUP_LEFTLEG)

		if rightLeg > 99 or leftLeg > 99 then
			return false
		end
	end
end)