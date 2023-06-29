local PLUGIN = PLUGIN
PLUGIN.name = "Levitate IT"
PLUGIN.author = "Alan Wake"
PLUGIN.description = "Adds a levitating it."

ix.command.Add("ItAdd", {
	description = "Создать ливитирующий текст на текущей позиции",
	adminOnly = true,
	arguments = {
		ix.type.text,
	},
	OnRun = function(self, client, text)
		return PLUGIN:ItAdd(client,text)
	end
})

ix.command.Add("ItRemove", {
	description = "Удалить ливитирующий текст по айди",
	adminOnly = true,
	arguments = {
		ix.type.number,
	},
	OnRun = function(self, client, num)
		return PLUGIN:ItRemove(client,num)
	end
})

ix.command.Add("ItGetAll", {
	description = "Получить все зарегистрированные Its",
	adminOnly = true,
	OnRun = function(self, client)
		return PLUGIN:ItGetAll(client)
	end
})

ix.util.Include("sv_plugin.lua")

if CLIENT then

	surface.CreateFont( "aw_ItText14", {
		font = "Arial",
		size = 14,
		weight = 500,
		outline = true,
		 shadow = true,
	})

    local function vector_obstructed(vec1, vec2, filter)
        local trace = util.TraceLine({
          	start = vec1,
          	endpos = vec2,
          	filter = filter
        })
      
        return trace.Hit
    end

	function PLUGIN:HUDPaint()

		for k, v in ipairs(GetNetVar("aw_RegisteredTexts",{})) do

			local pos = v[1]

			local ALPHA = (255 - (EyePos():Distance(pos)-150))

			local COLOR_WHITE = Color(255, 255, 255, ALPHA)

			local COLOR_BLACK = Color(0, 0, 0, 255)

			if EyePos():Distance(pos) <= 500 and (!vector_obstructed(EyePos(), pos, LocalPlayer())) then

				draw.DrawText( v[2], "aw_ItText14", pos:ToScreen().x, pos:ToScreen().y, COLOR_WHITE, TEXT_ALIGN_CENTER)

			end

		end

	end

end