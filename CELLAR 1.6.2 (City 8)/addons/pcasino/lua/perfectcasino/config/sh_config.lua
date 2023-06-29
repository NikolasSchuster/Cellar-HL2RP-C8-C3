-----------------------
--      IMPORTANT     -
-----------------------
-- The creation of the entities is done in-game with the toolgun.
-- This allows for you to easily have several of the same machine with different configurations,
-- making the addon easier to use in the process.


/* ============
 General Config
=============*/

-- Chat prefix
PerfectCasino.Config.PrefixColor = Color(175, 0, 0)
PerfectCasino.Config.Prefix = "[pCasino]"

--- The usergroups/SteamIDs that get access to the in-game entity maker
PerfectCasino.Config.AccessGroups = {}
PerfectCasino.Config.AccessGroups["founder"] = true



-- The following functions are for developers to add support to the currency they're using. By default it's set up for DarkRP
function PerfectCasino.Config.AddMoney(ply, amount)
	amount = tonumber(amount) or 0

	local character = ply:GetCharacter()

	if character then
		if amount > 0 then 
			character:GiveMoney(amount)
		else
			character:TakeMoney(amount)
		end
	end
end
function PerfectCasino.Config.CanAfford(ply, amount)
	return ply:GetCharacter():HasMoney(tonumber(amount))
end
function PerfectCasino.Config.FormatMoney(amount)
	return ix.currency.Get(amount) --DarkRP.formatMoney(tonumber(amount))
end


-- These are the reward functions that are run when prize wheels are triggered
-- ply is the user that is receiving the reward.
-- ent is the entity that is linked to the win. Most likely a slot machine or a prize wheel.
-- inputValue is the custom input used in the in-game config menu. This way, you can have 1 function for giving money, and just
-- provide it with different inputs
-- You can also return a string that will be a custom message, otherwise it will default to a preset one in the language file.
PerfectCasino.Config.RewardsFunctions = {}

-- No reward
PerfectCasino.Config.RewardsFunctions["nothing"] = function(ply, ent, inputValue)
	-- They won nothing, do nothing
end
-- RP money
PerfectCasino.Config.RewardsFunctions["money"] = function(ply, ent, inputValue)
	PerfectCasino.Config.AddMoney(ply, inputValue)
end
-- The machines Jackpot. This will only work on machines with jackpots.
PerfectCasino.Config.RewardsFunctions["jackpot"] = function(ply, ent, inputValue)
	local jackpotAmount = ent:GetCurrentJackpot()

	PerfectCasino.Config.AddMoney(ply, jackpotAmount)
	ent:SetCurrentJackpot(ent.data.jackpot.startValue) -- Reset the jackpot

	return "You have hit the jackpot, the payout is "..PerfectCasino.Config.FormatMoney(jackpotAmount)
end
-- Prize Wheel
PerfectCasino.Config.RewardsFunctions["prize_wheel"] = function(ply, ent, inputValue)
	PerfectCasino.Core.GiveFreeSpin(ply)
end
-- A weapon
PerfectCasino.Config.RewardsFunctions["weapon"] = function(ply, ent, inputValue)
	ply:Give(inputValue)
end
-- Health
PerfectCasino.Config.RewardsFunctions["health"] = function(ply, ent, inputValue)
	ply:SetHealth(inputValue)
end
-- Armor
PerfectCasino.Config.RewardsFunctions["armor"] = function(ply, ent, inputValue)
	ply:SetArmor(inputValue)
end
-- Kill
PerfectCasino.Config.RewardsFunctions["kill"] = function(ply, ent, inputValue)
	ply:Kill()
end
-- Set Playermodel
PerfectCasino.Config.RewardsFunctions["setmodel"] = function(ply, ent, inputValue)
	ply:SetModel(inputValue)
end
-- Pointshop 1 Points
PerfectCasino.Config.RewardsFunctions["ps1_points"] = function(ply, ent, inputValue)
	ply:PS_GivePoints(inputValue)
