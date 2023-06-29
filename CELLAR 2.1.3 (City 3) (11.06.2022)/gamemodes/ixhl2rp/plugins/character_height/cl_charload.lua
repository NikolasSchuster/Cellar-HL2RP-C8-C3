
local errorModel = "models/error.mdl"
local PANEL = vgui.GetControlTable('ixCharMenuCarousel')

function PANEL:SetActiveCharacter(character)
	local height = character:GetHeight()

	self.shadeY = self:GetTall()
	self.shadeHeight = self:GetTall()

	-- set character immediately if we're an error (something isn't selected yet)
	if (self.activeCharacter:GetModel() == errorModel) then
		self.activeCharacter:SetCharacter(character)
		self:ResetSequence(self.activeCharacter)

		self.activeCharacter:SetModelScale(height)
		self.lastCharacter:SetModelScale(height)

		return
	end

	-- if the animation is already playing, we update its parameters so we can avoid restarting
	local shade = self:GetTweenAnimation(1)
	local shadeHide = self:GetTweenAnimation(2)

	if (shade) then
		shade.newCharacter = character
		return
	elseif (shadeHide) then
		shadeHide.queuedCharacter = character
		return
	end

	self.lastCharacter:SetCharacter(self.activeCharacter:GetCharacter())
	self:ResetSequence(self.lastCharacter, self.activeCharacter)

	shade = self:CreateAnimation(self.animationTime * 0.5, {
		index = 1,
		target = {
			shadeY = 0,
			shadeHeight = self:GetTall()
		},
		easing = "linear",

		OnComplete = function(shadeAnimation, shadePanel)
			shadePanel.activeCharacter:SetCharacter(shadeAnimation.newCharacter)
			shadePanel:ResetSequence(shadePanel.activeCharacter)

			shadePanel.activeCharacter:SetModelScale(height)

			shadePanel:CreateAnimation(shadePanel.animationTime, {
				index = 2,
				target = {shadeHeight = 0},
				easing = "outQuint",

				OnComplete = function(animation, panel)
					if (animation.queuedCharacter) then
						panel:SetActiveCharacter(animation.queuedCharacter)
					else
						panel.lastCharacter:SetCharacter(nil)
					end

					panel.lastCharacter:SetModelScale(height)
				end
			})
		end
	})

	shade.newCharacter = character
end
