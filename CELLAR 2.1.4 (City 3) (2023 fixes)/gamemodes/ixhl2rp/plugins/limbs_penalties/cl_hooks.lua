
-- blur clients screen if head is hurt
function PLUGIN:RenderScreenspaceEffects()
	local client = LocalPlayer()

	if (client:GetMoveType() != MOVETYPE_NOCLIP) then
		local hDamageFraction = self:GetLimbsDamage(client, true, "head")[1]

		if (isnumber(hDamageFraction)) then
			DrawMotionBlur(0.1, 1 * hDamageFraction, 0.01)
		end
	end
end

-- replicate prone enter on client
net.Receive("ixLimbsPenaltiesProne", function()
	prone.Enter(LocalPlayer())
end)
