AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "40mm HE"

ENT.Model = "models/weapons/arccw/item/bo1_40mm.mdl"

ENT.Radius = 300
ENT.DamageOverride = 200

if CLIENT then
    killicon.Add( "arccw_bo1_m203_he", "arccw/weaponicons/ubs/m203", Color( 255, 255, 255, 255 ) )
end