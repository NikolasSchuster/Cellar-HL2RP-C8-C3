local guild_meta = ix.meta.guild or ix.middleclass 'ix_guilds'

GUILD_ENUM_PRIVILEGES = {
  ALL = 0,
  INVITE = 1,
  KICK = 2,
  MANAGE_PRIVILEGES = 3,
  BANK_WITHDRAW = 4,
  TAKE_ITEMS = 5,
  ADD_ROLES = 6,
  REMOVE_ROLES = 7,
  ADD_GROUPS = 8,
  REMOVE_GROUPS = 9
}

GUILD_ENUM_PRIVILEGES_TO_NAME = {}

for k, v in pairs(GUILD_ENUM_PRIVILEGES) do
  GUILD_ENUM_PRIVILEGES_TO_NAME[v] = k
end

function guild_meta:__tostring()
  return 'guild['..(self.id or 0)..']'
end

function guild_meta:Initialize(id, owner, name)
  self.id = tonumber(id)
  self.owner = owner
  self.name = name

  self.icon = 'undefined.png'
  self.lore = 'undefined'
  self.level = 0
  self.balance = 0
  self.groups = {}
  self.invites = {}
  self.members = { [owner] = { role = 'Владелец', privileges = {}, group = nil } }
  self.roles = {
    ['Владелец'] = { role = 'Владелец', privileges = { [GUILD_ENUM_PRIVILEGES.ALL] = true }, no_edit = true },
    ['Участник'] = { role = 'Участник', privileges = {} }
  }
end

function guild_meta:get_id()
  return self.id
end

function guild_meta:get_owner()
  return self.owner
end

function guild_meta:get_name()
  return self.name
end

function guild_meta:get_icon()
  return self.icon
end

function guild_meta:get_members()
  return self.members
end

function guild_meta:get_member(id)
  return self.members[id]
end

function guild_meta:get_roles()
  return self.roles
end

function guild_meta:get_groups()
  return self.groups
end

function guild_meta:get_invites()
  return self.invites
end

function guild_meta:get_level()
  return self.level
end

function guild_meta:get_balance()
  return self.balance
end

function guild_meta:get_lore()
  return self.lore
end

function guild_meta:is_owner(id)
  return self.owner == id
end

-- owner > role > group > member
function guild_meta:has_privilege(character, privilege)
  local member = self:get_members()[character:GetID()]
  local role = self:get_roles()[member.role]
  local group = self:get_groups()[member.group]

  if self:is_owner(character:GetID()) then
    return true
  end

  if role and role.privileges[privilege] then
    return role.privileges[privilege]
  end

  if group and group.privileges[privilege] then
    return group.privileges[privilege]
  end

  return member.privileges[privilege]
end

function guild_meta:sync_data(data)
  self.id = data.id
  self.name = data.name
  self.icon = data.icon
  self.owner = data.owner
  self.members = data.members
  self.roles = data.roles
  self.groups = data.groups
  self.invites = data.invites
  self.level = data.level
  self.balance = data.balance
  self.lore = data.lore
end

function guild_meta:get_data()
  return {
    id = self.id,
    name = self.name,
    icon = self.icon,
    owner = self.owner,
    members = self.members,
    roles = self.roles,
    groups = self.groups,
    invites = self.invites,
    level = self.level,
    balance = self.balance,
    lore = self.lore
  }
end

if (SERVER) then
  function guild_meta:sync(receiver)
    local receivers = {}

    for k, _ in pairs(self.members) do
      if ix.char.loaded[k] then
        receivers[#receivers + 1] = ix.char.loaded[k]:GetPlayer()
      end
    end

    ix.guilds.sync(self.id, receiver or receivers)
  end

  function guild_meta:add_member(character)
    character:SetGuildUID(self.id)

    local id = character:GetID()
    
    self.members[id] = { id = id }
  end

  function guild_meta:remove_member(character)
    character:SetGuildUID(-1)

    self.members[character:GetID()] = nil
  end

  function guild_meta:add_role(role)
    self.roles[role] = { role = role, privileges = {} }
  end

  function guild_meta:edit_role_privileges(role, privilege, boolean)
    self.roles[role].privileges[privilege] = boolean or nil
  end

  -- never remove owner role
  function guild_meta:remove_role(role)
    if self.roles[role].no_edit then return end

    self.roles[role] = nil
  end

  function guild_meta:add_group(group)
    self.groups[group] = { group = group, privileges = {} }
  end

  function guild_meta:edit_group_privileges(group, privilege, boolean)
    self.groups[group].privileges[privilege] = boolean or nil
  end

  function guild_meta:remove_group(group)
    self.groups[group] = nil
  end

  -- @TODO Add timestamp to make an invite expirable
  function guild_meta:add_invite(character)
    self.invites[character:GetID()] = true
  end

  function guild_meta:remove_invite(character)
    self.invites[character:GetID()] = nil
  end

  function guild_meta:set_member_role(character, role)
    if !self.roles[role] then return end

    self.members[character:GetID()].role = role
  end

  function guild_meta:set_member_group(character, group)
    if !self.groups[group] then return end

    self.members[character:GetID()].group = group
  end
end

ix.meta.guild = guild_meta
