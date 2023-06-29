--Easy placement and saving for Chess boards
if SERVER then AddCSLuaFile() end

SWEP.Base = "weapon_base"

SWEP.Category = "Game boards"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = "Left click to place a board, right click to remove a board, reload for menu"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.AdminSpawnable = true

SWEP.Slot = 4
SWEP.PrintName = "Chess Admin Tool"

SWEP.ViewModelFOV = 80
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
SWEP.UseHands = true

SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipMax = -1

SWEP.DeploySpeed = 1.5

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.HoldType = "pistol"

SWEP.GameEntities = {
	{"Chess", "ent_chess_board", {["board"] = Model("models/props_phx/games/chess/board.mdl"), ["table"] = Model("models/props/de_tides/restaurant_table.mdl")}},
	{"Draughts/Checkers", "ent_draughts_board", {["board"] = Model("models/props_phx/games/chess/board.mdl"), ["table"] = Model("models/props/de_tides/restaurant_table.mdl")}},
}
function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "EntID" )
end

function SWEP:Initialize()
	self:SetEntID( 1 ) --Chess by default
end
function SWEP:PrimaryAttack()
	if SERVER and IsValid( self.Owner ) then
		if not self.Owner:IsAdmin() then
			self.Owner:ChatPrint( "You are not allowed to use this tool!" )
			self:Remove()
			return
		end
		local tr = self.Owner:GetEyeTrace()
		if tr.Hit and tr.HitPos then
			local ent = ents.Create( self.GameEntities[self:GetEntID()][2] )
			ent:SetPos( tr.HitPos )
			ent:Spawn()
		end
	end
end
function SWEP:SecondaryAttack()
	if SERVER and IsValid( self.Owner ) then
		if not self.Owner:IsAdmin() then
			self.Owner:ChatPrint( "You are not allowed to use this tool!" )
			self:Remove()
			return
		end
		
		local tr = self.Owner:GetEyeTrace()
		if IsValid(tr.Entity) and tr.Entity.IsChessEntity then tr.Entity:Remove() end
	end
end
function SWEP:Reload()
	if CLIENT then self:OpenMenu() end
end

function SWEP:OpenMenu()
	if SERVER then return end
	if IsValid(self.Menu) then self.Menu:Remove() end
	
	self.Menu = vgui.Create( "DFrame" )
	self.Menu:SetTitle( "Chess Admin Tool" )
	self.Menu:SetSize( 300, 80 )
	self.Menu:SetPos( ScrW()/2-150, ScrH()/2-50 )
	self.Menu:MakePopup()
	
	local drop = vgui.Create( "DComboBox", self.Menu )
	drop:Dock( TOP )
	drop:SetValue( "Select Board" )
	for i=1,#self.GameEntities do
		drop:AddChoice( self.GameEntities[i][1], i )
	end
	drop.OnSelect = function( s, ind, val, data )
		RunConsoleCommand( "chess_admin_toolent", tostring(data) )
	end
	
	local btnpnl =  vgui.Create( "DPanel", self.Menu )
	btnpnl:Dock( BOTTOM )
	btnpnl:SetTall( 20 )
	btnpnl.Paint = function() end
	
	local close = vgui.Create( "DButton", btnpnl )
	close:SetWidth( 98 )
	close:Dock( RIGHT )
	close:SetText( "Close" )
	close.DoClick = function(s) if IsValid(self) and IsValid(self.Menu) then self.Menu:Remove() end end
	
	local rem = vgui.Create( "DButton", btnpnl )
	rem:SetWidth( 98 )
	rem:Dock( LEFT )
	rem:SetText( "Remove tool" )
	rem.DoClick = function(s)
		RunConsoleCommand( "chess_admin_toolremove" )
		if IsValid(self) and IsValid(self.Menu) then self.Menu:Remove() end
	end
	
	local sv = vgui.Create( "DButton", btnpnl )
	sv:SetWidth( 98 )
	sv:Dock( FILL )
	sv:SetText( "Save boards" )
	sv.DoClick = function(s)
		RunConsoleCommand( "chess_save" )
	end
end

function SWEP:OnRemove()
	if CLIENT and self.Ghosts then
		for _,v in pairs(self.Ghosts) do if IsValid(v) then v:Remove() end end
	end
