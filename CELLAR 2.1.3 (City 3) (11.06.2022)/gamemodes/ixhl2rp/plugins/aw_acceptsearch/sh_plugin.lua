local PLUGIN = PLUGIN

PLUGIN.name = "Accept Search"
PLUGIN.author = "Alan Wake"
PLUGIN.description = "Adds a accept permission to search the character without zit tie"

ix.util.Include("sv_plugin.lua")

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
        if (client:IsRestricted()) then
            return "@notNow"
        end
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity
        if !IsValid(target) or !target:IsPlayer() then
            return
        end
		if (target:IsRestricted()) then
			Schema:SearchPlayer(client, target)
			return "Вы обыскали персонажа"
		end
        PLUGIN:OnSearchWithoutZipTie(client,target)
	end

	ix.command.Add("CharSearch", COMMAND)
end
if CLIENT then
    local PANEL = {}
    local callback = function(this)
        local par = this:GetParent()
        par:AlphaTo(0,.75,0,function()
            par:Remove()
        end)
        netstream.Start("aw_AcceptSearch", this == par.accept)
    end
    function PANEL:Init()
        self:SetSize(ScrW(),ScrH())
        self:MakePopup()
        self:SetPos(0,0)
        self:SetAlpha(0)
        self:AlphaTo(255,2)

        self.Paint = function(this,w,h)
            -- ix.util.DrawBlur(self,7)
            derma.SkinFunc("PaintMenuBackground", self, w, h, 1)
            local color = {Color(56, 207, 248),Color(56, 61, 248, 225)}
            local w2,h2 = w/2-200,h/2-30
            surface.SetFont("cellar.f3.btn.blur")
            surface.SetTextColor(color[2])
            surface.SetTextPos(w2,h2)
            surface.DrawText("Персонаж "..self:GetData().." хочет обыскать Вас", true)

            surface.SetFont("cellar.f3.btn")
            surface.SetTextColor(color[1])
            surface.SetTextPos(w2,h2)
            surface.DrawText("Персонаж "..self:GetData().." хочет обыскать Вас", true)
        end
        self.OnMouseReleased = function(this)
            self.decline:DoClick()
        end

        self.accept = self:Add("cellar.f3.btn")
        self.accept:SetPos(ScrW()/2-200,ScrH()/2)
        self.accept:SetSize(240,40)
        self.accept:SetText("Разрешить")
        self.accept.DoClick = callback

        self.decline = self:Add("cellar.f3.btn")
        self.decline:SetPos(ScrW()/2-200,ScrH()/2+45)
        self.decline:SetSize(240,40)
        self.decline:SetText("Отклонить")
        self.decline.DoClick = callback
    end
    function PANEL:OnRemove()
        netstream.Start("aw_AcceptSearch")
    end
    function PANEL:SetData(data)
        self.data = data
    end
    function PANEL:GetData()
        return self.data and self.data:Name() or ""
    end
    vgui.Register("aw_AcceptSearch",PANEL,"DPanel") 

    netstream.Hook("aw_AcceptSearch",function(data)
        vgui.Create("aw_AcceptSearch"):SetData(data)
    end)
end