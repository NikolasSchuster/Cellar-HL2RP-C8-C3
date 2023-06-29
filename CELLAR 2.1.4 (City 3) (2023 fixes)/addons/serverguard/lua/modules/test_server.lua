require"lluv"
local uv  = lluv
local ws  = include "websocket/lluv/websocket.lua"

local wsurl   = "ws://127.0.0.1:12345"
local sprot = "echo"


local state = {
    validate = function(self, cli)
        return self.clis[cli] or false
    end,
    remove = function(self, cli)
        self:fire("Remove", self.clis[cli])
        self.ids[self.clis[cli]] = nil
        self.clis[cli] = nil
        cli:close()
    end,
    fire = function(self, name, ...)
        if (self.intrnl[name]) then
            self.intrnl[name](self, ...)
        end
        if (self.hooks[name]) then
            self.hooks[name](...)
        end
    end,
    intrnl = {
        Create = function(self, id, name, newcli) 
            for cli, id in pairs(self.clis) do
                cli:write("create "..id.." "..name)
                newcli:write("create "..id.." "..self.ids[id].name)
            end
            newcli:write("create 0 "..GetHostName())
        end,
        Chat = function(self, id, stm, name, msg)
            for cli in pairs(self.clis) do
                cli:write("chat "..id.." "..stm.." "..name.."# "..msg)
            end
        end,
        Remove = function(self, id)
            for cli, cli_id in pairs(self.clis) do
                if (id ~= cli_id) then
                    cli:write("remove "..id)
                end
            end
        end,
    },
    hooks = {
        Chat = print,
    },
    id_top = 1,
    clis = {},
    ids = {
        [0] = GetHostName()
    }
}

hook.Add("PlayerSay", "SERVERGUARD_PLAYERSAY_WS", function(ply, text, teamonly)
    if (teamonly) then 
        return
    end
    
    state:fire("Chat", 0, ply:SteamID(), ply:Nick(), text)
end)
local ops = {
    setname = function(self, cli, str)
        local id = self:validate(cli)
        if (not id) then
            self:remove(cli)
            return 
        end
        if (nil == self:fire("SetName", id, str)) then
            self.ids[id].name = name
        end
    end,
    create = function(self, cli, str)
        local id = self:validate(cli)
        if (id) then
            self:remove(cli)
            return 
        end
        local name = str
        if (nil == self:fire("Create", id, name, cli)) then
            self.clis[cli] = self.id_top
            local id = self.id_top
            self.id_top = self.id_top + 1
            self.ids[id] = {
                name = name
            }
        end
    end,
    chat = function(self, cli, str)
        local id = self:validate(cli)
        if (not id) then
            self:remove(cli)
            return 
        end
        local steamid, name, msg = str:match
            "^([^ ]+) ([^#]+)# (.+)$"
        
        self:fire("Chat", id, steamid, name, msg)
    end,
    broadcast = function(self, cli, str)
        local id = self:validate(cli)
        if (not id) then
            self:remove(cli)
            return 
        end
        self:fire("Broadcast", id, str)
    end
}

local function create()
    SERVERGUARD_SERVER = ws.new()
    local server = SERVERGUARD_SERVER
    server:bind(wsurl, sprot, function(self, err)
      if err then
        print("Server error:", err)
        return server:close()
      end

      server:listen(function(self, err)
        if err then
          print("Server listen:", err)
          return server:close()
        end

        local cli = server:accept()
        cli:handshake(function(self, err, protocol)
          if err then
            print("Server handshake error:", err)
            return cli:close()
          end
          print("New server connection:", protocol)

          cli:start_read(function(self, err, message, opcode)
            if err then
              print("Server read error:", err)
              state:remove(cli)
            end
            
            local op, str = message:match "^([^ ]+) (.+)$"

            print(op,str)
            local success, err = pcall(ops[op], state, cli, str)
            if (not success) then
                print("ERR", err)
            end
                
          end)
        end)
      end)
    end)

end

if (SERVERGUARD_SERVER) then
    SERVERGUARD_SERVER:close(function(self, ...)
      print("Server close:", ...)
      create()
    end)
else
    create()
end

hook.Add("ShutDown", "SERVERGUARD_SERVER_CLOSE", function()
    local closed = false
    SERVERGUARD_SERVER:close(function(self, ...)
      print("Server close:", ...)
      closed = true
    end)
    while (not closed) do
        uv.run(1)
    end
end)

timer.Create("LLUV_SERVERGUARD_TIMER", .2, 0, function()
    uv.run(2)
end)