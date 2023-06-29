ITEM.name = "Rad Checker"
ITEM.PrintName = "iRadChecker"
ITEM.category = "categoryMedical"
ITEM.model = Model("models/Items/car_battery01.mdl")
ITEM.description = "iRadCheckerDesc"

function ITEM:Check(user, target)
	--local medical = Clockwork.attributes:Fraction(player, ATB_MEDICAL, 100)
	--if medical >= 50 then
		local rad = "unknown"
		if target:GetCharacter() then
			if target:GetPos():DistToSqr(user:GetPos()) < (55*55) then
				rad = math.Round(target:GetCharacter():GetRadLevel(), 2)

				user:NotifyLocalized("radCheckNotify", target:GetName(), rad)
			end
		end
	--else
	--	user:NotifyLocalized(user, "noMedicalSkills")
	--end

	return false
end

ITEM.functions.Use = {
	name = "use",
	OnRun = function(item)
		item:Check(item.player, item.player)

		return false
	end,
	OnCanRun = function(item)
		return item.bBeingUsed
	end
}

ITEM.functions.UseOn = {
	name = "useon",
	OnRun = function(item)
		local client = item.player

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:GetCharacter()) then
			item.bBeingUsed = true

			client:SetAction("@radChecker", 2)
			client:DoStaredAction(target, function()
				item:Check(client, target)
			end, 2, function()
				client:SetAction()

				item.bBeingUsed = false
			end)
		else
			client:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) or item.bBeingUsed
	end
}