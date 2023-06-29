local path = string.GetPathFromFilename(debug.getinfo(1).short_src):gsub(".+/lua/", "")

return setmetatable({},{__index = function(self, name)
  local backend = include(path.."server_" .. name..".lua")
  self[name] = backend
  return backend
end})
