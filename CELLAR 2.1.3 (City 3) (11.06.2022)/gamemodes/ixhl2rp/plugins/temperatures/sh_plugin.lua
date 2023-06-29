local PLUGIN = PLUGIN

PLUGIN.name = "Temperatures"
PLUGIN.author = "maxxoft"
PLUGIN.description = "Temperatures system based on areas plugin."


ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

-- HUD --
ix.util.Include("sh_functionality.lua")
---------


ix.config.Add("tempTickTime", 6, "How many seconds between each time a character's body temperature is calculated.", function(_, new)
	for _, client in ipairs(player.GetAll()) do
		ix.plugin.Get("temperatures"):SetupTempTimer(client)
	end
end, {
	data = {min = 1, max = 24},
	category = "temperature"
})

ix.command.Add("SetAreaTemperature", {
	OnRun = function(self, client, areaType, temperature, name)
		PLUGIN:SetAreaTemperature(areaType, temperature, name)
		return "Температура для " .. areaType .. " была изменена."
	end,
	arguments = {
		ix.type.string,
		ix.type.number,
		bit.bor(ix.type.string, ix.type.optional)
	},
	privilege = "Edit Area Temperature",
	superAdminOnly = true
})

ix.char.RegisterVar("temperature", {
	field = "temperature",
	fieldType = ix.type.number,
	default = 37.2,
	isLocal = true,
	bNoDisplay = true
})

function PLUGIN:SetupAreaProperties()
	ix.area.AddType("temperature_controlled")
	ix.area.AddType("temperature_natural")
	ix.area.AddType("temperature_indoors")
	ix.area.AddType("temperature_indoors_loyal")
	ix.area.AddType("temperature_underground")
	ix.area.AddType("temperature_nexus")

	ix.area.AddProperty("temperature", ix.type.number, 10)
end

function PLUGIN:SetAreaTemperature(areaType, temperature, name)
	if not temperature then return end
	if not areaType and not name then return end

	if areaType:lower() == "global" then
		self.globalTemp = temperature
	end

	if isstring(name) then
		if not ix.area.stored[name] then return end
		ix.area.stored[name].properties.temperature = temperature
		return
	end

	for _, area in pairs(ix.area.stored) do
		if area.type == areaType then
			area.properties.temperature = temperature
		end
	end
end
