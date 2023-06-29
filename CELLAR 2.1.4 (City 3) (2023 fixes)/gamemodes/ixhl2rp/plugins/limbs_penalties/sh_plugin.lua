
local PLUGIN = PLUGIN

PLUGIN.name = "Limbs Penalties"
PLUGIN.author = "LegAz"
PLUGIN.description = "Add penalties to (almost) every limb when they're damaged."

function PLUGIN:GetLimbsDamage(client, bFraction, ...)
	local character = client:GetCharacter()
	local limbs = {...}

	if (character) then
		for k, v in ipairs(limbs) do
			local limbDamage = character:GetLimbDamage(v, bFraction)

			if (limbDamage > 0) then
				limbs[k] = limbDamage
			end
		end
	end

	return limbs
end

ix.util.Include("sh_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
