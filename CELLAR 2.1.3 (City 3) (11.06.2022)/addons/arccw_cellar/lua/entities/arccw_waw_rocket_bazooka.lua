AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "Bazooka Rocket (WAW)"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/item/waw_bazooka_rocket.mdl"

ENT.BoxSize = Vector(8, 4, 1)
ENT.Damage = 500
ENT.Radius = 300
ENT.ImpactDamage = 2000
ENT.Boost = 200
ENT.DragCoefficient = 0.15

if CLIENT then
    killicon.Add( "arccw_waw_rocket_bazooka", "arccw/weaponicons/arccw_waw_bazooka", Color( 255, 255, 255, 255 ) )
end