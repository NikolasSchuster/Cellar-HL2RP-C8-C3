-- luacheck: globals HOLDTYPE_TRANSLATOR
HOLDTYPE_TRANSLATOR = {}
HOLDTYPE_TRANSLATOR[""] = "normal"
HOLDTYPE_TRANSLATOR["physgun"] = "smg"
HOLDTYPE_TRANSLATOR["ar2"] = "smg"
HOLDTYPE_TRANSLATOR["crossbow"] = "shotgun"
HOLDTYPE_TRANSLATOR["rpg"] = "shotgun"
HOLDTYPE_TRANSLATOR["slam"] = "normal"
HOLDTYPE_TRANSLATOR["grenade"] = "grenade"
HOLDTYPE_TRANSLATOR["fist"] = "normal"
HOLDTYPE_TRANSLATOR["melee2"] = "melee"
HOLDTYPE_TRANSLATOR["passive"] = "normal"
HOLDTYPE_TRANSLATOR["knife"] = "knife"
HOLDTYPE_TRANSLATOR["duel"] = "pistol"
HOLDTYPE_TRANSLATOR["camera"] = "smg"
HOLDTYPE_TRANSLATOR["magic"] = "normal"
HOLDTYPE_TRANSLATOR["revolver"] = "pistol"

-- luacheck: globals  PLAYER_HOLDTYPE_TRANSLATOR
PLAYER_HOLDTYPE_TRANSLATOR = {}
PLAYER_HOLDTYPE_TRANSLATOR[""] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["fist"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["pistol"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["grenade"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["melee"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["slam"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["melee2"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["passive"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["knife"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["duel"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["bugbait"] = "normal"

local PLAYER_HOLDTYPE_TRANSLATOR = PLAYER_HOLDTYPE_TRANSLATOR
local HOLDTYPE_TRANSLATOR = HOLDTYPE_TRANSLATOR
local animationFixOffset = Vector(16.5438, -0.1642, -20.5493)

local GAMEMODE = GM or GAMEMODE
function GAMEMODE:TranslateActivity(client, act)
	local clientInfo = client:GetTable()
	local modelClass = clientInfo.ixAnimModelClass or "player"
	local bRaised = client:IsWepRaised()

	clientInfo.CalcSeqOverride2 = nil

	if (modelClass == "player") then
		local weapon = client:GetActiveWeapon()
		local bAlwaysRaised = ix.config.Get("weaponAlwaysRaised")
		weapon = IsValid(weapon) and weapon or nil

		if (!bAlwaysRaised and weapon and !bRaised and client:OnGround()) then
			local model = string.lower(client:GetModel())

			if (string.find(model, "zombie")) then
				local tree = ix.anim.zombie

				if (string.find(model, "fast")) then
					tree = ix.anim.fastZombie
				end

				if (tree[act]) then
					return tree[act]
				end
			end

			local holdType = weapon and (weapon.HoldType or weapon:GetHoldType()) or "normal"

			if (!bAlwaysRaised and weapon and !bRaised and client:OnGround()) then
				holdType = PLAYER_HOLDTYPE_TRANSLATOR[holdType] or "passive"
			end

			local tree = ix.anim.player[holdType]

			if (tree and tree[act]) then
				if (isstring(tree[act])) then
					clientInfo.CalcSeqOverride2 = client:LookupSequence(tree[act])

					return
				else
					return tree[act]
				end
			end
		end

		return self.BaseClass:TranslateActivity(client, act)
	end

	if (clientInfo.ixAnimTable) then
		local glide = clientInfo.ixAnimGlide

		if (client:InVehicle()) then
			act = clientInfo.ixAnimTable[1]

			local fixVector = clientInfo.ixAnimTable[2]

			if (isvector(fixVector)) then
				client:SetLocalPos(animationFixOffset)
			end

			if (isstring(act)) then
				clientInfo.CalcSeqOverride = client:LookupSequence(act)
			else
				clientInfo.CalcSeqOverride = -1
				return act
			end
		elseif (client:OnGround()) then
			if (clientInfo.ixAnimTable[act]) then
				local act2 = clientInfo.ixAnimTable[act][bRaised and 2 or 1]

				if (isstring(act2)) then
					clientInfo.CalcSeqOverride = client:LookupSequence(act2)
				else
					clientInfo.CalcSeqOverride = -1
					return act2
				end
			end
		elseif (glide) then
			if (istable(glide)) then
				glide = glide[bRaised and 2 or 1]
			end

			if (isstring(glide)) then
				clientInfo.CalcSeqOverride = client:LookupSequence(glide)
			else
				clientInfo.CalcSeqOverride = -1
				return clientInfo.ixAnimGlide
			end
		end
	end

	if clientInfo.CalcSeqOverride2 then
		clientInfo.CalcSeqOverride = clientInfo.CalcSeqOverride2
	end
end

local function UpdatePlayerHoldType(client, weapon)
	weapon = weapon or client:GetActiveWeapon()
	local holdType = "normal"

	if (IsValid(weapon)) then
		local class = weapon:GetClass()
		local baseTable = ix.anim[client.ixAnimModelClass] or {}

		holdType = weapon.HoldType or weapon:GetHoldType()
		holdType = HOLDTYPE_TRANSLATOR[holdType] or holdType

		if baseTable and baseTable[class] then
			holdType = class or holdType
		end
	end

	client.ixAnimHoldType = holdType
end

local function UpdateAnimationTable(client, vehicle)
	local baseTable = ix.anim[client.ixAnimModelClass] or {}

	if (IsValid(client) and IsValid(vehicle)) then
		local vehicleClass = vehicle:IsChair() and "chair" or vehicle:GetClass()

		if (baseTable.vehicle and baseTable.vehicle[vehicleClass]) then
			client.ixAnimTable = baseTable.vehicle[vehicleClass]
		else
			client.ixAnimTable = baseTable.normal[ACT_MP_CROUCH_IDLE]
		end
	else
		client.ixAnimTable = baseTable[client.ixAnimHoldType]
	end

	client.ixAnimGlide = baseTable["glide"]

	if (client.ixAnimTable) then
		client.ixAnimGlide = client.ixAnimTable.glide or client.ixAnimGlide
	end
end

function GAMEMODE:PlayerWeaponChanged(client, weapon)
	UpdatePlayerHoldType(client, weapon)
	UpdateAnimationTable(client)

	if (CLIENT) then
		return
	end

	-- update weapon raise state
	if (weapon.IsAlwaysRaised or ALWAYS_RAISED[weapon:GetClass()]) then
		client:SetWepRaised(true, weapon)
		return
	elseif (weapon.IsAlwaysLowered or weapon.NeverRaised) then
		client:SetWepRaised(false, weapon)
		return
	end

	-- If the player has been forced to have their weapon lowered.
	if (client:IsRestricted()) then
		client:SetWepRaised(false, weapon)
		return
	end

	-- Let the config decide before actual results.
	if (ix.config.Get("weaponAlwaysRaised")) then
		client:SetWepRaised(true, weapon)
		return
	end

	client:SetWepRaised(false, weapon)
end

if SERVER then
	util.AddNetworkString("ixAnimEvent")
else
	net.Receive("ixAnimEvent", function()
		local a = net.ReadEntity()
		local b = net.ReadInt(32)

		a:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, b, 0, true)
	end)
end

function GAMEMODE:DoAnimationEvent(client, event, data)
	local class = client.ixAnimModelClass

	if (class == "player") then
		return self.BaseClass:DoAnimationEvent(client, event, data)
	else
		local weapon = client:GetActiveWeapon()

		if (IsValid(weapon)) then
			if SERVER then
				if event == 401 then
					net.Start("ixAnimEvent")
						net.WriteEntity(client)
						net.WriteInt(client:LookupSequence(data == 1 and "activatebaton" or "deactivatebaton"), 32)
					net.SendPVS(client:GetPos())

					return ACT_INVALID
				end
			end

			local animation = client.ixAnimTable

			if (event == PLAYERANIMEVENT_ATTACK_PRIMARY) then
				client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.attack or ACT_GESTURE_RANGE_ATTACK_SMG1, true)

				return ACT_VM_PRIMARYATTACK
			elseif (event == PLAYERANIMEVENT_ATTACK_SECONDARY) then
				client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.attack or ACT_GESTURE_RANGE_ATTACK_SMG1, true)

				return ACT_VM_SECONDARYATTACK
			elseif (event == PLAYERANIMEVENT_RELOAD) then
				client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.reload or ACT_GESTURE_RELOAD_SMG1, true)

				return ACT_INVALID
			elseif (event == PLAYERANIMEVENT_JUMP) then
				client:AnimRestartMainSequence()

				return ACT_INVALID
			elseif (event == PLAYERANIMEVENT_CANCEL_RELOAD) then
				client:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

				return ACT_INVALID
			end
		end
	end

	return ACT_INVALID
end

function GAMEMODE:PlayerModelChanged(client, model)
	client.ixAnimModelClass = ix.anim.GetModelClass(model)

	UpdateAnimationTable(client)
end

do
	local vectorAngle = FindMetaTable("Vector").Angle
	local normalizeAngle = math.NormalizeAngle

	function GAMEMODE:CalcMainActivity(client, velocity)
		local clientInfo = client:GetTable()
		local forcedSequence = client:GetNetVar("forcedSequence")

		if (forcedSequence) then
			if (client:GetSequence() != forcedSequence) then
				client:SetCycle(0)
			end

			return -1, forcedSequence
		end

		client:SetPoseParameter("move_yaw", normalizeAngle(vectorAngle(velocity)[2] - client:EyeAngles()[2]))

		local sequenceOverride = nil
		if clientInfo.CalcSeqOverride and clientInfo.CalcSeqOverride > 0 then sequenceOverride = clientInfo.CalcSeqOverride or sequenceOverride end

		clientInfo.CalcSeqOverride = -1
		clientInfo.CalcIdeal = ACT_MP_STAND_IDLE

		-- we could call the baseclass function, but it's faster to do it this way
		local BaseClass = self.BaseClass
		local length = velocity:Length2DSqr()
		if (BaseClass:HandlePlayerNoClipping(client, velocity) or
			BaseClass:HandlePlayerDriving(client) or
			BaseClass:HandlePlayerVaulting(client, velocity) or
			BaseClass:HandlePlayerJumping(client, velocity) or
			BaseClass:HandlePlayerSwimming(client, velocity) or
			BaseClass:HandlePlayerDucking(client, velocity)) then -- luacheck: ignore 542
		else
			

			if (length > 22500) then
				clientInfo.CalcIdeal = ACT_MP_RUN
			elseif (length > 0.25) then
				clientInfo.CalcIdeal = ACT_MP_WALK
			end
		end

		self:TranslateActivity(client, clientInfo.CalcIdeal)
		hook.Run("ModifyMainActivity", client, length, clientInfo)

		clientInfo.m_bWasOnGround = client:OnGround()
		clientInfo.m_bWasNoclipping = (client:GetMoveType() == MOVETYPE_NOCLIP and !client:InVehicle())

		return clientInfo.CalcIdeal, sequenceOverride or clientInfo.CalcSeqOverride or -1
	end
end

if (SERVER) then
	util.AddNetworkString("PlayerVehicle")

	function GAMEMODE:PlayerEnteredVehicle(client, vehicle, role)
		UpdateAnimationTable(client)

		net.Start("PlayerVehicle")
			net.WriteEntity(client)
			net.WriteEntity(vehicle)
			net.WriteBool(true)
		net.Broadcast()
	end

	function GAMEMODE:PlayerLeaveVehicle(client, vehicle)
		UpdateAnimationTable(client)

		net.Start("PlayerVehicle")
			net.WriteEntity(client)
			net.WriteEntity(vehicle)
			net.WriteBool(false)
		net.Broadcast()
	end
else
	net.Receive("PlayerVehicle", function(length)
		local client = net.ReadEntity()
		local vehicle = net.ReadEntity()
		local bEntered = net.ReadBool()

		UpdateAnimationTable(client, bEntered and vehicle or false)
	end)
end