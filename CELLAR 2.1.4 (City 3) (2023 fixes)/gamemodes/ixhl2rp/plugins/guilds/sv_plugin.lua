local PLUGIN = PLUGIN

util.AddNetworkString 'ix_guild_create'
util.AddNetworkString 'ix_guild_delete'
util.AddNetworkString 'ix_guild_sync'
util.AddNetworkString 'ix_guild_members_receive'
util.AddNetworkString 'ix_guild_members_request'

util.AddNetworkString 'ix_guild_mgmt_get_all'
util.AddNetworkString 'ix_guild_mgmt_fetch_data'
util.AddNetworkString 'ix_guild_mgmt_ping'
util.AddNetworkString 'ix_guild_mgmt_update'

-- @TODO make it less complicated

util.AddNetworkString 'ix_guild_add_role'
util.AddNetworkString 'ix_guild_add_role_privilege'
util.AddNetworkString 'ix_guild_edit_role_privilege'
util.AddNetworkString 'ix_guild_remove_role'
util.AddNetworkString 'ix_guild_remove_role_privilege'
util.AddNetworkString 'ix_guild_add_group'
util.AddNetworkString 'ix_guild_add_group_privilege'
util.AddNetworkString 'ix_guild_edit_group_privilege'
util.AddNetworkString 'ix_guild_remove_group'
util.AddNetworkString 'ix_guild_remove_group_privilege'


function PLUGIN:PlayerInitialSpawn(client)
  ix.guilds.sync(nil, client)
end

-- @TODO refactor save-load methods

local function save_data(id)
  local guild = ix.guilds.get(id)

  if guild then
    local to_json = util.TableToJSON
    local all_data = guild:get_data()

    local query_update = mysql:Update('ix_guilds')
      query_update:Where('id', all_data.id)
      query_update:Update('icon', all_data.icon)
      query_update:Update('roles', to_json(all_data.roles))
      query_update:Update('groups', to_json(all_data.groups))
      query_update:Update('members', to_json(all_data.members))
      query_update:Update('invites', to_json(all_data.invites))
      query_update:Update('level', all_data.level)
      query_update:Update('balance', all_data.balance)
      query_update:Update('lore', all_data.lore)
    query_update:Execute()
  end
end

function PLUGIN:SaveData()
  for id, _ in pairs(ix.guilds.all()) do
    save_data(id)
  end
end

local function is_guild_member_online(guild)
  local boolean = false

  local players = player.GetAll()

  for i = 1, player.GetCount() do
    if !players[i]:GetCharacter() then continue end

    if guild:get_member(players[i]:GetCharacter()) then
      boolean = true

      break
    end
  end

  return boolean
end

