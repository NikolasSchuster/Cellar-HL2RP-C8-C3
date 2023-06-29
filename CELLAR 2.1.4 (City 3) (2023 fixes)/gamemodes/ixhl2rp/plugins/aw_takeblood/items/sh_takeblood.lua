local PLUGIN = PLUGIN

ITEM.name = "Пакет для крови"
ITEM.description = "Пустой пакет для крови с набором взятия новой."
ITEM.model = "models/props_rpd/medical_blood.mdl"
ITEM.category = "categoryMedical"

ITEM.functions.TakeHimBlood = {
	name = "Взять у человека",

	OnRun = function(item)
		PLUGIN:TakeBlood(item,true)
		return false
	end,

	OnCanRun = function(item)
		local ent = item.player:GetEyeTraceNoCursor().Entity
		return !item.entity and IsValid(ent) and ent:IsPlayer()
	end
}

ITEM.functions.TakeMyBlood = {
	name = "Взять у себя",

	OnRun = function(item)
		PLUGIN:TakeBlood(item)
		return false
	end,

	OnCanRun = function(item)
		return !item.entity
	end
}