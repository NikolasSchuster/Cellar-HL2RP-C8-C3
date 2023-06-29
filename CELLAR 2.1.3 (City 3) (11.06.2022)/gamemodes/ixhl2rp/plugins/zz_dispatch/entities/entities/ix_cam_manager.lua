ENT.Base = "base_entity"
ENT.Type = "point"

function ENT:Initialize()  
	if IsValid(dispatch.cam_manager) then
		dispatch.cam_manager:Remove()
	end
	
	dispatch.cam_manager = self

	self:SetName("cam_manager")
end

function ENT:AcceptInput(name, act, caller, data)
	if IsValid(act) then
		if name == "Scan" then
			self:OnFoundPlayer(caller, act)
		elseif name == "ScanNPC" then
			self:OnFoundNPC(caller, act)
		elseif name == "Death" then
			self:OnDeath(caller, act)
		end
	end
end

function ENT:OnDeath(camera, client)
	local letter = dispatch.AddWaypoint(camera:GetPos(), "УНИЧТОЖЕНА КАМЕРА", "warn", 60)
		
	Schema:AddCombineDisplayMessage(string.format("Метка %s: потерян сигнал с камерой!", letter), color_red)

	for x, _ in pairs(camera.IsSpectatedBy or {}) do
		dispatch.StopSpectate(x)
	end
end

local yellow = Color(255, 255, 0)
local orange = Color(255, 150, 0)
function ENT:ShouldHate(client)
	if client:IsNPC() then
		local alarm, alarmtext, alarmtext2 = false, "Метка %s: ", ""

		if client:Classify() == CLASS_HEADCRAB then
			alarmtext = alarmtext.."вторжение паразитов!"
			alarmtext2 = "Паразиты"
			alarm = true
		elseif client:Classify() == CLASS_ANTLION then
			alarmtext = alarmtext.."вторжение муравьиных львов!"
			alarmtext2 = "Муравьиные львы"
			alarm = true
		elseif client:Classify() == CLASS_ZOMBIE then
			alarmtext = alarmtext.."вторжение некротиков!"
			alarmtext2 = "Некротики"
			alarm = true
		end

		if alarm then
			return true, alarmtext, alarmtext2, "hazard", color_red
		end
		
		return false
	end

	if client:GetNoDraw() then
		return false
	end

	if client:Team() == FACTION_VORTIGAUNT then
		if client:HasWeapon("ix_vortbeam") then
			return true, "Метка %s: неподконтрольный биотик!", "Неподконтрольный биотик", "hazard", color_red
		end

		return false
	elseif !client:IsCombine() and !client:IsCityAdmin() then
		local card = client:GetCharacter():GetIDCard()
		local cid, name, datafile, data
		local textData = ""

		for _, weapon in pairs(client:GetWeapons()) do
			if IsValid(weapon) and weapon.ixItem then
				return true, "Метка %s: "..(card and "вооруженный" or "неопознанный вооруженный").." 647E! "..textData, "94B 647E "..textData, "gun", color_red
			end
		end

		if card then
			cid, name = card:GetData("cid", 0), card:GetData("name", "")
			datafile, data = ix.plugin.list["datafile"]:ReturnDatafileByID(client.ixDatafile, false)
			textData = "#"..cid.." "..name
		else
			return true, "Метка %s: обнаружено неопознанное лицо!", "Неопознанное лицо", "poi", yellow
		end

		if datafile and data then
			if data.status == "Anti-Citizen" then
				return true, "Метка %s: обнаружен анти-гражданин! "..textData, "Анти-гражданин "..textData, "warn", color_red
			elseif data.bol then
				return true, "Метка %s: наблюдение за "..textData, textData, "poi", yellow
			end
		end
	end

	return false
end

function ENT:OnFoundPlayer(camera, client)
	if client:IsNPC() then
		return
	end

	local hate, text, codetext, waypointType, color = self:ShouldHate(client)

	if !hate then 
		camera:AddEntityRelationship(client, D_NU, 99)

		timer.Simple(30, function()
			if IsValid(camera) and IsValid(client) then
				camera:AddEntityRelationship(client, D_FR, 99)
			end
		end)

		return 
	end

	camera.alertCooldown = camera.alertCooldown or {}

	timer.Simple(15, function()
		if IsValid(camera) and IsValid(client) then
			camera:AddEntityRelationship(client, D_NU, 99)

			timer.Simple(15, function()
				if IsValid(camera) and IsValid(client) then
					camera:AddEntityRelationship(client, D_FR, 99)
				end
			end)
		end
	end)

	if (camera.alertCooldown[client] or 0) < CurTime() then
		camera.alertCooldown[client] = CurTime() + 30

		local letter = dispatch.AddWaypoint(client:GetShootPos(), codetext, waypointType, 30)

		Schema:AddCombineDisplayMessage(string.format(text, letter), color)
	end
end

function ENT:OnFoundNPC(camera, npc)
	if npc:IsPlayer() then
		return
	end
	
	local hate, text, codetext, waypointType, color = self:ShouldHate(npc)

	if !hate then 
		return 
	end

	camera.alertCooldown = camera.alertCooldown or {}

	local class = npc:GetClass()

	if (camera.alertCooldown[class] or 0) < CurTime() then
		camera.alertCooldown[class] = CurTime() + 30

		local letter = dispatch.AddWaypoint(npc:GetPos(), codetext, waypointType, 30)
		
		Schema:AddCombineDisplayMessage(string.format(text, letter), color)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

if SERVER then
	hook.Add("OnEntityCreated", "dispatch.cam_manager", function(entity)
		if !IsValid(entity) then return end
		
		if entity:IsNPC() and entity:GetClass() == "npc_combine_camera" then
			entity:SetKeyValue("ignoreunseenenemies", "1")
			entity:SetKeyValue("spawnflags", bit.bor(2, 32))
			entity:SetKeyValue("OnFoundPlayer", "cam_manager,Scan")
			entity:SetKeyValue("OnFoundEnemy", "cam_manager,ScanNPC")
			entity:SetKeyValue("OnDeath", "cam_manager,Death")
		end
	end)

	hook.Add("InitPostEntity", "dispatch.cam_manager", function()
		local manager = ents.Create("ix_cam_manager") manager:Spawn()
	end)
end