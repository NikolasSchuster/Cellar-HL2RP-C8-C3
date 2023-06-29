-- This whole file is a little less than ideal. I find it hard to keep derma clean, especially when it can get so big so quickly.
-- I tried my best to keep consistent and to the point, but it gets a mind of its own in some places.
-- On the plus side, this menu will be used like twice, so its not the end of the world. Right?

-- Function cache
local color = Color
local draw_simpletext = draw.SimpleText
local draw_notexture = draw.NoTexture
local draw_roundedboxex = draw.RoundedBoxEx
local draw_roundedbox = draw.RoundedBox
local surface_setdrawcolor = surface.SetDrawColor
local surface_drawrect = surface.DrawRect
local surface_setdrawcolor = surface.SetDrawColor
local surface_setmaterial = surface.SetMaterial
local surface_drawtexturedrect = surface.DrawTexturedRect
-- Color cache
local mainBlack = color(38, 38, 38)
local bodyBlack = color(40, 40, 40)
local textWhite = color(220, 220, 220)
local mainRed = color(155, 50, 50)
local lineBreak = color(255, 255, 255, 10)
local scrollBackground = color(0, 0, 0, 100)

-- Material cache
local gradientDown = Material("gui/gradient_down")
local gradientMain = Material("gui/gradient")

-- Pre config stuff
local comboOptions = {}
comboOptions["pcasino_slot_machine"] = {
	"anything",
	"bell",
	"berry",
	"cherry",
	"clover",
	"diamond",
	"dollar",
	"melon",
	"seven"
}
comboOptions["pcasino_wheel_slot_machine"] = {
	"anything",
	"gold",
	"coins",
	"emerald",
	"bag",
	"bar",
	"coin",
	"vault",
	"chest"
}

