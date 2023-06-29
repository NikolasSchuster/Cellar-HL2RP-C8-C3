AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "Panzerschreck Rocket (WAW)"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/item/waw_panzer_rocket.mdl"

ENT.BoxSize = Vector(8, 4, 1)
ENT.Damage = 650
ENT.Radius = 250
ENT.ImpactDamage = 3000
ENT.Boost = 200
ENT.DragCoefficient = 0.15

if CLIENT then
    killicon.Add( "arccw_waw_rocket_panzer", "arccw/weaponicons/arccw_waw_panzerschreck", Color( 255, 255, 255, 255 ) )
end