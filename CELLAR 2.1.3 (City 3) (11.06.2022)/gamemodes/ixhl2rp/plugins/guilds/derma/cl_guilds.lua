local PANEL = {}

local loading_material = ix.util.GetMaterial 'widgets/disc.png'

local debug_paint = function(this, width, height)
  surface.SetDrawColor(100, 0, 0, 100)
  surface.DrawRect(0, 0, width, height)
end

function PANEL:Init()
  local parent = self:GetParent()

  self:SetSize(parent:GetWide(), parent:GetTall())
  self:Center()
end

function PANEL:update()
  self:Clear()

  self.guild = ix.guilds.get(LocalPlayer():GetCharacter():GetGuildUID())

  if self.guild then
    return self:show_guild()
  end

  return self:no_guild()
end

function PANEL:show_guild()
  local level = self.guild:get_level()

  self.info = self:Add('EditablePanel')
  self.info:SetTall(self:GetTall() * 0.05)
  self.info:Dock(TOP)
  self.info:DockMargin(2, 2, 2, 2)
  self.info.Paint = function(this, width, height)
    surface.SetDrawColor(color_white:Unpack())
    surface.DrawRect(0, height - 1, width, 1)
  end

  self.info:InvalidateLayout(true)

  self.navigation = self:Add('EditablePanel')
  self.navigation:SetTall(self:GetTall() * 0.05)
  self.navigation:Dock(TOP)
  self.navigation.current_tab = nil
  self.navigation.Paint = debug_paint

  self.dashboard = self:Add('EditablePanel')
  self.dashboard:Dock(FILL)
  self.dashboard:DockMargin(2, 2, 2, 2)

  self.label_level = self.info:Add('DLabel')
  self.label_level:SetFont('ixMenuButtonLabelFont')
  self.label_level:SetText('Уровень гильдии: ')
  self.label_level:SizeToContents()
  self.label_level:SetTextColor(color_white)
  self.label_level:SetPos(4, self.info:GetTall() * 0.5 - self.label_level:GetTall() * 0.5)

  self.current_level = self.info:Add('DLabel')
  self.current_level:SetFont('ixMenuButtonLabelFont')
  self.current_level:SetText(level < 1 and 'отсутствует' or ('/ '):rep(level))
  self.current_level:SizeToContents()
  self.current_level:SetTextColor(color_white)
  self.current_level:SetPos(self.label_level.x + self.label_level:GetWide() + 2, self.info:GetTall() * 0.5 - self.current_level:GetTall() * 0.5)

  if level > 0 then
    self.balance = self.info:Add('DLabel')
    self.balance:SetFont('ixMenuButtonLabelFont')
    self.balance:SetText('Баланс: '..self.guild:get_balance())
    self.balance:SizeToContents()
    self.balance:SetTextColor(color_white)
    self.balance:SetPos(self:GetWide() - self.balance:GetWide() - 4, self.info:GetTall() * 0.5 - self.balance:GetTall() * 0.5)
  end

  self:add_navigation_button('Список участников', function()
    local loading = self.dashboard:Add('EditablePanel')
    loading:SetSize(128, 128)
    loading:Center()
    loading.Paint = function(this, width, height)
      surface.SetDrawColor(color_white:Unpack())
      surface.SetMaterial(loading_material)
      surface.DrawTexturedRectRotated(width * 0.5, height * 0.5, width, height, -CurTime() * 512)
    end

    local members_scroll = self.dashboard:Add('DScrollPanel')
    members_scroll:Dock(FILL)

    net.Start('ix_guild_members_request')
    net.SendToServer()

    net.Receive('ix_guild_members_receive', function(length, client)
      local length = net.ReadUInt(32)
      local data = net.ReadData(length)
      local uncompressed = util.Decompress(data)

      if (!uncompressed) then
        return ErrorNoHalt('[Helix] Unable to decompress guild data!\n')
      end

      uncompressed = util.JSONToTable(uncompressed)

      for i = 1, #uncompressed do
        if !uncompressed[i] then continue end
        
        panel = members_scroll:Add('DButton')
        panel:SetText('')
        panel:Dock(TOP)
        panel:SetTall(64)
        panel.Paint = function(this, width, height)
          local color = derma.GetColor(uncompressed[i].online and 'Success' or 'Error', this)

          surface.SetDrawColor(ColorAlpha(color, 20))
          surface.DrawRect(0, 0, width, height)
        end

        name = panel:Add('DLabel')
        name:SetFont('ixMenuButtonLabelFont')
        name:SetText(uncompressed[i].name)
        name:SizeToContents()
        name:SetPos(4, 4)

        if self.guild:is_owner(self.guild.owner) then
          owner = panel:Add('DLabel')
          owner:SetFont('ixToolTipText')
          owner:SetText('(Создатель)')
          owner:SizeToContents()
          owner:SetTextColor(color_hover)
          owner:SetPos(name.x + name:GetWide() + 4, name.y)
        end

        role = panel:Add('DLabel')
        role:SetFont('ixMenuButtonLabelFont')
        role:SetTextColor(color_text)
        role:SetText('Роль: '..uncompressed[i].guild_data.role)
        role:SizeToContents()
        role:SetPos(name.x, name.y + name:GetTall() + 4)

        if uncompressed[i].guild_data.group then
          divider = self.navigation:Add('DShape')
          divider:SetType('Rect')
          divider:SetSize(1, panel:GetTall())
          divider:SetPos(0, 0) 
          divider:SetColor(Color(0, 255, 0, 255))

          group = panel:Add('DLabel')
          group:SetFont('ixMenuButtonLabelFont')
          group:SetTextColor(color_text)
          group:SetText('Группа: '..uncompressed[i].guild_data.group)
          group:SizeToContents()
          group:SetPos(name.x, name.y + name:GetTall() + 4)
        end

        loading:Remove()
      end
    end)
  end, true)

  self:add_navigation_button('Настройки', function()
    local titles = self.dashboard:Add('EditablePanel')
    titles:Dock(TOP)
    titles:SetTall(32)

    titles.roles = titles:Add('DLabel')
    titles.roles:Dock(LEFT)
    titles.roles:SetWide(self.dashboard:GetWide() * 0.5)
    titles.roles:SetFont('ixMenuButtonLabelFont')
    titles.roles:SetText('Роли')
    titles.roles:SetContentAlignment(5)

    titles.groups = titles:Add('DLabel')
    titles.groups:Dock(RIGHT)
    titles.groups:SetWide(self.dashboard:GetWide() * 0.5)
    titles.groups:SetFont('ixMenuButtonLabelFont')
    titles.groups:SetText('Группы')
    titles.groups:SetContentAlignment(5)

    local roles_tree = self.dashboard:Add('DTree')
    roles_tree:Dock(LEFT)
    roles_tree:SetWide(self.dashboard:GetWide() * 0.5)
    roles_tree.OnMousePressed = function(this, key)
      if key != MOUSE_RIGHT then return end

      if !self.guild:has_privilege(LocalPlayer():GetCharacter(), GUILD_ENUM_PRIVILEGES.ADD_ROLES) then
        return
      end

      local derma_menu = DermaMenu()
      derma_menu:AddOption('Добавить роль', function()
        Derma_StringRequest('Создание роли', 'Введите название роли', 'Новая роль', function(text)
          if self.guild:get_roles()[text] then return end

          this:AddNode(text)

          net.Start('ix_guild_add_role')
            net.WriteString(text)
          net.SendToServer()
        end)
      end)
      derma_menu:Open()
    end

    local groups_tree = self.dashboard:Add('DTree')
    groups_tree:Dock(RIGHT)
    groups_tree:SetWide(self.dashboard:GetWide() * 0.5)
    groups_tree.OnMousePressed = function(this, key)
      if key != MOUSE_RIGHT then return end

      if !self.guild:has_privilege(LocalPlayer():GetCharacter(), GUILD_ENUM_PRIVILEGES.ADD_GROUPS) then
        return
      end

      local derma_menu = DermaMenu()
      derma_menu:AddOption('Добавить группу', function()
        Derma_StringRequest('Создание группы', 'Введите название группы', 'Новая группа', function(text)
          if self.guild:get_groups()[text] then return end

          this:AddNode(text)

          net.Start('ix_guild_add_group')
            net.WriteString(text)
          net.SendToServer()
        end)
      end)
      derma_menu:Open()
    end

    local function edit_role_privileges(key, value, boolean)
      net.Start('ix_guild_edit_role_privilege')
        net.WriteString(key)
        net.WriteInt(value, 6)
        net.WriteBool(boolean)
      net.SendToServer()
    end

    local function edit_group_privileges(key, value, boolean)
      net.Start('ix_guild_edit_group_privilege')
        net.WriteString(key)
        net.WriteInt(value, 6)
        net.WriteBool(boolean)
      net.SendToServer()
    end

    for k, v in pairs(self.guild:get_roles()) do
      name = roles_tree:AddNode(v.no_edit and k..' (неизменяем)' or k)
      name:SetEnabled(!v.no_edit)
      name:ExpandTo(true)
      name.privileges = {}
      name.DoRightClick = function(this, node)
        if !self.guild:has_privilege(LocalPlayer():GetCharacter(), GUILD_ENUM_PRIVILEGES.MANAGE_PRIVILEGES) then
          return
        end

        local derma_menu = DermaMenu()
        local privileges = derma_menu:AddSubMenu('Привилегии')

        if this.privileges[GUILD_ENUM_PRIVILEGES.ALL] then goto stop end

        for i, p in pairs(GUILD_ENUM_PRIVILEGES_TO_NAME) do
          if this.privileges[i] then continue end

          privileges:AddOption(p, function()
            privilege = this:AddNode(p)
            this.privileges[i] = i
            privilege.DoRightClick = function(this2)
              local remove_privilege = DermaMenu()
                remove_privilege:AddOption('Удалить '..GUILD_ENUM_PRIVILEGES_TO_NAME[i], function()
                  this2:Remove()
                  this.privileges[i] = nil

                  edit_role_privileges(k, i, nil)
                end)
              remove_privilege:Open()
            end

            edit_role_privileges(k, i, true)
          end)
        end

        derma_menu:Open()

        ::stop::
      end

      if next(v.privileges) then
        for i, p in pairs(v.privileges) do
          privilege = name:AddNode(GUILD_ENUM_PRIVILEGES_TO_NAME[i])
          privilege.DoRightClick = function(this2)
            local remove_privilege = DermaMenu()
              remove_privilege:AddOption('Удалить '..GUILD_ENUM_PRIVILEGES_TO_NAME[i], function()
                this2:Remove()

                edit_role_privileges(k, i, nil)
              end)
            remove_privilege:Open()
          end

          if GUILD_ENUM_PRIVILEGES[i] == GUILD_ENUM_PRIVILEGES.ALL then break end
        end
      end
    end

    for k, v in pairs(self.guild:get_groups()) do
      name = groups_tree:AddNode(k)
      name:ExpandTo(true)
      name.privileges = {}
      name.DoRightClick = function(this, node)
        if !self.guild:has_privilege(LocalPlayer():GetCharacter(), GUILD_ENUM_PRIVILEGES.MANAGE_PRIVILEGES) then
          return
        end

        local derma_menu = DermaMenu()
        local privileges = derma_menu:AddSubMenu('Привилегии')

        if this.privileges[GUILD_ENUM_PRIVILEGES.ALL] then goto stop end

        for i, p in pairs(GUILD_ENUM_PRIVILEGES_TO_NAME) do
          if this.privileges[i] then continue end

          privileges:AddOption(p, function()
            privilege = this:AddNode(p)
            this.privileges[i] = i
            privilege.DoRightClick = function(this2)
              local remove_privilege = DermaMenu()
                remove_privilege:AddOption('Удалить '..GUILD_ENUM_PRIVILEGES_TO_NAME[i], function()
                  this2:Remove()
                  this.privileges[i] = nil

                  edit_group_privileges(k, i, nil)
                end)
              remove_privilege:Open()
            end

            edit_group_privileges(k, i, true)
          end)
        end

        derma_menu:Open()

        ::stop::
      end

      if next(v.privileges) then
        for i, p in pairs(v.privileges) do
          privilege = name:AddNode(GUILD_ENUM_PRIVILEGES_TO_NAME[i])
          privilege.DoRightClick = function(this2)
            local remove_privilege = DermaMenu()
              remove_privilege:AddOption('Удалить '..GUILD_ENUM_PRIVILEGES_TO_NAME[i], function()
                this2:Remove()

                edit_group_privileges(k, i, nil)
              end)
            remove_privilege:Open()
          end

          if GUILD_ENUM_PRIVILEGES[i] == GUILD_ENUM_PRIVILEGES.ALL then break end
        end
      end
    end
  end)

  self:add_navigation_button('Приглашения', function()
  end)

  self:add_navigation_button('Удалить фракцию', function()
  end)