end
function SWEP:Holster()
	if CLIENT then
		if self.Ghosts then
			for _,v in pairs(self.Ghosts) do if IsValid(v) then v:Remove() end end
		end
		return true
	end
	return true
end

if SERVER then
	local function SetToolEnt( tool, index )
		if tool.GameEntities[index] then tool:SetEntID( index ) end
	end
	concommand.Add( "chess_admin_toolent", function(p,c,a)
		if IsValid(p:GetActiveWeapon()) and p:GetActiveWeapon():GetClass()=="chess_admin_tool" then
			SetToolEnt( p:GetActiveWeapon(), tonumber(a[1]) )
		end
	end)
	concommand.Add( "chess_admin_toolremove", function(p,c,a)
		if IsValid(p:GetActiveWeapon()) and p:GetActiveWeapon():GetClass()=="chess_admin_tool" then p:GetActiveWeapon():Remove() end
	end)
end

if CLIENT then
	surface.CreateFont( "ChessAdmin", {
		font="Arial", size=40,
	})
	local ColBox = Color(0,0,0,150)
	local ColText = Color(255,255,255,255)
	local ColGhost = Color(0,255,0,150)
	function SWEP:DrawHUD()
		local w,h = ScrW(), ScrH()
		local txt = "Board: ".. tostring( self.GameEntities[self:GetEntID()][1] )
		
		surface.SetFont( "ChessAdmin" )
		local tw, th = surface.GetTextSize( txt )
		
		surface.SetDrawColor( ColBox )
		surface.DrawRect( (w/2) - ((tw/2)+3), h - (th+6), tw+6, th+6 )
		
		draw.DrawText( txt, "ChessAdmin", w/2, h-(th)-3, ColText, TEXT_ALIGN_CENTER )
	end
	
	function SWEP:DoGhosts()
		local tr = self.Owner:GetEyeTrace()
		if (not tr.Hit) then return end
		
		self.Ghosts = self.Ghosts or {}
		local mdltbl = self.GameEntities[self:GetEntID()][3]
		if not mdltbl then return end
		
		self.Ghosts[1] = IsValid(self.Ghosts[1]) and self.Ghosts[1] or ClientsideModel( mdltbl.table, RENDERGROUP_BOTH )
		self.Ghosts[1]:SetPos( tr.HitPos )
		self.Ghosts[1]:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.Ghosts[1]:SetColor( ColGhost )
		
		local h = 30 --(self.Ghosts[1]:OBBMaxs()[3] - self.Ghosts[1]:OBBMins()[3])
		self.Ghosts[2] = IsValid(self.Ghosts[2]) and self.Ghosts[2] or ClientsideModel( mdltbl.board, RENDERGROUP_BOTH )
		self.Ghosts[2]:SetPos( tr.HitPos+Vector(0,0,h or 50) )
		self.Ghosts[2]:SetAngles( Angle(-90,0,0) )
		self.Ghosts[2]:SetModelScale( 0.35, 0 )
		self.Ghosts[2]:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.Ghosts[2]:SetColor( ColGhost )
		
		self.Ghosts[3] = IsValid(self.Ghosts[3]) and self.Ghosts[3] or ClientsideModel( "models/nova/chair_plastic01.mdl", RENDERGROUP_BOTH )
		self.Ghosts[3]:SetPos( tr.HitPos+ (self.Ghosts[2]:GetRight()*40) )
		self.Ghosts[3]:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.Ghosts[3]:SetColor( ColGhost )
		
		self.Ghosts[4] = IsValid(self.Ghosts[4]) and self.Ghosts[4] or ClientsideModel( "models/nova/chair_plastic01.mdl", RENDERGROUP_BOTH )
		self.Ghosts[4]:SetPos( tr.HitPos+ (self.Ghosts[2]:GetRight()*-40) )
		self.Ghosts[4]:SetAngles( Angle(0,180,0) )
		self.Ghosts[4]:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.Ghosts[4]:SetColor( ColGhost )
	end
	function SWEP:PostDrawViewModel()
		if LocalPlayer()~=self.Owner then return self.BaseClass.PostDrawViewModel( self ) end
		self:DoGhosts()
	end
	function SWEP:DrawWorldModel()
		if LocalPlayer()~=self.Owner then return self.BaseClass.DrawWorldModel( self ) end
		self:DrawModel()
		self:DoGhosts()
	end
end