------------------------------------------------------------------
--
--  Author: Alexey Melnichuk <alexeymelnichuck@gmail.com>
--
--  Copyright (C) 2014-2016 Alexey Melnichuk <alexeymelnichuck@gmail.com>
--
--  Licensed according to the included 'LICENSE' document
--
--  This file is part of lua-lluv library.
--
------------------------------------------------------------------

local function split(str, sep, plain)
  local b, res = 1, {}
  while b <= #str do
    local e, e2 = string.find(str, sep, b, plain)
    if e then
      res[#res + 1] = string.sub(str, b, e-1)
      b = e2 + 1
    else
      res[#res + 1] = string.sub(str, b)
      break
    end
  end
  return res
end

local unpack = unpack or table.unpack

local function usplit(...) return unpack(split(...)) end

local function split_first(str, sep, plain)
  local e, e2 = string.find(str, sep, nil, plain)
  if e then
    return string.sub(str, 1, e - 1), string.sub(str, e2 + 1)
  end
  return str
end

local function slit_first_self_test()
  local s1, s2 = split_first("ab|cd", "|", true)
  assert(s1 == "ab")
  assert(s2 == "cd")

  local s1, s2 = split_first("|abcd", "|", true)
  assert(s1 == "")
  assert(s2 == "abcd")

  local s1, s2 = split_first("abcd|", "|", true)
  assert(s1 == "abcd")
  assert(s2 == "")

  local s1, s2 = split_first("abcd", "|", true)
  assert(s1 == "abcd")
  assert(s2 == nil)
end

local function class(base)
  local t = base and setmetatable({}, base) or {}
  t.__index = t
  t.__class = t
  t.__base  = base

  function t.new(...)
    local o = setmetatable({}, t)
    if o.__init then
      if t == ... then -- we call as Class:new()
        return o:__init(select(2, ...))
      else             -- we call as Class.new()
        return o:__init(...)
      end
    end
    return o
  end

  return t
end

local function class_self_test()
  local A = class()
  function A:__init(a, b)
    assert(a == 1)
    assert(b == 2)
  end

  A:new(1, 2)
  A.new(1, 2)

  local B = class(A)

  function B:__init(a,b,c)
    assert(self.__base == A)
    A.__init(B, a, b)
    assert(c == 3)
  end

  B:new(1, 2, 3)
  B.new(1, 2, 3)
end

-------------------------------------------------------------------
local corun do

local uv = lluv

local function spawn(fn, ...)
  coroutine.wrap(fn)(...)
end

local function fiber(...)
  uv.defer(spawn, ...)
end

corun = fiber

end
-------------------------------------------------------------------

-------------------------------------------------------------------
local List = class() do

function List:reset()
  self._first = 0
  self._last  = -1
  self._t     = {}
  return self
end

List.__init = List.reset

function List:push_front(v)
  assert(v ~= nil)
  local first = self._first - 1
  self._first, self._t[first] = first, v
  return self
end

function List:push_back(v)
  assert(v ~= nil)
  local last = self._last + 1
  self._last, self._t[last] = last, v
  return self
end

function List:peek_front()
  return self._t[self._first]
end

function List:peek_back()
  return self._t[self._last]
end

function List:pop_front()
  local first = self._first
  if first > self._last then return end

  local value = self._t[first]
  self._first, self._t[first] = first + 1

  return value
end

function List:pop_back()
  local last = self._last
  if self._first > last then return end

  local value = self._t[last]
  self._last, self._t[last] = last - 1

  return value
end

function List:size()
  return self._last - self._first + 1
end

function List:empty()
  return self._first > self._last
end

function List:find(fn, pos)
  pos = pos or 1
  if type(fn) == "function" then
    for i = self._first + pos - 1, self._last do
      local n = i - self._first + 1
      if fn(self._t[i]) then
        return n, self._t[i]
      end
    end
  else
    for i = self._first + pos - 1, self._last do
      local n = i - self._first + 1
      if fn == self._t[i] then
        return n, self._t[i]
      end
    end
  end
end

function List.self_test()
  local q = List:new()

  assert(q:empty() == true)
  assert(q:size()  == 0)

  assert(q:push_back(1) == q)
  assert(q:empty() == false)
  assert(q:size()  == 1)

  assert(q:peek_back() == 1)
  assert(q:empty() == false)
  assert(q:size()  == 1)

  assert(q:peek_front() == 1)
  assert(q:empty() == false)
  assert(q:size()  == 1)

  assert(q:pop_back() == 1)
  assert(q:empty() == true)
  assert(q:size()  == 0)

  assert(q:push_front(1) == q)
  assert(q:empty() == false)
  assert(q:size()  == 1)

  assert(q:pop_front() == 1)
  assert(q:empty() == true)
  assert(q:size()  == 0)

  assert(q:pop_back() == nil)
  assert(q:empty() == true)
  assert(q:size()  == 0)

  assert(q:pop_front() == nil)
  assert(q:empty() == true)
  assert(q:size()  == 0)

  assert(false == pcall(q.push_back, q))
  assert(q:empty() == true)
  assert(q:size()  == 0)

  assert(false == pcall(q.push_front, q))
  assert(q:empty() == true)
  assert(q:size()  == 0)

  q:push_back(1):push_back(2)
  assert(q:pop_back() == 2)
  assert(q:pop_back() == 1)

  q:push_back(1):push_back(2)
  assert(q:pop_front() == 1)
  assert(q:pop_front() == 2)

  q:reset()
  assert(nil == q:find(1))
  q:push_back(1):push_back(2):push_front(3)
  assert(1 == q:find(3))
  assert(2 == q:find(1))
  assert(3 == q:find(2))
  assert(nil == q:find(4))
  assert(2 == q:find(1, 2))
  assert(nil == q:find(1, 3))

end

end
-------------------------------------------------------------------

-------------------------------------------------------------------
local Queue = class() do

function Queue:__init()
  self._q = List.new()
  return self
end

function Queue:reset()        self._q:reset()      return self end

function Queue:push(v)        self._q:push_back(v) return self end

function Queue:pop()   return self._q:pop_front()              end

function Queue:peek()  return self._q:peek_front()             end

function Queue:size()  return self._q:size()                   end

function Queue:empty() return self._q:empty()                  end

end
-------------------------------------------------------------------

-------------------------------------------------------------------
local Buffer = class() do

-- eol should ends with specific char.

function Buffer:__init(eol, eol_is_rex)
  self._eol       = eol or "\n"
  self._eol_plain = not eol_is_rex
  self._lst = List.new()
  return self
end

function Buffer:reset()
  self._lst:reset()
  return self
end

function Buffer:eol()
  return self._eol, self._eol_plain
end

function Buffer:set_eol(eol, eol_is_rex)
  self._eol       = assert(eol)
  self._eol_plain = not eol_is_rex
  return self
end

function Buffer:append(data)
  if #data > 0 then
    self._lst:push_back(data)
  end
  return self
end

function Buffer:prepend(data)
  if #data > 0 then
    self._lst:push_front(data)
  end
  return self
end

function Buffer:read_line(eol, eol_is_rex)
  local plain

  if eol then plain = not eol_is_rex
  else eol, plain = self._eol, self._eol_plain end

  local lst = self._lst

  local ch = eol:sub(-1)
  local check = function(s) return not not string.find(s, ch, nil, true) end

  local t = {}
  while true do
    local i = self._lst:find(check)

    if not i then
      if #t > 0 then lst:push_front(table.concat(t)) end
      return
    end

    assert(i > 0)

    for i = i, 1, -1 do t[#t + 1] = lst:pop_front() end

    local line, tail

    -- try find EOL in last chunk
    if plain or (eol == ch) then line, tail = split_first(t[#t], eol, true) end

    if eol == ch then assert(tail) end

    if tail then -- we found EOL
      -- we can split just last chunk and concat
      t[#t] = line

      if #tail > 0 then lst:push_front(tail) end

      return table.concat(t)
    end

    -- we need concat whole string and then split
    -- for eol like `\r\n` this may not work well but for most cases it should work well
    -- e.g. for LuaSockets pattern `\r*\n` it work with one iteration but still we need
    -- concat->split because of case such {"aaa\r", "\n"}

    line, tail = split_first(table.concat(t), eol, plain)

    if tail then -- we found EOL
      if #tail > 0 then lst:push_front(tail) end
      return line
    end
  end
end

function Buffer:read_all()
  local t = {}
  local lst = self._lst
  while not lst:empty() do
    t[#t + 1] = self._lst:pop_front()
  end
  return table.concat(t)
end

function Buffer:read_some()
  if self._lst:empty() then return end
  return self._lst:pop_front()
end

function Buffer:read_n(n)
  n = math.floor(n)

  if n == 0 then
    if self._lst:empty() then return end
    return ""
  end

  local lst = self._lst
  local size, t = 0, {}

  while true do
    local chunk = lst:pop_front()

    if not chunk then -- buffer too small
      if #t > 0 then lst:push_front(table.concat(t)) end
      return
    end

    if (size + #chunk) >= n then
      assert(n > size)
      local pos = n - size
      local data = string.sub(chunk, 1, pos)
      if pos < #chunk then
        lst:push_front(string.sub(chunk, pos + 1))
      end

      t[#t + 1] = data
      return table.concat(t)
    end

    t[#t + 1] = chunk
    size = size + #chunk
  end
end

function Buffer:read(pat, ...)
  if not pat then return self:read_some() end

  if pat == "*l" then return self:read_line(...) end

  if pat == "*a" then return self:read_all() end

  return self:read_n(pat)
end

function Buffer:empty()
  return self._lst:empty()
end

function Buffer:next_line(data, eol)
  eol = eol or self._eol or "\n"
  if data then self:append(data) end
  return self:read_line(eol, true)
end

function Buffer:next_n(data, n)
  if data then self:append(data) end
  return self:read_n(n)
end

function Buffer.self_test(EOL)
  
  local b = Buffer.new("\r\n")
  
  b:append("a\r")
  b:append("\nb")
  b:append("\r\n")
  b:append("c\r\nd\r\n")
  
  assert("a" == b:read_line())
  assert("b" == b:read_line())
  assert("c" == b:read_line())
  assert("d" == b:read_line())
  
  local b = Buffer:new(EOL)
  local eol = b:eol()

  -- test next_xxx
  assert("aaa" == b:next_line("aaa" .. eol .. "bbb"))

  assert("bbbccc" == b:next_line("ccc" .. eol .. "ddd" .. eol))

  assert("ddd" == b:next_line(eol))

  assert("" == b:next_line(""))

  assert(nil == b:next_line(""))

  assert(nil == b:next_line("aaa"))

  assert("aaa" == b:next_n("123456", 3))

  assert(nil == b:next_n("", 8))

  assert("123"== b:next_n("", 3))

  assert("456" == b:next_n(nil, 3))

  b:reset()

  assert(nil == b:next_line("aaa|bbb"))

  assert("aaa" == b:next_line(nil, "|"))

  b:reset()

  b:set_eol("\r*\n", true)
   :append("aaa\r\r\n\r\nbbb\nccc")
  assert("aaa" == b:read_line())
  assert("" == b:read_line())
  assert("bbb" == b:read_line())
  assert(nil == b:read_line())
  -- assert("ccc" == b:read_line("$", true))

  b:reset()
  b:append("aaa\r\r")
  b:append("\r\r")
  assert(nil == b:read_line())
  b:append("\nbbb\n")
  assert("aaa" == b:read_line())
  assert("bbb" == b:read_line())

  b:reset()
  b:set_eol("\n\0")

  b:append("aaa")
  assert(nil == b:read_line())
  b:append("\n")
  assert(nil == b:read_line())
  b:append("\0")
  assert("aaa" == b:read_line())
end

end
-------------------------------------------------------------------

-------------------------------------------------------------------
local DeferQueue = class() do

local uv

function DeferQueue:__init()
  uv = uv or lluv

  self._cb = function()
    self:_on_tick()
    if self._queue:empty() then self:_stop() else self:_start() end
  end

  self._queue = Queue.new()
  self._timer = uv.timer():start(0, 1, self._cb):stop()
  return self
end

function DeferQueue:_start()
  self._timer:again()
end

function DeferQueue:_stop()
  self._timer:stop()
end

function DeferQueue:_on_tick()
  -- callback could register new function
  -- so we proceed only currently active
  -- and leave new one to next iteration
  for i = 1, self._queue:size() do
    local args = self._queue:pop()
    if not args then break end
    args[1](unpack(args, 2))
  end
end

function DeferQueue:call(...)
  self._queue:push({...})
  if self._queue:size() == 1 then
    self:_start()
  end
end

function DeferQueue:close(call)
  if not self._queue then return end

  if call then self._on_tick() end

  self._prepare:close()
  -- self._timer:close()
  self._queue, self._timer, self._prepare = nil
end

function DeferQueue.self_test()

  local dq = DeferQueue.new()
  assert(dq)
  assert(uv)
  
  local f = 0
  local increment = function() f = f + 1 end

  dq:call(increment)
  assert(f == 0)
  assert(0 == uv.run())
  assert(f == 1)

  dq:call(function()
    increment()
    dq:call(increment)
    assert(f == 2)
  end)
  assert(0 == uv.run())
  assert(f == 3)
end


end
-------------------------------------------------------------------

-------------------------------------------------------------------
local MakeErrors = function(cat, errors)
  assert(type(cat)    == "string")
  assert(type(errors) == "table")

  local numbers  = {} -- errno => name
  local names    = {} -- name  => errno
  local messages = {}

  for no, info in pairs(errors) do
    assert(type(info) == "table")
    local name, msg = next(info)

    assert(type(no)   == "number")
    assert(type(name) == "string")
    assert(type(msg)  == "string")
    
    assert(not numbers[no], no)
    assert(not names[name], name)
    
    numbers[no]    = name
    names[name]    = no
    messages[no]   = msg
    messages[name] = msg
  end

  local Error = class() do

  function Error:__init(no, ext)
    assert(numbers[no] or names[no], "unknown error: " ..  tostring(no))

    self._no = names[no] or no
    self._ext = ext

    return self
  end

  function Error:cat()
    return cat
  end

  function Error:name()
    return numbers[self._no]
  end

  function Error:no()
    return self._no
  end

  function Error:msg()
    return messages[self._no]
  end

  function Error:ext()
    return self._ext
  end

  function Error:__tostring()
    local msg = string.format("[%s][%s] %s (%d)", self:cat(), self:name(), self:msg(), self:no())
    local ext = self:ext()
    if ext then msg = msg .. " - " .. ext end
    return msg
  end

  end

  local o = setmetatable({
    __class = Error
  }, {__call = function(self, ...)
    return Error:new(...)
  end})

  for name, no in pairs(names) do
    o[name] = no
  end

  return o
end
-------------------------------------------------------------------

local function self_test()
  Buffer.self_test()
  List.self_test()
  DeferQueue.self_test()
  slit_first_self_test()
  class_self_test()
end

lluv.utils = {
  Buffer      = Buffer;
  Queue       = Queue;
  List        = List;
  Errors      = MakeErrors;
  DeferQueue  = DeferQueue;
  class       = class;
  split_first = split_first;
  split       = split;
  usplit      = usplit;
  corun       = corun;
  self_test   = self_test;
}