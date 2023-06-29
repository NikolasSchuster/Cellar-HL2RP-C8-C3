local PLUGIN = PLUGIN

function PLUGIN:ShouldHideBars()
	if ix.infoMenu.open then
		return true
	end
end

function PLUGIN:ShowHelp() 
	return false 
end

function PLUGIN:PlayerBindPress(client, bind, pressed)
	if bind:lower():find("gm_showhelp") and pressed then

		if LocalPlayer():GetCharacter() then
            ix.infoMenu.Display()
		end

		return true
	end
end

function PLUGIN:SetInfoMenuData(character, faction)
	ix.infoMenu.Add("Уровень: " .. character:GetLevel())

	local card = character:GetIDCard()

	if card then
		ix.infoMenu.Add("CID: #" .. card:GetData("cid", 0))
	end

	ix.infoMenu.Add("Токены: " .. ix.currency.Get(character:GetMoney()))

/*
	if(character:GetWage()) then
		ix.infoMenu.Add(string.format("Wage: %s tokens", character:GetWage()))
	end

	

	if(faction.name == "Civil Protection") then
		local cpData = character:GetCPInfo()

		ix.infoMenu.Add("Tagline: " .. character:GetCPTagline())
		ix.infoMenu.Add("Rank: " .. character:GetRank().displayName)

		if(cpData.spec) then
			ix.infoMenu.Add("Specialization: " .. character:GetSpec().name)
		end
	end
	*/
end