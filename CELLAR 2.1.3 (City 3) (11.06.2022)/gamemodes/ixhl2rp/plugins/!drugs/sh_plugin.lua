PLUGIN.name = "Drug"
PLUGIN.author = "AleXXX_007, Frosty"
PLUGIN.description = "Adds junks with effects."

function PLUGIN:Drugged(client)
	local skill = client:GetCharacter():GetAttribute("end")

	if skill == nil then
		skill = 0
	end

	client:SetLocalVar("drugged", client:GetLocalVar("drugged") + client:GetCharacter():GetData("drugged"))

	if client:GetLocalVar("drugged") > 100 then
		local unctime = (client:GetLocalVar("drugged") - 100) * 7.5

		client:ConCommand("say /fallover ".. unctime .."")
	end

	timer.Create("drugged", 5, 0, function()
		client:SetLocalVar("drugged", client:GetLocalVar("drugged") - 1)
		client:GetCharacter():SetData("drugged", client:GetLocalVar("drugged"))

		if client:GetCharacter():GetData("drugged") == 0 then
			timer.Remove("drugged")
		end
	end)
end

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
		client:SetLocalVar("drugged", 0)
		client:GetCharacter():SetData("drugged", 0)
	end

	function PLUGIN:PlayerDeath(client)
		client:SetLocalVar("drugged", 0)
		client:GetCharacter():SetData("drugged", 0)
	end
end

if (CLIENT) then
	function PLUGIN:RenderScreenspaceEffects()
		local default = {}
		default["$pp_colour_addr"] = 0
		default["$pp_colour_addg"] = 0
		default["$pp_colour_addb"] = 0
		default["$pp_colour_brightness"] = 0
		default["$pp_colour_contrast"] = 1
		default["$pp_colour_colour"] = 0.90
		default["$pp_colour_mulr"] = 0
		default["$pp_colour_mulg"] = 0
		default["$pp_colour_mulb"] = 0

		local a = LocalPlayer():GetLocalVar("drugged")

		if a == nil then
			a = 0
		end

		if (a > 20) then
			local value = (LocalPlayer():GetLocalVar("drugged"))*0.01

			DrawMotionBlur( 0.2, value, 0.05 )
		else
			DrawColorModify(default)
		end
	end
end