hook.Add("Think", "fixLanguage2", function()
	if ix and ix.lang then
		ix.lang.AddTable("russian", {
			scOTA = "Сверхчеловеческий Надзор",
		})

		hook.Remove("Think", "fixLanguage2")
	end
end)

local SCREEN_SCALE = math.Clamp(ScrH() / 1080, 0.6, 1)
local self = {}

self.playercombineOverlays = {}
self.combineOverlayMessageOW = {
	"29 SLOTA        EQU   $FB       :ADDRESS (SLOT _ - 16)",
	"49 SLOTD       EQU   $FT       :POKE RAM SLOT_(8)",
	"32 CPCMB       EQU   $86       :PAGE VIEWED (INDIRECT)",
	"59 STN08        EQU   $F9       :USED FOR CMB INFOLINK",
	"38	STBD9         EQU   $76       :$FFC% 08-6",
	"78 CMBTH       EQU   $88       :HBYTE OF MEM STOR (DIRECT)",
	"36 STORM       EQU   $FC       :<< POKE 98K RAM BANK",
	"45 VIEWE        EQU   $FV       :AW CORDS 4 OF 8(%)",
	
	
	"03 DISPW       EQU   $FD       :CMD 9 OF 8(%)",
	"63 D0HA         EQU   $92       :<< DISPLACED MEM_X529 OUT OF CACHE",
	"95 AUGMT       EQU   $03       :<< PAGE TERMINATED 19 (INDIRECT)",
	"40 CHRNO       EQU   $39       :SLOT_ (0 TO 7) 98K RAM", 
	"95 AUGMT       EQU   $FG       :H1BYTE OF STOR",
	"01 AUGMT       EQU   $FG       :POKE MOVE SLOT_549281 $FG"

} 

hook.Add("ShouldHideBars", "Overwatch", function()
	if LocalPlayer():IsOTA() then
		return true
	end
end)

local function DrawCombineOverlay(x, y)
	local client = LocalPlayer()

	local kk = 0
	for k, v in ipairs(player.GetAll()) do
		if !v:IsOTA() or v == client then continue end

		kk = kk + 1

		draw.SimpleText(v:Name() .. " / " .. v:Health() .. "% ::>", "BudgetLabel", ScrW() / 1.075, ScrH() / 7.8 + (kk * 20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, 1)
	end

	local col = Color( 9, 158, 156, 255 )

	draw.SimpleText("HEALTH: " .. client:Health() .. "%", "BudgetLabel", ScrW() / 1.9, ScrH() / 20, col, TEXT_ALIGN_LEFT, 1 )
	draw.SimpleText("BLOOD LEVEL: " .. math.Round((100 * (client:GetCharacter():GetBlood() / 5000)))  .. "%", "BudgetLabel", ScrW() / 2.5, ScrH() / 20, col, TEXT_ALIGN_LEFT, 1 )
	draw.SimpleText("RADIATION LEVEL: " .. math.Round((100 * (client:GetCharacter():GetRadLevel() / 1000)))  .. "%", "BudgetLabel", ScrW() / 2.5, ScrH() / 20 + 15, col, TEXT_ALIGN_LEFT, 1 )
	draw.SimpleText("STAMINA: " ..math.Round((100 * (client:GetLocalVar("stm") / client:GetCharacter():GetMaxStamina()))).."%", "BudgetLabel", ScrW() / 3.5, ScrH() / 28, col, TEXT_ALIGN_LEFT, 1 )
	local shock = math.Round((100 * (client:GetCharacter():GetShock() / client:GetCharacter():GetBlood())))
	draw.SimpleText("SHOCK: " ..shock  .. "%", "BudgetLabel", ScrW() / 1.5, ScrH() / 28, col, TEXT_ALIGN_LEFT, 1 )

	for k, v in pairs(self.playercombineOverlays) do
		if ( v.time <= CurTime( ) ) then
			v.a = Lerp( 0.06, v.a, 0 )
			
			if ( math.Round( v.a ) <= 0 ) then
				table.remove( self.playercombineOverlays, k )
			end
		else
			v.a = Lerp( 0.06, v.a, 100 )
		end
		
		v.y = Lerp( 0.06, v.y, ( y + 20 ) + ( k * 20 ) )
		
		if ( v.textTime <= CurTime( ) and v.message:utf8len( ) < v.originalMessage:utf8len( ) ) then
			local text =  v.originalMessage:utf8sub( v.textSubCount, v.textSubCount )
			
			v.message = v.message .. text
			v.textSubCount = v.textSubCount + 1
			v.textTime = CurTime( ) + v.textMakeDelay
			v.gradientW = v.gradientW + 5
		end
		
		surface.SetDrawColor( v.col.r, v.col.g, v.col.b, v.a - 130 )
		surface.SetMaterial( Material( "gui/gradient" ) )
		--surface.DrawTexturedRect( x, v.y + 10, v.gradientW, 1 )

		draw.SimpleText( v.message, "BudgetLabel", x / 4, v.y, Color( v.col.r, v.col.g, v.col.b, v.a ), TEXT_ALIGN_LEFT, 1 )
	end

end

local function AutomaticCombineOverlayMessageOW() 
	local index = #self.playercombineOverlays + 1
	local randMessage = table.Random(self.combineOverlayMessageOW)
	local color = Color(255, 255, 255)
	local rank = LocalPlayer():Nick()
	
	self.playercombineOverlays[index] = {
		message = "",
		a = 55,
		y = 20 + ((index + 1) * 20),
		time = CurTime() + 8,
		textTime = CurTime(),
		textMakeDelay = 0.005,
		textSubCount = 1,
		gradientW = 0,
		originalMessage = "     " .. randMessage,
		col = color
	}
end

local nextCombineOverlay = CurTime()
hook.Add("Think", "Overwatch", function()
	if !LocalPlayer():IsOTA() then
		return
	end

	if !LocalPlayer():Alive() then
		return
	end
	
	local ct = CurTime()

	if nextCombineOverlay <= ct then
		AutomaticCombineOverlayMessageOW()
		nextCombineOverlay = ct + 2.5
	end
end)

local colr = 255
local colg = 255
local colb = 255
local ct = CurTime()
local scrW, scrH = ScrW(), ScrH()

hook.Add("HUDPaint", "Overwatch", function()
	if !LocalPlayer():IsOTA() then
		return
	end

	if !LocalPlayer():Alive() then
		return
	end

	ct = CurTime()
	scrW, scrH = ScrW(), ScrH()

 	self.overwatchHUDData = self.overwatchHUDData or { }

	for i = 1, 100 do
		self.overwatchHUDData[i] = self.overwatchHUDData[i] or {
			w = 0,
			targetW = math.random(1, 50),
			a = math.Rand(0, 5)
		}
		
		local data = self.overwatchHUDData[i]

		data.w = Lerp(0.01, data.w, data.targetW + (10 / 1) * math.sin(ct + math.Rand(0, 2)))
		
		self.overwatchHUDData[ i ] = data
		
		local h = scrH * 0.02 + (scrH * (i / 100))
		
		draw.RoundedBox(0, 0, h, data.w, 5, Color(colr, colg, colb, math.abs(math.sin(ct * 0.5) + 2 ) * 3))
		draw.RoundedBox(0, scrW - data.w, h, data.w, 5, Color(colr, colg, colb, math.abs(math.sin(ct * 0.5) + 2 ) * 3))
	end 

	DrawCombineOverlay(0, 0)
end)
