AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "Tishina Grenade"

ENT.Model = "models/weapons/arccw/item/bo1_30mm.mdl"

ENT.DragCoefficient = 0.1

ENT.Radius = 350
ENT.DamageOverride = 150

if CLIENT then
    killicon.Add( "arccw_bo1_tishina_he", "arccw/weaponicons/ubs/gp25", Color( 255, 255, 255, 255 ) )
end