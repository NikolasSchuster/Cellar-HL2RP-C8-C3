--DEFINE_BASECLASS("DFrame")
local PANEL = {}
local frame = Material('cellar/main/tab/frameborder.png')
function PANEL:Init()
	--self.BaseClass.SetText(self, "")
    --self:SetTitle('')
    --self:ShowCloseButton(false)

    local parent = self:GetParent()
	self.closing = false
	local frameH, frameW, animTime, animDelay, animEase = 1600, 900, .5, .1, .1
	self:Center()
	local isAnimating = true
	self:SetSize(1600, 0)
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
	self.Think = function(me)
		if isAnimating then
		me:Center()
		end
	end
    self:MoveToFront()

end

function PANEL:Paint(w, h)

	surface.SetFont("cellar.main.btn")

    surface.SetDrawColor(color_white)
    surface.SetMaterial(frame)
    surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:Remove()
    self:Center()
    self:SizeTo(1600, 0, .5, .1, .1)
end

vgui.Register("cellar.tab.frame", PANEL, "Panel")