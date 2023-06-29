local GREETINGS = "GREETINGS"

local Dialog = {}
Dialog.__index = Dialog

Dialog.npc = false
Dialog.player = false
Dialog.activeTopic = false
Dialog.allTopics = {}
Dialog.availableTopics = {}
Dialog.removedTopics = {}
Dialog.data = {}
Dialog.classname = false

function Dialog:GetNPC()
	return self.npc
end

function Dialog:GetPlayer()
	return self.player
end

function Dialog:GetActiveTopic()
	return self.activeTopic
end

function Dialog:IsChallengeTopic(topicID)
	topicID = topicID or self:GetActiveTopic()
	
	local topicData = self:GetTopic(topicID)

	if topicData and (isnumber(topicData.flags)  and (bit.band(topicData.flags, DFLAG_CHALLENGE) != 0)) then
		return true, topicData.success, topicData.failure, topicData.challenge
	end
end

function Dialog:IsOnceTopic(topicID)
	topicID = topicID or self:GetActiveTopic()
	
	local topicData = self:GetTopic(topicID)

	if topicData and (isnumber(topicData.flags) and (bit.band(topicData.flags, DFLAG_ONCE) != 0)) then
		return true
	end
end

function Dialog:IsGoodbye(topicID)
	topicID = topicID or self:GetActiveTopic()
	
	local topicData = self:GetTopic(topicID)

	if topicData and (isnumber(topicData.flags) and (bit.band(topicData.flags, DFLAG_GOODBYE) != 0)) then
		return true
	end
end

function Dialog:IsDynamic(topicID)
	topicID = topicID or self:GetActiveTopic()
	
	local topicData = self:GetTopic(topicID)

	if topicData and (isnumber(topicData.flags) and (bit.band(topicData.flags, DFLAG_DYNAMIC) != 0)) then
		return true, topicData.choices
	end
end

function Dialog:RemoveTopic(topicID)
	topicID = topicID or self:GetActiveTopic()

	self.removedTopics[topicID] = true

	-- TODO: SAVE removed topics of character (that fired ONCE)

	local character = self:GetPlayer():GetCharacter()

	if SERVER and character then
		local knownTopics = character:GetKnownTopics()

		knownTopics[self.classname] = knownTopics[self.classname] or {}
		knownTopics[self.classname][topicID] = true

		character:SetKnownTopics(knownTopics)
	end
end

function Dialog:GetTopic(topicID)
	topicID = topicID or self:GetActiveTopic()

	if !self.allTopics[topicID] then
		return false
	end

	return self.allTopics[topicID]
end

function Dialog:ParseStrings(tbl)
	local gender = self:GetPlayer():GetCharacter():GetGender()
	local isFemale = (gender == GENDER_FEMALE or gender == GENDER_SHEMALE)

	for k, v in pairs(tbl) do
		if v.gender and (isFemale and v.gender == GENDER_MALE) then
			continue
		end

		if isfunction(v.condition) then
			local response = v.condition(self:GetPlayer(), self:GetNPC(), self)
			if response then
				return istable(response) and table.Random(response) or response
			end
		elseif v.text then
			return istable(v.text) and table.Random(v.text) or v.text
		end

		if istable(v) then
			return table.Random(v)
		elseif isstring(v) then
			return v
		end
	end

	return ""
end

function Dialog:GetLabel(tbl)
	if istable(tbl) then
		return self:ParseStrings(tbl)
	else
		return tbl
	end
end

function Dialog:GetTopics(topicID)
	topicID = topicID or self:GetActiveTopic()

	return #self:GetAvailableTopics(topicID) or 0
end

function Dialog:GetChoices(topicID)
	topicID = topicID or self:GetActiveTopic()

	if !self.allTopics[topicID] then
		return false
	end

	return self.allTopics[topicID].choices
end

function Dialog:SetActiveTopic(topicID)
	self.activeTopic = topicID
end

function Dialog:Exit()
	local user = self:GetPlayer()

	if !IsValid(user) then
		return false
	end

	if CLIENT then
		if IsValid(ix.gui.dialogue) then
			ix.gui.dialogue:Exit()
		end
	else
		user.Dialog = nil
	end
