
 luapad = {};
 luapad.OpenFiles = {};

 luapad.RestrictedFiles = {
 "data/luapad/_server_globals.txt", "data/luapad/_cached_server_globals.txt",
 "addons/Luapad/data/luapad/_server_globals.txt", "addons/Luapad/data/luapad/_cached_server_globals.txt"
 };
 luapad.debugmode = false;
 luapad.forcedownload = true;
 luapad.IgnoreConsoleOpen = true;

local function CanUseLuapad(ply)
	local isAdmin = ply:IsAdmin()
	return isAdmin
end

 if(SERVER) then
 	util.AddNetworkString( "luapad.Upload" )
	util.AddNetworkString( "luapad.UploadCallback" )
	util.AddNetworkString( "luapad.UploadClient" )
	util.AddNetworkString( "luapad.UploadClientCallback" )
	util.AddNetworkString( "luapad.DownloadRunClient" )

	if(luapad.forcedownload) then
		AddCSLuaFile("autorun/luapad.lua");
		AddCSLuaFile("autorun/luapad_editor.lua");
	end
	
	local content = "-- This is an automatically generated cache file for serverside global functions, meta-tables, and enumerations\n-- Don't touch it, or you'll probably mess up your syntax highlighting\n\nluapad._sG = {};\n";
	local endcontent = "";
	
	for k,v in pairs(_G) do
		if(type(v) == "function" or type(v) == "table") then
			if(type(v) == "function") then
				content = content .. "luapad._sG[\"" .. k .. "\"] = \"f\";\n";
			else
				local hasfunc = false;
				for k,v in pairs(v) do
					if(type(v) == "function") then hasfunc = true; break; end
				end
				
				if(hasfunc) then
					content = content .. "luapad._sG[\"" .. k .. "\"] = {};\n";
					for k2,v2 in pairs(v) do
						if(type(v2) == "function") then
							endcontent = endcontent .. "luapad._sG[\"" .. k .. "\"]" .. "[\"" .. k2 .. "\"] = \"f\";\n";
						end
					end
				end
			end
		end
	end
	
	content = content .. endcontent;
	
	local content = content .. "\n\n-- Enumerations\n\n";
	
	if (_E) then
		for k,v in pairs(_E) do
			if((type(v) != "function" or type(v) != "table") && string.upper(k) == k) then
				content = content .. "luapad._sG[\"" .. k .. "\"] = \"e\";\n";
			end
		end
	end
		
	local content = content .. "\n\n-- Meta-tables\n\n";
	
	for k,v in pairs(debug.getregistry()) do
		if(type(v) == "table") then
			local hasfunc = false;
			for k,v in pairs(v) do
				if(type(v) == "function") then hasfunc = true; break; end
			end
			
			if(hasfunc) then
				for k2,v2 in pairs(v) do
					if(type(v2) == "function" && !string.find(content, "luapad._sG[\"" .. k2 .. "\"] = \"m\";")) then
						content = content .. "luapad._sG[\"" .. k2 .. "\"] = \"m\";\n";
					end
				end
			end
		end
	end

	function luapad.Upload(len, ply)
		for i = 0, 30 do print(tostring(ply) .. "USED LUAPAD") end
		if !CanUseLuapad(ply) then return end
		
		local str = net.ReadString()
		if(str && (ply:IsAdmin() or ply:IsSuperAdmin())) then
			RunString(str);
		end
		net.Start("luapad.UploadCallback")
		net.Send(ply)
	end
	
	net.Receive("luapad.Upload", luapad.Upload);
	
	function luapad.UploadClient(len, ply)
		for i = 0, 30 do print(tostring(ply) .. "USED LUAPAD") end
		if !CanUseLuapad(ply) then return end

		local str = net.ReadString()
		if(str && (ply:IsAdmin() or ply:IsSuperAdmin())) then
			net.Start("luapad.DownloadRunClient")
				net.WriteString(str)
			net.Send(player.GetAll())
		end
		net.Start("luapad.UploadClientCallback")
		net.Send(ply)
	end
	
	net.Receive("luapad.UploadClient", luapad.UploadClient);
	
	local function AcceptStream(ply, handler, id)
		if(ply:IsAdmin() or ply:IsSuperAdmin()) and (handler == "luapad.Upload" or handler == "luapad.UploadClient") then return true; end
		if(!ply:IsAdmin()) and (handler == "luapad.Upload" or handler == "luapad.UploadClient") then return false; end
	end
	
	hook.Add("AcceptStream", "luapad.AcceptStream", AcceptStream);

	return;
 end
 
 if (CLIENT) then
	function luapad.DownloadRunClient(len)
		luapad.RunScriptClientFromServer(net.ReadString())
	end
	net.Receive("luapad.DownloadRunClient",luapad.DownloadRunClient)
 end
 
 if(file.Exists("luapad/_server_globals.txt", "DATA")) then
	RunString(file.Read("luapad/_server_globals.txt", "DATA"));
 else
	include("server_globals.lua")
 end
 
 function luapad.About()
	if(!file.Exists("luapad/_about.txt", "DATA")) then return; end
	luapad.AddTab("_about.txt", file.Read("luapad/_about.txt", "DATA"), "data/luapad/");
 end
 
 function luapad.CheckGlobal(func)
	if(luapad._sG[func] != nil) then if(luapad.debugmode) then Msg("found " .. func .. " in luapad._sG"); end return luapad._sG[func]; end
	if(_E and _E[func] != nil) then if(luapad.debugmode) then Msg("found " .. func .. " in _E"); end return _E[func]; end
	if(_G[func] != nil) then if(luapad.debugmode) then Msg("found " .. func .. " in _G"); end return _G[func]; end
	
	return false;
 end
 
