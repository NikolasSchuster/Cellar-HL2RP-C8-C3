local PLUGIN = PLUGIN

-- Open the datafile, start the population functions. Restricted: means it is limited.
netstream.Hook("CreateRestrictedDatafile", function(target, GenericData, DataFile, Data)
	if (!IsValid(PLUGIN.Datafile)) then
		PLUGIN.GUI = vgui.Create("cwRestrictedDatafile")
	end

	PLUGIN.GUI:SetPlayer(target)
		PLUGIN.GUI.Data = Data
		PLUGIN.GUI.GenericData = GenericData
		PLUGIN.GUI.DataFile = DataFile
	PLUGIN.GUI:Rebuild()
end)

-- Create the full datafile.
netstream.Hook("CreateFullDatafile", function(target, GenericData, DataFile, Data)
	if (!IsValid(PLUGIN.GUI)) then
		PLUGIN.GUI = vgui.Create("cwFullDatafile")
	end

	PLUGIN.GUI:SetPlayer(target)
		PLUGIN.GUI.Data = Data
		PLUGIN.GUI.GenericData = GenericData
		PLUGIN.GUI.DataFile = DataFile
	PLUGIN.GUI:Rebuild()
end)

-- Management panel, for removing entries.
netstream.Hook("CreateManagementPanel", function(target, Datafile)
	if (!IsValid(PLUGIN.Managefile)) then
		PLUGIN.Managefile = vgui.Create("cwDfManageFile")
	end

	PLUGIN.Managefile:SetPlayer(target)
	PLUGIN.Managefile:PopulateEntries(Datafile)
end)

netstream.Hook("AddDatafileEntry", function(data)
	if (IsValid(PLUGIN.GUI)) then
		table.insert(PLUGIN.GUI.DataFile, data) PLUGIN.GUI:Rebuild()
	end
end)

netstream.Hook("RemoveDatafileEntry", function(data)
	if (IsValid(PLUGIN.GUI)) then
		local key = data[1]
		local date = data[2]
		local category = data[3]

		if (PLUGIN.GUI.DataFile[key] and PLUGIN.GUI.DataFile[key].date == date and PLUGIN.GUI.DataFile[key].category == category) then
			table.remove(PLUGIN.GUI.DataFile, key) PLUGIN.GUI:Rebuild()
		end
	end
end)

netstream.Hook("RefreshDatafile", function(generic, data, data2)
	if (IsValid(PLUGIN.GUI)) then
		PLUGIN.GUI.Data = data2
		PLUGIN.GUI.GenericData = generic
		PLUGIN.GUI.DataFile = data
		PLUGIN.GUI:Rebuild()
	end
end)

net.Receive("PopulateDatafilePoints", function(length)
	local points = net.ReadInt(16)

	if (IsValid(PLUGIN.GUI)) then
		PLUGIN.GUI:PopulatePoints(points)
	end
end)
