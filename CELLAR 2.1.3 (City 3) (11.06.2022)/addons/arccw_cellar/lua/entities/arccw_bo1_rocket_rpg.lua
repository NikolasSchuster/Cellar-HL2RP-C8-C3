AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "RPG-7 Rocket (BO1)"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/item/bo1_rpgrocket.mdl"
ENT.BoxSize = Vector(8, 4, 1)

ENT.Damage = 250
ENT.Radius = 300
ENT.ImpactDamage = 3000

ENT.FuseTime = 0.1
ENT.Boost = 600
ENT.Lift = 80
ENT.DragCoefficient = 0.1

if CLIENT then
    killicon.Add( "arccw_bo1_rpgrocket", "arccw/weaponicons/arccw_bo1_rpg7", Color( 255, 255, 255, 255 ) )
end