if (SERVER) then
	AddCSLuaFile();
end;

local PLUGIN = PLUGIN;
local material = Material("effects/com_shield003a");

ENT.Type 			= "anim";
ENT.Base 			= "base_anim";
ENT.PrintName		= "Forcefield";
ENT.Category		= "HL2 RP";
ENT.Spawnable		= true;
ENT.AdminOnly		= true;
ENT.RenderGroup 	= RENDERGROUP_BOTH;
ENT.PhysgunDisabled = true;
ENT.Editable = true


function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Mode");
	self:NetworkVar("String", 0, "Access", {KeyName = "Access", Edit = {type = "String", order = 1}})
end;

if (SERVER) then
	function ENT:SpawnFunction( player, trace )
		if !(trace.Hit) then return; end;
		local angles = (player:GetPos() - trace.HitPos):Angle()
		angles.p = 0
		angles.r = 0
		angles:RotateAroundAxis(angles:Up(), 270)

		local entity = ents.Create("ix_forcefield")
		entity:SetPos(trace.HitPos + Vector(0, 0, 40))
		entity:SetAngles(angles:SnapTo("y", 90))
		entity:Spawn()
		entity:Activate()
		entity:SetAccess("cmbMpfAll")
		entity.owner = player;

		return entity;
	end;

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_fence01b.mdl");
		self:SetSolid(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:DrawShadow(false);
		self.on = true;
		self.mode = 1;
		self:SetDTInt(0, 1);

		local data = {}
		data.start = self:GetPos() + self:GetRight() * -16
		data.endpos = self:GetPos() + self:GetRight() * -480
		data.filter = self
		local trace = util.TraceLine(data)
		local angles = self:GetAngles()
		angles:RotateAroundAxis(angles:Up(), 90)


		self.dummy = ents.Create("prop_physics")
		self.dummy:SetModel("models/props_combine/combine_fence01a.mdl")
		self.dummy:SetPos(trace.HitPos)
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:Spawn()
		self.dummy.PhysgunDisabled = true
		self:DeleteOnRemove(self.dummy)

		local verts = {
			{pos = Vector(0, 0, -25)},
			{pos = Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0, 0, 25)},
			{pos = Vector(0, 0, -25)},
		}

		self:PhysicsFromMesh(verts);
		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:SetMaterial("default_silent");
			physObj:EnableMotion(false);
		end;

		self:SetCustomCollisionCheck(true);
		self:EnableCustomCollisions(true);

		physObj = self.dummy:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(false);
		end;

		self.dummy:MakePhysicsObjectAShadow();

		self:SetNWInt("dummy", self.dummy:EntIndex());


		self.ShieldLoop = CreateSound(self, "ambient/machines/combine_shield_loop3.wav");

		timer.Simple(0, function() PLUGIN:SaveData() end)
	end;

	function ENT:StartTouch( ent )
		if !(self.on) then return; end;

		if (ent:IsPlayer()) then
			if !(ent:IsCombine()) then
				if (!ent.ShieldTouch) then
					ent.ShieldTouch = CreateSound(ent, "ambient/machines/combine_shield_touch_loop1.wav");
					ent.ShieldTouch:Play();
					ent.ShieldTouch:ChangeVolume(0.25, 0);
				else
					ent.ShieldTouch:Play();
					ent.ShieldTouch:ChangeVolume(0.25, 0.5);
				end;
			end;
		end;
	end;

	function ENT:Touch(ent)
		if !(self.on) then return; end;

		if (ent:IsPlayer()) then
			if !(ent:IsCombine()) then
				if ent.ShieldTouch then
					ent.ShieldTouch:ChangeVolume(0.3, 0);
				end;
			end;
		end;
	end;

	function ENT:EndTouch( ent )
		if !(self.on) then return; end;

		if (ent:IsPlayer()) then
			if !(ent:IsCombine()) then
				if (ent.ShieldTouch) then
					ent.ShieldTouch:FadeOut(0.5);
				end;
			end;
		end;
	end;

	function ENT:Think()
		if (IsValid(self) and self.on) then
			self.ShieldLoop:Play();
			self.ShieldLoop:ChangeVolume(0.4, 0);
		else
			self.ShieldLoop:Stop();
		end;
	end;

	function ENT:OnRemove()
		if self.ShieldLoop then
			self.ShieldLoop:Stop();
		end;
	end;


	function ENT:Use(act, call, type, val)
		if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1;
		else
			return;
		end;

		if (act:IsCombine() and act:GetCharacter():HasIDAccess(self:GetAccess())) then
			self.mode = (self.mode or 1) + 1;
			self:SetDTInt(0, self.mode);

			if (self.mode > #PLUGIN.modes) then
				self.mode = 1;
				self:SetDTInt(0, self.mode);
			end;

			if (self.mode == 3) then
				self.on = false;
				self:SetSkin(1);
				self.dummy:SetSkin(1);
				self:EmitSound("shield/deactivate.wav");
				self:SetCollisionGroup(COLLISION_GROUP_WORLD);
			elseif (self.mode == 1) then
				self.on = true;
				self:SetSkin(0);
				self.dummy:SetSkin(0);
				self:EmitSound("shield/activate.wav");
				self:SetCollisionGroup(COLLISION_GROUP_NONE);
			end;

			self:EmitSound("buttons/combine_button5.wav", 140, 100 + (self.mode - 1) * 15);
			act:Notify("Режим установлен на: " .. PLUGIN.modes[self.mode][2]);

			PLUGIN:SaveData();
		end;
	end;




	function ENT:OnRemove()
		if (self.ShieldLoop) then
			self.ShieldLoop:Stop();
			self.ShieldLoop = nil;
		end;

		if self.ShieldTouch then
			self.ShieldTouch:Stop();
			self.ShieldTouch = nil;
		end;
	end;

end;

if (CLIENT) then

	function ENT:Initialize()
		self:EnableCustomCollisions(true);

		-- timer.Simple(0, function()
		-- 	local dummy = Entity(self:GetNWInt("dummy", 0))

		-- 	if IsValid(dummy) then
		-- 		local verts = {
		-- 			{pos = Vector(0, 0, -25)},
		-- 			{pos = Vector(0, 0, 150)},
		-- 			{pos = self:WorldToLocal(dummy:GetPos()) + Vector(0, 0, 150)},
		-- 			{pos = self:WorldToLocal(dummy:GetPos()) + Vector(0, 0, 150)},
		-- 			{pos = self:WorldToLocal(dummy:GetPos()) - Vector(0, 0, 25)},
		-- 			{pos = Vector(0, 0, -25)}
		-- 		}

		-- 		self:PhysicsFromMesh(verts)
		-- 	end
		-- end)
	end;

	function ENT:Draw()
		local dummy = Entity(self:GetNWInt("dummy", 0))
		local angles = self:GetAngles();
		local matrix = Matrix();

		self:DrawModel();
		matrix:Translate(self:GetPos() + self:GetUp() * -40 + self:GetForward() * -2);
		matrix:Rotate(angles);

		render.SetMaterial(material);

		if (IsValid(dummy)) then
			local vertex = self:WorldToLocal(dummy:GetPos());
			self:SetRenderBounds(vector_origin - Vector(0, 0, 40), vertex + self:GetUp() * 150);

			cam.PushModelMatrix(matrix);
			self:DrawShield(vertex);
			cam.PopModelMatrix();

			matrix:Translate(vertex);
			matrix:Rotate(Angle(0, 180, 0));

			cam.PushModelMatrix(matrix);
			self:DrawShield(vertex);
			cam.PopModelMatrix();
		end;
	end;


	-- I took a peek at how Chessnut drew his forcefields.
	function ENT:DrawShield(vertex)
		if (self:GetSkin() != 1) then
			mesh.Begin(MATERIAL_QUADS, 1);
			mesh.Position(vector_origin);
			mesh.TexCoord(0, 0, 0);
			mesh.AdvanceVertex();
			mesh.Position(self:GetUp() * 190);
			mesh.TexCoord(0, 0, 5);
			mesh.AdvanceVertex();
			mesh.Position(vertex + self:GetUp() * 190);
			mesh.TexCoord(0, 5, 5);
			mesh.AdvanceVertex();
			mesh.Position(vertex);
			mesh.TexCoord(0, 5, 0);
			mesh.AdvanceVertex();
			mesh.End();
		end;
	end;

end;