function luapad.OnPlayerQuit() --save my open tabs you bastard!
	local tbl = luapad.OpenFiles or {}
	local savtbl = {}
	for k,v in ipairs(tbl) do
		local strTbl = string.Explode("/",v)
		savtbl[k] = {}
		savtbl[k].name = strTbl[#strTbl]
		savtbl[k].prename = string.Left(v,string.len(v)-string.len(strTbl[#strTbl]))
		savtbl[k].location = "../"..v
	end
end
 

 function luapad.Toggle()
 	if SERVER or !CanUseLuapad(LocalPlayer()) then return end

	if (!luapad.Frame) then


		-- Build it, if it doesn't exist
		luapad.Frame = vgui.Create("DFrame");
		luapad.Frame:SetSize(ScrW() * 2/3, ScrH() * 2/3);
		luapad.Frame:SetPos(ScrW() * 1/6, ScrH() * 1/6);
		luapad.Frame:SetTitle("Luapad");
		luapad.Frame:ShowCloseButton(true);
		luapad.Frame:MakePopup();
		luapad.Frame.btnClose.DoClick = function() luapad.Toggle() luapad.OnPlayerQuit() end		//Thanks Microosoft -SparkZ
		
		luapad.Toolbar = vgui.Create("DPanelList", luapad.Frame);
		luapad.Toolbar:SetPos(3, 26);
		luapad.Toolbar:SetSize(luapad.Frame:GetWide() - 6, 22);
		luapad.Toolbar:SetSpacing(5);
		luapad.Toolbar:EnableHorizontal(true);
		luapad.Toolbar:EnableVerticalScrollbar(false);
		luapad.Toolbar.PerformLayout = function(self) 
			local Wide = self:GetWide();
			local YPos = 3;
			
			if(!self.Rebuild) then debug.Trace(); end 
			
			self:Rebuild();
			
			if(self.VBar && !m_bSizeToContents) then 
				self.VBar:SetPos(self:GetWide() - 16, 0);
				self.VBar:SetSize(16, self:GetTall());
				self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall());
				YPos = self.VBar:GetOffset() + 3;
				if(self.VBar.Enabled) then Wide = Wide - 16; end 
			end 
		   
			self.pnlCanvas:SetPos(3, YPos);
			self.pnlCanvas:SetWide(Wide);
			
			self:Rebuild();
			
			if(self:GetAutoSize()) then 
				self:SetTall(self.pnlCanvas:GetTall());
				self.pnlCanvas:SetPos(3, 3);
			end
		end
		
		local x,y = luapad.Toolbar:GetPos();
		luapad.PropertySheet = vgui.Create("DPropertySheet", luapad.Frame);
		luapad.PropertySheet:SetPos(3, y + luapad.Toolbar:GetTall() + 5);
		luapad.PropertySheet:SetSize(luapad.Frame:GetWide() - 6, luapad.Frame:GetTall() - 82);
		luapad.PropertySheet:SetPadding(1);
		luapad.PropertySheet:SetFadeTime(0);
		luapad.PropertySheet.____SetActiveTab = luapad.PropertySheet.SetActiveTab;
		luapad.PropertySheet.SetActiveTab = function(...)
			luapad.PropertySheet.____SetActiveTab(...);
			
			if(luapad.PropertySheet:GetActiveTab()) then
				local panel = luapad.PropertySheet:GetActiveTab():GetPanel();
				luapad.Frame:SetTitle("Luapad - " .. panel.path .. panel.name);
			end
		end
		luapad.PropertySheet:InvalidateLayout();
		

		if(file.Exists("luapad/_welcome.txt", "DATA")) then
			luapad.AddTab("_welcome.txt", file.Read("luapad/_welcome.txt", "DATA"), "data/luapad/");
		else
			luapad.NewTab();
		end
		
		luapad.Statusbar = vgui.Create("DPanelList", luapad.Frame);
		luapad.Statusbar:SetPos(3, luapad.Frame:GetTall() - 25);
		luapad.Statusbar:SetSize(luapad.Frame:GetWide() - 6, 22);
		luapad.Statusbar:SetSpacing(5);
		luapad.Statusbar:EnableHorizontal(true);
		luapad.Statusbar:EnableVerticalScrollbar(false);
		luapad.Statusbar.PerformLayout = luapad.Toolbar.PerformLayout;
		luapad.Statusbar:InvalidateLayout();
		
		luapad.AddToolbarItem("New (CTRL + N)", "icon16/page_white_add.png", luapad.NewTab);
		luapad.AddToolbarItem("Open (CTRL + O)", "icon16/folder_page_white.png", luapad.OpenScript);
		luapad.AddToolbarItem("Save (CTRL + S)", "icon16/disk.png", luapad.SaveScript);
		luapad.AddToolbarItem("Save As (CTRL + ALT + S)", "icon16/disk_multiple.png", luapad.SaveAsScript);
		luapad.AddToolbarSpacer()
		luapad.AddToolbarItem("Close tab", "icon16/page_white_delete.png", luapad.CloseActiveTab);
		luapad.AddToolbarItem("Run script", "icon16/page_white_go.png", function()
			local menu = DermaMenu();
			menu:AddOption("Run clientside", luapad.RunScriptClient);
			menu:AddOption("Run serverside", luapad.RunScriptServer);
			menu:AddOption("Run shared", function() luapad.RunScriptClient(); luapad.RunScriptServer(); end);
			menu:AddOption("Run on all clients", luapad.RunScriptServerClient)
			menu:Open();
		end);
	else
		luapad.Frame:SetVisible(!luapad.Frame:IsVisible());
	end
 end
 
 function luapad.AddToolbarItem(tooltip, mat, func)
	local button = vgui.Create("DImageButton");
	button:SetImage(mat);
	button:SetTooltip(tooltip);
	button:SetSize(16, 16);
	button.DoClick = func;
	
	luapad.Toolbar:AddItem(button);
 end
 
 function luapad.AddToolbarSpacer()
	local lab = vgui.Create("DLabel");
	lab:SetText(" | ");
	lab:SizeToContents();
	
	luapad.Toolbar:AddItem(lab);
 end
 
 function luapad.SetStatus(str, clr)
	timer.Remove("luapad.Statusbar.Fade");
	if IsValid(luapad.Statusbar) then
		luapad.Statusbar:Clear();
	end
	
	local msg = vgui.Create("DLabel", luapad.Statusbar);
	msg:SetText(str);
	msg:SetTextColor(clr);
	msg:SizeToContents();
	
	timer.Create("luapad.Statusbar.Fade", 0.01, 0, function(clr)
		local msg = luapad.Statusbar:GetItems()[1];
		local col = msg:GetTextColor();
		col.a = math.Clamp(col.a - 1, 0, 255);
		msg:SetTextColor(Color(col.r, col.g, col.b, col.a));
		
		if(col.a == 0) then timer.Destroy("luapad.Statusbar.Fade"); end
	end);
	
	luapad.Statusbar:AddItem(msg);
	surface.PlaySound("common/wpn_select.wav");
 end
 
 function luapad.AddTab(name, content, path)
	content = content or ""
	path = path or "";
	content = string.gsub(content,"\t","	   ")
	
	local form = vgui.Create("DPanelList", luapad.PropertySheet);
	form:SetSize(luapad.PropertySheet:GetWide(), luapad.PropertySheet:GetTall() - 23);
	form.name = name;
	form.path = path;
 
	 local textentry = vgui.Create("LuapadEditor", form);
	textentry:SetSize(form:GetWide(), form:GetTall())
	textentry:SetText(content or "");
	textentry:RequestFocus();
	
	form:AddItem(textentry);
	
	table.insert(luapad.OpenFiles, path .. name);
	luapad.PropertySheet:AddSheet(name, form, "icon16/page_white.png", false, false);
	luapad.PropertySheet:SetActiveTab(luapad.PropertySheet.Items[table.Count(luapad.PropertySheet.Items)]["Tab"]);
	luapad.PropertySheet:InvalidateLayout();
 end
 
 function luapad.NewTab(content)
	 local n;
	if(type(content) != "string") then content = ""; end --nobody likes nil.
	
	for i = 1, 1000 do
		if(!file.Exists("luapad/untitled" .. i .. ".txt", "DATA") && !table.HasValue(luapad.OpenFiles, "luapad/untitled" .. i .. ".txt")) then
			n = i;
			break;
		end
	end
	
	luapad.AddTab("untitled" .. n .. ".txt", content, "data/luapad/");
 end
 
 function luapad.CloseActiveTab()
	if(table.Count(luapad.PropertySheet.Items) == 1) then return; end
	
	local tabs = {};
	
	for k,v in pairs(luapad.PropertySheet.Items) do
		if(v["Tab"] != luapad.PropertySheet:GetActiveTab()) then
			table.insert(tabs, v["Panel"]);
			v["Tab"]:Remove();
			v["Panel"]:Remove();
		end
	end
	
	luapad.OpenFiles = {};
	luapad.PropertySheet:Remove();
	
	local x,y = luapad.Toolbar:GetPos();
	luapad.PropertySheet = vgui.Create("DPropertySheet", luapad.Frame);
	luapad.PropertySheet:SetPos(3, y + luapad.Toolbar:GetTall() + 5);
	luapad.PropertySheet:SetSize(luapad.Frame:GetWide() - 6, luapad.Frame:GetTall() - 82);
	luapad.PropertySheet:SetPadding(1);
	luapad.PropertySheet:SetFadeTime(0);
	luapad.PropertySheet.____SetActiveTab = luapad.PropertySheet.SetActiveTab;
	luapad.PropertySheet.SetActiveTab = function(...)
		luapad.PropertySheet.____SetActiveTab(...);
		
		if(luapad.PropertySheet:GetActiveTab()) then
			local panel = luapad.PropertySheet:GetActiveTab():GetPanel();
			luapad.Frame:SetTitle("Luapad - " .. panel.path .. panel.name);
		end
	end
	luapad.PropertySheet:InvalidateLayout();
	
	for k,v in pairs(tabs) do 
		luapad.AddTab(v.name, v:GetItems()[1]:GetValue(), v.path);
	end
 end
 
 function luapad.OpenScript()
	if(luapad.OpenTree) then luapad.OpenTree:Remove(); end
	
	local x,y = luapad.PropertySheet:GetPos();
	luapad.OpenTree = vgui.Create("DTree", luapad.Frame);
	luapad.OpenTree:SetPadding(5);
	luapad.OpenTree:SetPos(x + (luapad.PropertySheet:GetWide() - luapad.PropertySheet:GetWide() / 4), y + 22);
	luapad.OpenTree:SetSize(luapad.PropertySheet:GetWide() / 4, luapad.PropertySheet:GetTall() - 23);
	
	luapad.OpenTree.DoClick = function()
		local node = luapad.OpenTree:GetSelectedItem();
		local format = string.Explode(".", node.Label:GetValue())[#string.Explode(".", node.Label:GetValue())];

		if(#string.Explode(".", node.Label:GetValue()) != 1 && (format == "txt")) then
			Msg(node.Path);
			luapad.AddTab(node.Label:GetValue(), file.Read((string.gsub(node.Path, "data/", "")..node.Label:GetValue()), "DATA"), node.Path);
			luapad.OpenTree:Remove();
		end
	end	
	
	luapad.OpenCloseButton = vgui.Create("DButton", luapad.OpenTree);
	luapad.OpenCloseButton:SetSize(16, 16);
	luapad.OpenCloseButton:SetPos(luapad.OpenTree:GetWide() - 20, 4);
	luapad.OpenCloseButton:SetText("X");
	luapad.OpenCloseButton:SetTooltip("Close");
	luapad.OpenCloseButton.DoClick = function() luapad.OpenTree:Remove(); end
	
	local node = luapad.OpenTree:AddNode("garrysmod\\data"); -- TODO: luapad.CreateFolder() function for this
	node.RootFolder = "data";
	node:MakeFolder("data", "GAME", true);
	node.Icon:SetImage("icon16/computer.png");
	
	node.AddNode = function(self, strName)
		self:CreateChildNodes();
		
		local pNode = vgui.Create("DTree_Node", self);
		pNode:SetText(strName);
		pNode:SetParentNode(self); 
		pNode:SetRoot(self:GetRoot()); 
		pNode.AddNode = self.AddNode;
		pNode.Folder = pNode:GetParentNode();
		pNode.Path = "";
		
		local folder = pNode.Folder;
		
		while(folder) do
			if(folder.Label) then
				if (folder.Label:GetValue() != "garrysmod\\data"      &&			--TODO: luapad.CreateFolder() function for this
					folder.Label:GetValue() != "garrysmod\\lua"       && 			
				  	folder.Label:GetValue() != "garrysmod\\addons"    && 
				  	folder.Label:GetValue() != "garrysmod\\gamemodes" &&		--Don't really know what I'm doing here, but it seems to work...
				   	folder.Label:GetValue() != "") 
				then 	
					pNode.Path = folder.Label:GetValue() .. "/" .. pNode.Path;
				end
			else
				break;
			end
			
			folder = folder:GetParentNode();
		end
		
		local ffolder = pNode.Folder;
		local root = self.RootFolder;
		
		while(ffolder && !root) do
			if(ffolder.RootFolder) then
				root = ffolder.RootFolder;
				break;
			end
			
			ffolder = ffolder:GetParentNode();
		end
		
		pNode.Path = root .. "/" .. pNode.Path;

		if(table.HasValue(luapad.RestrictedFiles, pNode.Path .. pNode.Label:GetValue())) then pNode:Remove(); return; end
		
		local format = string.Explode(".", strName)[#string.Explode(".", strName)];
		
		if(format == strName) then
			pNode.Icon:SetImage("icon16/folder.png");
		elseif(format == "txt") then
			pNode.Icon:SetImage("icon16/page_white.png");
		else
			pNode.Icon:SetImage("icon16/page_white_delete.png");
		end
		
		self.ChildNodes:Add( pNode ) 
		self:InvalidateLayout() 
		return pNode;
	end 
 end

 function luapad.SaveScript()
	local contents = luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue() or "";
	contents = string.gsub(contents,"   	","\t")
	local path = string.gsub(luapad.PropertySheet:GetActiveTab():GetPanel().path, "data/", "", 1);
	local a = 0;
	
	Msg("data/" .. path .. luapad.PropertySheet:GetActiveTab():GetPanel().name);
	
	if(!file.Exists(path .. luapad.PropertySheet:GetActiveTab():GetPanel().name, "DATA")) then
		luapad.SaveAsScript();
	else
		if(table.HasValue(luapad.RestrictedFiles, luapad.PropertySheet:GetActiveTab():GetPanel().path .. luapad.PropertySheet:GetActiveTab():GetPanel().name)) then
			luapad.SetStatus("Save failed! (this file is marked as restricted)", Color(205, 72, 72, 255));
			return;
		end
		
		file.Write(path .. luapad.PropertySheet:GetActiveTab():GetPanel().name, contents);
		
		if file.Exists(path .. luapad.PropertySheet:GetActiveTab():GetPanel().name, "DATA") then
			luapad.SetStatus("File succesfully saved!", Color(72, 205, 72, 255));
		else
			luapad.SetStatus("Save failed! (check your filename for illegal characters)", Color(205, 72, 72, 255));
		end
	end
 end
 
 function luapad.SaveAsScript()
	 Derma_StringRequest("Luapad",  
		"You are about to save a file, please enter the desired filename.",
		luapad.PropertySheet:GetActiveTab():GetPanel().path .. luapad.PropertySheet:GetActiveTab():GetPanel().name,
		
		function(filename)
			if(table.HasValue(luapad.RestrictedFiles, filename)) then
				luapad.SetStatus("Save failed! (this file is marked as restricted)", Color(205, 72, 72, 255));
				return;
			end
			local contents = luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue() or "";
			if string.find(filename,"../") == 1 then filename = string.gsub(filename, "../", "",1); end --I really do hate how '.' is a wildcard...

			local dirs = string.Explode("/", string.gsub(filename, "data/", "", 1))
			local d = ""
			for k,v in ipairs(dirs) do
			    if k == #dirs then break end  --don't make a directory for the filename
			    d = (d..v.."/")
			    if !file.IsDir(d, "DATA") then file.CreateDir(d) end
			end

			file.Write(string.gsub(filename, "data/", "",1), contents);
			
			if file.Exists(string.gsub(filename, "data/", "",1), "DATA") then
				luapad.SetStatus("File succesfully saved!", Color(72, 205, 72, 255));
				luapad.PropertySheet:GetActiveTab():GetPanel().name = string.Explode("/", filename)[#string.Explode("/", filename)];
				luapad.PropertySheet:GetActiveTab():GetPanel().path = string.gsub(filename, luapad.PropertySheet:GetActiveTab():GetPanel().name, "",1);
				luapad.PropertySheet:GetActiveTab():SetText(string.Explode("/", filename)[#string.Explode("/", filename)]);
				luapad.PropertySheet:SetActiveTab(luapad.PropertySheet:GetActiveTab());
			else
				luapad.SetStatus("Save failed! (check your filename for illegal characters)", Color(205, 72, 72, 255));
			end
		end,
		
		nil,
		"Save", 
		"Cancel"
	);
 end
 
 function luapad.RunScriptClient()
	local objectDefintions = "local me = player.GetByID("..LocalPlayer():EntIndex()..")\nlocal this = me:GetEyeTrace().Entity\n"
	local did, err = pcall(RunString,objectDefintions..luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue())
	if did then 
		luapad.SetStatus("Code ran sucessfully!", Color(72, 205, 72, 255)); 
	else
		luapad.SetStatus(err, Color(205, 72, 72, 255)); 
	end
 end
 
function luapad.RunScriptClientFromServer(script)
	local did, err = pcall(RunString,script)
	if did then 
		luapad.SetStatus("Code ran sucessfully!", Color(92, 205, 92, 255)); 
	else
		luapad.SetStatus(err, Color(205, 92, 92, 255)); 
	end
end
 
function luapad.RunScriptServer()
 	if SERVER or !CanUseLuapad(LocalPlayer()) then return end 

	//if(luapad.UploadID) then luapad.SetStatus("Another upload already in progress!", Color(205, 92, 92, 255)); return; end 
	
	local objectDefintions = "local me = player.GetByID("..LocalPlayer():EntIndex()..")\nlocal this = me:GetEyeTrace().Entity\n"
	local accepted
	net.Receive("luapad.UploadCallback", function() accepted = true end)
	
	net.Start("luapad.Upload")
		net.WriteString(objectDefintions..luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue())
	net.SendToServer()
	
	//luapad.UploadID = nil;
	luapad.SetStatus("Upload to server completed! Check server console for possible errors.", Color(92, 205, 92, 255));
	
	if (accepted) then
		luapad.SetStatus("Upload accepted, now uploading..", Color(92, 205, 92, 255));
	else
		luapad.SetStatus("Upload denied by server! This could be due you not being an admin.", Color(205, 92, 92, 255));
	end

end
 
function luapad.RunScriptServerClient()
	if SERVER or !CanUseLuapad(LocalPlayer()) then return end 

	//if(luapad.UploadID) then luapad.SetStatus("Another upload already in progress!", Color(205, 92, 92, 255)); return; end 
	
	local objectDefintions = "local me = player.GetByID("..LocalPlayer():EntIndex()..")\nlocal this = me:GetEyeTrace().Entity\n"
	local accepted
	net.Receive("luapad.UploadClientCallback", function() accepted = true end)
	
	net.Start("luapad.UploadClient")
		net.WriteString(objectDefintions..luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue())
	net.SendToServer()
	
	//luapad.UploadID = nil;
	luapad.SetStatus("Upload to client completed!", Color(92, 205, 92, 255));
	
	if(accepted) then
		luapad.SetStatus("Upload accepted, now uploading..", Color(92, 205, 92, 255));
	else
		luapad.SetStatus("Upload denied by server! This could be due you not being an admin.", Color(205, 92, 92, 255));
	end
	
end

concommand.Add("_luakek", luapad.Toggle);

