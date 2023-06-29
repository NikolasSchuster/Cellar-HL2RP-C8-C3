local PLUGIN = PLUGIN

local function UpdateKassets(arguments)

	local items = PLUGIN:GetData()

	for k,v in pairs(items)do
		
		local ITEM = ix.item.Register(k, "base_kasseta", false, nil, true)

		ITEM.name = v.name
		ITEM.path = v.path
		ITEM.duration = v.duration
		ITEM.description = v.desc

	end
	
	netstream.Start(nil,"aw::registerkassetas",items)

end

function PLUGIN:RegisterKasseta(client, uniqueID, name, path, desc,duration)

	if !client:IsAdmin() then return "Вы не админ!" end

	if file.Read(path,"GAME") then

		local perviousdata = self:GetData()

		perviousdata[uniqueID] = {
			uniqueID = uniqueID,
			name = name,
			path = path,
			desc = desc,
			duration = duration
		}

		self:SetData(perviousdata)

		UpdateKassets()

		return "Кассета "..name.." успешно создана."

	end

	client:PrintMessage(HUD_PRINTCONSOLE,"Указывать путь необходимо от исходный папки garrysmod\nПример:\n	sound/music/HL2_song23_SuitSong3.mp3")

	return "Указан невалидный путь! Проверьте консоль."

end

function PLUGIN:GetKassetas(client)

	if !client:IsAdmin() then return end

	for k,v in pairs(self:GetData())do

		client:PrintMessage(HUD_PRINTCONSOLE,k.." = "..util.TableToJSON(v,true))

	end

	return "Проверьте консоль."
	
end

-- function PLUGIN:InitializedPlugins()

-- 	local items = self:GetData()

-- 	for k,v in pairs(items)do
		
-- 		local ITEM = ix.item.Register(k, "base_kasseta", false, nil, true)

-- 		ITEM.name = v.name
-- 		ITEM.path = v.path
-- 		ITEM.duration = v.duration
-- 		ITEM.description = v.desc

-- 	end
	
-- 	netstream.Start(nil,"aw::registerkassetas",items)

-- end

function PLUGIN:EjectKasseta(radio)

	local kasseta = radio:GetData("kassetainside")

	if kasseta then

		self:TurnRadio(radio,false)

		radio:SetData("kassetainside",nil)

		local client = radio.player

		if radio.entity then

			ix.item.Spawn(kasseta,radio.entity:GetPos()+Vector(12,0,0))

			goto notify

		end

		client:GetCharacter():GetInventory():Add(kasseta)

		::notify::

		self:TurnRadio(radio,false)

		self:ReverseRadio(IsEntity(radio) and radio or radio.entity)

		client:Notify("Вы успешно вытащили кассету.")

	end

end

function PLUGIN:InsertKasseta(radio,id)

    if id then

		local client = radio.triedusedby

		if IsValid(client) then

			local kasseta = client:GetCharacter():GetInventory():GetItemByID(id)

			if kasseta and kasseta.IsKasseta then

				radio:SetData("kassetainside",kasseta.uniqueID)

				kasseta:Remove()

				client:Notify("Вы успешно вставили кассету.")

			end
		end

        return

    end

	local client = radio.player

	radio.triedusedby = client
	client.aw_choosedradio = radio

	netstream.Start(client,"ChooseKasseta")
	
end

function PLUGIN:ReverseRadio(ent)
	
	if self.CSounds[ent] then
		
		self.CSounds[ent][4] = 0

		self:Sync()

	end

end

function PLUGIN:TurnRadio(radio,enable)

	local isent = IsEntity(radio)

	local weapons = radio.GetOwner and IsValid(radio:GetOwner()) and radio:GetOwner().carryWeapons


	local ent = (isent and radio) or radio.entity or (weapons and weapons.radio)

	if IsValid(ent) then
		
		local tradio = !isent and radio or ent.ixItem or ent:GetItemTable()

		local kasseta = ix.item.list[tradio:GetData("kassetainside")]

		if !kasseta then 

			if enable then

				(isent and ent:GetOwner() or radio.player):Notify("В радио нет кассеты!")

			end

			return

		end

		netstream.Start(nil,"SetRadioState",ent:EntIndex(),enable)


		-- local sound = self.CSounds[ent]

		-- if sound then

		-- 	sound:Stop()

		-- 	self.CSounds[ent] = nil

		-- end

		-- sound = CreateSound(ent,kasseta:GetPath())

		-- self.CSounds[ent] = sound
		
		-- if enable then

		-- 	sound:Play()

		-- end

		self.CSounds[ent] = self.CSounds[ent] or {}

		self.CSounds[ent][1] = kasseta:GetDuration()

		self.CSounds[ent][2] = kasseta:GetPath()

		self.CSounds[ent][3] = enable

		-- self.CSounds[ent][6] = ejected

		self:Sync()

	end

