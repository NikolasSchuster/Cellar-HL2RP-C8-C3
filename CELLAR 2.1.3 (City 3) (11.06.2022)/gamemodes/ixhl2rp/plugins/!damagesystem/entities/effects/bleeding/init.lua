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
		smoke:SetColor(120, 0, 0)
		smoke:SetGravity(Vector())
	end

	local smoke = self.Emitter:Add("effects/blooddrop", pos + VectorRand()*2)
	smoke:SetVelocity((ang:Up()*-math.Rand(.5, 1) + ang:Forward()*math.Rand(-1, 1) + ang:Right()*math.Rand(-1, 1)) * 15)
	smoke:SetDieTime(math.Rand(.8, .12))
	smoke:SetStartSize(1)
	smoke:SetEndSize(3)
	smoke:SetColor(lcol.r, 0, 0)
	smoke:SetGravity(Vector(0, 0, -500))
	smoke:SetCollideCallback(ParticleCollides);
	smoke:SetCollide(true)

	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end