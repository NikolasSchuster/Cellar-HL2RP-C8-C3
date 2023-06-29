local PLUGIN = PLUGIN

PLUGIN.name = "Outlands Warfare"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

do
	local META = FindMetaTable("Player")

	function META:InOutlands()
		return self:GetLocalVar("inOutlands", false)
	end
end

if SERVER then
	function PLUGIN:InitPostEntity()
		if game.GetMap() == "rp_cellar_city8" then
			local zone = ents.Create("outland_zone")
			zone:Spawn()
			zone:SetupZone(Vector(-1922, 164, -655), Vector(-11974, -15409, 1135))
		end
	end

	function PLUGIN:SaveData()
		local data = {}

		for _, v in ipairs(ents.FindByClass("tier1_loot")) do
			data[#data + 1] = {
				"tier1_loot",
				v:GetPos(),
				v:GetAngles(),
				v:GetModel()
			}
		end

		for _, v in ipairs(ents.FindByClass("tier2_loot")) do
			data[#data + 1] = {
				"tier2_loot",
				v:GetPos(),
				v:GetAngles(),
				v:GetModel()
			}
		end

		self:SetData(data)
	end

	function PLUGIN:LoadData()
		local data = self:GetData()

		if data then
			for _, v in ipairs(data) do
				local entity = ents.Create(v[1])
				entity:SetPos(v[2])
				entity:SetAngles(v[3])
				entity:Spawn()
				entity:SetModel(v[4])

				local physObject = entity:GetPhysicsObject()

				if (IsValid(physObject)) then
					physObject:EnableMotion(false)
				end
			end
		end
	end
else
	local staticMat = CreateMaterial("outlandnoise", "UnlitGeneric", {
		["$basetexture"] = "vgui/grain",
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
		["$additive"] = 1,
		["Proxies"] = {
			["AnimatedTexture"] = {
				["animatedtexturevar"] = "$basetexture",
				["animatedtextureframenumvar"] = "$frame",
				["animatedtextureframerate"] = "20"
			},
		}
	})

	local alpha = 0
	function PLUGIN:HUDPaint()
		if LocalPlayer():InOutlands() then
			alpha = Lerp(FrameTime(), alpha, 4)
		else
			alpha = Lerp(FrameTime(), alpha, 0)
		end

		if alpha <= 0 then
			return
		end

		local w, h = ScrW(), ScrH()

		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(staticMat)

		for i = 1, 3 do
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end