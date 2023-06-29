PLUGIN.name = "Core Modifications"
PLUGIN.description = ""
PLUGIN.author = ""

ix.config.language = "russian"

ix.currency.symbol = ""
ix.currency.singular = "token"
ix.currency.plural = "tokens"

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("meta/sh_item.lua")

if CLIENT then
	language.Add("game_player_joined_game", "")
	language.Add("game_player_left_game", "")
end

do 
	local function fixOOC()
		ix.chat.Register("ooc", {
			CanSay = function(self, speaker, text)
				if (!ix.config.Get("allowGlobalOOC")) then
					speaker:NotifyLocalized("Global OOC is disabled on this server.")
					return false
				else
					local delay = ix.config.Get("oocDelay", 10)

					-- Only need to check the time if they have spoken in OOC chat before.
					if (delay > 0 and speaker.ixLastOOC) then
						local lastOOC = CurTime() - speaker.ixLastOOC

						-- Use this method of checking time in case the oocDelay config changes.
						if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
							speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

							return false
						end
					end

					-- Save the last time they spoke in OOC.
					speaker.ixLastOOC = CurTime()
				end
			end,
			OnChatAdd = function(self, speaker, text)
				-- @todo remove and fix actual cause of speaker being nil
				if (!IsValid(speaker)) then
					return
				end

				local icon = serverguard.ranks:GetRank(serverguard.player:GetRank(speaker)).texture or "icon16/user.png"

				icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

				chat.AddText(icon, Color(255, 50, 50), "[OOC] ", speaker, color_white, ": "..text)
			end,
			prefix = {"//", "/OOC"},
			description = "@cmdOOC",
			noSpaceAfter = true
		})
	end

	hook.Add("InitializedConfig", "ixChatTypes2", function()
		fixOOC()
	end)

	fixOOC()
end