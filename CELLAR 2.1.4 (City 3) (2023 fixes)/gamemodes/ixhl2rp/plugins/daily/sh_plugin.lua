local PLUGIN = PLUGIN

-- if daily task is done -> character:SetDailyStatus(PLUGIN.globalDailyTime)

PLUGIN.name = "Daily Tasks"
PLUGIN.author = "Vintage Thief"
PLUGIN.description = "Provides daily tasks for players."

ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("libs/sv_character.lua") -- daily tasks vars :(
ix.util.Include("daily_tasks/daily_tasks.lua") -- daily tasks base

if CLIENT then
	return
end

PLUGIN.globalDailyTime = PLUGIN.globalDailyTime or os.time()

if (SERVER) then
	function PLUGIN:PlayerLoadedCharacter(_, character)
		if character:GetDailyStatus() != PLUGIN.globalDailyTime then
			--
		end
	end
end