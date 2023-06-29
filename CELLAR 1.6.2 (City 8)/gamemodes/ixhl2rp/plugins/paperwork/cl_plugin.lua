local PLUGIN = PLUGIN

local PANEL = {}
PANEL.TextHTML = [[
	<html content="text/html; charset=UTF-8">
	<head>
	<style type="text/css">
		html {
			margin: 0;
			padding: 0;
			background-color: rgba(0,0,0,0.01);
		}
		body {
			margin: 0;
			padding: 0;
		}
		
		::-webkit-scrollbar {
			width: 10px;
		}
		::-webkit-scrollbar-thumb {
			background-color: #3E65A0;
		}
		::-webkit-scrollbar-thumb:active {
			background-color: #4A78BF;
		}
	</style>
	</head>
	<textarea id="textentry"; style="overflow-y: scroll; height: 100%; width: 100%; resize: none; font-size: 87%; font-family: sans-serif;" maxlength = ]]..PLUGIN.maxLength..[[;></textarea>
	<script>
		function SetText( text ) {
			document.getElementById("textentry").value = text;
		};
		function GetText() {
			if ("gmodinterface" in window) {
				gmodinterface._GetText(document.getElementById("textentry").value);
			}
		};
		function GetSelectedText() {
			if ("gmodinterface" in window) {
				var text = "";
				var textentry = document.getElementById("textentry");
				text = textentry.value.substring(textentry.selectionStart, textentry.selectionEnd);
				gmodinterface._GetSelectedText(text);
			}
		};
		function SetReadOnly( bool ) {
			if (bool) {
				document.getElementById("textentry").setAttribute("readonly",true);
			} else {
				document.getElementById("textentry").removeAttribute("readonly");
			}
		};
		function GetReadOnly() {
			if ("gmodinterface" in window) {
				gmodinterface._GetReadOnly(document.getElementById("textentry").getAttribute("readonly"));
			}
		};
		function escapeRegExp(str) {
    		return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
		}
		function InsertCode( format ) {
			var textentry = document.getElementById("textentry");
			var len = textentry.value.length;
		    var start = textentry.selectionStart;
			var end = textentry.selectionEnd;
			var selectedText = textentry.value.substring(start, end);
			var replacement = selectedText.replace(new RegExp(escapeRegExp(selectedText), 'g'), format);

			textentry.value = textentry.value.substring(0, start) + replacement + textentry.value.substring(end, len);
		};
	</script>
	<body>
	</html>
]]

function PANEL:Init()
	self.Text = ""
	self.ReadOnly = nil
	self.SelectedText = ""
	self:InitSecond()
	hook.Add("ShutDown", self,function()
		if not ValidPanel(self) or not self.HTML then return end
	end)
end
function PANEL:InitSecond()
	local HTML = vgui.Create( "DHTML", self )
	self.HTML = HTML
	function HTML.Paint( HTML, w, h ) end
	HTML:Dock( FILL )
	self:InvalidateLayout()
	self.HTML:InvalidateLayout(true)
	self.HTML:SetHTML( self.TextHTML )
	self.HTML:RequestFocus()

	self.HTML:AddFunction("gmodinterface", "_GetText", function( text )
		self.Text = text
	end)
	self.HTML:AddFunction("gmodinterface", "_GetReadOnly", function( bool )
		self.ReadOnly = bool
	end)
	self.HTML:AddFunction("gmodinterface", "_GetSelectedText", function( text )
		self.SelectedText = text
	end)
end
function PANEL:Paint()
	if IsValid(self.HTML) then return end
	self:InitSecond()
end
function PANEL:InsertCode(format)
	self.HTML:Call("InsertCode(\""..format.."\")")
end
function PANEL:GetSelectedText()
	self.HTML:Call("GetSelectedText()")
	return self.SelectedText
end
function PANEL:GetReadOnly()
	self.HTML:Call("GetReadOnly()")
	return self.ReadOnly
end
function PANEL:SetReadOnly( bool )
	self.HTML:Call("SetReadOnly("..tostring(bool)..")")
	self.ReadOnly = bool
end
function PANEL:GetText()
	self.HTML:Call("GetText()")
	return self.Text
end
function PANEL:SetText( text )
	self.HTML:Call("SetText(\""..text.."\")")
	self.Text = text
end
vgui.Register("HTextEntry", PANEL, "EditablePanel")

PANEL = {}

AccessorFunc(PANEL, "itemID", "ItemID", FORCE_NUMBER)

