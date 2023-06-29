local PLUGIN = PLUGIN

function PLUGIN:OnSearchWithoutZipTie(player,target)
	if IsValid(target.WantToSearch) then
		player:Notify("Персонажа уже обыскивают!")
		return
	end
	if !player.SearchCoolDown or !player.SearchCoolDown[target] or CurTime() > player.SearchCoolDown[target] then
		player:Notify("Вы запросили обыск персонажа.")

		player.SearchCoolDown = player.SearchCoolDown or {}
		player.SearchCoolDown[target] = CurTime() + 15

		target.WantToSearch = player
		netstream.Start(target,"aw_AcceptSearch",player)

		local id = "aw_SearchCheck"..target:UniqueID()
		timer.Create(id,1,15,function()
			if timer.RepsLeft(id) == 0 then target.WantToSearch = nil end
			if !target.WantToSearch then timer.Remove(id) end
		end)
		return
	end
	player:Notify("Подождите перед запросом!")
end

function PLUGIN:SearchWitoutZipTie(player,target)
    local time = ix.config.Get("containerOpenTime", 2)*5
	local uniqueID = "AWSearchingWithoutZipTie"..player:UniqueID()
	target.WantToSearch = nil
	timer.Create(uniqueID, 0.1, time / 0.1, function()
		if IsValid(player) and IsValid(target) and player:GetEyeTraceNoCursor().Entity == target then
			if player:GetVelocity():Length() > 1 or target:GetVelocity():Length() > 1 then
				timer.Remove(uniqueID)
				player:SetAction()
			elseif timer.RepsLeft(uniqueID) == 0 then
				player:Notify("Вы успешно обыскали персонажа.")
                Schema:SearchPlayer(player, target)
			end
		else
			timer.Remove(uniqueID)
			player:SetAction()
		end
	end)
	player:SetAction("Обыскиваю персонажа...",time)  
end
netstream.Hook("aw_AcceptSearch",function(caller,data)
	if !data and caller.WantToSearch then
		caller:Notify("Вы отказались от обыска!")
		caller.WantToSearch:Notify("Персонаж отказался от обыска!")
		caller.WantToSearch = nil
	end
    if caller.WantToSearch then
		caller:Notify("Вы согласились на обыск.")
        PLUGIN:SearchWitoutZipTie(caller.WantToSearch,caller)
    end
end)
timer.Create("AWCheckOpenedContainersByPlayers",0.3,0,function()
	-- local checkedstored = {}
	for k,v in ipairs(player.GetAll())do
		if v:IsAdmin() then
			continue
		end
		local store = v.ixOpenStorage
		local owner = store and store:GetOwner()
		if store then // !checkedstored[store]
			if (owner and owner:IsPlayer() and owner:GetVelocity():Length() > 0) then // v:GetVelocity():Length() > 0 or 
				-- checkedstored[store] = true
				ix.storage.Close(store)
				v.ixOpenStorage = nil
				store.receivers = {}
			end
		end
	end
end)