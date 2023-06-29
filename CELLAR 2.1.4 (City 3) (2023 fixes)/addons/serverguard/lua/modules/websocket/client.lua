local path = string.GetPathFromFilename(debug.getinfo(1).short_src):gsub(".+/lua/", "")

return setmetatable({},{__index = function(self, name)
    debug.Trace()
  if name == 'new' then name = 'sync' end
  local backend = include(path.."client_" .. name..".lua")
  self[name] = backend
  if name == 'sync' then self.new = backend end
  return backend
end})
