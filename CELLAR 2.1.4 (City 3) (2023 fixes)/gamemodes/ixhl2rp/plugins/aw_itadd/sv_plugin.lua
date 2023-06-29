local PLUGIN = PLUGIN

local function trimmerdollartext(text)
    
    while text:find("($)")do 
        
        local s = text:find("($)") 
        
        text = text:sub(1,s-1).."\n"..text:sub(s+1,text:utf8len())
    
    end 

    return text
end

local function SyncIts(data)

    SetNetVar("aw_RegisteredTexts",data)

    for k,v in ipairs(player.GetAll())do
        
        v:SyncVars()

    end
    
end

function PLUGIN:ItAdd(client,text)

    text = trimmerdollartext(text)

    local its = GetNetVar("aw_RegisteredTexts",{})

    local newnum = #its+1

    its[newnum] = {client:GetPos() + Vector(0,0,45),text}

    SyncIts(its)

    self:SetData(its)

    return "It с айди "..newnum.." был успешно создан."

end

function PLUGIN:ItRemove(client,num)

    local its = GetNetVar("aw_RegisteredTexts",{})

    if !its[num] then
        
        return "Указан несуществующий айди!"

    end

    its[num] = nil 

    SyncIts(its)

    self:SetData(its)

    return "Указанный айди успешно удалён."

end

function PLUGIN:ItGetAll(client)

    client:SendLua([[
        for k,v in pairs(GetNetVar("aw_RegisteredTexts",{}))do
            print(k.." = "..util.TableToJSON(v,true))
        end
    ]])
    
    return "Проверьте консоль."

end

function PLUGIN:InitializedPlugins()

    SyncIts(self:GetData())

end