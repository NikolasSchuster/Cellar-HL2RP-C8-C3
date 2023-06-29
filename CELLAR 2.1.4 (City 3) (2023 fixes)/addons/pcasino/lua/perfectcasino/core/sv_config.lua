function PerfectCasino.Core.CreateEnt(class, settings, pos, ang, id)
	local ent = ents.Create(class)
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()
	
	ent.DatabaseID = id
	ent.data = settings

	ent:PostData()

	local phys = ent:GetPhysicsObject()
	if not IsValid(phys) then return end
	phys:EnableMotion(false)
end

net.Receive("pCasino:ToolGun:CreateEntity", function(_, ply)
	if not PerfectCasino.Core.Access(ply) then return end -- Check if they even have perms to make entities

	local class = net.ReadString()
	if not PerfectCasino.Core.Entites[class] then return end -- Check if the entity is in the pCasino system

	local settings = net.ReadTable() -- Get the settings. We trust the user as they're an admin

	local pos = net.ReadVector()
	local ang = net.ReadAngle()

	local id = PerfectCasino.Database.CreateEntity(class, settings, pos, ang)
	PerfectCasino.Core.CreateEnt(class, settings, pos, ang, id)
end)

net.Receive("pCasino:RequestData:Send", function(_, ply)
	local entity = net.ReadEntity()
	if not IsValid(entity) then return end

	-- Prevent spam
	if PerfectCasino.Cooldown.Check("RequestData:"..entity:EntIndex(), 1, ply) then return end

	if not string.match(entity:GetClass(), "pcasino") then return end
	if not entity.data then return end

	net.Start("pCasino:RequestData:Respond")
		net.WriteEntity(entity)
		net.WriteTable(entity.data)
	net.Send(ply)
end)

hook.Add("InitPostEntity", "pCasino:Spawn:Entities", function()
	PerfectCasino.Database.Startup()
	local entities = PerfectCasino.Database.GetEntites()

	if not istable(entities) or table.IsEmpty(entities) then return end

	for k, v in pairs(entities) do
		local settings = util.JSONToTable(v.settings)
		local pos = util.JSONToTable(v.pos)
		pos = Vector(pos.x, pos.y, pos.z)
		local ang = util.JSONToTable(v.ang)
		ang = Angle(ang.x, ang.y, ang.z)

		PerfectCasino.Core.CreateEnt(v.class, settings, pos, ang, v.id)
	end
end)

hook.Add("PostCleanupMap", "pCasino:Spawn:Entities", function()
	local entities = PerfectCasino.Database.GetEntites()

	if not istable(entities) or table.IsEmpty(entities) then return end

	for k, v in pairs(entities) do
		local settings = util.JSONToTable(v.settings)
		local pos = util.JSONToTable(v.pos)
		pos = Vector(pos.x, pos.y, pos.z)
		local ang = util.JSONToTable(v.ang)
		ang = Angle(ang.x, ang.y, ang.z)

		PerfectCasino.Core.CreateEnt(v.class, settings, pos, ang, v.id)
	end
end)