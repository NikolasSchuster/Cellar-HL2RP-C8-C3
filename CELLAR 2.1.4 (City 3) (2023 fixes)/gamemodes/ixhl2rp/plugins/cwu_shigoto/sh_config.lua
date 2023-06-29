ix.config.Add("qte_time", 3, "How much time do a player have to activate QTE?", nil, {
    data = {min = 1, max = 5},
    category = "cwu_shigoto"
})

ix.config.Add("electro_exp", 5, "How much EXP a player get if repairs electronical stuff?", nil, {
    data = {min = 0, max = 10},
    category = "cwu_shigoto"
})

ix.config.Add("craftman_exp", 5, "How much EXP a player get if repairs other stuff?", nil, {
    data = {min = 0, max = 10},
    category = "cwu_shigoto"
})

ix.config.Add("safe_time", 30, "How much time does it take to take a new reward from a safe?", nil, {
	data = {min = 15, max = 86400},
	category = "cwu_shigoto"
})