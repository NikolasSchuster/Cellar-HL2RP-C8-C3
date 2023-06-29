local PLUGIN = PLUGIN

net.Receive('ix_guild_sync', function(_, _)
  local length = net.ReadUInt(32)
  local data = net.ReadData(length)
  local uncompressed = util.Decompress(data)

  if (!uncompressed) then
    return ErrorNoHalt('[Helix] Unable to decompress guild data!\n')
  end

  local output = util.JSONToTable(uncompressed)

  local stored = ix.guilds.stored
  
  if output.query_remove then
    stored[output.id] = nil

    return
  end

  if output.id then
    if !stored[output.id] then
      local guild = ix.meta.guild:New(output.id, output.name)
      guild:sync_data(output)

      stored[guild.id] = guild

      return
    end

    stored[output.id]:sync_data(output)

    return
  end

  for _, v in pairs(output) do
    if !stored[v.id] then
      guild = ix.meta.guild:New(v.id, v.name)
      guild:sync_data(v)

      ix.guild.stored[v.id] = guild

      continue
    end
    
    stored[v.id]:sync_data(v)
  end
end)

net.Receive('ix_guild_mgmt_get_all', function(_, _)
  if CAMI.PlayerHasAccess(LocalPlayer(), 'Guilds - Manage guilds', nil) then
    vgui.Create 'ix_guild_manager'
  end
end)
