AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "25mm HE"

ENT.Model = "models/Items/AR2_Grenade.mdl"

ENT.DragCoefficient = 1

ENT.Radius = 250
ENT.DamageOverride = 150

if CLIENT then
    killicon.Add( "arccw_bo1_25mm_he", "arccw/weaponicons/ubs/m203", Color( 255, 255, 255, 255 ) )
end