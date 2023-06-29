    local function RestoreChess(client)

        if !IsValid(client) or client:IsAdmin() then
            
            local tbl = ix.data.Get("aw_savedchess",{})

            for k,v in pairs(ents.GetAll())do

                if v:GetClass() == "ent_chess_board" then
                    
                    v:Remove()

                end
            end
                

            for k,v in pairs(tbl)do
                
                local ent = ents.Create("ent_chess_board")

                ent:SetPos(v[1])

                ent:Spawn()

            end

            print("CHESS RESTORED")

        end

    end
    
    concommand.Add("ix_chesssave",function(client)

        if !IsValid(client) or client:IsAdmin() then

            local tbl = {}

            for k,v in pairs(ents.GetAll())do

                if v:GetClass() == "ent_chess_board" then
                    
                    tbl[#tbl+1] = {v:GetPos() - Vector(0,0,29.8),v:GetAngles()}

                end
                
            end

            ix.data.Set("aw_savedchess",tbl)

        end

    end)

    concommand.Add("ix_chessrestore",RestoreChess)

    hook.Add("InitPostEntity","aw_chessrestore",function()
        
        RestoreChess()

    end)