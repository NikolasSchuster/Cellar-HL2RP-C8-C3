
local PLUGIN = PLUGIN

PLUGIN.aparts = "N/A"
PLUGIN.nRecords = 0
PLUGIN.cRecords = 0
PLUGIN.mRecords = 0
PLUGIN.status = "N/A"

net.Receive("ixTerminalResponse", function(len)
	local notes = net.ReadUInt(10)
	local civicrecords = net.ReadUInt(10)
	local medrecords = net.ReadUInt(10)
	local aparts = net.ReadString()
	local status = net.ReadString()

	if (isnumber(notes)) then
		PLUGIN.nRecords = notes
	end

	if (isnumber(civicrecords)) then
		PLUGIN.cRecords = civicrecords
	end

	if (isnumber(medrecords)) then
		PLUGIN.mRecords = medrecords
	end

	if (isstring(aparts)) then
		PLUGIN.aparts = aparts
	end
	
	if (isstring(status)) then
		PLUGIN.status = status
	end
end)