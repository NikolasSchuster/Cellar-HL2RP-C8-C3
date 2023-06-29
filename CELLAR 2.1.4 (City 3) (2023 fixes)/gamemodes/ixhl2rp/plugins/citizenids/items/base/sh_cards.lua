ITEM.name = "Card Base"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.description = "A small, metallic card with a magnetic strip used for identification purposes. %s"
ITEM.isEquipment = true
ITEM.slot = 9 --EQUIP_CID
ITEM.category = "categoryCard"
ITEM.cardType = 0

CARDTYPE_NONE = 0
CARDTYPE_MED = 1
CARDTYPE_CWU = 2
CARDTYPE_UNION = 3
CARDTYPE_CITY = 4

function ITEM:GetDescription()
	return L(string.format("iCardDesc%s", self.cardType or 0), self:GetData("name", "nobody"))
end

function ITEM:GetRare()
	return self.cardType
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end

	function ITEM:PopulateTooltip(tooltip)
		local cid = self:GetData("cid")
		local number = self:GetData("number")

		if (cid) then
			local panel = tooltip:AddRowAfter("rarity", "cid")
			panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
			panel:SetText("CID: #" .. cid)
			panel:SizeToContents()
		end

		if (number) then
			local panel = tooltip:AddRowAfter("rarity", "number")
			panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
			panel:SetText("RegID: #" .. number)
			panel:SizeToContents()
		end

		if (self.cardType > 0) then
			local notice = tooltip:AddRowAfter("description", "notice")
			notice:SetMinimalHidden(true)
			notice:SetFont("ixMonoSmallFont")
			notice:SetText(L(string.format("cardNotice%s", self.cardType)))
			notice.Paint = function(_, width, height)
				surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", tooltip), 11))
				surface.DrawRect(0, 0, width, height)
			end
			notice:SizeToContents()
		end
	end
end

function ITEM:CanEquip(client, slot)
	return IsValid(client) and self:GetData("equip") != true and self.slot == slot
end

function ITEM:CanUnequip(client, slot)
	return IsValid(client) and self:GetData("equip") == true
end

function ITEM:OnEquipped(client, slot)
	self:SetData("equip", true)

	client.ixDatafile = self:GetData("datafileID", 0)

	hook.Run("OnCharacterIDCardChanged", client:GetCharacter(), client.ixDatafile)
end

function ITEM:OnUnequipped(client, slot)
	self:SetData("equip", false)

	client.ixDatafile = nil

	hook.Run("OnCharacterIDCardChanged", client:GetCharacter())
end

function ITEM:OnInstanced(invID, x, y, item)
	local inventory = ix.item.inventories[invID]

	if (inventory and inventory.owner) then
		local character = ix.char.loaded[inventory.owner]

		if (character) then
			item:SetData("name", character:GetName())
			item:SetData("cid", Schema:ZeroNumber(math.random(1, 99999), 5))
			item:SetData("number", string.format("%s-%d",
				string.gsub(math.random(100000000, 999999999), "^(%d%d%d)(%d%d%d%d)(%d%d)", "%1:%2:%3"),
				Schema:ZeroNumber(math.random(1, 99), 2)
			))
		end
	end

	item:SetData("access", self.access or {})

	hook.Run("OnIDCardInstanced", item)
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:OnUnequipped(item:GetOwner())
	end
end)

function ITEM:OnTransferred(curInv, inventory)
	if isfunction(curInv.GetOwner) then
		local owner = curInv:GetOwner()

		if IsValid(owner) and curInv.vars.isEquipment then
			self:OnUnequipped(owner)
		end
	end
end

ITEM.functions.devEdit = {
	name = "Admin Edit",
	icon = "icon16/wrench.png",
	OnClick = function(item)
		
	end,
	OnRun = function(item)
		netstream.Start(item.player, "ixCitizenIDEdit", item:GetID(), item:GetData(true))
		return false
	end,
	OnCanRun = function(item)
		return item.player:IsAdmin()
	end
}

ITEM.combine = {}
ITEM.combine.devTransfer = {
	name = "Admin Transfer Card Type",
	icon = "icon16/wrench.png",
	OnRun = function(from, to)
		local datafileID = tonumber(to:GetData("datafileID", 0))

		to:SetData("name", from:GetData("name"))
		to:SetData("cid", from:GetData("cid"))
		to:SetData("number", from:GetData("number"))
		to:SetData("datafileID", from:GetData("datafileID", 0))

		local queryObj = mysql:Delete("ix_datafiles")
			queryObj:Where("datafile_id", datafileID)
		queryObj:Execute()

		ix.plugin.list["datafile"].stored[datafileID] = nil
	end,
	OnCanRun = function(item)
		return item.player:IsAdmin()
	end
}