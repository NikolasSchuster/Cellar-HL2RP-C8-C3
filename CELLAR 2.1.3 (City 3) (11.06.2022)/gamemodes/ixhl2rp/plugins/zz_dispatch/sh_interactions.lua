if CLIENT then
	do
		local function Circle(sx, sy, radius, vertexCount, color, angle)
			local vertices = {}
			local ang = -math.rad(angle or 0)
			local c = math.cos(ang)
			local s = math.sin(ang)
			for i = 0, 360, 360 / vertexCount do
				local radd = math.rad(i)
				local x = math.cos(radd)
				local y = math.sin(radd)

				local tempx = x * radius * c - y * radius * s + sx
				y = x * radius * s + y * radius * c + sy
				x = tempx

				vertices[#vertices + 1] = {
					x = x,
					y = y,
					u = u,
					v = v
				}
			end

			if vertices and #vertices > 0 then
				draw.NoTexture()
				surface.SetDrawColor(color)
				surface.DrawPoly(vertices)
			end
		end

		local f, b = Vector(0, 0, 0), Angle(0, 90, 90)
		function dispatch.Draw3DCursor()
			local dir = LocalPlayer():EyeAngles():Forward()
			local trace = dispatch.GetViewTrace()

			if !trace then
				return
			end

			local hitNormal = trace.Hit and trace.HitNormal or -dir

			if math.abs(hitNormal.z) > .98 then
				hitNormal:Add(-dir * .01)
			end

			local pos, ang = LocalToWorld(f, b, trace.HitPos, hitNormal:Angle())
			cam.Start3D2D(pos, ang, math.pow(trace.Fraction, .1) * (a or .2))
				cam.IgnoreZ(true)
					render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD, BLEND_DST_ALPHA, BLEND_DST_ALPHA, BLENDFUNC_ADD)

					Circle(0, 0, 32, 18, Color(0, 200, 255), 0)

					render.OverrideBlend(false)
				cam.IgnoreZ(false)
			cam.End3D2D()
		end
	end

	do
		local showradial = false
		function dispatch.ShowQuickPingMenu()
			if IsValid(ix.gui.waypoints) then
				local leftClick = input.WasMouseReleased(MOUSE_LEFT)
				local rightClick = input.WasMouseReleased(MOUSE_RIGHT)

				if leftClick then
					hook.Run("quickmenu.leftclick")
				end

				if rightClick then
					hook.Run("quickmenu.rightclick")
				end
			end

			if IsValid(ix.gui.dispatch) then
				return
			end

			if !showradial and input.IsKeyDown(KEY_T) and !IsValid(vgui.GetHoveredPanel()) and !gui.IsConsoleVisible() and !gui.IsGameUIVisible() then
				if BLOCK_WAYPOINT_USE > CurTime() then return end

				if !IsValid(ix.gui.waypoints) then
					local a = vgui.Create("dispatch.radial.menu")
					a.KeyCode = KEY_T
					BLOCK_WAYPOINT_USE = CurTime() + 0.25
					showradial = true
				end
			elseif input.WasKeyReleased(KEY_T) and showradial then
				showradial = false
			end
		end
	end

	local c = Color(32, 200, 255, 255)
	hook.Add("PreDrawHalos", "dispatch.ui", function()
		if !IsValid(ix.gui.dispatch) then return end
		if !IsValid(vgui.GetHoveredPanel()) || vgui.GetHoveredPanel():IsWorldClicker() then return end

		local trace = dispatch.GetViewTrace()
		local ent = trace.Entity

		if !IsValid(ent) then return end
		if !dispatch.world_hints[ent:GetClass()] then return end

		halo.Add({ent}, c, 1, 1, 1, true, false)
	end)
end

local function chooseOptimalBits(amount)
	local bits = 1

	while 2 ^ bits <= amount do
		bits = bits + 1
	end

	return math.max(bits, 1)
end

