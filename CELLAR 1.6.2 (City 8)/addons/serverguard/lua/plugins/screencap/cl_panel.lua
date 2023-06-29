--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;
local category = {};

g_ScreenCapData = {}

category.name = "Screen capture";
category.material = "serverguard/menuicons/icon_camera.png";
category.permissions = "Screencap";

local loadingTexture = Material("icon16/arrow_rotate_anticlockwise.png");

function category:Create(base)
	base.quality = 50;
	
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Screen capture");
	base.panel:Dock(FILL);
  
  	base.panel.qualitySlider = base.panel:Add("DNumSlider");
	base.panel.qualitySlider:Dock(TOP);
	base.panel.qualitySlider:DockMargin(4, 0, 0, 14);
	base.panel.qualitySlider:SetText("Picture Quality (Lower Quality = Faster Capture)");
	base.panel.qualitySlider:SetMinMax(10, 100);
	base.panel.qualitySlider:SetDecimals(0);
	base.panel.qualitySlider:SetValue(base.quality);
	base.panel.qualitySlider.Label:SizeToContentsX();
	base.panel.qualitySlider.Label:SetSkin("serverguard");
	base.panel.qualitySlider.TextArea:SetSkin("serverguard");

	function base.panel.qualitySlider:OnValueChanged(value)
		base.quality = math.ceil(value);
	end;
	
	base.panel.list = base.panel:Add("tiger.list");
	base.panel.list:Dock(FILL);

	base.panel.list:AddColumn("PLAYER", 320);
	base.panel.list:AddColumn("STEAMID", 200);
	base.panel.list:AddColumn("VIEW & CAPTURE", 100):SetDisabled(true);
	
	function base.panel.list:Think()
		local players = player.GetHumans();
		
		for i = 1, #players do
			local pPlayer = players[i];
			
			if (!IsValid(pPlayer.screenPanel)) then
				local panel = base.panel.list:AddItem(serverguard.player:GetName(pPlayer), pPlayer:SteamID());
				
				panel.player = pPlayer;
				panel.unique = pPlayer:UID();
				
				function panel:OnMousePressed(code)
				end;
				
				function panel:Think()
					if (!IsValid(self.player)) then
						g_ScreenCapData[self.unique] = nil;
						
						self:Remove();
						
						base.panel.list:GetCanvas():InvalidateLayout();
		
						timer.Simple(FrameTime() *2, function()
							base.panel.list:OnSort();
						end);
					end;
				end;
				
				local nameLabel = panel:GetLabel(1);
				
				nameLabel:SetUpdate(function(self)
					if (IsValid(pPlayer)) then
						if (self:GetText() != serverguard.player:GetName(pPlayer)) then
							self:SetText(serverguard.player:GetName(pPlayer));
						end;
					end;
				end);
				
				local lastBase = vgui.Create("Panel");
				lastBase.rotate = 0;
				lastBase.progress = 0;
				lastBase.SizeToColumn = true;
				
				lastBase.capture = lastBase:Add("DImageButton");
				lastBase.capture:SetSize(16, 16);
				lastBase.capture:SetImage("icon16/film_add.png");
				lastBase.capture:SetToolTipSG("Capture Screen");
				
				function lastBase.capture:DoClick()
					lastBase.ready = false;
					
					serverguard.netstream.Start("sgScreencapRequest", {
						panel.player:Nick(), base.quality
					});
					
					g_ScreenCapData[panel.player:UID()] = {data = {}, parts = 1};
				end;
				
				lastBase.view = lastBase:Add("DImageButton");
				lastBase.view:SetSize(16, 16);
				lastBase.view:SetImage("icon16/film_go.png");
				lastBase.view:SetToolTipSG("View Image");
				lastBase.view:SetVisible(false);
				
				function lastBase.view:DoClick()										
					local baseb = vgui.Create("tiger.panel");
					baseb:SetSize(ScrW() * 0.75, ScrH() * 0.75);
					baseb:Center();
					baseb:SetTitle("Screen Capture of "..pPlayer:Name().. " ("..pPlayer:SteamID()..")");
					baseb:MakePopup();

					local closeButton = baseb:Add("tiger.button");
					closeButton:SetPos(4, 4);
					closeButton:SetText("Close");
					closeButton:SizeToContents();
					closeButton:DockMargin(0, 0, 0, 24);
					
					function closeButton:DoClick()
						baseb:Remove();
					end;
					
					local path = ("serverguard/screencaps/%s.jpg"):format(tostring(panel.player:UID()));
					RunConsoleCommand("mat_reloadmaterial", "../data/"..path:StripExtension());
					
					local image = baseb:Add("DImage");
					image:Dock(FILL);
					image:SetImage("../data/"..path);

					function baseb:PerformLayout(w, h)
						closeButton:SetPos(w - (closeButton:GetWide() + 24), (closeButton:GetTall() * 0.5) + 14);
					end;
					
					baseb:InvalidateLayout(true);
				end;
				
				function lastBase:Paint(w, h)
					if (IsValid(panel.player)) then
						local data = g_ScreenCapData[panel.player:UID()];
						
						if (data) then
							local fraction = #data.data /data.parts;
							
							if (self.ready) then
								if (!self.view:IsVisible()) then
									local path = ("serverguard/screencaps/%s.jpg"):format(tostring(panel.player:UID()));
									local compiled = "";
									
									for k, str in pairs(data.data) do
										compiled = compiled .. str;
									end;

									file.Write(path, compiled);
									RunConsoleCommand("mat_reloadmaterial", "../data/"..path:StripExtension());

									self.view:SetVisible(true);
								end;
								
								if (!self.capture:IsVisible()) then
									self.capture:SetVisible(true);
								end;
								
								self.progress = 0;
							else
								if (self.capture:IsVisible()) then
									self.capture:SetVisible(false);
								end;
								
								if (self.view:IsVisible()) then
									self.view:SetVisible(false);
								end;
								
								if (fraction > 0) then
									draw.SimpleRect(0, 5, self.progress, 20, Color(0, 200, 0));
	
									self.progress = math.Approach(self.progress, (w - 6) * fraction, 2);
								end;
								
								util.PaintShadow(0, 5, w - 6, 20, 3, 0.2);
								
								draw.MaterialRotated(12, 15, 16, 16, color_white, loadingTexture, self.rotate);
								
								self.rotate = self.rotate + 140 * FrameTime();
								
								if (self.rotate >= 360) then
									self.rotate = 0;
								end;
								
								local theme = serverguard.themes.GetCurrent();
								
								draw.SimpleText(math.Round((#data.data /data.parts) *100) .. "%", "tiger.base.footer", w -8, 8, theme.tiger_button_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP);
								
								if (fraction >= 1 and self.progress >= (w -6) *fraction) then
									self.ready = true;
								end;
							end;
						end;
					end;
				end;
				
				function lastBase:PerformLayout()
					local w, h = self:GetSize();
					
					if (self.view:IsVisible()) then
						self.capture:SetPos(w / 2 + 12, h / 2 - 8);
						self.view:SetPos(w /2 - 12,  h / 2 - 8);
					else
						self.capture:SetPos(w /2 -8, h /2 -8);
					end;
					
					local column = panel:GetThing(3).column;
					local x = column:GetPos();
					
					self:SetPos(x, 0);
				end;
				
				panel:AddItem(lastBase);
				
				timer.Simple(FrameTime() *2, function()
					local column = panel:GetThing(3).column;
				
					lastBase:SetSize(column:GetWide() -1, 30);
					lastBase:InvalidateLayout();
				end);
				
				pPlayer.screenPanel = panel;
			end;
		end;
	end;
end;

plugin:AddSubCategory("Intelligence", category);