function PLUGIN:PlayerLoadedCharacter(client, character, current_character)
  if current_character then
    local id = current_character:GetGuildUID()

    if id != -1 then
      local guild = ix.guilds.get(id)

      if !is_guild_member_online(guild) then
        save_data(id)
        ix.guilds.stored[id] = nil
        ix.guilds.sync(id)
      end
    end
  end

  local id = character:GetGuildUID()
  if id == -1 then return end

  if !ix.guilds.get(id) then
    local query_find = mysql:Select('ix_guilds')
      query_find:Where('id', id)
      query_find:Callback(function(result)
        if (!istable(result) or #result == 0) then return end
        local to_table = util.JSONToTable

        result = result[1]
        
        result.id = tonumber(result.id)
        result.owner = tonumber(result.owner)
        result.level = tonumber(result.level)
        result.members = to_table(result.members)
        result.roles = to_table(result.roles)
        result.groups = to_table(result.groups)
        result.invites = to_table(result.invites)

        local guild = ix.meta.guild:New(result.id, result.owner, result.name)
        guild:sync_data(result)

        ix.guilds.stored[id] = guild
        ix.guilds.sync(id)
      end)
    query_find:Execute()
  end
end

function PLUGIN:PreCharacterDeleted(client, character)
  local id = character:GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if !guild then
    -- code
  end

  if guild:is_owner(character:GetID()) then
    return ix.guilds.delete(id)
  end

  guild:remove_member(character)
  guild:sync()
end

function PLUGIN:OnCharacterDisconnect(client, character)
  local id = character:GetGuildUID()

  if id != -1 then
    local guild = ix.guilds.get(id)

    if !is_guild_member_online(guild) then
      ix.guilds.stored[id] = nil
      ix.guilds.sync(id)
    end
  end
end

net.Receive('ix_guild_create', function(length, client)
  local name = net.ReadString()

  local string_length = name:utf8len()

  local min = ix.config.Get('minGuildNameLength')
  local max = ix.config.Get('maxGuildNameLength')

  if name:find('%S') and string_length >= min and string_length <= max then
    ix.guilds.register(client:GetCharacter(), name)
  end
end)

net.Receive('ix_guild_delete', function(length, client)
  ix.guilds.delete(client:GetCharacter())
end)

net.Receive('ix_guild_members_request', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  local query_find = mysql:Select('ix_guilds')
    query_find:Where('id', guild:get_id())
    query_find:Select('members')
    query_find:Callback(function(guild_result)
      if (!istable(guild_result) or #guild_result == 0) then return end

      guild_result = guild_result[1]
      guild_result.members = util.JSONToTable(guild_result.members)

      local query = mysql:Select("ix_characters")
      query:Select("name")
      query:Select("id")
      query:Where("schema", Schema and Schema.folder or "helix")
      query:Callback(function(characters_result)
        if (!istable(characters_result) or #characters_result == 0) then return end

        local members = {}

        for i = 1, #characters_result do
          id = tonumber(characters_result[i].id)
          
          if guild_result.members[id] then
            members[id] = {
              id = id,
              name = characters_result[i].name,
              guild_data = guild_result.members[id],
              online = ix.char.loaded[id] and IsValid(ix.char.loaded[id]:GetPlayer())
            }
          end
        end

        local json = util.TableToJSON(members)
        local compressed = util.Compress(json)
        local length = compressed:len()

        net.Start("ix_guild_members_receive")
          net.WriteUInt(length, 32)
          net.WriteData(compressed, length)
        net.Send(client)
      end)
      query:Execute()
    end)
  query_find:Execute()
end)

-- @TODO make it less complicated

net.Receive('ix_guild_add_role', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if guild:has_privilege(client:GetCharacter(), GUILD_ENUM_PRIVILEGES.ADD_ROLES) then
    local key = net.ReadString()
    if guild:get_roles()[key] then return end

    guild:add_role(key)
    guild:sync()
  end
end)

net.Receive('ix_guild_edit_role_privilege', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if guild:has_privilege(client:GetCharacter(), GUILD_ENUM_PRIVILEGES.MANAGE_PRIVILEGES) then
    local role = net.ReadString()
    local key = net.ReadInt(6)
    local boolean = net.ReadBool()

    local get_roles = guild:get_roles()[role]

    if get_roles then
      guild:edit_role_privileges(role, key, boolean)
      guild:sync()
    end
  end
end)

net.Receive('ix_guild_remove_role', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if guild:has_privilege(client:GetCharacter(), GUILD_ENUM_PRIVILEGES.REMOVE_ROLES) then
    guild:remove_role(net.ReadString())
    guild:sync()
  end
end)

net.Receive('ix_guild_add_group', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if guild:has_privilege(client:GetCharacter(), GUILD_ENUM_PRIVILEGES.ADD_GROUPS) then
    local key = net.ReadString()
    if guild:get_groups()[key] then return end

    guild:add_group(key)
    guild:sync()
  end
end)

net.Receive('ix_guild_edit_group_privilege', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if guild:has_privilege(client:GetCharacter(), GUILD_ENUM_PRIVILEGES.MANAGE_PRIVILEGES) then
    local group = net.ReadString()
    local key = net.ReadInt(6)
    local boolean = net.ReadBool()

    local get_groups = guild:get_groups()[group]

    if get_groups then
      guild:edit_group_privileges(group, key, boolean)
      guild:sync()
    end
  end
end)

net.Receive('ix_guild_remove_group', function(length, client)
  local id = client:GetCharacter():GetGuildUID()
  if id == -1 then return end

  local guild = ix.guilds.get(id)

  if guild:has_privilege(client:GetCharacter(), GUILD_ENUM_PRIVILEGES.REMOVE_GROUPS) then    
    guild:remove_group(key)
    guild:sync()
  end
end)

net.Receive('ix_guild_mgmt_fetch_data', function(length, client)
  if !CAMI.PlayerHasAccess(client, 'Guilds - Manage guilds', nil) then return end

  local fetch_data = {}

  local query_find = mysql:Select('ix_guilds')
    query_find:Select('id')
    query_find:Select('name')
    query_find:Callback(function(result)
      if (!istable(result) or #result == 0) then return end
      
      for i = 1, #result do
        fetch_data[#fetch_data + 1] = { id = result[i].id, name = result[i].name }
      end
    end)
  query_find:Execute()

  local json = util.TableToJSON(fetch_data)
  local compressed = util.Compress(json)
  local length = compressed:len()

  net.Start('ix_guild_mgmt_fetch_data')
    net.WriteUInt(length, 32)
    net.WriteData(compressed, length)
  net.Send(client)
end)

net.Receive('ix_guild_mgmt_ping', function(length, client)
  if !CAMI.PlayerHasAccess(client, 'Guilds - Manage guilds', nil) then return end

  local id = net.ReadString()
  local data = {}

  local guild = ix.guilds.get(tonumber(id))

  if guild then
    data.id = guild.id
    data.name = guild.name
    data.lore = guild.lore
    data.balance = guild.balance
    data.owner = guild.owner
    data.level = guild.level
    data.roles = guild.roles
    data.groups = guild.groups
    data.invites = guild.invites
    data.members = {}

    local characters = ix.char.loaded

    for i = 1, #characters do
      id = characters[i]:GetID()
      member = guild:get_member(id)

      if member then
        data.members[id] = {
          name = characters[i]:GetName(),
          role = member.role,
          group = member.group
        }
      end
    end
  else
    local query_find = mysql:Select('ix_guilds')
      query_find:Where('id', id)
      query_find:Callback(function(result)
        if (!istable(result) or #result == 0) then return end

        local to_table = util.JSONToTable

        result = result[1]
        
        result.id = tonumber(result.id)
        result.owner = tonumber(result.owner)
        result.level = tonumber(result.level)
        result.members = to_table(result.members)
        result.roles = to_table(result.roles)
        result.groups = to_table(result.groups)
        result.invites = to_table(result.invites)

        local query = mysql:Select('ix_characters')
        query:Select('id')
        query:Select('name')
        query:Callback(function(characters_result)
          if (!istable(characters_result) or #characters_result == 0) then return end

          for i = 1, #characters_result do
            id = tonumber(characters_result[i].id)

            if result.members[id] then
              result.members[id].name = tostring(characters_result[i].name)
            end
          end
        end)
        query:Execute()

        data = result
      end)
    query_find:Execute()
  end

  local json = util.TableToJSON(data)
  local compressed = util.Compress(json)
  local length = compressed:len()

  net.Start('ix_guild_mgmt_ping')
    net.WriteUInt(length, 32)
    net.WriteData(compressed, length)
  net.Send(client)
end)

net.Receive('ix_guild_mgmt_update', function(length, client)
  if !CAMI.PlayerHasAccess(client, 'Guilds - Manage guilds', nil) then return end

  local id = net.ReadString()
  local length = net.ReadUInt(32)
  local data = net.ReadData(length)
  local uncompressed = util.Decompress(data)

  if (!uncompressed) then
    return ErrorNoHalt('[Helix] Unable to decompress guild data!\n')
  end

  uncompressed = util.JSONToTable(uncompressed)

  local guild = ix.guilds.get(tonumber(id))

  if guild then
    for k, v in pairs(uncompressed) do
      guild[k] = v
      guild:sync()
    end

    return
  end

  -- db changes
end)
