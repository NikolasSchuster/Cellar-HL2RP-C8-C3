local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawnedProp(client, model, entity)
	model = tostring(model):lower()
	local data = ix.bed.stored[model:lower()]

	if data then
		local bed = ents.Create("ix_bed")
		bed:SetPos(entity:GetPos())
		bed:SetAngles(entity:GetAngles())
		bed:SetModel(model)
		bed:Spawn()

		entity:Remove()
	end
end

function PLUGIN:HealTick(client, rate)
	local character = client:GetCharacter()

	local HP = (75 * rate * 5 / 3600)

	character.healingHP = character.healingHP or 0
	character.healingHP = character.healingHP + HP

	if character.healingHP >= 1 then
		local roundedHP = math.Truncate(character.healingHP)

		character:HealLimbs(roundedHP)
		character:SetBlood(math.min(character:GetBlood() + 25, 5000))

		if character:IsBleeding() then
			if math.random(0, 100) < 26 then
				character:SetBleeding(false)
			end
		end

		if character:IsFeelPain() then
			if math.random(0, 100) < 26 then
				character:SetFeelPain(false)
			end
		end

		client:SetHealth(ix.plugin.list["!damagesystem"]:GetMinimalHealth(character))

		character.healingHP = math.Round(character.healingHP - roundedHP, 5)
	end
end

function PLUGIN:SetupHealTimer(client, entity, rate)
	local uniqueID = "ixHeal" .. client:SteamID64()
	timer.Remove(uniqueID)

	if client:InCriticalState() then
		return
	end

	if IsValid(entity) then
		local data = ix.bed.stored[entity:GetModel():lower()]
		if data then
			rate = data.rate or 0.25
		end
	else
		return
	end

	if rate then
		client.healRate = rate

		timer.Create(uniqueID, 5, 0, function()
			if !IsValid(client) or !IsValid(entity) then
				timer.Remove(uniqueID)
				return
			end

			if !client:GetNetVar("forcedSequence") then
				return
			end

			self:HealTick(client, rate)
		end)
	end
end

function PLUGIN:RemoveHealTimer(client)
	local uniqueID = "ixHeal" .. client:SteamID64()

	if timer.Exists(uniqueID) then
		timer.Remove(uniqueID)
	end
end

function PLUGIN:PostPlayerLoadout(client)
	self:RemoveHealTimer(client)
end

local function CalculateResting(rate, startTime)
	local ticks = ((os.time() - startTime) / 5)
	local HP = ((75 * rate * 5 / 3600) * ticks)
	local bleeding, pain = false, false

	if math.random(0, HP) < (HP * 0.26) then
		bleeding = true
	end

	if math.random(0, HP) < (HP * 0.26) then
		pain = true
	end

	return HP, bleeding, pain
end

function PLUGIN:CharacterLoaded(character)
	local resting = character:GetData("resting")

	if resting then
		local data = util.JSONToTable(resting)

		local hp, bleeding, pain = CalculateResting(tonumber(data[1]), tonumber(data[2]))

		character:HealLimbs(hp)
		character:SetBlood(math.min(character:GetBlood() + (25 * hp), 5000))

		if character:IsBleeding() and bleeding then
			character:SetBleeding(false)
		end

		if character:IsFeelPain() and pain then
			character:SetFeelPain(false)
		end

		character:GetPlayer():SetHealth(ix.plugin.list["!damagesystem"]:GetMinimalHealth(character))

		character:SetData("resting", nil)
	end
end

function PLUGIN:CharacterPreSave(character)
	local client = character:GetPlayer()
	local uniqueID = "ixHeal" .. client:SteamID64()

	if timer.Exists(uniqueID) then
		local data = {
			client.healRate,
			os.time()
		}

		character:SetData("resting", util.TableToJSON(data))
	else
		character:SetData("resting", nil)
	end
end

function PLUGIN:SaveData()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_bed")) do
		data[#data + 1] = {
			v:GetPos(),
			v:GetAngles(),
			v:GetModel()
		}
	end

	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData()

	if data then
		for _, v in ipairs(data) do
			local data2 = ix.bed.stored[v[3]:lower()]

			if data2 then
				local entity = ents.Create("ix_bed")
				entity:SetPos(v[1])
				entity:SetAngles(v[2])
				entity:Spawn()
				entity:SetModel(v[3])
				entity:SetSolid(SOLID_VPHYSICS)
				entity:PhysicsInit(SOLID_VPHYSICS)

				local physObject = entity:GetPhysicsObject()

				if IsValid(physObject) then
					physObject:EnableMotion(false)
				end
			end
		end
	end
end