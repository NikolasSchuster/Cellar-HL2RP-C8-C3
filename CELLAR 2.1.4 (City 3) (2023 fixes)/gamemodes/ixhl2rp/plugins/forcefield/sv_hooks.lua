local PLUGIN = PLUGIN

function PLUGIN:OnPlayerCorpseCreated(client, ragdoll)
	if IsValid(ragdoll) and client:GetNetVar("dissolve") then
		ragdoll:Remove()
	end
end