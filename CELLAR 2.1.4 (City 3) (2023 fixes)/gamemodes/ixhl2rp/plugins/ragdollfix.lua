local PLUGIN = PLUGIN

PLUGIN.name = "Ragdoll Fixes"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = ""

if SERVER then
	local playerMeta = FindMetaTable("Player")

	function playerMeta:CreateServerRagdoll(bDontSetPlayer)
		local entity = ents.Create("prop_ragdoll")
		entity:SetPos(self:GetPos())
		entity:SetAngles(self:EyeAngles())
		entity:SetModel(self:GetModel())
		entity:SetSkin(self:GetSkin())

		for k, v in ipairs(self:GetBodyGroups()) do
			entity:SetBodygroup(v.id, self:GetBodygroup(v.id))
		end

		entity:Spawn()

		if (!bDontSetPlayer) then
			entity:SetNetVar("player", self)
		end

		entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		entity:Activate()

		hook.Run("OnCreatePlayerServerRagdoll", self)

		local velocity = self:GetVelocity()

		for i = 0, entity:GetPhysicsObjectCount() - 1 do
			local physObj = entity:GetPhysicsObjectNum(i)

			if (IsValid(physObj)) then
				physObj:SetVelocity(velocity)

				local index = entity:TranslatePhysBoneToBone(i)

				if (index) then
					local position, angles = self:GetBonePosition(index)

					physObj:SetPos(position)
					physObj:SetAngles(angles)
				end
			end
		end

		return entity
	end
end