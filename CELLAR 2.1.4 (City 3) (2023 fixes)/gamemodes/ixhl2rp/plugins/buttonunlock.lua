local PLUGIN = PLUGIN

PLUGIN.name = "Buttons Unlock Plugin"
PLUGIN.author = "Vintage Thief"
PLUGIN.description = "Allows admins to unlock buttons using chat command /buttonunlock."

do
	ix.command.Add("ButtonLock", {
		description = "Закрыть кнопку",
		privilege = "Manage Buttons",
		adminOnly = true,
		OnRun = function(self, client)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsButton() then

				entity:Fire("lock")

				return "Вы успешно закрыли эту кнопку."
			else
				return "@dNotValid"
			end
		end
	})

	ix.command.Add("ButtonUnlock", {
		description = "Открыть кнопку",
		privilege = "Manage Buttons",
		adminOnly = true,
		OnRun = function(self, client)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsButton() then

				entity:Fire("unlock")

				return "Вы успешно открыли эту кнопку."
			else
				return "@dNotValid"
			end
		end
	})
end