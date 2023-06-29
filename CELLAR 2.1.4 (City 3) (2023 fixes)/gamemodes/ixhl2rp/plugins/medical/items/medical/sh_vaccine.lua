ITEM.name = "Шприц с вакциной \"AZV-01\""
ITEM.description = "Аккуратный пластиковый шприц с инъектором, внутри которого находится прозрачная жидкость без вкуса, запаха и какого-либо цвета. Принявший подобную вакцину отделается лишь небольшими головными болями на протяжении недели и диареей, но она явно сможет защитить вакцинированного от непредвиденных последствий. Судя по этикетке, эту вакцину следует принять до 31 декабря 2021 года, в противном случае вакцина испортится и более не будет предоставлять защиту при вакцинировании."
ITEM.model = Model("models/items/morphine.mdl")
ITEM.useSound = "items/medshot4.wav"
ITEM.category = "Уникальное"
ITEM.cost = 0
ITEM.dUses = 1
ITEM.dIsInject = true
ITEM.rarity = 4
ITEM.dUseTime = 10

if CLIENT then
	local greenClr = Color(50, 200, 50)
	local redClr = Color(200, 50, 50)

	function ITEM:PopulateTooltip(tooltip)
		local uses = tooltip:AddRowAfter("rarity", "uses")
		uses:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		uses:SetText(L("usesDesc", self:GetData("uses", self.dUses), self.dUses))

		local medical = LocalPlayer():GetCharacter():GetSkill("medicine") or 0

		local skill = tooltip:AddRowAfter("uses")
		skill:SetBackgroundColor(medical >= 2 and greenClr or redClr)
		skill:SetText("Необходим навык медицины 2")
	end
end

function ITEM:OnCanUse(client)
	if client:GetCharacter():GetSkill("medicine") >= 2 then
		return true
	end
	
	return false
end

local date = os.date("*t")
date.hour = 20
date.min = 0
date.sec = 0
date.day = 31
date.month = 7
local vaccineTime = os.time(date)

function ITEM:OnConsume(player, injector, mul, character)
	if os.time() <= vaccineTime then
		character:SetData("hasVaccine", true)
	end
end

local function DoAction(self, time, condition, callback)
	local uniqueID = "ixStare"..self:UniqueID()

	timer.Create(uniqueID, 0.1, time / 0.1, function()
		if (IsValid(self)) then
			if (condition and !condition()) then
				timer.Remove(uniqueID)

				if (callback) then
					callback(false)
				end
			elseif (callback and timer.RepsLeft(uniqueID) == 0) then
				callback(true)
			end
		else
			timer.Remove(uniqueID)

			if (callback) then
				callback(false)
			end
		end
	end)
end

function ITEM:OnUse(client, injector)
	local character = client:GetCharacter()
	local mod = 1
	--local mod = (1.22 * self:GetData("rare"))
	--if mod <= 0 then mod = 1 end;	

	if client.bUsingMedical then
		return false
	end

	if self.OnConsume then
		local hands = client:GetWeapon("ix_hands")
		client.bUsingMedical = true
		client:SetAction("@medInject", self.dUseTime or 10)
		DoAction(client, self.dUseTime or 10, function()
			if client:KeyDown(IN_RELOAD) then
				return false
			end
			if client:Alive() and !IsValid(client.ixRagdoll) and client:GetCharacter() == character and !client:IsUnconscious() then
				return true
			end
		end, function(success)
			if success then
				client:EmitSound(self.useSound)

				self:OnConsume(client, injector, mod, character)

				local uses = self:GetData("uses", self.dUses)
				if uses == 1 then
					local isWorld = false
					local pos, ang
					local data = {
						S = self:GetSkin(),
						M = self:GetModel()
					}

					if isfunction(self.OnJunkCreated) then
						data = self:OnJunkCreated() or data
					end

					if IsValid(self.entity) then
						isWorld = true
						pos, ang = self.entity:GetPos(), self.entity:GetAngles()
					end
					
					self:Remove()
				else
					self:SetData("uses", self:GetData("uses", self.dUses) - 1)
				end
			else
				client:SetAction()
			end

			client.bUsingMedical = false
		end)
	end

	return false
end

ITEM.functions.Inject = {
	name = "#injectuse",
	OnRun = function(item)
		local client = item.player

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local targetEnt = util.TraceLine(data).Entity
		local target = targetEnt

		if IsValid(target.ixPlayer) then
			target = target.ixPlayer
		end

		if IsValid(target) and target:IsPlayer() and target:GetCharacter() and !client.bUsingMedical then
			client.bUsingMedical = true
			client:SetAction("@medInject", item.dUseTime)
			DoAction(client, item.dUseTime or 10, function()
				if client:KeyDown(IN_RELOAD) then
					return false
				end

				if client:GetEyeTrace().Entity != targetEnt then
					return false
				end

				if !target:Alive() then
					return false
				end

				return true
			end, function(success)
				if success then
					client:EmitSound(item.useSound)

					item:OnConsume(target, client, 1, target:GetCharacter())

					local uses = item:GetData("uses", item.dUses)
					if uses == 1 then
						local isWorld = false
						local pos, ang
						local data = {
							S = item:GetSkin(),
							M = item:GetModel()
						}

						if isfunction(item.OnJunkCreated) then
							data = item:OnJunkCreated() or data
						end

						if IsValid(item.entity) then
							isWorld = true
							pos, ang = item.entity:GetPos(), item.entity:GetAngles()
						end
						
						item:Remove()
					else
						item:SetData("uses", item:GetData("uses", item.dUses) - 1)
					end
				else
					client:SetAction()
				end

				client.bUsingMedical = false
			end)
		else
			client:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and !item.player.bUsingMedical and item:OnCanUse(item.player)
	end
}