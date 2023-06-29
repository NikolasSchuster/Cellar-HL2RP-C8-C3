PLUGIN.name = 'Guilds'
PLUGIN.description = 'Guilds'
PLUGIN.author = 'DrodA'
PLUGIN.version = 1.0

--[[-------------------------------------------------------------------------
1 уровень - у лидера фракции и его замов появляется возможность создания банка фракции - туда можно сложить деньги при помощи любого члена фракции свободно и в неограниченном количестве. ВЛОЖИТЬ может любой, но ЗАБРАТЬ только лидер или зам. Есть также возможность установить ЗАРПЛАТУ согласно рангу и желанию лидера фракции, если хочет, за счет банка.

2 уровень - достигается при одобрении администрации, как и последующие. Открывается доступ к хранилищу фракции 10 на 10, куда могут ПОЛОЖИТЬ предметы могут любые члены фракции, но ЗАБРАТЬ может только лидер или заместитель.

3 уровень - дается общий буст фракции в размере +15 хп каждому члену, а также пассивный реген ХП в размере +2 хп каждые 5 часов, включая время в оффлайне.

4 уровень - лимит с 6 участников поднимается до 20.
---------------------------------------------------------------------------]]

ix.config.Add('minGuildNameLength', 3, 'The minimum number of characters a player can have.', nil, {
  data = { min = 1, max = 32 },
  category = 'guild'
})

ix.config.Add('maxGuildNameLength', 32, 'The maximum number of characters a player can have.', nil, {
  data = { min = 1, max = 32 },
  category = 'guild'
})

CAMI.RegisterPrivilege({ Name = 'Guilds - Manage guilds', MinAccess = 'superadmin' })

ix.util.Include 'meta/sh_guild.lua'

ix.util.Include 'cl_plugin.lua'
ix.util.Include 'sv_plugin.lua'

ix.util.Include 'database/sv_database.lua'

ix.char.RegisterVar('guildUID', {
  field = 'guild',
  fieldType = ix.type.number,
  default = -1,
  bNoDisplay = true,
  OnSet = function(this, value)
    local client = this:GetPlayer()

    if (IsValid(client)) then
      this.vars.guildUID = value

      net.Start('ixCharacterVarChanged')
        net.WriteUInt(this:GetID(), 32)
        net.WriteString('guildUID')
        net.WriteType(this.vars.guildUID)
      net.Broadcast()
    end
  end,

  OnGet = function(this, default)
    return this.vars.guildUID or -1
  end,

  OnAdjust = function(this, client, data, value, new_data)
    new_data.guildUID = value
  end
})

ix.command.Add('GuildManager', {
  description = '@cmdGuildManager',
  superAdminOnly = true,
  OnRun = function(this, client)
    net.Start('ix_guild_mgmt_get_all')
    net.Send(client)
  end
})
