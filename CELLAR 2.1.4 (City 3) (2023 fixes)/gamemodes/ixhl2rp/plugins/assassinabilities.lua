local PLUGIN = PLUGIN

PLUGIN.name = "Assassin Abilities"
PLUGIN.author = "maxxoft"
PLUGIN.description = "Adds Combine Assassin special abilities."

PLUGIN.CachedMat = {}
PLUGIN.CachedSprites = {}

if SERVER then
	function PLUGIN:CloakToggle(this, client, cmd, args, argstr)
		if !IsValid(client) then print("invalid") return end
		local cloaked = client:GetNWBool("cloaked")
		if !cloaked then
			local cloakmat = Material("sprites/heatwave")
			cloakmat:SetInt("$model", 1)
			cloakmat:SetInt("$nofog", 1)
			cloakmat:SetInt("$nodecal", 1)
			cloakmat:SetInt("$bluramount", 1)
			cloakmat:SetInt("$forcerefract", 1)
			cloakmat:SetFloat("$refractamount", 0.0005)
			cloakmat:SetString("$dudvmap", "effects/fisheyelens_dudv")
			cloakmat:SetString("$normalmap", "effects/fisheyelens_normal")

			self.CachedMats[client] = client:GetMaterial()

			client:DrawShadow(false)
			client:SetMaterial("sprites/heatwave")

			local sprite = util.SpriteTrail(client, 8, Color(49, 180, 212), false, 10, 3, 1, 1 / (10 + 3), "trails/plasma.vmt")
			self.CachedSprites[client] = sprite

			client:SetNWBool("cloaked", true)
		elseif PLUGIN.CachedMats and cloaked then
			client:DrawShadow(true)
			client:SetMaterial(self.CachedMats[client])

			self.CachedSprites[client]:Remove()

			client:SetNWBool("cloaked", false)
		end
	end


	concommand.Add("cmb_cloak", PLUGIN.CloakToggle)
else
	function PLUGIN:PlayerWithinBounds(ply, target, dist)
		local distSqr = dist * dist
		return ply:GetPos():DistToSqr(target:GetPos()) < distSqr
	end

	function PLUGIN:DrawOverlay()
		-- local players = player.GetAll()

	end

end