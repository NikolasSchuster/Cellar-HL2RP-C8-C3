ix.config.Add("daily_reward", 10, "How much EXP does a player get when finish a daily task?", nil, {
    data = {min = 5, max = 50},
    category = "daily_system"
})

if (SERVER) then
    ix.log.AddType("daily_complete", function(client)
        return Format("%s выполнил ежеджневное задание.", client:Name())
    end, FLAG_NORMAL)
end