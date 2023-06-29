
local playerMeta = FindMetaTable("Player")

-- default SetAction is really shitty and we better override it to prevent possible errors from occuring when setting a long-termed action
function playerMeta:SetAction(text, time, callback, startTime, finishTime, onCancel)
	if (time and time <= 0) then
		if (callback) then
			callback(self)
		end

		return
	end

	local uniqueID = "ixAct" .. self:SteamID()
	-- Default the time to five seconds.
	time = time or 5
	startTime = startTime or CurTime()
	finishTime = finishTime or (startTime + time)

	if (timer.Exists(uniqueID)) then
		if (self.OnActionCancel) then
			self:OnActionCancel()
		end

		timer.Remove(uniqueID)
	end

	self.OnActionCancel = onCancel

	if (!text or text == false) then
		net.Start("ixActionBarReset")
		net.Send(self)

		return
	end

	net.Start("ixActionBar")
		net.WriteFloat(startTime)
		net.WriteFloat(finishTime)
		net.WriteString(text)
	net.Send(self)

	-- If we have provided a callback, run it delayed.
	if (callback) then
		-- Create a timer that runs once with a delay.
		timer.Create(uniqueID, time, 1, function()
			-- Call the callback if the player is still valid.
			if (IsValid(self)) then
				callback(self)
			end
		end)
	end
end

function PLUGIN:PlayerLoadedCharacter(client)
	client:SetAction()
end
