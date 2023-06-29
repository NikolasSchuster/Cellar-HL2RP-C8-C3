
net.Receive("ixUpdateBagLimitNotification", function()
	local variant = net.ReadUInt(2)
	local message

	if (variant != 0) then
		local maxCount = variant == 2 and ix.config.Get("inventoryMaxSmallStorages", 2) or ix.config.Get("inventoryMaxStorages", 1)
		message = variant == 2 and L("invMaxSmallStorages", maxCount) or L("invMaxStorages", maxCount)
	else
		message = L("noDifferentStorages")
	end

	timer.Simple(0, function()
		if (ix.option.Get("chatNotices", false)) then
			for _, v in pairs(ix.gui.chat.tabs:GetTabs()) do
				if (!v:GetFilter()["notice"]) then
					v.entries[#v.entries]:Remove()
					v.entries[#v.entries] = nil

					ix.util.Notify(message)
				end
			end
		else
			local lastNotice = ix.gui.notices.notices[1]

			if (lastNotice) then
				lastNotice:SetText(message)
				lastNotice:SizeToContents()
			end
		end
	end)
end)
