ITEM.name = 'ЕМП инструмент'
ITEM.model = Model('models/alyx_emptool_prop.mdl')
ITEM.width = 1
ITEM.height = 1
ITEM.description = 'Маленькая продолговатая конструкция с парой пластиковых кнопок. При попытке взаимодействовать им с замками Альянса, спокойно вскрывает их.'
ITEM.hack_delay = 5

ITEM.functions.Hack = {
  OnRun = function(item)
    local client = item.player

    item:get_terminal():hack(item.hack_delay)

    return true
  end,
  OnCanRun = function(item)
    return not IsValid(item.entity) and IsValid(item:get_terminal()) -- IsValid(item:get_terminal())
  end,
}

function ITEM:get_terminal()
  local data = {}
  data.start = self.player:GetShootPos()
  data.endpos = data.start + self.player:GetAimVector() * 84
  data.filter = {self.player, self}

  local trace = util.TraceLine(data)
  local entity = trace.Entity

  if IsValid(entity) and entity:GetClass() == 'ix_dissolver_terminal' then
    return entity
  end
end
