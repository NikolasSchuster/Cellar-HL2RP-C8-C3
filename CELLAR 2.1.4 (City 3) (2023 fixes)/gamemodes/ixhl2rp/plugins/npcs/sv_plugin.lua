local PLUGIN = PLUGIN

do
	local meta = FindMetaTable("Player")

	function meta:OpenDialogue(npc, class)
		if !IsValid(npc) then
			return
		end

		local topics = ix.dialogues.stored[class]

		if self.Dialog then
			self.Dialog = nil
		end

		self.IsOpeningDialogue = true

		if topics then
			net.Start("ixDialogOpen")
				net.WriteEntity(npc)
				net.WriteString(class)
			net.Send(self)

			self.Dialog = setmetatable({}, ix.meta.dialog)
			self.Dialog:Open(self, npc, topics, class)
		end
	end

	net.Receive("ixDialogOpen", function(len, ply)
		local topicID = net.ReadString()

		if !ply.IsOpeningDialogue then 
			return 
		end

		ply.Dialog:OpenTopic("GREETINGS")

		ply.IsOpeningDialogue = false
	end)
end