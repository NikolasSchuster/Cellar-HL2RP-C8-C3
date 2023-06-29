-- Create all the sounds

-- General slotmachine sound
sound.Add({name = "pcasino_other_lever", channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/other/lever.wav")}) 
sound.Add({name = "pcasino_other_slot_spin", channel = CHAN_STATIC, volume = 0.25, level = 60, pitch = {95, 110}, sound = Sound("pcasino/other/spin_hum.wav")})
-- Basic slotmachine specific sounds
sound.Add({name = "pcasino_basic_slotmachine_jackpot", channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/basicslotmachine/jackpot_tune.wav")}) 
for i=1, 3 do
	sound.Add({name = "pcasino_basic_slotmachine_stop"..i, channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/basicslotmachine/stop_"..i..".wav")}) 
end
sound.Add({name = "pcasino_basic_slotmachine_win", channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/basicslotmachine/win_tune.wav")}) 
sound.Add({name = "pcasino_basic_slotmachine_fail", channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/basicslotmachine/fail_tune.wav")}) 
sound.Add({name = "pcasino_basic_slotmachine_suspense", channel = CHAN_STATIC, volume = 1, level = 90, pitch = {95, 110}, sound = Sound("pcasino/basicslotmachine/suspense_tune.wav")}) 
-- Wheel slotmachine specific sounds
for i=1, 3 do
	sound.Add({name = "pcasino_wheel_slotmachine_stop"..i, channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/wheelslotmachine/stop_"..i..".wav")}) 
end
sound.Add({name = "pcasino_wheel_slotmachine_jackpot", channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/wheelslotmachine/jackpot_tune.wav")}) 
sound.Add({name = "pcasino_wheel_slotmachine_jackpot_voice", channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/wheelslotmachine/jackpot_voice.wav")}) 

-- Chips
for i=1, 2 do
	sound.Add({name = "pcasino_chip"..i, channel = CHAN_STATIC, volume = 0.5, level = 60, pitch = {95, 110}, sound = Sound("pcasino/chip/chip_"..i..".wav")})
end
-- Card
for i=1, 4 do
	sound.Add({name = "pcasino_card"..i, channel = CHAN_STATIC, volume = 1, level = 60, pitch = {95, 110}, sound = Sound("pcasino/card/card_"..i..".wav")})
end
-- Other
sound.Add({name = "pcasino_other_spin", channel = CHAN_STATIC, volume = 0.4, level = 60, pitch = {95, 110}, sound = Sound("pcasino/other/spin.wav")})
sound.Add({name = "pcasino_other_mystery_spin", channel = CHAN_STATIC, volume = 0.8, level = 60, pitch = {95, 110}, sound = Sound("pcasino/other/mystery_spin.wav")})


function PerfectCasino.Sound.Play(ent, soundName, volume)
	if IsValid(ent) and  IsEntity(ent) then
		ent:EmitSound("pcasino_"..soundName, nil, nil, volume)
	elseif isvector(ent) then
		-- As the wheel is off to the side, we need to give a custom position to play the sound from
		sound.Play("pcasino_"..soundName, ent)
	end
end
function PerfectCasino.Sound.Stop(ent, soundName)
	ent:StopSound("pcasino_"..soundName)
end