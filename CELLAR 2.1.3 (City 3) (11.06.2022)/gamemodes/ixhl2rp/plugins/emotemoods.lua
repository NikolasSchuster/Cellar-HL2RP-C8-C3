PLUGIN.name = "Emote Moods"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = ""

MOOD_NONE = 0
MOOD_RELAXED = 1
MOOD_HEADSTRONG = 2
MOOD_FRUSTRATED = 3

ix.lang.AddTable("english", {
	moodDefault = "Default",
	moodRelaxed = "Relaxed",
	moodHeadstr = "Headstrong",
	moodFrustr = "Frustrated",
})

ix.lang.AddTable("russian", {
	moodDefault = "Default",
	moodRelaxed = "Relaxed",
	moodHeadstr = "Headstrong",
	moodFrustr = "Frustrated",
})

PLUGIN.MoodTextTable = {
	[MOOD_NONE] = "moodDefault",
	[MOOD_RELAXED] = "moodRelaxed",
	[MOOD_HEADSTRONG] = "moodHeadstr",
	[MOOD_FRUSTRATED] = "moodFrustr",
}

PLUGIN.MoodAnimTable = {
	[MOOD_RELAXED] = { 
		[0] = "LineIdle01",
		[1] = "walk_all_Moderate"
	},
	[MOOD_HEADSTRONG] = { 
		[0] = "idle_subtle"
	},
	[MOOD_FRUSTRATED] = { 
		[0] = "LineIdle02",
		[1] = "pace_all",
	}
}

do
	local PLAYER = FindMetaTable("Player")
	
	function PLAYER:GetMood()
		return self:GetNetVar("mood") or MOOD_NONE
	end

	if SERVER then
		function PLAYER:SetMood(int)
			int = int or 0

			self:SetNetVar("mood", int)
		end
	end
end

if SERVER then
	function PLUGIN:PlayerLoadedCharacter(client, character)
		client:SetMood(MOOD_NONE)
	end
end

do
	local COMMAND = {}
	COMMAND.description = "@cmdCharSetMood"
	COMMAND.arguments = {
		ix.type.number
	}

	function COMMAND:OnRun(client, mood)
		mood = math.Clamp(mood, 0, MOOD_FRUSTRATED)
		client:SetMood(mood)
	end

	ix.command.Add("CharSetMood", COMMAND)

	function PLUGIN:ModifyMainActivity(client, length, clientInfo)
		local mood = client:GetMood()
		
		if !client:IsWepRaised() and !client:InVehicle() and mood > 0 then
			if length < 0.25 then
				clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][0] and client:LookupSequence(self.MoodAnimTable[mood][0]) or clientInfo.CalcSeqOverride
			elseif length > 0.25 and length < 22500 then
				clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][1] and client:LookupSequence(self.MoodAnimTable[mood][1]) or clientInfo.CalcSeqOverride
			end
		end
	end
end