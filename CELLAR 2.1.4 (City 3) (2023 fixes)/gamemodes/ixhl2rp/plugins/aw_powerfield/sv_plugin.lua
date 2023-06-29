local PLUGIN = PLUGIN
function PLUGIN:DeployField(ply)
    local shieldDeployer = ents.Create("shield_deployer")
        local _shieldDeployAngleYaw = ply:GetEyeTrace().Normal:Angle().yaw
        shieldDeployer.shieldDeployAngleYaw = _shieldDeployAngleYaw
        shieldDeployer:SetPos(ply:GetPos() + Vector(0,0,48))
        shieldDeployer:SetAngles(ply:GetAngles())
        shieldDeployer:Spawn()
        local shieldDeployerPhys = shieldDeployer.phys -- GET THIS AFTER SPAWNING AND ACTIVATING NEXT TIME DICK ED
        shieldDeployer:Activate()

    if(shieldDeployer:GetPhysicsObject():IsValid() && ply:IsValid()) then 
        shieldDeployerPhys:SetVelocityInstantaneous(ply:EyeAngles():Forward() * 500)  
    end 
    ply:ViewPunch( Angle( -4, 0, 0 ) )
end
function PLUGIN:PlaceField(item)
    local client = item.player
    if IsValid(client) then
        item:SetData("fieldinstock",item:GetData("fieldinstock",3)-1)
        if item:GetData("fieldinstock") < 1 then
            item:Remove()
        end
        self:DeployField(client)
    end
end

function PLUGIN:InitializedPlugins()
    concommand.Remove("deploy_force_shield")
end