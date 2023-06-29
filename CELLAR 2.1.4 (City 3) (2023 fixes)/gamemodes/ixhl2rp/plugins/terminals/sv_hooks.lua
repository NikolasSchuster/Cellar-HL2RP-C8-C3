local PLUGIN = PLUGIN

util.AddNetworkString("ixTerminalResponse")
util.AddNetworkString("ixTerminalRetrieveInfo")
util.AddNetworkString("ixTerminalRequest")

net.Receive("ixTerminalRetrieveInfo", function(len, player)
	if !player:Alive() then return end

	local terminal
	for k, v in pairs(ents.FindInSphere(player:GetPos(), 80)) do
		if v:GetClass() == "ix_loyalist_terminal" then
			terminal = v
			break
		end
	end

	if !IsValid(terminal) then 
		return
	end

	local dID, datafile, genericdata = ix.plugin.list["datafile"]:ReturnDatafileByID(player.ixDatafile)

	if genericdata and datafile then
		local notes, civics, meds = 0, 0, 0

		for k, v in pairs(datafile) do
			if v.category == "union" then
				notes = notes + 1
			elseif v.category == "civil" then
				civics = civics + 1
			elseif v.category == "med" then
				meds = meds + 1
			end
		end

		net.Start("ixTerminalResponse")
			net.WriteUInt(notes, 10)
			net.WriteUInt(civics, 10)
			net.WriteUInt(meds, 10)
			net.WriteString(genericdata.aparts or "N/A")
			net.WriteString(genericdata.status or "N/A")
		net.Send(player)
	end
end)

net.Receive("ixTerminalRequest", function(len, player)
	if !player:Alive() then return end

	local terminal
	for k, v in pairs(ents.FindInSphere(player:GetPos(), 80)) do
		if v:GetClass() == "ix_loyalist_terminal" then
			terminal = v
			break
		end
	end

	if !IsValid(terminal) then 
		return 
	end
	
	if CurTime() < (player.nextTerminalRequest or 0) then return; end

	local b = player:GetCharacter():GetIDCard()
	Schema:AddCombineDisplayMessage(Format("NOTICE: %s (#%s) is requesting officer at information terminal.", player:Name(), b:GetData("cid", 0)), Color(255, 180, 0));

	local waypoint = {
		pos = terminal:GetPos() + terminal:GetUp() * 20 + terminal:GetForward() * 10,
		text = string.format("Вызов [%s #%s]", player:Name(), b:GetData("cid", 0)),
		color = Color(255, 180, 0),
		addedBy = player,
		time = CurTime() + 300
    }

	ix.plugin.list["waypoints"]:AddWaypoint(waypoint)

	player.nextTerminalRequest = CurTime() + 299
end)

function PLUGIN:LoadData()
    self:LoadLoyalistTerminals()
end

function PLUGIN:SaveData()
	self:SaveLoyalistTerminals()
end

function PLUGIN:LoadLoyalistTerminals()
	local data = self:GetData()

	if data then
		for _, v in ipairs(data) do
			local entity = ents.Create("ix_loyalist_terminal")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()

			local physObject = entity:GetPhysicsObject()

			if IsValid(physObject) then
				physObject:EnableMotion(false)
			end
		end
	end
end

function PLUGIN:SaveLoyalistTerminals()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_loyalist_terminal")) do
		data[#data + 1] = {
			v:GetPos(),
			v:GetAngles()
		}
	end

	self:SetData(data)
end
