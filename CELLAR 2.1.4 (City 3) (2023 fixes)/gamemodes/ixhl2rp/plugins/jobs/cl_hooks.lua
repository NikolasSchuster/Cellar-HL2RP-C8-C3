local color = Color(255, 0, 0)

hook.Add("PreDrawHalos", "jobs.toolHalos", function()
	if not ix.option.Get("drawTools") then return end
	halo.Add(ents.FindByClass("ix_quest_tools"), color, 5, 5, 2)
end)