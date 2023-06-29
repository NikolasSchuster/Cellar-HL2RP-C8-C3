util.AddNetworkString("ixRemoveQuiz")

local correct = {
	[1] = 2,
	[2] = 1,
	[3] = 3,
	[4] = 2,
}

netstream.Hook("ixSendQuiz", function(client, answers)
	for k, v in ipairs(answers) do
		if v != correct[k] then
			client:Notify("Вы неверно ответили на некоторые вопросы!")
			return
		end
	end

	client:SetData("quiz", true)

	net.Start("ixRemoveQuiz")
	net.Send(client)
end)

function PLUGIN:CanPlayerCreateCharacter(client)
	if !client:GetData("quiz", false) then
		return false, "Вы не ответили на вопросы!"
	end
end