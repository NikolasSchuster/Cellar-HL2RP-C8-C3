util.AddNetworkString("ixEmote")

do
	local meta = FindMetaTable("Player")

	function meta:Emote(chatType, emoteType, ...)
		local args = {...}
		chatType = string.lower(chatType)

		local class = ix.chat.classes[chatType]

		if class and class:CanSay(self, text) != false then
			local receivers

			if class.CanHear and !receivers then
				receivers = {}

				for _, v in ipairs(player.GetAll()) do
					if v:GetCharacter() and class:CanHear(self, v) != false then
						receivers[#receivers + 1] = v
					end
				end

				if #receivers == 0 then
					return
				end
			end

			net.Start("ixEmote")
				net.WriteEntity(self)
				net.WriteString(chatType)
				net.WriteString(emoteType)
				net.WriteTable(args)
			net.Send(receivers or {})
		end
	end
end