function PANEL:Init()
	local w = math.max( ScrH() / 4, 600 )
	local h = math.max( ScrH() / 1.15, 640 )
		
	self:SetSize(w, h)	
	self:MakePopup()
	self:Center()
	self:SetTitle(L("iPaper"))

	self.controls = vgui.Create("DScrollPanel", self)
	self.controls:Dock(BOTTOM)

	self.list = vgui.Create("DIconLayout", self.controls)
	self.list:Dock(TOP)
	self.list:DockMargin(0, 0, 0, 5)
	self.list:SetSpaceX(0)
	self.list:SetSpaceY(0)


	self.title = self:Add("DLabel")
	self.title:SetText(L("pwTitle"))
	self.title:SizeToContents()
	self.title:Dock(TOP)
	self.title:DockMargin(1, 0, 0, 5)

	self.titletext = self:Add("DTextEntry")
	self.titletext:SetValue("Безымянный")
	self.titletext:Dock(TOP)

	self.content = self:Add("DLabel")
	self.content:SetText(L("pwContent"))
	self.content:SizeToContents()
	self.content:Dock(TOP)
	self.content:DockMargin(1, 5, 0, 5)

	self.contents = self:Add("HTextEntry")
	self.contents:DockMargin(0, 0, 0, 4)
	self.contents:Dock(FILL)

	
	surface.SetFont("Default")
	for k, v in ipairs(PLUGIN.BBCodes) do
		local formatbtn = self.list:Add( "DButton" )
		formatbtn:SetTooltip(v.hint)
		formatbtn:SetText(v.id)
		local x, y = surface.GetTextSize(v.id)
		formatbtn:SetSize(x + 10, 24)
		formatbtn.DoClick = function(s)
			self.contents:InsertCode(v.format)
		end
	end

	
	self.canpickup = self.controls:Add("DCheckBoxLabel")
	self.canpickup:SetText(L("pwAdminRestrict"))
	self.canpickup:Dock(TOP)

	self.sizetext = self.controls:Add("DLabel")
	self.sizetext:Dock(TOP)
	self.sizetext:SetText("")
	self.sizetext.Think = function(s)
		if !s.nextTick or s.nextTick > CurTime() then
			s:SetText(L("pwSize", string.utf8len(self.contents:GetText()), PLUGIN.maxLength))
			s.nextTick = CurTime() + .75
		end
	end
	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(TOP)
	self.confirm:SetDisabled(true)
	self.confirm:SetText(L("pwOk"))
	self.confirm.DoClick = function(this)
		netstream.Start("ixWritePaper", self.itemID, self.titletext:GetValue(), self.contents:GetText(), self.canpickup:GetChecked())
		self:Close()
	end
	self.controls:SizeToContents()
end
function PANEL:Think()
	local h = self.controls:GetCanvas():GetTall()
	if self.controls:GetTall() != h then
		self.controls:SetTall(h)
	end
end
function PANEL:allowEdit(bool)
	if (bool == true) then
		self.contents:SetReadOnly(false)
		self.confirm:SetDisabled(false)
	else
		self.contents:SetReadOnly(true)
		self.confirm:SetDisabled(true)
	end
end
function PANEL:setText(text)
	self.contents:SetText(text)
end
function PANEL:OnClose()
	netstream.Start("ixWritePaperClosed", self.itemID)
end
vgui.Register("BB_NoteWrite", PANEL, "DFrame")


local TEXTFIELDS = {}
function DOMToTable(xml)
	local h = gxml.domHandler()
    local x = gxml.xmlParser(h)
    x:parse(xml)
	return h.root
end

PANEL = {}

AccessorFunc(PANEL, "itemID", "ItemID", FORCE_NUMBER)
local function processFields(tbl)
	if tbl["n"] then
		tbl["n"] = nil 
	end
	if !tbl[1] then
		tbl[1] = { ["_text"] = "" }
	end
	for k, v in pairs(tbl) do
		if type(v) == "table" and k != "_parent" then
			table.insert(TEXTFIELDS, v["_text"])
		end
	end
end
local function processHTML(tbl)
	for k, v in pairs(tbl) do
		if type(v) == "table" and k != "_parent" then
			processHTML(v)
		end
	end
	if tbl["_name"] == "span" then
		if tbl["_attr"] then 
			if tbl["_attr"]["class"] == "textarea" then
				processFields(tbl["_children"])
			end
		end
	end
end
function PANEL:Init()
	TEXTFIELDS = {}
	self.btnMinim:SetVisible(false)
	self.btnMaxim:SetVisible(false)

	local w = math.max(ScrH() / 4, 600)
	local h = math.max(ScrH() / 1.15, 640)
		
	self:SetSize(w, h)	
	self:MakePopup()
	self:Center()
	self:SetTitle(L("iPaper"))

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)

	local HTML = self:Add("DHTML")
	function HTML.Paint( HTML, w, h ) end
	self.contents = HTML

	self.contents:Dock(FILL)
	self.contents:InvalidateLayout(true)
	self.contents:RequestFocus()
	self.contents:AddFunction("gmodinterface", "_GetHTMLEntry", function(html)
		html = string.Replace(html, "<br>", "<br></br>")
		html = string.Replace(html, "<hr>", "<hr></hr>")
		local htmltable = DOMToTable("<0>"..html.."</0>")
		processHTML(htmltable)
		netstream.Start("ixEditPaper", self.itemID, TEXTFIELDS)
		self:Close()
	end)

	self.controls.Paint = function(this, w, h) end
	
	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(FILL)
	self.confirm:SetDisabled(false)
	self.confirm:SetText(L("pwOk"))
	self.confirm.DoClick = function(this)
		self.contents:Call("gmodinterface._GetHTMLEntry(document.getElementById('entry').innerHTML);")
	end
