local plugin = plugin;
local category = {};

category.name = "Reports";
category.material = "serverguard/menuicons/icon_envelope.png";
category.permissions = "Manage Reports";

function category:Create(base)
	base.panel = base:Add("tiger.panel");
	base.panel:SetTitle("Report Configuration");
	base.panel:Dock(FILL);

	local configList = base.panel:Add("tiger.list");
	configList:SetTall(64);
	configList:Dock(TOP);

	local shouldShowReal = vgui.Create("tiger.checkbox");
	configList:AddPanel(shouldShowReal);

	shouldShowReal:Dock(TOP);
	shouldShowReal:SetText("Alerts");
	shouldShowReal:BindToConfig("reports", "hide");

	local shouldTrack = vgui.Create('tiger.checkbox')
	configList:AddPanel(shouldTrack)

	shouldTrack:Dock(TOP)
	shouldTrack:SetText("Statistics")
	shouldTrack:BindToConfig("reports", "tracker");
	
	
end;

plugin:AddSubCategory("Server settings", category);