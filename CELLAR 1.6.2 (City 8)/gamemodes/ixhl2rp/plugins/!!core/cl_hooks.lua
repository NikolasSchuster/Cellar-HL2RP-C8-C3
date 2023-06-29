
function ix.hud.PopulatePlayerTooltip(tooltip, client)
	local currentPing = client:Ping()

	local ping = tooltip:AddRow("ping")
	ping:SetText(L("ping", currentPing))
	ping.Paint = function(_, width, height)
		surface.SetDrawColor(ColorAlpha(derma.GetColor(
			currentPing < 110 and "Success" or (currentPing < 165 and "Warning" or "Error")
		, tooltip), 22))
		surface.DrawRect(0, 0, width, height)
	end
	ping:SizeToContents()

	hook.Run("PopulatePlayerTooltip", client, tooltip)
end