PerfectCasino = {}
PerfectCasino.Config = {}
PerfectCasino.Log = {}
PerfectCasino.Translation = {}
PerfectCasino.Core = {}
PerfectCasino.Sound = {}
PerfectCasino.UI = {}
PerfectCasino.Database = {}
PerfectCasino.Cooldown = {}
PerfectCasino.Chips = {}
PerfectCasino.Cards = {}
PerfectCasino.MachineLimits = {}
if CLIENT then
	PerfectCasino.Spins = 0
else
	PerfectCasino.Spins = {}
end

print("Loading PerfectCasino")

local path = "PerfectCasino/"
if SERVER then
	resource.AddWorkshop("2228228831")
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("Loading folder:", folder)
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        AddCSLuaFile(path .. folder .. "/" .. File)
	        include(path .. folder .. "/" .. File)
	    end
	
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sv_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end
	
	    for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        AddCSLuaFile(path .. folder .. "/" .. File)
	    end
	end
end

if CLIENT then
	local files, folders = file.Find(path .. "*", "LUA")
	
	for _, folder in SortedPairs(folders, true) do
		print("Loading folder:", folder)
	    for b, File in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end

	    for b, File in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), true) do
	    	print("	Loading file:", File)
	        include(path .. folder .. "/" .. File)
	    end
	end

	-- Font was loading funny and this seems to fix it
	hook.Add("PostDrawHUD", "_pcasino_fixfonts", function()
		include(path.."derma/cl_fonts.lua") 
		hook.Remove("PostDrawHUD", "_pcasino_fixfonts")
	end)
end
print("Loaded PerfectCasino")