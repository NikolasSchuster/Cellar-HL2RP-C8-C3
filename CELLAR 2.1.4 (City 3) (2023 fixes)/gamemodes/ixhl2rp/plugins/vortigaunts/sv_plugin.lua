local PLUGIN = PLUGIN

function PLUGIN:PlayerModelChanged(client, model, oldModel)
    if client:Team() == FACTION_VORTIGAUNT then
        if (model:lower() != "models/vortigaunt_slave.mdl") then
            if !client:HasWeapon("ix_vortbeam") then
                client:Give("ix_vortbeam")
            end

            if !client:HasWeapon("ix_vortheal") then
                client:Give("ix_vortheal")
            end
        end
    end
end

function PLUGIN:PostPlayerLoadout(client)
    if client:Team() == FACTION_VORTIGAUNT then
        if (client:GetModel():lower() != "models/vortigaunt_slave.mdl") then
            if !client:HasWeapon("ix_vortbeam") then
                client:Give("ix_vortbeam")
            end

            if !client:HasWeapon("ix_vortheal") then
                client:Give("ix_vortheal")
            end
        end
    end
end