PerfectCasino.UI.ConfigMenu = nil
PerfectCasino.UI.CurrentSettings = PerfectCasino.UI.CurrentSettings or {}
function PerfectCasino.UI.Config()
	if IsValid(PerfectCasino.UI.ConfigMenu) then PerfectCasino.UI.ConfigMenu:Show() return end

	local frame = vgui.Create("DFrame")
	PerfectCasino.UI.ConfigMenu = frame
	frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
	frame:SetTitle("")
	frame:Center()
	frame:MakePopup()
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:DockPadding(0, 0, 0, 0)
	frame.Paint = function(self, w, h)
		-- We drop the 40 to allow for rounded edges on the header
		surface_setdrawcolor(bodyBlack)
		surface_drawrect(0, 40, w, h-40)
	end
	frame.fullScreen = false
	frame.centerX, frame.centerY = frame:GetPos()

	local header = vgui.Create("DPanel", frame)
	header:Dock(TOP)
	header:SetTall(40)
	header:DockMargin(0, 0, 0, 0)
	header.Paint = function(self, w, h)
		draw_roundedboxex(frame.fullScreen and 0 or 5, 0, 0, w, 40, mainBlack, true, true)
		draw_simpletext(PerfectCasino.Translation.ConfigMenu.Title, "pCasino.Header.Static", 10, 20, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

		-- Header buttons
		local close = vgui.Create("DButton", header)
		close:Dock(RIGHT)
		close:SetSize(header:GetTall(), header:GetTall())
		close:SetText("")
		close.animationLerp = 0
		close.Paint = function(self, w, h)
			if self:IsHovered() then
				self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
			else
				self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
			end

			draw_notexture()
			surface_setdrawcolor(200 - (self.animationLerp*55), 0, 0, 255)
			PerfectCasino.UI.DrawCircle(w*0.5, h*0.5, w*0.2, 1)
		end
		close.DoClick = function()
			frame:Hide()
		end

		local scale = vgui.Create("DButton", header)
		scale:Dock(RIGHT)
		scale:SetSize(header:GetTall(), header:GetTall())
		scale:SetText("")
		scale.animationLerp = 0
		scale.Paint = function(self, w, h)
			if self:IsHovered() then
				self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
			else
				self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
			end

			draw_notexture()
			surface_setdrawcolor(255, 165 - (self.animationLerp*25), 0, 255)
			PerfectCasino.UI.DrawCircle(w*0.5, h*0.5, w*0.2, 1)
		end
		scale.DoClick = function()
			if frame.fullScreen then
				frame:SizeTo(ScrW()*0.6, ScrH()*0.6, 0.5)
				frame:MoveTo(frame.centerX, frame.centerY, 0.5)
			else
				frame:SizeTo(ScrW(), ScrH(), 0.5)
				frame:MoveTo(0, 0, 0.5)
			end

			frame.fullScreen = not frame.fullScreen
		end

	-- Used to apply padding as DScrollPanel doesn't allow it
	local shellParent = vgui.Create("DPanel", frame)
	shellParent:Dock(FILL)
	shellParent:DockPadding(5, 5, 5, 5)
	shellParent.Paint = function(self, w, h)
		surface_setdrawcolor(0, 0, 0, 155)
		-- Header shadow
		surface_setmaterial(gradientDown)
		surface_drawtexturedrect(0, 0, w, 10)
		-- Navbar shadow
		surface_setmaterial(gradientMain)
		surface_drawtexturedrect(0, 0, 10, h)
	end
	local shell = vgui.Create("DScrollPanel", shellParent)
	shell:Dock(FILL)
	shell.Paint = function() end
	local sbar = shell:GetVBar()
	sbar:SetWide(sbar:GetWide()*0.5)
	sbar:SetHideButtons(true)
	function sbar:Paint(w, h)
		draw_roundedbox(10, 0, 0, w, h, scrollBackground)
	end
	function sbar.btnGrip:Paint(w, h)
		draw_roundedbox(10, 0, 0, w, h, mainRed)
	end



	local navBar = vgui.Create("DScrollPanel", frame)
	navBar:Dock(LEFT)

	local buttonX, buttonY = 0, 0
	local barPos = 0
	navBar.Paint = function(self, w, h)
		surface_setdrawcolor(mainBlack)
		surface_drawrect(0, 0, w, h)

		surface_setdrawcolor(lineBreak)
		surface_drawrect(0, 0, w, 2)

		if not self.currentFocus then return end

		buttonX, buttonY = self.currentFocus:GetPos()
		barPos = Lerp(0.1, barPos, buttonY)
		barPos = math.Approach(barPos, buttonY, 5*FrameTime())

		surface_setdrawcolor(mainRed)
		surface_drawrect(0, barPos, 4, 40)
	end
	navBar:SetSize(frame:GetWide()*0.2)
	navBar:GetVBar():SetWide(0)
	navBar.open = true

	function navBar:AddTab(name, callback)
		local button = vgui.Create("DButton", self)
		button:Dock(TOP)
		button:SetTall(40)
		button:SetText("")

		button.Paint = function(me, w, h)
			draw_simpletext(name, "pCasino.Nav.Static", 12, h*0.5, textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			surface_setdrawcolor(lineBreak)
			surface_drawrect(5, h-2, w-10, 2)
		end

		button.DoClick = function()
			shell:Clear()
			self.currentFocus = button
			callback(shell, button, self)
		end

		if not self.currentFocus then
			timer.Simple(0.1, function()
				if not IsValid(button) then return end
				button.DoClick()
			end)
			self.currentFocus = button
		end

		return button
	end

	local entityToConfig = vgui.Create("DPanel", shell)
	entityToConfig:SetTall(65)
	entityToConfig:Dock(TOP)
	entityToConfig.Paint = function(self, w, h)
		draw_simpletext(PerfectCasino.Translation.ConfigMenu.EntityToConfig, "pCasino.Title.Static", 10, 0, textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		surface_setdrawcolor(lineBreak)
		surface_drawrect(5, h-2, w-10, 2)
	end

	local entry = vgui.Create("DComboBox", entityToConfig)
	frame.entitySelectBox = entry
	entry:Dock(BOTTOM)
	entry:DockMargin(10, 0, 10, 5)
	entry:SetValue(PerfectCasino.Translation.ConfigMenu.EntityToConfigComboBox)
	for k, v in pairs(PerfectCasino.Core.Entites) do
		entry:AddChoice(PerfectCasino.Translation.Entities[k] or k, k)
	end
	entry.OnSelect = function(self, index, name, class)
		local configData = PerfectCasino.Core.GetEntityConfigOptions(class)
		local allSettings = (PerfectCasino.UI.CurrentSettings.Entity == class) and PerfectCasino.UI.CurrentSettings.Settings or {}
		for k, v in pairs(configData) do
			allSettings[k] = allSettings[k] or {}
			if k == "combo" then
				navBar:AddTab(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, function(shell)
					local title = vgui.Create("DPanel", shell)
					title:Dock(TOP)
					title:DockMargin(0, 0, 0, 5)
					title:SetTall(57.5)
					title.Paint = function(self, w, h)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, "pCasino.Title.Static", 10, 0, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Desc or "", "pCasino.SubTitle.Static", 10, h, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					end

					local function addComboCard(data, key)
						local base = vgui.Create("DPanel", shell)
						base:SetTall(135)
						base:Dock(TOP)
						base.Paint = function(self, w, h)
							surface_setdrawcolor(lineBreak)
							surface_drawrect(5, h-2, w-10, 2)
						end
						local entryBar = vgui.Create("DPanel", base)
						entryBar:Dock(BOTTOM)
						entryBar:SetTall(20)
						entryBar:DockMargin(5, 0, 5, 5)
						entryBar.Paint = function() end
							local multiplier = vgui.Create("DPanel", entryBar)
							multiplier:Dock(LEFT)
							multiplier:SetWide(275)
							multiplier:DockMargin(0, 0, 0, 0)
							multiplier:SetTall(20)
							multiplier.Paint = function(self, w, h)
								draw_simpletext(PerfectCasino.Translation.ConfigMenu.TakeoutBonusMultiplier, "pCasino.Textbox.Static", 10, h*0.5, textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end
								local entry = vgui.Create("pCasinoEntry", multiplier)
								entry:Dock(RIGHT)
								entry:DockMargin(5, 0, 5, 0)
								entry.OnChange = function()
									allSettings[k][base.key].p = entry:GetValue()
								end
								entry:SetDisplayText("0.5")
								entry:SetNumeric(true)
								entry:SetValue(data and data.p or 0.5)

							local jackpot = vgui.Create("DPanel", entryBar)
							jackpot:Dock(LEFT)
							jackpot:SetWide(140)
							jackpot:DockMargin(0, 0, 0, 0)
							jackpot:SetTall(20)
							jackpot.Paint = function(self, w, h)
								draw_simpletext(PerfectCasino.Translation.ConfigMenu.IsJackpot, "pCasino.Textbox.Static", 10, h*0.5, textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end
								local toggle = vgui.Create("pCasinoSwitch", jackpot)
								toggle:Dock(RIGHT)
								toggle:SetWide(40)
								toggle:SetToggle(data and data.j or false)
								toggle.DoClick = function()
									toggle:Toggle()
									allSettings[k][base.key].j = toggle:GetToggle()
								end

							local delete = vgui.Create("DButton", entryBar)
							delete:Dock(RIGHT)
							delete:SetWide(75)
							delete:SetText("")
							delete:DockMargin(5, 0, 0, 0)
							delete.animationLerp = 0
							delete.Paint = function(self, w, h)
								if self:IsHovered() then
									self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
								else
									self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
								end
								draw_roundedbox(0+(5*self.animationLerp), 0, 0, w, h, mainRed)
								draw_simpletext(PerfectCasino.Translation.ConfigMenu.Delete, "pCasino.Button.Micro", w*0.5, (h*0.5), textWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
							delete.DoClick = function()
								allSettings[k][base.key] = nil
								base:Remove()
							end

						local btnBar = vgui.Create("DPanel", base)
						btnBar:Dock(BOTTOM)
						btnBar:SetTall(20)
						btnBar:DockMargin(5, 0, 5, 5)
						btnBar.Paint = function() end

						for i=1, 3 do
							local icon = vgui.Create("DImage", base)	-- Add image to Frame
							icon:Dock(LEFT)
							icon:SetWide(75)
							icon:DockMargin(5, 5, 0, 5)
							icon:SetMaterial(PerfectCasino.Icons["anything"].mat)

							local nextIcon = vgui.Create("DButton", btnBar)
							nextIcon:Dock(LEFT)
							nextIcon:SetWide(75)
							nextIcon:SetText("")
							nextIcon:DockMargin(5, 0, 0, 0)
							nextIcon.CurState = 1
							if data then
								for k, v in pairs(comboOptions[class]) do
									if v == data.c[i] then
										nextIcon.CurState = k
										icon:SetMaterial(PerfectCasino.Icons[comboOptions[class][nextIcon.CurState]].mat)
										break
									end
								end
							end
							nextIcon.animationLerp = 0
							nextIcon.Paint = function(self, w, h)
								if self:IsHovered() then
									self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
								else
									self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
								end
								draw_roundedbox(0+(5*self.animationLerp), 0, 0, w, h, mainRed)
								draw_simpletext(PerfectCasino.Icons[comboOptions[class][self.CurState]].name, "pCasino.Button.Micro", w*0.5, (h*0.5), textWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
							nextIcon.DoClick = function()
								nextIcon.CurState = nextIcon.CurState + 1

								if not comboOptions[class][nextIcon.CurState] then
									nextIcon.CurState = 1
								end

								icon:SetMaterial(PerfectCasino.Icons[comboOptions[class][nextIcon.CurState]].mat)
								
								allSettings[k][base.key].c = allSettings[k][base.key].c or {}
								allSettings[k][base.key].c[i] = comboOptions[class][nextIcon.CurState]
							end
						end

						local icons = {}
						for k, v in pairs(btnBar:GetChildren()) do
							icons[k] = comboOptions[class][v.CurState]
						end
						if key then
							base.key = key
						else
							base.key = table.insert(allSettings[k], {c = {icons[1], icons[2], icons[3]}, p = entry:GetValue(), j = toggle:GetToggle()})
						end
					end

					local newCombo = vgui.Create("DButton", shell)
					newCombo:SetText("")
					newCombo:Dock(TOP)
					newCombo:SetTall(25)
					newCombo:DockMargin(10, 5, 10, 5)
					newCombo.animationLerp = 0
					newCombo.Paint = function(self, w, h)
						if self:IsHovered() then
							self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
						else
							self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
						end
						draw_roundedbox(0+(5*self.animationLerp), 0, 0, w, h, mainRed)
						draw_simpletext(PerfectCasino.Translation.ConfigMenu.AddComboButton, "pCasino.Main.Static", w*0.5, (h*0.5), textWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
					newCombo.DoClick = function()
						addComboCard(data)
						shell:GetVBar():AnimateTo(150*(#allSettings[k] + 1), 1)
					end

					-- PerfectCasino.Icons

					local tableHeaders = vgui.Create("DPanel", shell)
					tableHeaders:Dock(TOP)
					tableHeaders:SetTall(30)
					tableHeaders.Paint = function(self, w, h)
						draw_simpletext(PerfectCasino.Translation.ConfigMenu.TableHeaderChance, "pCasino.Main.Static", 10, h*0.5, textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						surface_setdrawcolor(lineBreak)
						surface_drawrect(10, h-2, w-15, 2)
					end

						local useSettings = false
						if not table.IsEmpty(allSettings[k]) then
							useSettings = true
						end
						for n, m in pairs(useSettings and allSettings[k] or v) do
							addComboCard(m, useSettings and n or nil)
						end
				end)
			elseif k == "wheel" then
				navBar:AddTab(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, function(shell)
					local title = vgui.Create("DPanel", shell)
					title:Dock(TOP)
					title:DockMargin(0, 0, 0, 5)
					title:SetTall(57.5)
					title.Paint = function(self, w, h)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, "pCasino.Title.Static", 10, 0, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Desc or "", "pCasino.SubTitle.Static", 10, h, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					end

					for n, m in pairs(v) do
						allSettings[k][n] = allSettings[k][n] or m
						local setting = vgui.Create("DPanel", shell)
						setting:SetTall(80)
						setting:Dock(TOP)
						setting.Paint = function(self, w, h)
							--draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k][n] or string.upper(n), "pCasino.SubTitle.Static", 10, 0, k == "chance" and colorCache[n] or textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							surface_setdrawcolor(lineBreak)
							surface_drawrect(5, h-2, w-10, 2)
						end
	
						local icon = vgui.Create("DImageButton", setting)	-- Add image to Frame
						icon:Dock(LEFT)
						icon:SetWide(80)
						icon:DockMargin(5, 5, 0, 5)
						icon.CurState = 1
						icon:SetMaterial(PerfectCasino.Icons[PerfectCasino.IconsList[icon.CurState]].mat)
						for z, x in pairs(PerfectCasino.IconsList) do
							if x == allSettings[k][n].p then
								icon.CurState = z
								icon:SetMaterial(PerfectCasino.Icons[PerfectCasino.IconsList[icon.CurState]].mat)
								break
							end
						end
						icon.DoClick = function()
							icon.CurState = icon.CurState + 1

							if not PerfectCasino.IconsList[icon.CurState] then
								icon.CurState = 1
							end

							icon:SetMaterial(PerfectCasino.Icons[PerfectCasino.IconsList[icon.CurState]].mat)
							
							allSettings[k][n].p = PerfectCasino.IconsList[icon.CurState]
						end

						local inputValue = vgui.Create("pCasinoEntry", setting)
						inputValue:Dock(BOTTOM)
						inputValue:DockMargin(5, 0, 10, 5)
						inputValue.OnChange = function()
							allSettings[k][n].i = inputValue:GetValue() == "" and m.i or inputValue:GetValue()
						end
						inputValue:SetDisplayText(m.i)
						inputValue:SetText((not (allSettings[k][n].i == m.i)) and allSettings[k][n].i or m.i)

						local rewardType = vgui.Create("DComboBox", setting)
						rewardType:Dock(BOTTOM)
						rewardType:DockMargin(5, 5, 10, 5)
						rewardType:SetValue(PerfectCasino.Translation.ConfigMenu.RewardComboBox)
						for o, p in pairs(PerfectCasino.Config.RewardsFunctions) do
							local key = rewardType:AddChoice(PerfectCasino.Translation.Rewards[o] or o, o)
							if allSettings[k][n].f == o then
								rewardType:ChooseOptionID(key)
							end
						end
						rewardType.OnSelect = function(self, index, name, class)
							allSettings[k][n].f = class
						end

						local name = vgui.Create("pCasinoEntry", setting)
						name:Dock(BOTTOM)
						name:DockMargin(5, 0, 10, 0)
						name.OnChange = function()
							allSettings[k][n].n = name:GetValue() == "" and m.n or name:GetValue()
						end
						name:SetDisplayText(m.n)
						name:SetText((not (allSettings[k][n].n == m.n)) and allSettings[k][n].n or m.n)

					end
				end)
			elseif k == "chance" then
				navBar:AddTab(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, function(shell)
					local title = vgui.Create("DPanel", shell)
					title:Dock(TOP)
					title:DockMargin(0, 0, 0, 5)
					title:SetTall(57.5)
					title.Paint = function(self, w, h)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, "pCasino.Title.Static", 10, 0, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Desc or "", "pCasino.SubTitle.Static", 10, h, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					end
	
					local colorCache = {}
					local chanceBar = vgui.Create("DPanel", shell)
					chanceBar:Dock(TOP)
					chanceBar:DockMargin(0, 0, 0, 5)
					chanceBar:SetTall(60)
					chanceBar.Paint = function(self, w, h)
						draw_simpletext(PerfectCasino.Translation.Config.chance.Bar, "pCasino.Title.Static", 10, 0, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						surface_setdrawcolor(lineBreak)
						surface_drawrect(10, (h*0.5)+5, w-20, (h*0.5)-10)
	
						-- (hudW-10) * math_clamp(localPly:Health(), 0, 100)/100
						local total = 0
						for n, m in pairs(allSettings[k]) do
							total = total+m
						end
						-- I know, the same loop twice... Ugly :/
						local curPos = 10
						for n, m in pairs(allSettings[k]) do
							if m == 0 then continue end
							if not colorCache[n] then
								colorCache[n] = Color(math.random(100, 255), math.random(100, 255), math.random(100, 255))
							end
	
							local width = (w-20) * (m/total)
							surface_setdrawcolor(colorCache[n])
							surface_drawrect(curPos, (h*0.5)+5, width, (h*0.5)-10)
	
							curPos = curPos + width
						end
					end
	
					for n, m in pairs(v) do
						allSettings[k][n] = allSettings[k][n] or m.d
						local setting = vgui.Create("DPanel", shell)
						setting:SetTall(50)
						setting:Dock(TOP)
						setting.Paint = function(self, w, h)
							draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k][n] or string.upper(n), "pCasino.SubTitle.Static", 60, 0, k == "chance" and colorCache[n] or textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							surface_setdrawcolor(lineBreak)
							surface_drawrect(5, h-2, w-10, 2)
						end

						local icon = vgui.Create("DImageButton", setting)	-- Add image to Frame
						icon:Dock(LEFT)
						icon:SetWide(45)
						icon:DockMargin(5, 5, 0, 5)
						icon.CurState = 1
						icon:SetMaterial(PerfectCasino.Icons[n].mat)

						local entry = vgui.Create("pCasinoEntry", setting)
						entry:Dock(BOTTOM)
						entry:DockMargin(10, 0, 10, 5)
						entry.OnChange = function()
							allSettings[k][n] = entry:GetValue() == "" and m.d or entry:GetValue()
						end
						entry:SetDisplayText(m.d)
						entry:SetText((not (allSettings[k][n] == m.d)) and allSettings[k][n] or "")
						entry:SetNumeric(true)
					end
				end)
			else
				navBar:AddTab(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, function(shell)
					local title = vgui.Create("DPanel", shell)
					title:Dock(TOP)
					title:DockMargin(0, 0, 0, 5)
					title:SetTall(57.5)
					title.Paint = function(self, w, h)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Title or k, "pCasino.Title.Static", 10, 0, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k].Desc or "", "pCasino.SubTitle.Static", 10, h, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					end
	
					for n, m in pairs(v) do
						-- allSettings[k][n] = allSettings[k][n] or m.d
						if allSettings[k][n] == nil then
							allSettings[k][n] = m.d
						end
						local setting = vgui.Create("DPanel", shell)
						setting:SetTall(50)
						setting:Dock(TOP)
						setting.Paint = function(self, w, h)
							draw_simpletext(PerfectCasino.Translation.Config[k] and PerfectCasino.Translation.Config[k][n] or string.upper(n), "pCasino.SubTitle.Static", 10, 0, k == "chance" and colorCache[n] or textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
							surface_setdrawcolor(lineBreak)
							surface_drawrect(5, h-2, w-10, 2)
						end
	
						if m.t == "bool" then
							local toggle = vgui.Create("pCasinoSwitch", setting)
							toggle:SetPos(10, setting:GetTall()-toggle:GetTall()-5)
							toggle:SetWide(40)
							toggle:SetToggle(allSettings[k][n])
							toggle.DoClick = function()
								toggle:Toggle()
								allSettings[k][n] = toggle:GetToggle()
							end
						else
							local entry = vgui.Create("pCasinoEntry", setting)
							entry:Dock(BOTTOM)
							entry:DockMargin(10, 0, 10, 5)
							entry.OnChange = function()
								allSettings[k][n] = entry:GetValue() == "" and m.d or entry:GetValue()
							end
							entry:SetDisplayText(m.d)
							entry:SetText((not (allSettings[k][n] == m.d)) and allSettings[k][n] or "")
							if m.t == "num" then
								entry:SetNumeric(true)
							end
						end
					end
				end)
			end
		end

		navBar:AddTab(PerfectCasino.Translation.ConfigMenu.SpawnEntity, function(shell)
			local defaults = PerfectCasino.Core.GetEntityConfigOptions(class)
			for k, v in pairs(allSettings) do
				if table.IsEmpty(v) then
					for n, m in pairs(defaults[k]) do
						v[n] = m.d or m
					end
				end
			end

			PerfectCasino.UI.CurrentSettings.Entity = class
			PerfectCasino.UI.CurrentSettings.Settings = allSettings

			PerfectCasino.UI.ConfigMenu:Hide()
		end)

		-- Allow them to reset the options. Essentially hard reloads the menu
		navBar:AddTab(PerfectCasino.Translation.ConfigMenu.ResetButton, function(shell)
			PerfectCasino.UI.ConfigMenu:Close()
			PerfectCasino.UI.ConfigMenu = nil
			PerfectCasino.UI.CurrentSettings = {}
			PerfectCasino.UI.Config()
		end)
	end
end