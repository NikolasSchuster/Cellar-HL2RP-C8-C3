DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.PrintName = "Base NPC"
ENT.Author = ""
ENT.Contact = ""
ENT.Category	= "HL2 RP"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Editable = true
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "TeamColor", {KeyName = "faction", Edit = {type = "VectorColor", order = 1}})
	self:NetworkVar("String", 0, "NPCName", {KeyName = "npcname", Edit = {type = "Generic", order = 2}})
	self:NetworkVar("String", 1, "PhysDesc", {KeyName = "physdesc", Edit = {type = "Generic", order = 3}})
	self:NetworkVar("String", 2, "Dialogue", {KeyName = "dialogue", Edit = {type = "Generic", order = 4}})
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/Humans/Group03/male_03.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))
		self:ResetSequence(self:LookupSequence("idle_angry"))
		self:SetUseType(SIMPLE_USE)
		self:SetBloodColor(BLOOD_COLOR_RED)
	else
		self:SetIK(false)
	end
end

if CLIENT then
	ENT.PopulateEntityInfo = true

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:GetName()
		return self:GetNPCName() or ""
	end

	function ENT:OnPopulateEntityInfo(container)
		local color = self:GetTeamColor():ToColor()
		container:SetArrowColor(color)

		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetName())
		name:SetBackgroundColor(color)
		name:SizeToContents()

		local speak = container:AddRow("helpText")
		speak:SetText(L("pressSpeak"))
		speak:SizeToContents()

		local descriptionText = self:GetPhysDesc()
		descriptionText = descriptionText:len() > 128 and string.format("%s...", descriptionText:sub(1, 125)) or descriptionText

		if descriptionText != "" then
			local description = container:AddRow("description")
			description:SetText(descriptionText)
			description:SizeToContents()
		end
	end
else
	function ENT:Think()
		self:NextThink(CurTime())
		return true
	end

	function ENT:Setup(name, desc, factionColor, dialogID, model, anim, bodygroups)
		self:SetModel(model or "models/Humans/Group03/male_03.mdl")
		self:SetTeamColor(factionColor or Vector())
		self:SetNPCName(name or "Unknown")
		self:SetPhysDesc(desc)
		self:SetDialogue(dialogID)
		
		timer.Simple(0.2, function()
			if IsValid(self) then
				if anim then 
					self.anim = anim
					self:ResetSequence(self:LookupSequence(anim))
				end

				self.bgs = bodygroups
				for i = 0, 9 do
					local number = string.sub(bodygroups or "", i, i)

					if number and number != "" then
						self:SetBodygroup(i, tonumber(number) or 0)
					end
				end
			end
		end)
	end

	function ENT:OnChangedAnim(anim)
		self.anim = anim

		self:ResetSequence(self:LookupSequence(anim))
	end

	function ENT:OnChangedBodyGroups(bgs)
		self.bgs = bgs

		for i = 0, 9 do
			local number = string.sub(bgs, i, i)

			if number and number != "" then
				self:SetBodygroup(i, tonumber(number))
			end
		end
	end

	function ENT:Use(activator)	
		if activator:GetPos():Distance(self:GetPos()) < 82 then
			activator:OpenDialogue(self, self:GetDialogue())
		end
	end
end

properties.Add("ixnpc_data1", {
	MenuLabel = "Set NPC Model",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_basenpc") then return false end
		if (!gamemode.Call("CanProperty", client, "ixnpc_data1", entity)) then return false end

		return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Model", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:SetModel(text)
	end
})

properties.Add("ixnpc_data2", {
	MenuLabel = "Set NPC Anim",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_basenpc") then return false end
		if (!gamemode.Call("CanProperty", client, "ixnpc_data2", entity)) then return false end

		return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Animation", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:OnChangedAnim(text)
	end
})

properties.Add("ixnpc_data3", {
	MenuLabel = "Set NPC Bodygroups",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_basenpc") then return false end
		if (!gamemode.Call("CanProperty", client, "ixnpc_data3", entity)) then return false end

		return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Bodygroups 00000", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:OnChangedBodyGroups(text)
	end
})