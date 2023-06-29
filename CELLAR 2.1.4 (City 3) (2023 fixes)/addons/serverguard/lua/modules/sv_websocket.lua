local frame = include'websocket/frame.lua'

return {
  client = include'websocket/client.lua',
  server = include'websocket/server.lua',
  CONTINUATION = frame.CONTINUATION,
  TEXT = frame.TEXT,
  BINARY = frame.BINARY,
  CLOSE = frame.CLOSE,
  PING = frame.PING,
  PONG = frame.PONG
}
