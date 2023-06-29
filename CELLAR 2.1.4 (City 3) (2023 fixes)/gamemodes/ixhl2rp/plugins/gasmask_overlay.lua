local PLUGIN = PLUGIN

PLUGIN.name = "Gasmask Overlay"
PLUGIN.author = "maxxoft"
PLUGIN.description = "Simple gasmask overlay plugin."

if CLIENT then
	local function DrawMaterialOverlay()
		local char = LocalPlayer():GetCharacter()

		if char and char:HasWearedGasmask() and not char:HasVisor() then
			matOverlay = Material("gasmask/MetroMask1")

			if not matOverlay then return end

			render.UpdateScreenEffectTexture()

			matOverlay:SetInt("$ignorez", 1)

			render.SetMaterial(matOverlay)
			render.DrawScreenQuad()
		end
	end

	hook.Add("RenderScreenspaceEffects", "RenderGasmaskOverlay", DrawMaterialOverlay)
end
