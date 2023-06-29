
local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character)
	local height = character:GetHeight()

	client:SetHeight(height)
end

ix.char.RegisterVar("height", {
	field = "height",
	fieldType = ix.type.number,
	default = 1,
	index = 4,
	OnSet = function(character, value)
		local client = character:GetPlayer()

		if (IsValid(client) and client:GetCharacter() == character) then
			local rangeMin, rangeMax = unpack(PLUGIN.gendersHeight[character.GetGender and character:GetGender() or 1])

			if (value < rangeMin or value > rangeMax) then
				value = math.Clamp(value, rangeMin ,rangeMax)
			end

			client:SetHeight(value)
		end

		character.vars.height = value
	end,
	OnValidate = function(_, value, payload)
		if (!value) then
			return 1
		end

		if (!isnumber(value)) then
			return false, "unknownError"
		end

		local rangeMin, rangeMax = unpack(PLUGIN.gendersHeight[payload.gender or 1])

		if (value < rangeMin or value > rangeMax) then
			return false, "unknownError"
		end
	end
})

do
	local playerMeta = FindMetaTable("Player")

	function playerMeta:SetHeight(height)
		self:SetModelScale(height, .000001)

		timer.Simple(.1, function()
			if (self) then
				local headBone = self:LookupBone("ValveBiped.Bip01_Head1")
				local offset, crouchOffset

				if (headBone) then
					offset = self:GetBonePosition(headBone)
					offset = self:WorldToLocal(offset).z + 1

					if (!self:IsFemale()) then
						offset = offset + 1
					end
				else
					local modelRadius = self:GetModelRadius() - 6

					if (self:IsFemale()) then
						modelRadius = modelRadius - 2
					end

					offset = modelRadius * height
				end

				crouchOffset = offset * 0.5

				self:SetViewOffset(Vector(0, 0, offset))
				self:SetViewOffsetDucked(Vector(0, 0, crouchOffset))
			end
		end)
	end
end
