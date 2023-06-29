util.AddNetworkString("UpdateClassTable")
util.AddNetworkString("ClearClassTable")
util.AddNetworkString("HunterMuzzle")
util.AddNetworkString("FlashlightSwitched")

local DEFAULT_HULL = Vector(36, 36, 72)
local DEFAULT_VIEW = Vector(0, 0, 64)
local DEFAULT_VIEW_DUCK = Vector(0, 0, 28)

function PLUGIN:SetupCreatureClass(client, class, info)
	if !info then
		return
	end

	client:StripWeapons()
	client:Give("ix_creatureinput")
	client:SelectWeapon("ix_creatureinput")

	client:SetNetVar("isCreature", true)

	local hull = info.hull
	local duckBy = info.duckBy or 0

	if hull then
		client:SetStepSize(hull.z / 4)
		client:SetHull(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z))
		client:SetHullDuck(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z - duckBy or 0))
	else
		client:ResetHull()
		client:SetStepSize(18)
	end

	if info.jumpPower then
		client:SetJumpPower(info.jumpPower or 100)
	end

	if info.moveSpeed then
		client:SetWalkSpeed(info.moveSpeed.walk or 0)
		client:SetRunSpeed(info.moveSpeed.run or 0)
	end

	client:SetHealth(info.health or 100)
	client:SetMaxHealth(info.health or 100)

	if info.camera then
		client:SetViewOffset(info.camera.offset)
		client:SetViewOffsetDucked(info.camera.offset - Vector(0, 0, duckBy))
	else
		client:SetViewOffset(DEFAULT_VIEW)
		client:SetViewOffsetDucked(DEFAULT_VIEW_DUCK)
	end

	net.Start("UpdateClassTable")
		net.WriteEntity(client)
		net.WriteUInt(class, 8)
	net.Broadcast()
end

function PLUGIN:ResetCreatureClass(client)
	client.infoTable = nil
	client:SetNetVar("isCreature", nil)

	client:ResetHull()
	client:SetStepSize(18)

	client:SetViewOffset(DEFAULT_VIEW)
	client:SetViewOffsetDucked(DEFAULT_VIEW_DUCK)

	net.Start("ClearClassTable")
		net.WriteEntity(client)
	net.Broadcast()
end