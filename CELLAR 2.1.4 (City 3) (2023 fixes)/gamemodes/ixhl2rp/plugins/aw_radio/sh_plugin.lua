local PLUGIN = PLUGIN
PLUGIN.name = "Radio && Kassetas"
PLUGIN.author = "Alan Wake"
PLUGIN.description = "Adds a Radio and Kassetes for it"

PLUGIN.CSounds = PLUGIN.CSounds or {}

-- ALWAYS_RAISED["aw_radio"] = false 

ix.util.Include("sv_plugin.lua")

function PLUGIN:GetKassetaPath(id)

	local kasseta = ix.item.list[id]

	return kasseta and kasseta:GetPath()

end

ix.command.Add("CreateKasseta", {
	description = "[UniqueID] && [Название] && [Путь] && [Описание] && [Длительность]",
	arguments = {
		ix.type.string,
		ix.type.string,
        ix.type.string,
        ix.type.string,
        ix.type.number,
	},
	OnRun = function(self, client, uniqueID, name, path, desc,duration)

		return PLUGIN:RegisterKasseta(client, uniqueID, name, path, desc, duration)

	end
})

ix.command.Add("GetKassets", {
	description = "Получить все зарегистрированные кассеты на сервере",
	OnRun = function(self, client)

        return PLUGIN:GetKassetas(client)

	end
})

if CLIENT then

    PLUGIN.stored = PLUGIN.stored or {}

    function PLUGIN:Think() -- updates positions and validate
        
        for k,v in pairs(PLUGIN.CSounds)do

            if IsValid(v[5]) then

                if !IsValid(k) then

                    v[5]:Stop()
                    
                    PLUGIN.CSounds[k] = nil

                    continue

                end

                v[5]:SetPos(k:GetPos())

            end

        end

    end

    netstream.Hook("ChooseKasseta",function()

        local menu = DermaMenu()

        for k,v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems())do
            
            if v.IsKasseta then

                menu:AddOption(v:GetName(),function() netstream.Start("ChooseKasseta",v:GetID()) end)

            end

        end

        local x = gui.MouseX()

        if gui.MouseX() < 20 then

            x = ScrW()/2

        end

        menu:Open(x,x == gui.MouseX() and gui.MouseY() or ScrH()/2)

    end)

    netstream.Hook("SetRadioState",function(id,state)

        local ent = ents.GetByIndex(id)

        PLUGIN.stored[ent] = state

    end)

    local function RunStopSound(csound,enable)

        -- if ejected then
            
        --     csound:SetTime(0)

        -- end

        if enable then

            csound:Play()

            return 

        end

        csound:Pause()

    end

    netstream.Hook("aw::syncradio",function(csounds)

        for k,v in pairs(csounds)do

            PLUGIN.CSounds[k] = PLUGIN.CSounds[k] or {}

            PLUGIN.CSounds[k][3] = v[3]
        
            
            -- if !IsValid(PLUGIN.CSounds[k][5]) or (PLUGIN.CSounds[k][2] and PLUGIN.CSounds[k][2] != v[2]) then
            if IsValid(PLUGIN.CSounds[k][5]) then

                if PLUGIN.CSounds[k][5]:GetFileName() == v[2] then

                    PLUGIN.CSounds[k][5]:SetTime(v[4])

                    RunStopSound(PLUGIN.CSounds[k][5],v[3],v[6])

                    return
                    
                end

            end

            PLUGIN.CSounds[k][2] = v[2]

            sound.PlayFile(v[2],"3d noblock",function(sound)

                if IsValid(sound) then

                    PLUGIN.CSounds[k][5] = sound

                    sound:SetTime(v[4] or 0)

                    RunStopSound(sound,v[3],v[6])

                end
                
            end)

        end

    end)

    netstream.Hook("aw::registerkassetas",function(items)

        for k,v in pairs(items)do
		
            local ITEM = ix.item.Register(k, "base_kasseta", false, nil, true)
    
            ITEM.name = v.name
            ITEM.path = v.path
            ITEM.duration = v.duration
            ITEM.desc = v.desc
    
        end

    end)

    function PLUGIN:HUDPaint()
        
        local weapon = LocalPlayer():GetActiveWeapon()

        if IsValid(weapon) and weapon:GetClass() == "aw_radio" then
            
            ix.util.DrawText("Запустить/Пауза - ЛКМ", ScrW()*.5, ScrH()*.86, nil, 1, 1, "ixBigFont")

            ix.util.DrawText("Вставить/Вытащить кассету - ПКМ", ScrW()*.5, ScrH()*.89, nil, 1, 1, "ixBigFont")

            ix.util.DrawText("К началу - R", ScrW()*.5, ScrH()*.92, nil, 1, 1, "ixBigFont")

        end

    end

end