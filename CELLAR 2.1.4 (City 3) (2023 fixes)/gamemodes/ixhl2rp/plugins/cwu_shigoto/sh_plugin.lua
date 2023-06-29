local PLUGIN = PLUGIN

PLUGIN.name = "CWU Shigoto"
PLUGIN.author = "Vintage Thief"
PLUGIN.description = "Plugin allows citizens with a certain flag (apllied for a job at CWU) to interact with city infrastructure and support it."

ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")
--ix.util.Include("sv_hooks.lua") ПОСЛЕ ТЕСТОВ

PLUGIN.qte_numbers = {"1", "2", "3", "4", "5"}

PLUGIN.safe_tokens = {
	["tokens"] = math.random(25, 50) -- я тут подумаю, тут не трогать пока
}