PLUGIN.name = "NPC Relations"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = "Allows easy setting of NPC relations."

if SERVER then
	function PLUGIN:OnEntityCreated(entity)
		if entity:IsNPC() then
			for _, client in pairs(player.GetAll()) do
				local character = client:GetCharacter()

				if (character) then
					local faction = ix.faction.indices[character:GetFaction()]

					if (faction and faction.npcRelations) then
						entity:AddEntityRelationship(client, faction.npcRelations[entity:GetClass()] or D_HT, 0)
					end
				end
			end
		end
	end

	function PLUGIN:PlayerSpawn(client)
		local character = client:GetCharacter()

		if character then
			local faction = ix.faction.indices[character:GetFaction()]
			local relations = faction.npcRelations

			if relations then
				for _, entity in pairs(ents.GetAll()) do
					if (entity:IsNPC() and relations[entity:GetClass()]) then
						entity:AddEntityRelationship(client, relations[entity:GetClass()], 0)
					end
				end
			else
				for _, entity in pairs(ents.GetAll()) do
					if (entity:IsNPC()) then
						entity:AddEntityRelationship(client, D_HT, 0)
					end
				end
			end
		end
	end
end
