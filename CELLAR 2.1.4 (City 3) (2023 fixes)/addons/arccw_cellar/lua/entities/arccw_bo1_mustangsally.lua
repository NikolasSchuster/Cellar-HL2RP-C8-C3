AddCSLuaFile()

ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "1911 PAP Ammo (BO1)"

ENT.Model = "models/weapons/arccw/item/bo1_40mm.mdl"
ENT.Damage = 700
ENT.Radius = 150
ENT.Gravity = false
ENT.Lift = 0

if CLIENT then
    killicon.Add( "arccw_bo1_mustangsally", "arccw/weaponicons/arccw_bo1_m1911", Color( 255, 255, 255, 255 ) )
end