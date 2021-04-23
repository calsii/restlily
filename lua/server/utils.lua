local ngx = require "ngx"

local ngx = ngx
local re = ngx.re
local io_open = io.open

local _M = {}

function _M.touch_file(path, content)
    local fp, err = io_open(path)
    if not fp then
        return nil, err
    end

    local chunk = fp:read("*all")

    if content ~= nil then
        fp:write(content)
    end

    fp:close()

    return chunk
end

function _M.gsub(subject, regex, replace, options)
    if not options then
        options = "jo"
    end

    return re.gsub(subject, regex, replace, options)
end

return _M
