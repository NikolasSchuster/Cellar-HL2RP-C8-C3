ITEM.base = "base_useable"
ITEM.name = "Base Medical"
ITEM.description = "An item you can use multiple times."
ITEM.model = Model("models/props_junk/popcan01a.mdl")
ITEM.category = "categoryMedical"
ITEM.width = 1
ITEM.height = 1
ITEM.dIsInject = false
ITEM.dUseTime = 2
ITEM.dUses = 1
ITEM.junk = nil
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"}

local function DoAction(self, time, condition, callback)
	local uniqueID = "ixStare" .. self:UniqueID()

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
	local mod = 1 + character:GetSkillModified("medicine") * 0.1 or 1
	--local mod = (1.22 * self:GetData("rare"))
	--if mod <= 0 then mod = 1 end;	

	if client.bUsingMedical then
		return false
	end

	if self.OnConsume then
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
				if self.useSound then
					if istable(self.useSound) then
						client:EmitSound(self.useSound[math.random(1, #self.useSound)])
					else
						client:EmitSound(self.useSound)
					end
				end

				local healData = self:OnConsume(client, injector, mod, character)

				client:GetCharacter():DoAction("healing", healData)

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

					if isstring(self.junk) then
						if isWorld then
							ix.item.Spawn(self.junk, pos, nil, ang, data)
						else
							local junkItem = character:GetInventory():Add(self.junk, nil, data)

							if !junkItem then
								junkItem = ix.item.Spawn(self.junk, client, nil, nil, data)
							end
						end
					end
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

function ITEM:OnRegistered()
	self.functions.Use.name = "Использовать"
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
					if item.useSound then
						if istable(item.useSound) then
							client:EmitSound(item.useSound[math.random(1, #item.useSound)])
						else
							client:EmitSound(item.useSound)
						end
					end

					if item.OnConsume then
						local injectorChar = client:GetCharacter()
						local mod = 1 + injectorChar:GetSkillModified("medicine") * 0.1 or 1
						local healData = item:OnConsume(target, client, mod, target:GetCharacter())

						injectorChar:DoAction("healingTarget", healData)
					end

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

						if isstring(item.junk) then
							if isWorld then
								ix.item.Spawn(item.junk, pos, nil, ang, data)
							else
								local junkItem = character:GetInventory():Add(item.junk, nil, data)

								if !junkItem then
									junkItem = ix.item.Spawn(item.junk, client, nil, nil, data)
								end
							end
						end
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
		return !IsValid(item.entity) and !item.player.bUsingMedical
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	local client = inventory.GetOwner and inventory:GetOwner() or nil

	if IsValid(client) and client:GetCharacter() then
		return !client.bUsingMedical
	end
end
