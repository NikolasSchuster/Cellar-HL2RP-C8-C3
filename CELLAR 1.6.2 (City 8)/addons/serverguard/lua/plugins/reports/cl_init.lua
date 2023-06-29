--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("cl_panel.lua", SERVERGUARD.STATE.CLIENT);
plugin:IncludeFile("cl_settings.lua", SERVERGUARD.STATE.CLIENT);

serverguard.netstream.Hook("sgStartReport", function(data)
	local menu = vgui.Create("tiger.panel");
	menu:SetTitle("Write a report");
	menu:SetSize(580, 440);
	menu:Center();
	menu:MakePopup();
	menu:DockPadding(24, 24, 24, 48);
	
	local entry = menu:Add("DTextEntry");
	entry:SetMultiline(true);
	entry:Dock(FILL);
	entry:SetSkin("serverguard");
	
	local complete = menu:Add("tiger.button");
	complete:SetPos(4, 4);
	complete:SetText("Complete");
	complete:SizeToContents();
	
	function complete:DoClick()
		serverguard.SetMenuStay(false);
		
		local text = entry:GetValue();
		
		if (text != "") then				
			serverguard.netstream.Start("sgSendReport", text);
		end;
		
		menu:Remove();
	end;

	local cancel = menu:Add("tiger.button");
	cancel:SetPos(4, 4);
	cancel:SetText("Cancel");
	cancel:SizeToContents();
	
	function cancel:DoClick()
		serverguard.SetMenuStay(false);
		
		menu:Remove();
	end;
	
	function menu:PerformLayout()
		local w, h = self:GetSize();
	
		complete:SetPos(w - (complete:GetWide() + 24), h - (complete:GetTall() + 14));
		
		cancel:SetPos(0, h - (cancel:GetTall() + 14));
		cancel:MoveLeftOf(complete, 14);
	end;
end);