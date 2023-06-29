
do
	local CHANNEL

	-- br
	CHANNEL = ix.radio:New()
	CHANNEL.name = "br"
	CHANNEL.uniqueID = "br"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 7
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(215, 165, 0)
	CHANNEL:Register()

	-- cab
	CHANNEL = ix.radio:New()
	CHANNEL.name = "cab"
	CHANNEL.uniqueID = "cab"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 7
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(200, 150, 0)
	CHANNEL:Register()

	-- coi
	CHANNEL = ix.radio:New()
	CHANNEL.name = "coi"
	CHANNEL.uniqueID = "coi"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 7
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(215, 165, 0)
	CHANNEL:Register()

	-- combine
	CHANNEL = ix.radio:New()
	CHANNEL.name = "combine"
	CHANNEL.uniqueID = "combine"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 7
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(200, 0, 0)
	CHANNEL:Register()

	-- cp main
	CHANNEL = ix.radio:New()
	CHANNEL.name = "tac"
	CHANNEL.uniqueID = "cp_main"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 10
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(50, 180, 215, 255)
	CHANNEL.icon = ix.util.GetMaterial("cellar/chat/radio_union.png")
	CHANNEL:Register()

	-- intercom um
	CHANNEL = ix.radio:New()
	CHANNEL.name = "medical intercom"
	CHANNEL.uniqueID = "intercom_um"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 0
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(0, 200, 200)
	CHANNEL.sound = "ambient/levels/prison/radio_random14.wav"
	CHANNEL:Register()

	-- intercom uil
	CHANNEL = ix.radio:New()
	CHANNEL.name = "uil intercom"
	CHANNEL.uniqueID = "intercom_uil"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 0
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(0, 200, 200)
	CHANNEL.sound = "ambient/levels/prison/radio_random14.wav"
	CHANNEL:Register()

	-- overwatch
	CHANNEL = ix.radio:New()
	CHANNEL.name = "overwatch"
	CHANNEL.uniqueID = "overwatch"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 11
	CHANNEL.stationaryCanAccess = false
	CHANNEL.color = Color(200, 75, 75)
	CHANNEL.icon = ix.util.GetMaterial("cellar/chat/dispatch.png")
	CHANNEL:Register()

	-- proselyte
	CHANNEL = ix.radio:New()
	CHANNEL.name = "proselyte"
	CHANNEL.uniqueID = "freq_proselyte"
	CHANNEL.subChannels = 1
	CHANNEL.global = false
	CHANNEL.defaultPriority = 5
	CHANNEL.stationaryCanAccess = false
	CHANNEL:Register()
end
