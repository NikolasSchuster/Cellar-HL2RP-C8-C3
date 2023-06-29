local PLUGIN = PLUGIN
ITEM.name = "Kasseta Base";
ITEM.model = "models/Items/car_battery01.mdl";
ITEM.path = "music/HL2_song23_SuitSong3.mp3"
ITEM.description = "Вполне обычная кассета, что бы на ней было...";
ITEM.category = "Кассеты"
ITEM.duration = 60
ITEM.IsKasseta = true

function ITEM:GetPath()
    return self.path
end

function ITEM:GetDuration()
    return self.duration
end