do
	dispatch.world_hints = {}
	dispatch.world_actions = {}
	local worldActionIndex = 0

	local meta = {
		MsgStart = function(self)
			net.Start("dispatch.world.action")
			net.WriteUInt(self.Index, worldActionIndex)
		end,
		MsgEnd = function(self)
			net.SendToServer()
		end
	}
	meta.__index = meta

	function dispatch.WorldAction(data)
		local index = (#dispatch.world_actions + 1)
		worldActionIndex = chooseOptimalBits(index)

		data.Index = index
		setmetatable(data, meta)

		dispatch.world_actions[index] = data

		local class = data.HintClass

		if class then
			if isstring(class) then
				dispatch.world_hints[class] = true
			elseif istable(class) then
				for _, v in ipairs(class) do
					dispatch.world_hints[v] = true
				end
			end
		end
	end

	if SERVER then
		util.AddNetworkString("dispatch.world.action")

		net.Receive("dispatch.world.action", function(len, client)
			if !IsValid(client) then return end
			if !dispatch.InDispatchMode(client) then return end

			local index = net.ReadUInt(worldActionIndex)
			if !index then return end

			local action = dispatch.world_actions[index]
			if !action then return end
			if !action.Receive then return end

			action:Receive(client)
		end)
	else
		local function AddToggleOption(data, menu, entity, client, trace)
			if !menu.ToggleSpacer then
				menu.ToggleSpacer = menu:AddSpacer()
				menu.ToggleSpacer:SetZPos(500)
			end

			local checked = data:Checked(entity, client)
			local label = checked and data.LabelOn or data.LabelOff

			local option = menu:AddOption(label, function() 
				data:Action(entity, client, trace) 
			end)

			option:SetChecked(checked)
			option:SetImage(!checked and "icon16/accept.png" or "icon16/delete.png")
			option:SetZPos(501)

			return option
		end

		local function AddOption(data, menu, entity, client, trace)
			if data.Type == "toggle" then return AddToggleOption(data, menu, entity, client, trace) end

			if data.PrependSpacer then
				menu:AddSpacer()
			end

			local option = menu:AddOption(data.Label, function() data:Action(entity, client, trace) end)

			if data.Icon then
				option:SetImage(data.Icon)
			end

			return option
		end

		function dispatch.OpenWorldAction()
			local trace = dispatch.GetViewTrace()
			local entity = trace.Entity

			local menu = DermaMenu()

			for k, v in SortedPairsByMemberValue(dispatch.world_actions, "Order") do
				if !v.Filter then continue end
				if !v:Filter(entity, LocalPlayer()) then continue end

				local option = AddOption(v, menu, entity, LocalPlayer(), trace)
			end

			menu:Open()
		end
	end
end

dispatch.WorldAction({
	Label = "Поставить метку",
	--Icon = "",
	Order = 1,

	Filter = function(self, entity, client)
		return true
	end,

	Action = function(self, entity, client, trace)
		if !IsValid(ix.gui.waypoints) then
			vgui.Create("dispatch.radial.menu")

			ix.gui.waypoints.isDispatch = true
			ix.gui.waypoints.pos = trace.HitPos
		end
	end
})

dispatch.WorldAction({
	LabelOn = "Выключить рационник",
	LabelOff = "Включить рационник",
	--Icon = "",
	Order = 2,

	Type = "toggle",

	HintClass = "ix_rationdispenser",

	Filter = function(self, entity)
		return IsValid(entity) and entity:GetClass() == self.HintClass
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Checked = function(self, entity)
		return entity:GetEnabled() == true
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !self:Filter(entity) then return end

		entity:SetEnabled(!entity:GetEnabled())
	end
})

dispatch.WorldAction({
	Label = "Обозначить как нарушителя",
	Icon = "icon16/exclamation.png",
	Order = 2,

	HintClass = "player",

	Filter = function(self, entity)
		return IsValid(entity) and entity:IsPlayer() and !entity:IsCombine()
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !IsValid(entity) or !entity:IsPlayer() or !entity:GetCharacter() then return end

		local card = entity:GetCharacter():GetIDCard()

		local data = ""
		if card then
			data = string.format(" #%s %s", card:GetData("cid", 0), card:GetData("name", ""))

			ix.plugin.list["datafile"]:SetBOL(nil, entity.ixDatafile, true)
		end

		local letter = dispatch.AddWaypoint(entity:GetShootPos(), "НАРУШИТЕЛЬ"..data, "warn", 60)

		Schema:AddCombineDisplayMessage(string.format("Метка %s: %s", letter, card and ("гражданин"..data.." помечен как нарушитель!") or "неопознанное лицо помечено как нарушитель!"), color_red)
	end
})

dispatch.WorldAction({
	Label = "Открыть личное дело",
	Icon = "icon16/book_open.png",
	Order = 3,

	HintClass = "player",

	Filter = function(self, entity)
		return IsValid(entity) and entity:IsPlayer()
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !IsValid(entity) or !entity:IsPlayer() or !entity:GetCharacter() then return end

		dispatch.OpenDatafile(client, entity:GetCharacter())
	end
})

dispatch.WorldAction({
	Label = "Наблюдать",
	Icon = "icon16/zoom.png",
	Order = 4,

	HintClass = "player",

	Filter = function(self, entity)
		return IsValid(entity) and entity:IsPlayer() and entity:Team() == FACTION_MPF
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !IsValid(entity) or !entity:IsPlayer() or !entity:GetCharacter() then return end

		dispatch.Spectate(client, entity)

		ix.log.Add(client:GetCharacter(), "squadObserve", entity:GetCharacter())
	end
})

dispatch.WorldAction({
	LabelOn = "Разблокировать дверь",
	LabelOff = "Заблокировать дверь",
	--Icon = "",
	Order = 3,

	Type = "toggle",

	HintClass = "func_door",

	Filter = function(self, entity)
		return IsValid(entity) and entity:GetClass() == self.HintClass and !entity:HasSpawnFlags(256) and !entity:HasSpawnFlags(1024)
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Checked = function(self, entity)
		return (entity:GetNWBool("locked") or false) == true
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !self:Filter(entity) then return end

		local locked = entity:IsLocked()
		locked = !locked

		entity:Fire(locked and "lock" or "unlock")
		entity:SetNWBool("locked", locked)
	end
})

dispatch.WorldAction({
	Label = "Использовать",
	Icon = "icon16/connect.png",
	Order = 2,

	HintClass = "func_door",

	Filter = function(self, entity)
		return IsValid(entity) and entity:GetClass() == self.HintClass and !entity:HasSpawnFlags(256) and !entity:HasSpawnFlags(1024)
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !self:Filter(entity) then return end

		entity:Fire((entity:GetInternalVariable("m_toggle_state") == 0) and "close" or "open")
	end
})

dispatch.WorldAction({
	LabelOn = "Включить замок",
	LabelOff = "Отключить замок",
	--Icon = "",
	Order = 2,

	Type = "toggle",

	HintClass = "ix_combinelock",

	Filter = function(self, entity)
		return IsValid(entity) and entity:GetClass() == self.HintClass
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Checked = function(self, entity)
		return entity:GetLocked() == true
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !self:Filter(entity) then return end

		entity:SetLocked(!entity:GetLocked())
	end
})

dispatch.WorldAction({
	LabelOn = "Разблокировать замок",
	LabelOff = "Заблокировать замок",
	--Icon = "",
	Order = 3,

	Type = "toggle",

	HintClass = "ix_combinelock",

	Filter = function(self, entity)
		return IsValid(entity) and entity:GetClass() == self.HintClass
	end,

	Action = function(self, entity, client, trace)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Checked = function(self, entity)
		return (entity:GetNWBool("locked") or false) == true
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()

		if !self:Filter(entity) then return end

		local locked = !(entity:GetNWBool("locked") or false)

		entity:SetLocked(locked)
		entity:EmitSound("buttons/combine_button_locked.wav")
		entity:SetDisplayError(locked)
		entity.nextUseTime = locked and (CurTime() + 3600) or CurTime()
		entity:SetNWBool("locked", locked)
	end
})

dispatch.WorldAction({
	Label = "Установить режим доступа",
	Order = 2,
	HintClass = "ix_forcefield",

	Filter = function(self, entity)
		return IsValid(entity) and entity:GetClass() == self.HintClass
	end,

	Action = function(self, entity, client, trace)
		local m = DermaMenu()

		m:AddOption("Разрешить доступ всем", function()
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteUInt(0, 3)
			self:MsgEnd()
		end)
		m:AddOption("Проход только по доступу", function()
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteUInt(1, 3)
			self:MsgEnd()
		end)
		m:AddOption("Проход недоступен", function()
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteUInt(2, 3)
			self:MsgEnd()
		end)

		m:Open()
	end,

	Receive = function(self, client)
		local entity = net.ReadEntity()
		local y = net.ReadUInt(3)
		if !self:Filter(entity) then return end

		local x = {
			[1] = 3,
			[2] = 1,
			[3] = 2
		}

		local mode = math.Clamp(x[y + 1], 1, 3)

		entity.mode = mode
		entity:SetDTInt(0, mode)

		if entity.mode == 3 then
			entity.on = false
			entity:SetSkin(1)
			entity.dummy:SetSkin(1)
			entity:EmitSound("shield/deactivate.wav")
			entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
		elseif entity.mode == 1 then
			entity.on = true
			entity:SetSkin(0)
			entity.dummy:SetSkin(0)
			entity:EmitSound("shield/activate.wav")
			entity:SetCollisionGroup(COLLISION_GROUP_NONE)
		end
	end
})