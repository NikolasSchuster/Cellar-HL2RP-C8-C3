--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

category.name = "Watchlist";
category.material = "serverguard/menuicons/icon_watchlist.png";
category.permissions = "Manage Watchlist";

function category:Create(base)
	serverguard.netstream.Start("WatchlistGet");

	category.panel = base:Add("tiger.panel");
	category.panel:SetTitle("Watchlist");
	category.panel:DockPadding(24, 24, 24, 48);
	category.panel:Dock(FILL);

	category.panel.statusLabel = category.panel:Add("DLabel");
	category.panel.statusLabel:SetFont("tiger.button");
	category.panel.statusLabel:SetText("");
	category.panel.statusLabel:SetSkin("serverguard");

	category.panel.list = category.panel:Add("tiger.list");
	category.panel.list:Dock(FILL);
	category.panel.list:AddColumn("STEAMID", 150);
	category.panel.list:AddColumn("NOTE", 150);
	category.panel.list:AddColumn("STATUS", 150);
	category.panel.list.sortType = SORT_DESCENDING;

	category.panel.refreshButton = category.panel:Add("tiger.button");
	category.panel.refreshButton:SetText("Refresh");
	category.panel.refreshButton:SizeToContents();

	category.panel.addButton = category.panel:Add("tiger.button");
	category.panel.addButton:SetText("Add player");
	category.panel.addButton:SizeToContents();

	function category.panel.refreshButton:DoClick()
		category.panel.list:Clear();
		serverguard.netstream.Start("WatchlistGet");
	end;

	function category.panel.addButton:DoClick()
		local panel = vgui.Create("tiger.panel");
		panel:SetTitle("Watch a player");
		panel:SetSize(500, 200);
		panel:Center();
		panel:MakePopup();
		panel:DockPadding(24, 24, 24, 48);

		local steamIDEntry = panel:Add("tiger.textentry");
		steamIDEntry:SetLabelText("Steam ID");
		steamIDEntry:Dock(TOP);

		local noteEntry = panel:Add("tiger.textentry");
		noteEntry:SetLabelText("Note");
		noteEntry:Dock(TOP);

		local completeButton = panel:Add("tiger.button");
		completeButton:SetText("Complete");
		completeButton:SizeToContents();

		function completeButton:DoClick()
			serverguard.netstream.Start("WatchlistAdd", {steam_id = steamIDEntry:GetText(), note = noteEntry:GetText()});
			panel:Remove();
		end;

		local cancelButton = panel:Add("tiger.button");
		cancelButton:SetText("Cancel");
		cancelButton:SizeToContents();

		function cancelButton:DoClick()
			panel:Remove();
		end;

		function panel:PerformLayout(w, h)
			completeButton:SetPos(w - (completeButton:GetWide() + 24), h - (completeButton:GetTall() + 14));			
			cancelButton:SetPos(0, h - (cancelButton:GetTall() + 14));
			cancelButton:MoveLeftOf(completeButton, 14);
		end;
	end;

	function category.panel:PerformLayout(width, height)
		category.panel.refreshButton:SetPos(width - (category.panel.refreshButton:GetWide() + 24), height - (category.panel.refreshButton:GetTall() + 14));
		category.panel.statusLabel:SetPos(25, height - (category.panel.statusLabel:GetTall() + 18));
		category.panel.addButton:SetPos(width - (category.panel.addButton:GetWide() + 100), height - (category.panel.addButton:GetTall() + 14));
	end;
end;

plugin:AddSubCategory("Lists", category);

local function PlayerIsOnline(stid)
	local ply, online = nil, "Offline"

	for _, ply in pairs(player.GetAll()) do
		if (ply:SteamID() == stid) then
			ply, online = ply, "Online"
		end
	end
	
	return {ply, online}
end

serverguard.netstream.Hook("WatchlistGet", function(data)
	if (IsValid(category.panel)) then
		category.panel.list:Clear();

		category.panel.statusLabel:SetText("Total troublemakers: "..tostring(#data));
		category.panel.statusLabel:SizeToContents();

		for k, v in pairs(data) do
			local playeronline = PlayerIsOnline(v.steam_id)
			local item = category.panel.list:AddItem(v.steam_id, v.note, playeronline[2]);

			function item:OnMousePressed()
				local menu, option = DermaMenu(), nil;
					menu:SetSkin("serverguard");

					option = menu:AddOption("Delete", function() 
						util.CreateDialog("Notice", "Are you sure you want to delete this record?",
							function()
								serverguard.netstream.Start("WatchlistRemove", v.steam_id);
							end, "&Yes",
							function()
							end, "No"
						);
					end);
					option:SetImage("icon16/delete.png");

					option = menu:AddOption("Edit", function() 
						local banLength = nil
						local baseb = vgui.Create("tiger.panel");
						baseb:SetTitle(string.format("Edit Note", name));
						baseb:SetSize(500, 152);
						baseb:Center();
						baseb:MakePopup();
						baseb:DockPadding(24, 24, 24, 48);

						local form = baseb:Add("tiger.list");
						form:Dock(FILL);

						local noteEntry = vgui.Create("tiger.textentry");
							noteEntry:SetLabelText("Note");
							noteEntry:SetText(v.note);
							noteEntry:Dock(TOP);
						form:AddPanel(noteEntry);

						local completeButton = baseb:Add("tiger.button");
						completeButton:SetPos(4, 4);
						completeButton:SetText("Complete");
						completeButton:SizeToContents();

						function completeButton:DoClick()
							if (string.Trim(noteEntry:GetValue()) == "") then 
								serverguard.netstream.Start("WatchlistRemove", v.steam_id);
								baseb:Remove();
								return;
							end;
									
							serverguard.netstream.Start("WatchlistEdit", {steam_id = v.steam_id, note = noteEntry:GetText()});
									
							baseb:Remove();
						end;

						local cancelButton = baseb:Add("tiger.button");
						cancelButton:SetPos(4, 4);
						cancelButton:SetText("Cancel");
						cancelButton:SizeToContents();
								
						function cancelButton:DoClick()
							baseb:Remove();
						end;
								
						function baseb:PerformLayout(w, h)
							completeButton:SetPos(w - (completeButton:GetWide() + 24), h - (completeButton:GetTall() + 14));
								
							cancelButton:SetPos(0, h - (cancelButton:GetTall() + 14));
							cancelButton:MoveLeftOf(completeButton, 14);
						end;
					end);

				menu:Open();
			end;
		end;
	end
end);