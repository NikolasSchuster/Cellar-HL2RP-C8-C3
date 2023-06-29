
function PLUGIN:InitializedPlugins()
	local calculationDelay = 1

	timer.Create("ixCalculateSpecialBoostsDuration", calculationDelay, 0, function()
		for _, client in ipairs(player.GetAll()) do
			local character = client:GetCharacter()

			if (character) then
				local specialBoostsDuration = character:GetSpecialBoostsDuration()

				for k, v in pairs(specialBoostsDuration) do
					local newDuration = v - calculationDelay

					if (newDuration > 0) then
						character:AttachDurationToSpecialBoost(k, newDuration)
					else
						for id, special in pairs(character:GetSpecialBoosts()) do
							for id2, boost in pairs(special) do
								if (id2 == k) then
									character:AttachDurationToSpecialBoost(id2, nil)
									character:RemoveSpecialBoost(id2, id)
								end
							end
						end
					end
				end
			end
		end
	end)
end

function PLUGIN:CharacterPreSave(character)
	local specialBoosts = character:GetSpecialBoosts()
	local saveBoosts = {}

	for id, special in pairs(specialBoosts) do
		for id2, boost in pairs(special) do
			local boostDuration = character:GetSpecialBoostDuration(id2)

			if (boostDuration) then
				saveBoosts[#saveBoosts + 1] = {["info"] ={[id] = special}, ["duration"] = boostDuration}
			end
		end
	end

	if (!table.IsEmpty(saveBoosts)) then
		character:SetData("specialBoosts", saveBoosts)
	end
end

function PLUGIN:PlayerLoadedCharacter(_, character)
	local savedBoosts = character:GetData("specialBoosts")

	if (istable(savedBoosts)) then
		local specialBoosts = {}
		local specialBoostsDuration = {}

		for k, v in ipairs(savedBoosts) do
			for id, special in pairs(v["info"]) do
				for id2, boost in pairs(special) do
					specialBoosts[id] = specialBoosts[id] or {}
					specialBoosts[id][id2] = boost

					specialBoostsDuration[id2] = v["duration"]
				end
			end
		end

		character:SetVar("specialboosts", specialBoosts)
		character:SetVar("specialBoostsDuration", specialBoostsDuration)

		character:SetData("specialBoosts")
	end
end
