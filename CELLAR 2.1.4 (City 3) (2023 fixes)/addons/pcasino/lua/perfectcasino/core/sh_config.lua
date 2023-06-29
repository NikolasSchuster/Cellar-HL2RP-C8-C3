PerfectCasino.Core.Entites = PerfectCasino.Core.Entites or {}
function PerfectCasino.Core.RegisterEntity(class, data, model)
	PerfectCasino.Core.Entites[class] = {}
	PerfectCasino.Core.Entites[class].cache = {}
	PerfectCasino.Core.Entites[class].config = data
	PerfectCasino.Core.Entites[class].model = model
end

function PerfectCasino.Core.GetEntityConfigOptions(class)
	return PerfectCasino.Core.Entites[class].config
end

if SERVER then return end

function PerfectCasino.Core.RequestConfigData(entity)
	net.Start("pCasino:RequestData:Send")
		net.WriteEntity(entity)
	net.SendToServer()
end

net.Receive("pCasino:RequestData:Respond", function()
	local ent = net.ReadEntity()
	if not ent then return end

	local data = net.ReadTable()
	ent.data = data
	ent:PostData()
end)