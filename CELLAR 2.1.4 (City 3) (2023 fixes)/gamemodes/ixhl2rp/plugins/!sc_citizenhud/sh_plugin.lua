local PLUGIN = PLUGIN

PLUGIN.name = "Citizen HUD"
PLUGIN.author = "Sectorial.Commander"
PLUGIN.description = ""

PLUGIN.lerphunger = 1
PLUGIN.lerpthirst = 1
PLUGIN.lerpradiation = 1
PLUGIN.lerpfilter = 1
PLUGIN.lerpgeiger = 1
PLUGIN.tickbrake = true
PLUGIN.tickbrake1 = true
PLUGIN.staminaBrake = true
PLUGIN.tempBrake = true


ix.util.Include('cl_cellarcitizenhud.lua')
ix.util.Include('cl_staminablur.lua')

function PLUGIN:HUDPaint()

    local client = LocalPlayer()
    local character = client:GetCharacter()

    if not client:GetCharacter() then return end

    if character:IsCombine() or character:IsOTA() or character:IsCombine() and not character:IsCityAdmin() then

        if IsValid(cellar_citizenhud_needs) then
            if cellar_citizenhud_needs or not cellar_citizenhud_needs.removed then
                cellar_citizenhud_needs:SetVisible(false)
                cellar_citizenhud_needs:Remove()
            end
        end

        if IsValid(cellar_citizenhud_rad) then
            if cellar_citizenhud_rad or not cellar_citizenhud_rad.removed then
                cellar_citizenhud_rad:SetVisible(false)
                cellar_citizenhud_rad:Remove()
            end
        end

        if IsValid(cellar_citizenhud_stamina) then
            if cellar_citizenhud_stamina or not cellar_citizenhud_stamina.removed then
                cellar_citizenhud_stamina:SetVisible(false)
                cellar_citizenhud_stamina:Remove()
            end
        end

        return 
    end

    if character:GetFaction() == FACTION_CITIZEN or character:IsCityAdmin() or character:GetFaction() == FACTION_VORTIGAUNT or character:IsCWU() then

        PLUGIN.lerphunger = Lerp(0.1 * FrameTime(), PLUGIN.lerphunger, LocalPlayer():GetCharacter():GetHunger()/100)
        oldhunger = math.Round(PLUGIN.lerphunger, 2)
        newhunger = math.Round(LocalPlayer():GetCharacter():GetHunger()/100, 2)
        PLUGIN.lerpthirst = Lerp(0.1 * FrameTime(), PLUGIN.lerpthirst, LocalPlayer():GetCharacter():GetThirst()/100)
        oldthirst = math.Round(PLUGIN.lerpthirst, 2)
        newthirst = math.Round(LocalPlayer():GetCharacter():GetThirst()/100, 2)

        -- hunger and thirst
        if oldhunger != newhunger or oldthirst != newthirst then
            PLUGIN.tickbrake = false
            if !cellar_citizenhud_needs or cellar_citizenhud_needs.removed then
                vgui.Create('cellar.citizenhud.needs')
            end
        end
    
        if oldhunger == newhunger and oldthirst == newthirst and PLUGIN.tickbrake == false then
            if cellar_citizenhud_needs then
                PLUGIN.tickbrake = true
                cellar_citizenhud_needs:Remove()
            end
        end

        -- stamina

        local stamina = math.Round(math.Clamp((ix.plugin.list["stamina"].predictedStamina or 100) / LocalPlayer():GetCharacter():GetMaxStamina(), 0, 1), 2)

        if stamina <= 0.27 then
            PLUGIN.staminaBrake = false
            if !cellar_citizenhud_stamina or cellar_citizenhud_stamina.removed then
                vgui.Create('cellar.citizenhud.stamina')
            end
        end

        if stamina > 0.27 and PLUGIN.staminaBrake == false then
            if cellar_citizenhud_stamina then
                PLUGIN.staminaBrake = true
                cellar_citizenhud_stamina:Remove()
            end
        end

        -- geiger and filter
        local radLevel = LocalPlayer():GetNetVar("radDmg") or 0
	    local geiger = character:HasGeigerCounter()
        local filter = character:HasWearedFilter()

        if geiger == true then
            PLUGIN.lerpgeiger = Lerp(0.35 * FrameTime(), PLUGIN.lerpgeiger, radLevel/100)
            oldgeiger = math.Round(PLUGIN.lerpgeiger, 2)
            newgeiger = math.Round(radLevel/100, 2)

            PLUGIN.lerpfilter = Lerp(0.35 * FrameTime(), PLUGIN.lerpfilter, filter and filter:GetFilterQuality()/filter.filterQuality)
            oldfilter = math.Round(PLUGIN.lerpfilter, 2)
            newfilter = math.Round(filter:GetFilterQuality()/filter.filterQuality, 2)


            if oldgeiger != newgeiger or oldfilter != newfilter then
                PLUGIN.tickbrake1 = false
                if !cellar_citizenhud_rad or cellar_citizenhud_rad.removed then
                    vgui.Create('cellar.citizenhud.rad')
                end
            end

            if oldgeiger == newgeiger and oldfilter == newfilter and PLUGIN.tickbrake1 == false then
                if cellar_citizenhud_rad then
                    PLUGIN.tickbrake1 = true
                    cellar_citizenhud_rad:Remove()
                end
            end
        end

       -- temperature

        local temperature = LocalPlayer():GetLocalVar("coldCounter", 0) / 100

        if temperature < 1 then
            PLUGIN.tempBrake = false
            if !cellar_citizenhud_temperature or cellar_citizenhud_temperature.removed then
                vgui.Create('cellar.citizenhud.temperature')
            end
        end

        if temperature > 0.99 then
            if IsValid(cellar_citizenhud_temperature) then
                PLUGIN.tempBrake = true
                cellar_citizenhud_temperature:Remove()
            end
        end
        
    else
        if IsValid(cellar_citizenhud_needs) or (cellar_citizenhud_needs and not cellar_citizenhud_needs.removed) then
            cellar_citizenhud_needs:Remove()
        end

        if IsValid(cellar_citizenhud_rad) or (cellar_citizenhud_rad and not cellar_citizenhud_rad.removed) then
            cellar_citizenhud_rad:Remove()
        end

        if IsValid(cellar_citizenhud_temperature) or (cellar_citizenhud_temperature and not cellar_citizenhud_temperature.removed) then
            cellar_citizenhud_temperature:Remove()
        end
    end
end