local PLUGIN = PLUGIN


ENT.Type = "anim"
ENT.PrintName = "Vault - Alaska"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = false
ENT.bNoPersist = true


if (SERVER) then

	function ENT:Initialize()

		self:SetNetVar("reward_done", false)
		self:SetNetVar("now_time", 0)
		self:SetModel("models/Items/ammocrate_grenade.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self.nextUseTime = 0

		local conf_time = ix.config.Get("reward_time")

		self.timer_name = "vault_timer" .. self:EntIndex()
		self.timer_name_tick = "vault_timer_tick" .. self:EntIndex()
		self.timer_name_control = "vault_timer_control" .. self:EntIndex()

		-- netvars for displaying control over models every 10 seconds

		timer.Create( self.timer_name_control, 10, 0, function()

			local z_check_metro = ix.config.Get("z_metro")
			local z_check_otabridge = ix.config.Get("z_otabridge")
			local z_check_village = ix.config.Get("z_village")
			local z_check_destroyedvillage = ix.config.Get("z_destroyedvillage")
			local z_check_canalspit = ix.config.Get("z_canalspit")
			local z_check_fisherhouse = ix.config.Get("z_fisherhouse")
			local z_check_mines = ix.config.Get("z_mines")
			local pla = 3

			if z_check_metro == pla then
				self:SetNetVar("nv_metro", true)
			else
				self:SetNetVar("nv_metro", false)
			end
			if z_check_otabridge == pla then
				self:SetNetVar("nv_otabridge", true)
			else
				self:SetNetVar("nv_otabridge", false)
			end
			if z_check_village == pla then
				self:SetNetVar("nv_village", true)
			else
				self:SetNetVar("nv_village", false)
			end
			if z_check_destroyedvillage == pla then
				self:SetNetVar("nv_destroyedvillage", true)
			else
				self:SetNetVar("nv_destroyedvillage", false)
			end
			if z_check_canalspit == pla then
				self:SetNetVar("nv_canalspit", true)
			else
				self:SetNetVar("nv_canalspit", false)
			end
			if z_check_fisherhouse == pla then
				self:SetNetVar("nv_fisherhouse", true)
			else
				self:SetNetVar("nv_fisherhouse", false)
			end
			if z_check_mines == pla then
				self:SetNetVar("nv_mines", true)
			else
				self:SetNetVar("nv_mines", false)
			end
		end)

		timer.Create( self.timer_name, conf_time, 0, function()
			self:SetNetVar("reward_done", true)
		end)

		timer.Create( self.timer_name_tick, 1, 0, function()

			local clamp_time = math.Clamp(self:GetNetVar("now_time") + 1, 0, conf_time)
			self:SetNetVar("now_time", clamp_time)
			
		end)

	end
	
	local PLUGIN = PLUGIN
	function ENT:Use( activator, caller )
		if not activator:IsPlayer() then return end
		local char = activator:GetCharacter()
		if self:GetNetVar("reward_done") == true then

			timer.Remove(self.timer_name)
			timer.Remove(self.timer_name_tick)
			timer.Remove(self.timer_name_control)

			local conf_time = ix.config.Get("reward_time")
			local pla = 3
			local z_check_metro = ix.config.Get("z_metro")
			local z_check_otabridge = ix.config.Get("z_otabridge")
			local z_check_village = ix.config.Get("z_village")
			local z_check_destroyedvillage = ix.config.Get("z_destroyedvillage")
			local z_check_canalspit = ix.config.Get("z_canalspit")
			local z_check_fisherhouse = ix.config.Get("z_fisherhouse")
			local z_check_mines = ix.config.Get("z_mines")
			local vaultpos = self:GetPos()

			if z_check_metro == pla then
			
				local tokens_amount = PLUGIN.loot_tokens.tokens
				char:SetMoney(char:GetMoney() + tokens_amount)

				for k, v in pairs(PLUGIN.loot_ammo) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end

				for k, v in pairs(PLUGIN.loot_healthkits) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end
			if z_check_otabridge == pla then
				for k, v in pairs(PLUGIN.loot_ammo) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end

				for k, v in pairs(PLUGIN.loot_healthkits) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end
			if z_check_village == pla then
				local tokens_amount = PLUGIN.loot_tokens.tokens
				char:SetMoney(char:GetMoney() + tokens_amount)

				for k, v in pairs(PLUGIN.loot_food) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end

				for k, v in pairs(PLUGIN.loot_drinks) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end
			if z_check_destroyedvillage == pla then
				for k, v in pairs(PLUGIN.loot_healthkits) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end

				for k, v in pairs(PLUGIN.loot_seeds) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end
			if z_check_canalspit == pla then
				local tokens_amount = PLUGIN.loot_tokens.tokens
				char:SetMoney(char:GetMoney() + tokens_amount)

				for k, v in pairs(PLUGIN.loot_garabge) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end
			if z_check_fisherhouse == pla then
				for k, v in pairs(PLUGIN.loot_food) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end

				for k, v in pairs(PLUGIN.loot_drinks) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end
			if z_check_mines == pla then
				local tokens_amount = PLUGIN.loot_tokens.tokens
				char:SetMoney(char:GetMoney() + tokens_amount)

				for k, v in pairs(PLUGIN.loot_metal) do
					local result, _ = char:GetInventory():Add(k, v)
					if (!result) then
						for i = 0, v do
							ix.item.Spawn(k, vaultpos + Vector(0, 0, 26))
						end
					end
				end
			end

			char:GetPlayer():NotifyLocalized("Вы успешно забрали вашу добычу.")

			self:SetNetVar("now_time", 0)
			self:SetNetVar("reward_done", false)

			timer.Create( self.timer_name, conf_time, 0, function()
				self:SetNetVar("reward_done", true)
			end)

			timer.Create( self.timer_name_tick, 1, 0, function()
				local clamp_time = math.Clamp(self:GetNetVar("now_time") + 1, 0, conf_time)
				self:SetNetVar("now_time", clamp_time)		
			end)

			timer.Create( self.timer_name_control, 10, 0, function()

				local z_check_metro = ix.config.Get("z_metro")
				local z_check_otabridge = ix.config.Get("z_otabridge")
				local z_check_village = ix.config.Get("z_village")
				local z_check_destroyedvillage = ix.config.Get("z_destroyedvillage")
				local z_check_canalspit = ix.config.Get("z_canalspit")
				local z_check_fisherhouse = ix.config.Get("z_fisherhouse")
				local z_check_mines = ix.config.Get("z_mines")
				local pla = 3

				if self:GetNetVar("now_time") >= conf_time then
					self:SetNetVar("reward_done", true)
				end

				if z_check_metro == pla then
					self:SetNetVar("nv_metro", true)
				else
					self:SetNetVar("nv_metro", false)
				end
				if z_check_otabridge == pla then
					self:SetNetVar("nv_otabridge", true)
				else
					self:SetNetVar("nv_otabridge", false)
				end
				if z_check_village == pla then
					self:SetNetVar("nv_village", true)
				else
					self:SetNetVar("nv_village", false)
				end
				if z_check_destroyedvillage == pla then
					self:SetNetVar("nv_destroyedvillage", true)
				else
					self:SetNetVar("nv_destroyedvillage", false)
				end
				if z_check_canalspit == pla then
					self:SetNetVar("nv_canalspit", true)
				else
					self:SetNetVar("nv_canalspit", false)
				end
				if z_check_fisherhouse == pla then
					self:SetNetVar("nv_fisherhouse", true)
				else
					self:SetNetVar("nv_fisherhouse", false)
				end
				if z_check_mines == pla then
					self:SetNetVar("nv_mines", true)
				else
					self:SetNetVar("nv_mines", false)
				end
			end)

		else
			char:GetPlayer():NotifyLocalized("Время для получения добычи еще не пришло.")
		end
	end

	function ENT:OnRemove()
		timer.Remove(self.timer_name)
		timer.Remove(self.timer_name_tick)
		timer.Remove(self.timer_name_control)
	end

else

	function ENT:Draw()

		local conf_time = ix.config.Get("reward_time")
		local amount = (self:GetNetVar("now_time") .. "/" .. conf_time)

		local metro_control = ""
		local metro_col = ""
		local otabridge_control = ""
		local village_control = ""
		local destroyedvillage_control = ""
		local canalspit_control = ""
		local fisherhouse_control = ""
		local mines_control = ""

		-- territory control checker
		if self:GetNetVar("nv_metro") == true then metro_control = "ПОД КОНТРОЛЕМ" metro_col = Color( 0, 228, 34, 189) else metro_control = "НЕТ КОНТРОЛЯ" metro_col = Color( 214, 0, 0, 202) end
		if self:GetNetVar("nv_otabridge") == true then otabridge_control = "ПОД КОНТРОЛЕМ" otabridge_col = Color( 0, 228, 34, 189) else otabridge_control = "НЕТ КОНТРОЛЯ" otabridge_col = Color( 214, 0, 0, 202) end
		if self:GetNetVar("nv_village") == true then village_control = "ПОД КОНТРОЛЕМ" village_col = Color( 0, 228, 34, 189)	else village_control = "НЕТ КОНТРОЛЯ" village_col = Color( 214, 0, 0, 202) end
		if self:GetNetVar("nv_destroyedvillage") == true then destroyedvillage_control = "ПОД КОНТРОЛЕМ" destroyedvillage_col = Color( 0, 228, 34, 189) else destroyedvillage_control = "НЕТ КОНТРОЛЯ" destroyedvillage_col = Color( 214, 0, 0, 202) end
		if self:GetNetVar("nv_canalspit") == true then canalspit_control = "ПОД КОНТРОЛЕМ" canalspit_col = Color( 0, 228, 34, 189) else canalspit_control = "НЕТ КОНТРОЛЯ" canalspit_col = Color( 214, 0, 0, 202)	end
		if self:GetNetVar("nv_fisherhouse") == true then fisherhouse_control = "ПОД КОНТРОЛЕМ" fisherhouse_col = Color( 0, 228, 34, 189) else fisherhouse_control = "НЕТ КОНТРОЛЯ" fisherhouse_col = Color( 214, 0, 0, 202) end
		if self:GetNetVar("nv_mines") == true then mines_control = "ПОД КОНТРОЛЕМ" mines_col = Color( 0, 228, 34, 189) else mines_control = "НЕТ КОНТРОЛЯ" mines_col = Color( 214, 0, 0, 202)	end

		self:DrawModel()
		local fixedAng = self:GetAngles()
		fixedAng:RotateAroundAxis( self:GetRight(), -90 )
		fixedAng:RotateAroundAxis( self:GetForward(), 90 )
		
		if self:GetPos():Distance(LocalPlayer():GetPos()) >= 512 then return end

		-- progress
		local fixedPos = self:GetPos() + self:GetUp() * 5 + self:GetRight() * 5 + self:GetForward() * 16
		cam.Start3D2D(fixedPos, fixedAng, 0.1)
			draw.RoundedBox(4, 0, 0, 100, 100, Color(0,0,0,225))
			draw.SimpleText( "Готовность:", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( amount, "Default", 50, 42, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_title = self:GetPos() + self:GetUp() * 9 + self:GetRight() * 5 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_title, fixedAng, 0.1)
			draw.SimpleText( "Аляска", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
		cam.End3D2D()

		-- territories
		local fixedPos_metro = self:GetPos() + self:GetUp() * 9 + self:GetRight() * 24 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_metro, fixedAng, 0.1)
			draw.SimpleText( "МЕТРО", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( metro_control, "Default", 50, 25, metro_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_otabridge = self:GetPos() + self:GetUp() * 4 + self:GetRight() * 24 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_otabridge, fixedAng, 0.1)
			draw.SimpleText( "АВАНПОСТ ОТА", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( otabridge_control, "Default", 50, 25, otabridge_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_village = self:GetPos() + self:GetUp() * -1 + self:GetRight() * 24 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_village, fixedAng, 0.1)
			draw.SimpleText( "ДЕРЕВНЯ", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( village_control, "Default", 50, 25, village_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_destroyedvillage = self:GetPos() + self:GetUp() * -6 + self:GetRight() * 24 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_destroyedvillage, fixedAng, 0.1)
			draw.SimpleText( "РАЗРУШЕННАЯ ДЕРЕВНЯ", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( destroyedvillage_control, "Default", 50, 25, destroyedvillage_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_canalspit = self:GetPos() + self:GetUp() * 9 + self:GetRight() * -14 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_canalspit, fixedAng, 0.1)
			draw.SimpleText( "ВОДОСТОК", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( canalspit_control, "Default", 50, 25, canalspit_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_fisherhouse = self:GetPos() + self:GetUp() * 4 + self:GetRight() * -14 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_fisherhouse, fixedAng, 0.1)
			draw.SimpleText( "ДОМ РЫБАКА", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( fisherhouse_control, "Default", 50, 25, fisherhouse_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		local fixedPos_mines = self:GetPos() + self:GetUp() * -1 + self:GetRight() * -14 + self:GetForward() * 16
		cam.Start3D2D(fixedPos_mines, fixedAng, 0.1)
			draw.SimpleText( "ШАХТЫ", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( mines_control, "Default", 50, 25, mines_col, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

end