end
-- Pointshop 1 Item
PerfectCasino.Config.RewardsFunctions["ps1_item"] = function(ply, ent, inputValue)
	ply:PS_GiveItem(inputValue)
end
-- Pointshop 2 Points
PerfectCasino.Config.RewardsFunctions["ps2_points"] = function(ply, ent, inputValue)
	ply:PS2_AddStandardPoints(inputValue)
end
-- Pointshop 2 Item
PerfectCasino.Config.RewardsFunctions["ps2_item"] = function(ply, ent, inputValue)
	local item = Pointshop2.GetItemClassByPrintName(inputValue) 
	ply:PS2_EasyAddItem(item.className)
end
-- Pointshop 2 Premium Points
PerfectCasino.Config.RewardsFunctions["ps2_prempoints"] = function(ply, ent, inputValue)
	ply:PS2_AddPremiumPoints(inputValue)
end
-- SH Pointshop Points
PerfectCasino.Config.RewardsFunctions["pssh_points"] = function(ply, ent, inputValue)
	ply:SH_AddStandardPoints(inputValue)
end
-- SH Pointshop Item
PerfectCasino.Config.RewardsFunctions["pssh_item"] = function(ply, ent, inputValue)
	ply:SH_AddItem(inputValue)
end
-- SH Pointshop Premium Points
PerfectCasino.Config.RewardsFunctions["pssh_prempoints"] = function(ply, ent, inputValue)
	ply:SH_AddPremiumPoints(inputValue)
end
-- William's Car Dealer
PerfectCasino.Config.RewardsFunctions["wcd_givecar"] = function(ply, ent, inputValue)
	WCD:GiveVehicleToSteamID(ply:SteamID(), inputValue)
end
-- Fresh Car Dealer Give Car
PerfectCasino.Config.RewardsFunctions["fcd_givecar"] = function(ply, ent, inputValue)
	fcd.giveVehicle(ply, inputValue)
end
-- Brick Wall's Essentials
PerfectCasino.Config.RewardsFunctions["bwe_givexp"] = function(ply, ent, inputValue)
	ply:AddExperience(inputValue, "pCasino")
end
-- mTokens tokens
PerfectCasino.Config.RewardsFunctions["mtkn_tokens"] = function(ply, ent, inputValue)
	mTokens.AddPlayerTokens(ply, tonumber(inputValue))
end
-- SantosRP (Credit to Finnet [76561198369907384])
PerfectCasino.Config.RewardsFunctions["srp_givecar"] = function(ply, ent, inputValue)
	ply:GetCharacter().Vehicles[inputValue] = {
		color = Color(255, 255, 255, 255)
    }
	GAMEMODE.Player:SetGameVar(ply, "vehicles", ply:GetCharacter().Vehicles)
	GAMEMODE.SQL:MarkDiffDirty(ply, "vehicles")
end
-- Brick's Credits
PerfectCasino.Config.RewardsFunctions["bc_credits"] = function(ply, ent, inputValue)
	ply:AddBRCS_Credits(inputValue)
end
-- VCMod (Credit to slaVAC [76561198095033845])
PerfectCasino.Config.RewardsFunctions["vcmod_givecar"] = function(ply, ent, inputValue)
    if not ply:VC_CD_getOwnedVehicleData(inputValue) then
        ply:VC_CD_addVehicle(inputValue)
    end
end

if SERVER then return end
-- Here you can add custom icons that can be used in the prize wheels.
-- The formatting is as follows:
-- 1st argument: A unique name. This must be lowercase and have no spaces or special characters.
-- 2nd argument: This is the display name. This can be anything you like and will be what shows up the UIs
-- 3rd argument: This is the URL to the image. It must be a PNG and will be rescaled to a 1:1 aspect ration, so to provide it as a square image will help keep quality.
-- Example:
PerfectCasino.Core.AddIcon("car", "Car", "https://0wain.xyz/icons/pcasino/car.png")