end

function PANEL:add_navigation_button(name, callback, is_default)
  local button = self.navigation:Add('DButton')
  button:SetFont('ixMenuButtonFontSmall')
  button:SetText(name)
  button:SetTextColor(color_white)
  button:SizeToContents()
  button:Dock(LEFT)
  button:DockMargin(2, 2, 2, 2)
  button:SetContentAlignment(5)

  if callback then
    button.DoClick = function(this)
      if self.navigation.current_tab != this then
        self.dashboard:Clear()

        callback(this)
      end

      self.navigation.current_tab = this
    end
  end
end

if is_default then
  button:DoClick()
end

function PANEL:no_guild()
  local create = self:Add('DButton')
  create:SetFont('ixMenuButtonFont')
  create:SetText('Создать фракцию')
  create:SetTextColor(color_white)
  create:SizeToContents()
  create:SetSize(self:GetWide() * 0.245, create:GetTall() + 8)
  create:CenterHorizontal()
  create:SetContentAlignment(5)
  create:Center()
  create.Paint = button_paint
  create.DoClick = function(this)
    self:Clear()
    self:create_new_guild()
  end

  local invites = self:Add('DButton')
  invites:SetFont('ixMenuButtonFont')
  invites:SetText('Приглашения')
  invites:SetTextColor(color_white)
  invites:SizeToContents()
  invites:SetSize(create:GetWide(), invites:GetTall() + 8)
  invites:CenterHorizontal()
  invites.Paint = button_paint
  invites:SetPos(invites.x, create.y + create:GetTall() + 16)
  invites.Paint = button_paint
  invites:SetEnabled(false)
  invites.DoClick = function(this)
    self:Clear()
    self:check_invites(LocalPlayer():GetLocalVar('invites', {}))
  end

  local invites_label = self:Add('DLabel')
  invites_label:SetFont('ixMenuButtonFontSmall')
  invites_label:SetText('')
  invites_label:SetTextColor(color_black)
  invites_label:SizeToContentsX(4)
  invites_label:SetTall(24)
  invites_label:SetContentAlignment(5)
  invites_label:SetPos(invites.x - invites_label:GetWide() * 0.5, invites.y - invites_label:GetTall() * 0.5)
  invites_label.Paint = function(this, width, height)
    draw.RoundedBox(4, 0, 0, width, height, Color(255,215,0))
  end

  invites_label.Think = function(this)
    local get_invites = LocalPlayer():GetLocalVar('invites', {})

    if next(get_invites) then
      this:Show()
      this:SetText(#get_invites)
      this:SizeToContentsX(4)

      invites:SetEnabled(true)

      return
    end

    this:Hide()
    invites:SetEnabled(false)
  end
end

function PANEL:create_new_guild()
  local title = self:Add('DLabel')
  title:SetFont('ixTitleFont')
  title:SetText('Создание фракции')
  title:SizeToContents()
  title:Center()

  local name_tip = self:Add('DLabel')
  name_tip:SetFont('ixMenuButtonFontSmall')
  name_tip:SetText('Название должно содержать минимум '..ix.config.Get('minGuildNameLength')..' и максимум '..ix.config.Get('maxGuildNameLength')..' символа(ов)')
  name_tip:SetTextColor(Color(250, 250, 250))
  name_tip:SizeToContents()
  name_tip:Center()
  name_tip:SetPos(name_tip.x, title.y + title:GetTall() - 4)

  local name = self:Add('DTextEntry')
  name:SetSize(self:GetWide() * 0.2, 24)
  name:Center()
  name:SetPos(name.x, name_tip.y + name_tip:GetTall() + 8)
  name:SetPlaceholderText('Введите название')

  local apply = self:Add('DButton')
  apply:SetFont('ixSubTitleFont')
  apply:SetText('Принять')
  apply:SizeToContents()
  apply:Center()
  apply:SetPos(apply.x, name.y + name:GetTall() + 8)
  apply.DoClick = function(this)
    local string_length = name:GetText():utf8len()

    local min = ix.config.Get('minGuildNameLength')
    local max = ix.config.Get('maxGuildNameLength')

    if !name:GetText():find('%S') or (string_length < min or string_length > max) then
      name_tip:SetColor(derma.GetColor('Error', name_tip))
      timer.Simple(0.3, function()
        if name_tip then
          name_tip:SetColor(color_white)
        end
      end)

      return
    end

    net.Start('ix_guild_create')
      net.WriteString(name:GetText())
    net.SendToServer()

    self:Clear()

    local loading = self:Add('EditablePanel')
    loading:SetSize(128, 128)
    loading:Center()
    loading.Paint = function(this, width, height)
      surface.SetDrawColor(color_white:Unpack())
      surface.SetMaterial(loading_material)
      surface.DrawTexturedRectRotated(width * 0.5, height * 0.5, width, height, -CurTime() * 512)
    end

    timer.Simple(2, function()
      self:update()
      loading:Remove()
    end)
  end
end

function PANEL:check_invites(invites)
  local goback = self:Add('DButton')
  goback:SetFont('ixMenuButtonFont')
  goback:SetTextColor(color_white)
  goback:SetText('НАЗАД')
  goback:SizeToContents()
  goback:SetPos(4, 6)
  goback.DoClick = function(this)
    self:Clear()
    self:no_guild()
  end

  local invites_scroll = self:Add('DScrollPanel')
  invites_scroll:Dock(FILL)
  invites_scroll:DockMargin(0, goback:GetTall() + 8, 0, 0)

  for i = 1, #invites do
    is_active = ix.guilds.get(invites[i].id) and true or false

    panel = invites_scroll:Add('EditablePanel')
    panel:Dock(TOP)
    panel:DockMargin(0, 2, 0, 2)
    panel:SetWide(self:GetWide())
    panel:SetTall(64)
    panel.Paint = function(this, width, height)
      local color = derma.GetColor(invites[i].is_active and 'Success' or 'Error', this)

      surface.SetDrawColor(ColorAlpha(color, 20))
      surface.DrawRect(0, 0, width, height)
    end

    decline = panel:Add('DButton')
    decline:SetFont('ixMenuButtonLabelFont')
    decline:SetTextColor(color_white)
    decline:SetText('Отклонить')
    decline:SizeToContents()
    decline:SetPos(panel:GetWide() - decline:GetWide() - 8, panel:GetTall() * 0.5 - decline:GetTall() * 0.5)

    accept = panel:Add('DButton')
    accept:SetFont('ixMenuButtonLabelFont')
    accept:SetTextColor(color_white)
    accept:SetText('Принять')
    accept:SizeToContents()
    accept:SetPos(decline.x - accept:GetWide() - 8, panel:GetTall() * 0.5 - accept:GetTall() * 0.5)

    name = panel:Add('DLabel')
    name:SetFont('ixMenuButtonLabelFont')
    name:SetText(invites[i].name)
    name:SizeToContents()
    name:SetPos(4, 4)

    invited_by = panel:Add('DLabel')
    invited_by:SetFont('ixMenuButtonLabelFont')
    invited_by:SetTextColor(color_white)
    invited_by:SetText('Пригласил: '..invites[i].invited_by)
    invited_by:SizeToContents()
    invited_by:SetPos(name.x, name.y + name:GetTall() + 4)
  end
end

function PANEL:Paint(width, height)
  debug_paint(self, width, height)
end

vgui.Register('ix_guilds', PANEL, 'EditablePanel')

hook.Add('CreateMenuButtons', 'ix_guilds', function(tabs)
  tabs['Guild'] = function(container)
    local panel = container:Add('ix_guilds')
    panel.call_parent = function(this, callback)
      if callback then
        callback(this, container)
      end
    end

    container.OnSetActive = function(this)
      panel:update()
    end
  end
end)
