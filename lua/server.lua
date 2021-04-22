local ngx = require "ngx"
local say = ngx.say
local req_method = ngx.req.get_method

local _M = {
  version = "0.0.1"
}

function _M.bootstrap()
  say("server started")
end

return _M
