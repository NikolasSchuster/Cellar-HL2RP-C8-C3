require"lluv"
local uv = lluv
local WS = include "sv_websocket.lua"

local function create()
    SERVERGUARD_CLIENT = WS.client.lluv() 
    local cli = SERVERGUARD_CLIENT
    do
        local state = {
            validate = function(self, cli)
                return cli
            end,
            remove = function(self, cli)
                self:fire("Remove", cli)
                self.ids[cli] = nil
            end,
            fire = function(self, name, ...)
                if (self.hooks[name]) then
                    self.hooks[name](self, ...)
                end
            end,
            hooks = {
                Chat = function(self, id, stm, name, msg)
                    PrintMessage(HUD_PRINTTALK, ("(%s) %s: %s"):format(
                        self.ids[id].name,
                        name,
                        msg
                    ))
                    print(("(%s) %s: %s"):format(
                        self.ids[id].name,
                        name,
                        msg
                    ))
                end,
            },
            id_top = 0,
            ids = {}
        }
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
                local name = str
                if (nil == self:fire("Create", id, name)) then
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
        
        cli:on_open(function(ws)
            cli:send("create "..GetHostName())
        end)

        cli:on_error(function(ws, err)
          print("Error:", err)
        end)

        cli:on_message(function(ws, msg, code)
            
            local op, id, str = msg:match "^([^ ]+) ([^ ]+) (.+)$"
            
            print(msg)
            print(op, id, str)
            local success, err = pcall(ops[op], state, id, str)
            if (not success) then
                print("ERR", err)
            end
            
        end)

        cli:connect("ws://127.0.0.1:12345", "echo")

    end
end

if (SERVERGUARD_CLIENT) then
    SERVERGUARD_CLIENT:close()
    create()
else
    create()
end

hook.Add("ShutDown", "SERVERGUARD_CLIENT_CLOSE", function()
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