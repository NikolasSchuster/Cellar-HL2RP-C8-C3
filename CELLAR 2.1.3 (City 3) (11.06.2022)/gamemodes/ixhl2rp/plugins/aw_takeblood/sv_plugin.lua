local PLUGIN = PLUGIN

PLUGIN.TakeBloodTime = 10

function PLUGIN:TakeBlood(item,him)
    local client = item.player
    local target = client:GetEyeTraceNoCursor().Entity
	local blood

    if !him or (him and IsValid(target) and target:IsPlayer()) then

		if target and target.GetCharacter then
			blood = target:GetCharacter():GetBlood()
		else 
			blood = client:GetCharacter():GetBlood()
		end

        if blood < 3500 then

            return client:Notify("Недостаточно крови!")

        end

        local uniqueID = "TakingBlood"..client:UniqueID()

        client:SetAction("Беру кровь",self.TakeBloodTime,function()

            client:Notify("Вы успешно взяли кровь.")

            item:Remove()

            client:GetCharacter():GetInventory():Add("bloodbag")

            local winddrawing = him and target or client

            winddrawing:SetBlood(winddrawing:GetBlood()-3000)

        end)

        local additionalcheck
            
        if him then 
            additionalcheck = function()
                return !IsValid(target) or (IsValid(target) and target:GetVelocity():Length() != 0)
            end

            target:SetAction("У вас берут кровь",self.TakeBloodTime,function()
                target:Notify("У вас успешно взяли кровь.")
            end)

        end

        timer.Create(uniqueID,0.1,self.TakeBloodTime/0.1,function()

            if !IsValid(client) or (IsValid(client) and client:GetVelocity():Length() != 0) or 
                !client:GetCharacter():GetInventory():GetItems()[item:GetID()] or (additionalcheck and additionalcheck()) then 
                
                timer.Remove(uniqueID)

                client:SetAction()

                if him then
                    
                    target:SetAction()

                end

            end                            

        end)

        return

    end

    client:Notify("Цель невалидна!")

end