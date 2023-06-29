local PANEL = {}

function PANEL:Init()
  if (IsValid(ix.gui.guild_manager)) then
    ix.gui.guild_manager:Remove()
  end

  ix.gui.guild_manager = self

  self:SetSize(ScrW() * 0.35, ScrH() * 0.5)
  self:Center()
  self:MakePopup()
  self:SetTitle('Упрощенный менеджер гильдий')
  self:ShowCloseButton(true)

  self.sheet = self:Add('DPropertySheet')
  self.sheet:Dock(FILL)
  self.sheet.OnActiveTabChanged = function(this, old_tab, new_tab)
    if new_tab:GetPanel().initialize then
      new_tab:GetPanel():initialize()
    end
  end

  self:InvalidateLayout(true)

  self.editor = self.sheet:Add('ix_guild_manager_editor')
  self.sheet:AddSheet('Список гильдий', self.editor, 'icon16/book_add.png')
end

vgui.Register('ix_guild_manager', PANEL, 'DFrame')

local PANEL = {}

function PANEL:Init()
  self.list = self:Add('DScrollPanel')
  self.list:Dock(FILL)

  net.Start('ix_guild_mgmt_fetch_data')
  net.SendToServer()

  net.Receive('ix_guild_mgmt_fetch_data', function()
    local length = net.ReadUInt(32)
    local data = net.ReadData(length)
    local uncompressed = util.Decompress(data)

    if (!uncompressed) then
      return ErrorNoHalt('[Helix] Unable to decompress guild data!\n')
    end

    local guild_data = util.JSONToTable(uncompressed)

    for i = 1, #guild_data do
      local label = self.list:Add('DButton')
      label:SetText('['..guild_data[i].id..'] '..guild_data[i].name)
      label:Dock(TOP)
      label:DockMargin(2, 2, 2, 2)
      label.Paint = function(this, width, height)
        surface.SetDrawColor(0, 0, 0, this:IsHovered() and 180 or 120)
        surface.DrawRect(0, 0, width, height)
      end

      label.DoClick = function(this, width, height)
        net.Start('ix_guild_mgmt_ping')
          net.WriteString(guild_data[i].id)
        net.SendToServer()

        net.Receive('ix_guild_mgmt_ping', function()
          local length = net.ReadUInt(32)
          local data = net.ReadData(length)
          local uncompressed = util.Decompress(data)

          if (!uncompressed) then
            return ErrorNoHalt('[Helix] Unable to decompress guild data!\n')
          end

          self:get_guild_data(util.JSONToTable(uncompressed))
        end)
      end
    end
  end)
end

local function create_entry(title, callback)
  local entry = callback()

  local parent = entry:GetParent()

  entry:SetZPos(parent.zpos)

  parent:InvalidateLayout(true)

  entry.label = parent:Add('DLabel')
  entry.label:SetText(title..':')
  entry.label:SetTextInset(2, 0)
  entry.label:SetWide(120)
  entry.label:SetPos(entry.x, entry.y + entry:GetTall() * 0.5 - entry.label:GetTall() * 0.5)
  entry.label:SetZPos(parent.zpos)

  entry:DockMargin(entry.label:GetWide(), 2, 2, 2)

  parent.zpos = parent.zpos + 1

  return entry
end