end
function PANEL:SafeParse(text)
	if !self.parser then 
		self.parser = vgui.Create("DHTML", self)
		self.parser.Paint = function() end
		self.parser:SetSize(0, 0)
		self.parser:AddFunction("gmodinterface", "_GetText", function(html)
			self.parser:Remove()
			html = PLUGIN:ParseBBCode(html)
			self:Load(html)
		end)
	end

	self.parser:SetHTML([[<!DOCTYPE html>
	<html content="text/html; charset=UTF-8">
	<script>
		function SafeParse() {
			var a = document.getElementById("a");
			a.innerHTML = a.textContent || a.innerText || "";

			if ("gmodinterface" in window) {
				gmodinterface._GetText(a.innerHTML);
			}
		}
	</script><div id="a">]]..text..[[</div></html>]])
	self.parser:Call("SafeParse();")
end
function PANEL:Load(data)
	self.contents:SetHTML([[<!DOCTYPE html>
	<html content="text/html; charset=UTF-8">
	<head>
	<style type="text/css">
		[contenteditable]:empty:before{
			content: "<заполнить>";
			display: block;
		}
		html {
			margin: 0;
			padding: 0;
			background-color: #FFF;
		}
		body {
			margin: 0;
			padding: 0;
			font-family: sans-serif;
		}
		span {
			display: inline-block;
		}
		div {
			display: inline-block;
		}
		div.content {
			display: block;
			width: calc(100% - 40px);
			height: 100%;
			font-size: 12px;
			text-align: left;
			margin: 20px 20px 20px 20px;
			word-break: break-all;
			white-space: pre-wrap;
		}
		.big {
			font-size: 16px;
		}
		.small {
			font-size: 10px;
		}
		.large {
			font-size: 20px;
		}
		.red {
			color: rgb(255,40,40);
		}
		.green {
			color: rgb(40,255,40);
		}
		.blue {
			color: rgb(40,40,255);
		}
		.sign {
			font-style: italic;
			font-size: 90%;
			font-family: "Trebuchet MS", monospace;
		}
		.textarea {
			display: inline-block;
			word-break: break-all;
			min-width: 32px;
			min-height: 100%;
			vertical-align:top;
			text-decoration: underline;
		}
	</style>
	</head>
	<body>
	<div id="entry" class="content">]]..data..[[</div></body></html>]])
end
function PANEL:Paint(w, h)
	surface.SetDrawColor(80, 80, 80, 225)
	surface.DrawRect(0, 0, w, 24)
end
function PANEL:OnClose()
	netstream.Start("ixWritePaperClosed", self.itemID)
end
vgui.Register("BB_NoteEdit", PANEL, "DFrame")

do
	function PLUGIN:ParseBBCode(text)
		if !isstring(text) then return end
		local final_text = text

		final_text = string.Replace(final_text, "$f$", "<span class=\"textarea\" contenteditable></span>")
		final_text = string.Replace(final_text, "$s$", "<span class=\"sign\">")
		final_text = string.Replace(final_text, "$/s$", "</span>")

		for bbcode, tbl in ipairs(self.BBCodes) do
			if tbl.find and tbl.replace then
				if tbl.find[1] and tbl.replace[1] then
					final_text = string.Replace(final_text, tbl.find[1], tbl.replace[1])
				end
				if tbl.find[2] and tbl.replace[2] then
					final_text = string.Replace(final_text, tbl.find[2], tbl.replace[2])
				end
			end
		end
		
		return final_text
	end
end

netstream.Hook("ixOpenPaper", function(itemID, text, title, write)
	if BB_WRITE_EDITOR then BB_WRITE_EDITOR:Remove() BB_WRITE_EDITOR = nil end

	if write then
		BB_WRITE_EDITOR = vgui.Create("BB_NoteWrite")
		BB_WRITE_EDITOR:SetItemID(itemID)
		BB_WRITE_EDITOR:allowEdit(true)
		BB_WRITE_EDITOR.titletext:SetValue(title or "Безымянный")
		BB_WRITE_EDITOR:setText(text and string.JavascriptSafe(text) or "")
	else
		BB_WRITE_EDITOR = vgui.Create("BB_NoteEdit")
		BB_WRITE_EDITOR:SetItemID(itemID)
		BB_WRITE_EDITOR:SafeParse(text)
		BB_WRITE_EDITOR:SetTitle(title)
	end
end)

