local PANEL = {}
local frame = Material('cellar/main/tab/charactercard360x585.png')

surface.CreateFont("cellar.charname", {
	font = "Nagonia",
	extended = true,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.charname.blur", {
	font = "Nagonia",
	extended = true,
	size = 18,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

function PANEL:Init()
	--self.BaseClass.SetText(self, "")
    --self:SetTitle('')
    --self:ShowCloseButton(false)
    if IsValid(test222) then
        test222:Remove()
    end
    test222 = self

    local parent = self:GetParent()
	local frameH, frameW, animTime, animDelay, animEase = 360, 585, .5, .1, .1
	self:Center()
	local isAnimating = true
	self:SetSize(360, 0)
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
	self.Think = function(me)
		if isAnimating then
		me:Center()
		end
	end
    self:MoveToFront()

    self.textparent = self:Add('Panel')
    self.textparent:SetSize(181, 21)
    self.textparent:SetPos(92, 12)
    self.textparent.Paint = function(me, w, h)
        local slider = TimedSin(.2, 181/2, 181*2, 0)
        draw.SimpleText("TEXT TEXTOVICH", 'cellar.charname.blur', slider, 11, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("TEXT TEXTOVICH", 'cellar.charname', slider, 11, Color(56, 207, 248, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

end

function PANEL:Paint(w, h)

	surface.SetFont("cellar.main.btn")

    surface.SetDrawColor(color_white)
    surface.SetMaterial(frame)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText('12345', 'cellar.charname.blur', 45, 93, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText('12345', 'cellar.charname', 45, 93, Color(56, 207, 248, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function PANEL:Remove()
    test222:Center()
    self:SizeTo(360, 0, .5, .1, .1)
end

vgui.Register("cellar.charactercard", PANEL, "Panel")



function test()
    vgui.Create('cellar.charactercard')
end

function testremove()
    test222:Remove()
end

concommand.Add('test111', test)
concommand.Add('test222', testremove)


PANEL = {}
function PANEL:Init()
    local cross = Material('cellar/main/tab/crosshovered.png')
    if IsValid(Jopa) then
        Jopa:Remove()
    end
    Jopa = self
    self:Center()
    self:SetSize(360, 585)
    self:SetPos(ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2)
    self:MakePopup()


    self.invisibleframe = self:Add('cellar.charactercard')
    self.invisibleframe:SetPos(0, 0)
    self.invisibleframe:SetSize(360, 585)
    --self.invisibleframe.Paint = function(self, w, h)
    --end

    self.slider = self:Add("ixSlider")
	self.slider:Dock(FILL)
    self.slider.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, color_black)
    end

    local testmodel = vgui.Create('ixModelPanel', self.invisibleframe)
    testmodel:Center()
    testmodel:SetPos(-110, 10)
    testmodel:SetSize(360 * 1.6, 585)
    testmodel:SetModel(LocalPlayer():GetModel())

    local remove = self.invisibleframe:Add('DButton')
    remove:SetPos(0, 0)
    remove:SetText('')
    remove:SetSize(32, 32)
    remove.Paint = function(me, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(cross)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    remove.DoClick = function()
        Jopa:Remove()
    end
end

vgui.Register('Jopa', PANEL, "Panel")




function testtt()
    vgui.Create('Jopa')
end

concommand.Add('Jopa', testtt)