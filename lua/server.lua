local say = ngx.say

local _S = {
  version = "0.0.1"
}

function _S.bootstrap()
  say("server started")
end

return _S
