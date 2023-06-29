local PLUGIN = PLUGIN

PLUGIN.name = "Radio voicelines"
PLUGIN.author = "maxxoft"
PLUGIN.description = "Adds radio voicelines support."

if SERVER then
	util.AddNetworkString("PlayVRadio")
else
	net.Receive("PlayVRadio", function(len, ply)
		-- local speaker = net.ReadEntity()
		print("playing")
		local snd = net.ReadString()
		local beep = net.ReadString()
		local sounds = {snd, beep}

		-- Let there be a delay before any sound is played.
		delay = delay or 0
		spacing = spacing or 0.1

		-- Loop through all of the sounds.
		for _, v in pairs(sounds) do
			if v == " " then goto next end
			local postSet, preSet = 0, 0

			-- Determine if this sound has special time offsets.
			if (istable(v)) then
				postSet, preSet = v[2] or 0, v[3] or 0
				v = v[1]
			end

			-- Get the length of the sound.
			local length = SoundDuration(v)
			-- If the sound has a pause before it is played, add it here.
			delay = delay + preSet

			-- Have the sound play in the future.
			timer.Simple(delay, function()
				-- Check if the entity still exists and play the sound.
				if (IsValid(entity)) then
					surface.PlaySound(v)
				end
			end)

			-- Add the delay for the next sound.
			delay = delay + length + postSet + spacing
			::next::
		end
	end)
end