function PANEL:get_guild_data(...)
  local data = ...

  local has_tab = false

  for i = 1, #ix.gui.guild_manager.sheet:GetItems() do
    if ix.gui.guild_manager.sheet:GetItems()[i].Name == data.id then
      has_tab = true

      break    
    end
  end

  if has_tab then
    return ix.gui.guild_manager.sheet:SwitchToName(data.id)
  end

  local panel = vgui.Create('EditablePanel')
  panel:Dock(FILL)
  panel:DockMargin(2, 2, 2, 2)
  panel:InvalidateLayout(true)
  panel.zpos = 0
  panel.collect_data = {}
  panel.set_data = function(this, key, value)
    this.collect_data[key] = value
  end

  -- @TODO make a real logo

  -- panel.logo = panel:Add('DPanel')
  -- panel.logo:SetSize(128, 64)
  -- panel.logo:SetPos(self:GetWide() - panel.logo:GetWide() - 2, 2)
  -- panel.logo.material = ix.util.GetMaterial('hlmv/background')
  -- panel.logo.Paint = function(this, width, height)
  --   surface.SetDrawColor(color_white:Unpack())
  --   surface.SetMaterial(this.material)
  --   surface.DrawTexturedRect(0, 0, width, height)
  -- end

  create_entry('Название', function()
    local entry = panel:Add('DTextEntry')
    entry:Dock(TOP)
    entry:DockMargin(2, 2, 120, 2)
    entry:SetText(data.name)
    entry.OnChange = function(this)
      panel:set_data('name', this:GetText())
    end

    return entry
  end)

  create_entry('Уровень', function()
    local entry = panel:Add('DLabel')
    entry:Dock(TOP)
    entry:DockMargin(2, 2, 2, 2)
    entry:SetText(data.level)
    entry:SetMouseInputEnabled(true)
    entry.DoClick = function(this)
      local derma_menu = DermaMenu()

      for i = 0, 4 do
        if tonumber(this:GetText()) == i then continue end

        derma_menu:AddOption(i, function()
          this:SetText(i)

          panel:set_data('level', tonumber(i))
        end)
      end

      derma_menu:Open()
    end

    return entry
  end)

  create_entry('Баланс', function()
    data.balance = tostring(data.balance)

    local entry = panel:Add('DTextEntry')
    entry:Dock(TOP)
    entry:DockMargin(2, 2, 2, 2)
    entry:SetPlaceholderText(data.balance)
    entry:SetNumeric(true)
    entry.OnChange = function(this)
      panel:set_data('balance', tonumber(this:GetText()))
    end

    return entry
  end)

  create_entry('Описание', function()
    local entry = panel:Add('DLabel')
    entry:Dock(TOP)
    entry:DockMargin(2, 2, 2, 2)
    entry:SetText(data.lore)
    entry:SetMouseInputEnabled(true)
    entry.SizeToContents = function(this)
      if (this.bWrap) then return end

      local width, height = this:GetContentSize()

      if (width > self:GetWide()) then
        this:SetWide(self:GetWide())
        this:SetTextInset(0, 8)
        this:SetWrap(true)
        this:SizeToContentsY()
        this:SetTall(this:GetTall() + 16) -- eh
        this:SetContentAlignment(8)
        this.bWrap = true
      else
        this:SetSize(width + 16, height + 16)
      end
    end

    entry.OnMousePressed = function(this, key)
      if key != MOUSE_LEFT then return end

      Derma_StringRequest('Описание гильдии', '', this:GetText(), function(text)
        this:SetText(text)
        this:SizeToContents()

        panel:set_data('lore', text)
      end)
    end

    entry:SizeToContents()

    return entry
  end)

  local members = panel:Add('DListView')
  members:Dock(FILL)
  members:DockMargin(2, 2, 2, 2)
  members:SetMultiSelect( false )
  members:AddColumn('Имя')
  members:AddColumn('Роль')
  members:AddColumn('Группа')
  members:SetZPos(5)
  
  for _, v in pairs(data.members) do
    members:AddLine(v.name, v.role, v.group or '--')
  end

  local update = panel:Add('DButton')
  update:SetText('Обновить конфигурацию')
  update:SizeToContents()
  update:Dock(BOTTOM)
  update:DockMargin(2, 2, 2, 2)
  update.DoClick = function(this)
    local json = util.TableToJSON(panel.collect_data)
    local compressed = util.Compress(json)
    local length = compressed:len()

    net.Start("ix_guild_mgmt_update")
      net.WriteString(data.id)
      net.WriteUInt(length, 32)
      net.WriteData(compressed, length)
    net.SendToServer()
  end

  ix.gui.guild_manager.sheet:AddSheet(data.id, panel, nil)
  ix.gui.guild_manager.sheet:SwitchToName(data.id)
end

vgui.Register('ix_guild_manager_editor', PANEL, 'EditablePanel')