end

function Dialog:GetRumours()
	local rumours = {}
	for k, v in pairs(self.allTopics) do
		if !v.flags then continue end
		if self.removedTopics[k] then continue end

		if bit.band(v.flags, DFLAG_RUMOURS) != 0 then
			rumours[#rumours + 1] = k
		end
	end

	return rumours
end

function Dialog:SaveDialogData()
	if !self.classname then
		return
	end

	local character = self:GetPlayer():GetCharacter()

	if !character then
		return
	end

	local dlgData = character:GetDialogData() or {}
	dlgData[self.classname] = dlgData[self.classname] or {}
	
	for k, v in pairs(self.data) do
		dlgData[self.classname][k] = v
	end

	character:SetDialogData(dlgData)
end

function Dialog:OnSelectChoice(topicID, force)
	if CLIENT then
		net.Start("ixDialogSelectTopic")
			net.WriteString(topicID)
		net.SendToServer()
	end

	if self.inDynamicTopic then
		local jump = false
		local topicData = self:GetTopic()

		if isfunction(topicData.choose) then
			jump = topicData.choose(self.availableTopics[tonumber(topicID)] or topicID, self:GetPlayer(), self:GetNPC(), self)
		end

		if jump then
			self.inDynamicTopic = false

			self:SetActiveTopic(jump)

			self:OnSelectChoice(jump, true)
		end

		return
	end

	if SERVER then
		if !force and !self.availableTopics[topicID] then
			return
		end
	end

	local topicData = self:GetTopic(topicID)

	if topicData.data then
		for k, v in pairs(topicData.data) do
			self.data[k] = v
		end
	end

	local selectResult

	if topicData.select then
		selectResult = topicData.select(self:GetPlayer(), self:GetNPC(), self)
	end

	if SERVER then
		self:SaveDialogData()
	end

	if topicData.rumours then
		local rumours = self:GetRumours()
		if #rumours > 0 then
			local random = math.floor(util.SharedRandom(self:GetPlayer():EntIndex().."Rumours", 1, #rumours))

			topicID = rumours[random]
		end
	end

	if self:IsOnceTopic(topicID) then
		self:RemoveTopic(topicID)
	end

	if self:IsGoodbye(topicID) then
		self:Exit()
		return
	end

	local isChallenge, successTopic, failureTopic = self:IsChallengeTopic(topicID)
	if isChallenge then
		if SERVER then
			if topicData.challenge and topicData.challenge(self:GetPlayer(), self:GetNPC(), self) then
				topicID = successTopic
			else
				topicID = failureTopic
			end

			net.Start("ixDialogChallengeResult")
				net.WriteString(topicID)
			net.Send(self:GetPlayer())

			self:OnSelectChoice(topicID, true)
			return
		end

		return
	end

	local isDynamic, choiceFunc = self:IsDynamic(topicID)

	if !isDynamic then
		self:SetAvailableTopics()
	else
		if SERVER then
			self:SetDynamicTopics(isfunction(choiceFunc) and choiceFunc(self:GetPlayer(), self:GetNPC(), self) or {})
		end
	end

	if selectResult != false then
		self:OpenTopic(topicID, isDynamic)
	end
end

function Dialog:GetAvailableTopics(topicID)
	topicID = topicID or self:GetActiveTopic()

	local choices = self:GetChoices(topicID)
	
	if choices then
		local availableTopics = {}

		for i, topicID in pairs(choices) do
			local topicData = self:GetTopic(topicID)
			if !topicData then continue end

			if topicData.condition and !topicData.condition(self:GetPlayer(), self:GetNPC(), self) then 
				continue 
			end

			if self.removedTopics[topicID] then 
				continue
			end

			availableTopics[topicID] = SERVER and true or {priority = (topicData.priority or i), label = self:GetLabel(topicData.topic)}
		end

		return availableTopics
	end
end

function Dialog:SetDynamicTopics(topics)
	self.availableTopics = {}

	for k, v in pairs(topics) do
		self.availableTopics[k] = v
		self.availableTopics[k].priority = k
		self.availableTopics[k].label = self:GetLabel(v.label)
	end

	if SERVER then
		net.Start("ixDialogGetTopics")
			net.WriteTable(topics)
		net.Send(self:GetPlayer())
	end

	return true
end

function Dialog:SetAvailableTopics(topicID)
	topicID = topicID or self:GetActiveTopic()

	local availableTopics = self:GetAvailableTopics(topicID)

	if availableTopics then
		self.availableTopics = availableTopics

		return true
	end
end

function Dialog:Open(client, npc, topics, class)
	if !IsValid(client) then
		return false
	end

	self.player = client
	self.npc = npc
	self.allTopics = {}
	self.availableTopics = {}
	self.classname = class

	for topicID, topicData in pairs(topics) do
		self.allTopics[topicID] = topicData
	end

	for topicID, topicData in pairs(ix.dialogues.stored["_Rumours"] or {}) do -- load rumours
		self.allTopics[topicID] = topicData
	end

	local character = client:GetCharacter()

	if character then
		self.removedTopics = (character:GetKnownTopics() or {})[class] or {}
		self.data = (character:GetDialogData() or {})[class] or {}
	end

	if CLIENT then
		net.Receive("ixDialogOpenTopic", function(len)
			local topicID = net.ReadString()
			local isDynamic = net.ReadBool()

			self:OpenTopic(topicID, isDynamic)
		end)

		net.Receive("ixDialogChallengeResult", function(len)
			local topicID = net.ReadString()

			self:OnSelectChoice(topicID)
		end)

		net.Receive("ixDialogGetTopics", function(len)
			local topics = net.ReadTable()

			self:SetDynamicTopics(topics)
			ix.gui.dialogue:BuildTopic(self:GetActiveTopic(), true)
		end)
	end
end

function Dialog:OpenTopic(topicID, isDynamic)
	topicID = topicID or GREETINGS

	if !IsValid(self:GetPlayer()) then
		return false
	end

	if topicID == GREETINGS then
		local topicData = self:GetTopic(topicID)
		if isfunction(topicData.greeting) then
			topicID = topicData.greeting(self:GetPlayer(), self:GetNPC(), self)
		end
	end

	if !self:GetActiveTopic() then
		self:SetActiveTopic(topicID)
	end

	if !isDynamic then
		if self:SetAvailableTopics(topicID) then 
			self:SetActiveTopic(topicID)
		end
	else
		self:SetActiveTopic(topicID)
	end

	self.inDynamicTopic = isDynamic

	if SERVER then
		net.Start("ixDialogOpenTopic")
			net.WriteString(topicID)
			net.WriteBool(isDynamic)
		net.Send(self:GetPlayer())
	else
		ix.gui.dialogue:BuildTopic(topicID)
	end
end

if SERVER then
	util.AddNetworkString("ixDialogOpen")
	util.AddNetworkString("ixDialogOpenTopic")
	util.AddNetworkString("ixDialogSelectTopic")
	util.AddNetworkString("ixDialogChallengeResult")
	util.AddNetworkString("ixDialogGetTopics")

	net.Receive("ixDialogSelectTopic", function(len, ply)
		local topicID = net.ReadString()

		if !ply.Dialog then 
			return 
		end

		ply.Dialog:OnSelectChoice(topicID)
	end)
else
	net.Receive("ixDialogOpen", function(len)
		local ply = LocalPlayer()
		local npc = net.ReadEntity()
		local classDialog = net.ReadString()
		local topics = ix.dialogues.stored[classDialog]

		if !IsValid(npc) then
			return
		end

		if ply.Dialog then 
			ply.Dialog = nil
		end

		if topics then
			ix.gui.dialogue = vgui.Create("dialog.Main")
			ix.gui.dialogue:MakePopup()

			local object = setmetatable({}, ix.meta.dialog)
			object:Open(ply, npc, topics, classDialog)

			ply.Dialog = object

			ix.gui.dialogue:OpenNPC(ply.Dialog, npc, npc:GetName(), npc.GetTeamColor and npc:GetTeamColor() or color_White)

			net.Start("ixDialogOpen")
			net.SendToServer()

			ix.gui.dialogue:Animate()
		end
	end)
end


ix.meta.dialog = Dialog
