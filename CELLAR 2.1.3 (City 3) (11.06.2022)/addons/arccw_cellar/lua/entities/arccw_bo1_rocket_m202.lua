AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "arccw_bo1_projectile_base"
ENT.PrintName 			= "M202 Rocket (BO1)"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/item/bo1_m202_rocket.mdl"
ENT.BoxSize = Vector(6, 4, 1)

ENT.Damage = 200
ENT.Radius = 300
ENT.ImpactDamage = nil

ENT.FuseTime = 0.1
ENT.Boost = 400
ENT.Lift = 50
ENT.DragCoefficient = 0.1

if CLIENT then
    killicon.Add( "arccw_bo1_m202rocket", "arccw/weaponicons/arccw_bo1_m202", Color( 255, 255, 255, 255 ) )
end