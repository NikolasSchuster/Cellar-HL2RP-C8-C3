local PLUGIN = PLUGIN

function PLUGIN:DatabaseConnected()
  local query = mysql:Create('ix_guilds')
    query:Create('id', 'INT(11) UNSIGNED NOT NULL AUTO_INCREMENT')
    query:Create('level', 'INTEGER DEFAULT 0')
    query:Create('balance', 'INTEGER DEFAULT 0')
    query:Create('owner', 'INTEGER')
    query:Create('members_limit', 'INTEGER DEFAULT 6')
    query:Create('members', 'MEDIUMTEXT NOT NULL DEFAULT "[]"')
    query:Create('invites', 'TEXT NOT NULL DEFAULT "[]"')
    query:Create('name', 'TEXT')
    query:Create('roles', 'TEXT NOT NULL DEFAULT "[]"')
    query:Create('groups', 'TEXT NOT NULL DEFAULT "[]"')
    query:Create('lore', 'TEXT')
    query:Create('icon', 'TEXT')
    query:Create('date_create', 'DATETIME')
    query:PrimaryKey('id')
  query:Execute()
end

function PLUGIN:OnWipeTables()
  mysql:Drop('ix_guilds'):Execute()
end
