PLUGIN.name = "Holstered Weapons"
PLUGIN.author = "Black Tea. Ported to Helix by LegendSMEfire aka KINGXIII edited for Cellar Project by Vintage Thief"
PLUGIN.desc = "Shows holstered weapons on players."

ix.config.Add(
	"showHolsteredWeps",
	true,
	"Whether or not holstered weapons show on players.",
	nil,
	{category = PLUGIN.name}
)

if (SERVER) then return end

-- To add your own holstered weapon model, add a new entry to HOLSTER_DRAWINFO
-- in *your* code (not here) where the key is the weapon class and the value
-- is a table that contains:
--   1. pos: a vector offset
--   2. ang: the angle of the model
--   3. bone: the bone to attach the model to
--   4. model: the model to show
HOLSTER_DRAWINFO = HOLSTER_DRAWINFO or {}

HOLSTER_DRAWINFO["arccw_uspmatch"] = {
	pos = Vector(4, -7, 2),
	ang = Angle(0, 90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_pistol.mdl"
}
HOLSTER_DRAWINFO["arccw_traumapistol"] = {
	pos = Vector(4, -7, 2),
	ang = Angle(0, 90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/bordelzio/arccw/hkvp70/wmodel/w_hk_vp70.mdl"
}
HOLSTER_DRAWINFO["arccw_357"] = {
	pos = Vector(4, -7, 2),
	ang = Angle(0, 90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/tfa_mmod/w_357.mdl"
}
HOLSTER_DRAWINFO["arccw_stunstick"] ={
	pos = Vector(4, 8, 0),
	ang = Angle(15, 90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_stunbaton.mdl"
}
HOLSTER_DRAWINFO["arccw_hatchet"] ={
	pos = Vector(4, -7, 0),
	ang = Angle(90, 90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/tfa_nmrih/w_me_hatchet.mdl"
}
HOLSTER_DRAWINFO["arccw_knife"] ={
	pos = Vector(0, -7, 0),
	ang = Angle(0, 270, 90),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_knife_t.mdl"
}
HOLSTER_DRAWINFO["weapon_frag"] ={
	pos = Vector(4, -7, 2),
	ang = Angle(180, 90, 90),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/items/grenadeammo.mdl"
}
HOLSTER_DRAWINFO["arccw_crowbar"] = {
	pos = Vector(4, 8, 0),
	ang = Angle(45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_crowbar.mdl"
}
HOLSTER_DRAWINFO["arccw_ar2"] = {
	pos = Vector(4, 16, 0),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_irifle.mdl"
}
HOLSTER_DRAWINFO["arccw_ak47"] = {
	pos = Vector(4, 15, -5),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_tdon_mwak_mammal_edition.mdl"
}
HOLSTER_DRAWINFO["arccw_bo1_dragunov"] = {
	pos = Vector(6, 20, 13), -- 1 - ВПЕРЕД НАЗАД(+) 2 - ВВЕРХ-ВНИЗ(+) 3 - ВЛЕВО ВПРАВО(-)
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/c_bo1_svd.mdl"
}
HOLSTER_DRAWINFO["arccw_bo1_l96"] = {
	pos = Vector(9, 15, 10),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/c_bo1_awm.mdl"
}
HOLSTER_DRAWINFO["arccw_bo1_rpg7"] = {
	pos = Vector(4, 10, 8), -- 1 - ВПЕРЕД НАЗАД(+) 2 - ВВЕРХ-ВНИЗ(+) 3 - ВЛЕВО ВПРАВО(-)
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/c_bo1_rpg7.mdl"
}
HOLSTER_DRAWINFO["arccw_bo2_mk48"] = {
	pos = Vector(8, 15, 10),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/w_bo2_mk48.mdl"
}
HOLSTER_DRAWINFO["arccw_bo2_type95"] = {
	pos = Vector(4, 15, 10), -- 1 - ВПЕРЕД НАЗАД(+) 2 - ВВЕРХ-ВНИЗ(+) 3 - ВЛЕВО ВПРАВО(-)
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/w_bo2_type95.mdl"
}
HOLSTER_DRAWINFO["arccw_makarov"] = {
	pos = Vector(4, -7, -2), -- 1 - ВПЕРЕД НАЗАД(+) 2 - ВВЕРХ-ВНИЗ(+) 3 - ВЛЕВО ВПРАВО(-)
	ang = Angle(180, -90, 180), -- хер его знает как тут крутить, тут нет логики никакой, только рандом
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/arccw_ins2/w_makarov.mdl"
}
HOLSTER_DRAWINFO["arccw_waw_arisaka"] = {
	pos = Vector(4, 15, 10),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/w_waw_arisaka.mdl"
}
HOLSTER_DRAWINFO["arccw_waw_mosin"] = {
	pos = Vector(4, 15, 10),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/w_waw_mosin.mdl"
}
HOLSTER_DRAWINFO["arccw_spas12"] = {
	pos = Vector(4, 16, 0),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/cellar/weapons/w_shotgun.mdl"
}
HOLSTER_DRAWINFO["arccw_oden"] = {
	pos = Vector(1, 5, 1),
	ang = Angle(-45, 0, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/cod_mw2019/w_oden_mammaledition.mdl"
}
HOLSTER_DRAWINFO["arccw_m4a4"] = {
	pos = Vector(8, 15, 15),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw_go/v_rif_m4a1.mdl"
}
HOLSTER_DRAWINFO["arccw_dominator"] = {
	pos = Vector(3, 7, -7),
	ang = Angle(-45, 0, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/arccw/fml/w_volked_pkp.mdl"
}
HOLSTER_DRAWINFO["weapon_rpg"] = {
	pos = Vector(4, 24, 8),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_rocket_launcher.mdl"
}
HOLSTER_DRAWINFO["weapon_crossbow"] = {
	pos = Vector(0, -2, -2),
	ang = Angle(0, 0, 90),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_crossbow.mdl"
}
HOLSTER_DRAWINFO["arccw_smg1"] = {
	pos = Vector(3, 8, 1),
	ang = Angle(135, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/cellar/weapons/w_smg1.mdl"
}

function PLUGIN:PostPlayerDraw(client)
	if (not ix.config.Get("showHolsteredWeps")) then return end
	if (not client:GetChar()) then return end
	if (client == LocalPlayer() and not client:ShouldDrawLocalPlayer()) then
		return
	end

	local wep = client:GetActiveWeapon()
	local curClass = ((wep and wep:IsValid()) and wep:GetClass():lower() or "")

	client.holsteredWeapons = client.holsteredWeapons or {}

	-- Clean up old, invalid holstered weapon models.
	for k, v in pairs(client.holsteredWeapons) do
		local weapon = client:GetWeapon(k)
		if (not IsValid(weapon)) then
			v:Remove()
		end
	end

	-- Create holstered models for each weapon.
	for k, v in ipairs(client:GetWeapons()) do
		local class = v:GetClass():lower()
		local drawInfo = HOLSTER_DRAWINFO[class]
		if (not drawInfo or not drawInfo.model) then continue end

		if (not IsValid(client.holsteredWeapons[class])) then
			local model =
				ClientsideModel(drawInfo.model, RENDERGROUP_TRANSLUCENT)
				model:SetNoDraw(true)
			client.holsteredWeapons[class] = model
		end

		local drawModel = client.holsteredWeapons[class]
		local boneIndex = client:LookupBone(drawInfo.bone)

		if (not boneIndex or boneIndex < 0) then continue end
		local bonePos, boneAng = client:GetBonePosition(boneIndex)

		if (curClass ~= class and IsValid(drawModel)) then
			local right = boneAng:Right()
			local up = boneAng:Up()
			local forward = boneAng:Forward()	

			boneAng:RotateAroundAxis(right, drawInfo.ang[1])
			boneAng:RotateAroundAxis(up, drawInfo.ang[2])
			boneAng:RotateAroundAxis(forward, drawInfo.ang[3])

			bonePos = bonePos
				+ drawInfo.pos[1] * right
				+ drawInfo.pos[2] * forward
				+ drawInfo.pos[3] * up

			drawModel:SetRenderOrigin(bonePos)
			drawModel:SetRenderAngles(boneAng)
			drawModel:DrawModel()
		end
	end
end

function PLUGIN:EntityRemoved(entity)
	if (entity.holsteredWeapons) then
		for k, v in pairs(entity.holsteredWeapons) do
			v:Remove()
		end
	end
end

for k, v in ipairs(player.GetAll()) do
	for k2, v2 in ipairs(v.holsteredWeapons or {}) do
		v2:Remove()
	end
	v.holsteredWeapons = nil
end