AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "40mm HE"

ENT.Model = "models/weapons/arccw/item/bo1_40mm.mdl"

-- Generic grenade used by grenade launcher weapons (hence no damage)
ENT.Radius = 250

if CLIENT then
    killicon.Add( "arccw_bo1_40mm_he", "arccw/weaponicons/ubs/m203", Color( 255, 255, 255, 255 ) )
end