end

netstream.Hook("ChooseKasseta",function(client,id)

	PLUGIN:InsertKasseta(client.aw_choosedradio,id)

	client.aw_choosedradio = nil

end)

function PLUGIN:Sync(client)
	
	netstream.Start(client,"aw::syncradio",self.CSounds)

end


-- hooks

local nextacts = {}
-- local validbuttons = {
-- 	[MOUSE_LEFT] = true,
-- 	[MOUSE_RIGHT] = true,
-- 	[KEY_R] = true,
-- }

-- function PLUGIN:PlayerButtonDown(client,button)

-- 	if !validbuttons[button] then return end

-- 	local weapon = client:GetActiveWeapon()

-- 	if !IsValid(weapon) or (IsValid(weapon) and weapon:GetClass() != "aw_radio") then return end

-- 	local now = CurTime()

-- 	if !nextacts[client] or now > nextacts[client] then

-- 		nextacts[client] = now + 1

-- 		local item = weapon.ixItem

-- 		if item and item.IsRadio then

-- 			item.player = client
			
-- 			if button == MOUSE_LEFT then
				
-- 				local enable = self.CSounds[weapon] and self.CSounds[weapon][3]

-- 				self:TurnRadio(weapon,!enable)

-- 			elseif button == MOUSE_RIGHT then
				
-- 				if item:GetData("kassetainside") then
					
-- 					self:EjectKasseta(item)

-- 					return

-- 				end

-- 				self:InsertKasseta(item)

-- 			elseif button == KEY_R then

-- 				self:ReverseRadio(weapon)

-- 			end

-- 		end

-- 		return

-- 	end

-- 	client:Notify("Подождите перед следующим действием!")

-- end

function PLUGIN:SWEPHandle(weapon,button)
	local client = weapon:GetOwner()

	-- if !IsValid(weapon) or (IsValid(weapon) and weapon:GetClass() != "aw_radio") then return end

	local now = CurTime()

	if !nextacts[client] or now > nextacts[client] then

		nextacts[client] = now + 1

		local item = weapon.ixItem

		if item and item.IsRadio then

			item.player = client
			
			if button == MOUSE_LEFT then
				
				local enable = self.CSounds[weapon] and self.CSounds[weapon][3]

				self:TurnRadio(weapon,!enable)

			elseif button == MOUSE_RIGHT then
				
				if item:GetData("kassetainside") then
					
					self:EjectKasseta(item)

					return

				end

				self:InsertKasseta(item)

			elseif button == KEY_R then

				self:ReverseRadio(weapon)

			end

		end

		return

	end

	client:Notify("Подождите перед следующим действием!")

end

function PLUGIN:PlayerSpawn(client)

	self:Sync(client)

	netstream.Start(client,"aw::registerkassetas",self:GetData())

end

local synctime = CurTime()

local csynctime = 1

function PLUGIN:Think()

	local now = CurTime()

	if now > synctime then

		local mustberemoved = {}

		for k,v in pairs(self.CSounds)do

			if !IsValid(k) then mustberemoved[k] = true continue end

			if self.CSounds[k][3] then

				self.CSounds[k][4] = (self.CSounds[k][4] or 0) + csynctime

				if self.CSounds[k][4] > self.CSounds[k][1] then

					self:TurnRadio(k,false)

					self.CSounds[k][3] = nil

					self.CSounds[k][4] = 0

				end

			end

		end

		for k,v in pairs(mustberemoved)do
			
			self.CSounds[k] = nil

		end

		synctime = now + csynctime

	end
	
end

function PLUGIN:EntityRemoved(ent)

	if ent.GetItemTable then

		-- local item = ent:GetItemTable()

		-- if item.IsRadio then

		-- 	local sound = self.CSounds[ent]

		-- 	if sound then

		-- 		sound:Stop()
				
		-- 		self.CSounds[ent] = nil

		-- 	end

		-- end

		if ent.GetItemTable and ent:GetItemTable().IsRadio then

			self:Sync()

		end

	end

end

timer.Simple(0,UpdateKassets)