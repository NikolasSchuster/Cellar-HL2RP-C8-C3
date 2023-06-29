-------------------
-- General Settings
-------------------
-- What should we multiply fall damage by while prone. Set to 1 to disable.
prone.config.FallDamageMultiplier = 1.75


-----------------------
-- Key-related settings
-----------------------
-- NOTICE:	Every setting in this section can later be changed
--			by the user with the "prone_config" command.

-- By default is the bind key enabled.
prone.config.DefaultBindKey_Enabled = true

-- What is the default bind key set by the server.
-- See http://wiki.garrysmod.com/page/Enums/KEY
prone.config.DefaultBindKey = KEY_LCONTROL

-- By default should the player double tap the bind key to go prone.
prone.config.DefaultBindKey_DoubleTap = true

-- By default can the user press the jump key to get up.
prone.config.DefaultJumpToGetUp = true

-- By default must the user double press the jump key to get up.
prone.config.DefaultJumpToGetUp_DoubleTap = false


--------------
-- Move speeds
--------------
-- How fast they move while prone.
prone.config.MoveSpeed = 50

-- How fast they move while getting up or going down.
prone.config.TransitionSpeed = 0


----------------------------
-- Shooting related settings
----------------------------
-- There are no moving and shooting animations while prone so it would look like
-- players aren't shooting when they are. You probably don't want to change this to false.
prone.config.MoveShoot_Restrict = true

-- Weapons in this list can be shot while moving if the ab
prone.config.MoveShoot_Whitelist = {
	weapon_physgun			= true,
	weapon_physcannon		= true,		-- Gravity Gun
	gmod_tool				= true,		-- Toolgun
	gmod_camera				= true,
	weapon_medkit			= true,
	weaponchecker			= true,		-- (DarkRP)
	keys					= true,		-- (DarkRP)
	pocket					= true,		-- (DarkRP)
	weapon_keypadchecker	= true,		-- (DarkRP)
	unarrest_stick			= true,		-- (DarkRP)
	arrest_stick			= true,		-- (DarkRP)
	weapon_zm_carry			= true,		-- (TTT) Magneto Stick
	weapon_ttt_binoculars	= true,		-- (TTT)
	weapon_ttt_unarmed		= true		-- (TTT)
}

--------------------
-- Advanced Settings
--------------------
-- Sets the hull height while prone. What you can fit under.
prone.config.HullHeight = 24

-- Sets how low the player's view will be while prone.
prone.config.View = Vector(0, 0, 20)

prone.animations.gettingdown = "pronedown_stand"
prone.animations.gettingup = "proneup_stand"
prone.animations.passive = "pwalk_normal"

-- These two are not in use right now.
prone.animations.gettingdown_crouch = "pronedown_crouch"
prone.animations.gettingup_crouch = "proneup_crouch"

prone.animations.WeaponAnims = {}