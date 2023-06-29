local PLUGIN = PLUGIN

ITEM.name = "Paper"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "iPaperDesc"
ITEM.isPaper = true
ITEM.bAllowMultiCharacterInteraction = true

function ITEM:GetDescription()
	return self:GetData("O", 0) == 0 and L("iPaperDesc") or L("iPaperDesc2")
end

function ITEM:GetTitle()
	return self:GetData("C", "")
end

if CLIENT then
	function ITEM:PopulateTooltip(tooltip)
		local uses = tooltip:AddRowAfter("rarity")
		uses:SetText(L("iPaperTitle", self:GetTitle()))
	end
else
	function ITEM:CanTransfer(oldInv, targetInv)
		if targetInv and targetInv.GetOwner then
			local pickup = self:GetData("D", false)
			local owned = self:GetData("O", 0)

			if owned != 0 and pickup then
				local client = targetInv:GetOwner()
				
				if client then
					local character = client:GetCharacter()

					if !client:IsAdmin() and character:GetID() != owned then
						return false
					end
				end
			end
		end
	end

	function ITEM:OnEntityCreated(entity)
		timer.Simple(0, function()
			--local text = ""
			local data = table.Copy(entity:GetNetVar("data", {}))
			--text = data["T"] or ""

			data["T"] = nil

			entity:SetNetVar("data", data)

			--self:SetData("T", text, false, false, true)
		end)
	end
end

function ITEM:Write(title, text, character)
	if title then
		title = tostring(title):sub(1, PLUGIN.maxTitleLength)

		self:SetData("C", title)
	end

	text = tostring(text):sub(1, PLUGIN.maxLength)
	
	self:SetData("T", text, false, false, true)

	if character then
		self:SetData("O", character and character:GetID() or 0)
	end
end

ITEM.functions.View = {
	name = "iPaperUse",
	OnRun = function(item)
		local obj = ix.item.instances[item:GetID()]
		local text = obj:GetData("T", "")

		item.user = item.user or {}
		item.user[item.player] = true
		netstream.Start(item.player, "ixOpenPaper", item:GetID(), text, item:GetData("C", ""), false)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("O", 0)

		return owner != 0
	end
}

ITEM.functions.Write = {
	name = "iPaperUse2",
	OnRun = function(item)
		local obj = ix.item.instances[item:GetID()]
		local text = obj:GetData("T", nil)

		item.user = item.user or {}
		item.user[item.player] = true
		netstream.Start(item.player, "ixOpenPaper", item:GetID(), text, item:GetData("C", nil), true)
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("O", 0)
		local time = item:GetData("canEdit", nil)

		return (time and time > os.time()) or owner == 0
	end
}

