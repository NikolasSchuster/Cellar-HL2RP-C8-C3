if not file.Exists("pcasino_data", "DATA") then
	file.CreateDir("pcasino_data")
	file.CreateDir("pcasino_data/ui")
end	

PerfectCasino.Icons = {}
PerfectCasino.IconsList = {} -- This is a list of all the icons. It is used in some UI elements to allow players to cycle through them all.
function PerfectCasino.Core.AddIcon(id, name, url)
	PerfectCasino.Icons[id] = {name = name, url = url, mat = Material("data/pcasino_data/ui/"..id..".png")}

	table.insert(PerfectCasino.IconsList, id)
end

PerfectCasino.Core.AddIcon("anything", "Anything", "https://0wain.xyz/icons/pcasino/anything.png")

PerfectCasino.Core.AddIcon("bell", "Bell", "https://0wain.xyz/icons/pcasino/bell.png")
PerfectCasino.Core.AddIcon("berry", "Strawberry", "https://0wain.xyz/icons/pcasino/berry.png")
PerfectCasino.Core.AddIcon("cherry", "Cherry", "https://0wain.xyz/icons/pcasino/cherry.png")
PerfectCasino.Core.AddIcon("clover", "Clover", "https://0wain.xyz/icons/pcasino/clover.png")
PerfectCasino.Core.AddIcon("diamond", "Diamond", "https://0wain.xyz/icons/pcasino/diamond.png")
PerfectCasino.Core.AddIcon("dollar", "Dollar", "https://0wain.xyz/icons/pcasino/dollar.png")
PerfectCasino.Core.AddIcon("melon", "Watermelon", "https://0wain.xyz/icons/pcasino/melon.png")
PerfectCasino.Core.AddIcon("seven", "Seven", "https://0wain.xyz/icons/pcasino/seven.png")

PerfectCasino.Core.AddIcon("gold", "Gold Bars", "https://0wain.xyz/icons/pcasino/gold.png")
PerfectCasino.Core.AddIcon("coins", "Coins", "https://0wain.xyz/icons/pcasino/coins.png")
PerfectCasino.Core.AddIcon("emerald", "Emerald", "https://0wain.xyz/icons/pcasino/emerald.png")
PerfectCasino.Core.AddIcon("bag", "Money Bag", "https://0wain.xyz/icons/pcasino/bag.png")
PerfectCasino.Core.AddIcon("bar", "Gold Bar", "https://0wain.xyz/icons/pcasino/bar.png")
PerfectCasino.Core.AddIcon("coin", "Coin", "https://0wain.xyz/icons/pcasino/coin.png")
PerfectCasino.Core.AddIcon("vault", "Vault", "https://0wain.xyz/icons/pcasino/vault.png")
PerfectCasino.Core.AddIcon("chest", "Treasure Chest", "https://0wain.xyz/icons/pcasino/chest.png")

-- Other
PerfectCasino.Core.AddIcon("mystery_1", "Mystery Wheel 1", "https://0wain.xyz/icons/pcasino/mystery_1.png")
PerfectCasino.Core.AddIcon("mystery_2", "Mystery Wheel 2", "https://0wain.xyz/icons/pcasino/mystery_2.png")
PerfectCasino.Core.AddIcon("mystery_3", "Mystery Wheel 3", "https://0wain.xyz/icons/pcasino/mystery_3.png")
PerfectCasino.Core.AddIcon("dolla", "Dolla", "https://0wain.xyz/icons/pcasino/dolla.png")

function PerfectCasino.Core.LoadIcons()
	for k, v in pairs(PerfectCasino.Icons) do
		print("[pCasino]", "Checking icon", k)
		if file.Exists( "pcasino_data/ui/"..k..".png", "DATA" ) then print("	", "Found") continue end

		print("	", "Attempting to download from", v.url)
		http.Fetch(v.url, function( body, len, headers, code )
			file.Write("pcasino_data/ui/"..k..".png", body)
			v.mat = Material("data/pcasino_data/ui/"..k..".png")

			print("[pCasino]", k, "Download is complete. The image can be found at", "pcasino_data/ui/"..k..".png")
		end)
	end
end

hook.Add("HUDPaint", "pVault:LoadIcons", function()
	hook.Remove("HUDPaint", "pVault:LoadIcons")
	PerfectCasino.Core.LoadIcons()
end)



-- Seat text

local draw_simpletext = draw.SimpleText
hook.Add("HUDPaint", "pVault:ChairLeave", function()
	local myChair = LocalPlayer():GetVehicle()
	if (not IsValid(myChair)) or (not IsValid(myChair:GetParent())) then return end
	if not (myChair:GetParent():GetClass() == "pcasino_chair") then return end

	draw_simpletext(PerfectCasino.Translation.UI.LeaveSeat, "pCasino.Entity.Bid", ScrW()*0.5, ScrH(), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end)

-- Free spin received
net.Receive("pCasino:FreeSpin", function()
	PerfectCasino.Spins = net.ReadUInt(6)
end)



-- Improved toolgun
concommand.Add("pcasino_clone", function()
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	local entity = LocalPlayer():GetEyeTrace().Entity

	if not string.match(entity:GetClass(), "pcasino") then return end
	if not entity.data then return end

	PerfectCasino.UI.CurrentSettings.Entity = entity:GetClass()
	PerfectCasino.UI.CurrentSettings.Settings = table.Copy(entity.data)

	if IsValid(PerfectCasino.UI.ConfigMenu) then
		PerfectCasino.UI.ConfigMenu:Close()
	end

	PerfectCasino.UI.Config()

	local comboBox = PerfectCasino.UI.ConfigMenu.entitySelectBox
	local key
	for k, v in pairs(comboBox.Choices) do
		if not (v == PerfectCasino.Translation.Entities[entity:GetClass()]) then continue end

		key = k
	end

	if not key then return end
	comboBox:ChooseOptionID(key)

	PerfectCasino.UI.ConfigMenu:Hide()
end)

-- Used for debugging
concommand.Add("pcasino_print_data", function()
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	local entity = LocalPlayer():GetEyeTrace().Entity

	if not string.match(entity:GetClass(), "pcasino") then return end
	if not entity.data then return end

	PrintTable(entity.data)
end)