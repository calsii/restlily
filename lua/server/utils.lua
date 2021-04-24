local ngx = require "ngx"

local ngx = ngx
local re = ngx.re
local io_open = io.open

local _M = {}

function _M.read_file(path)
    local fp, err = io_open(path)
    if not fp then
        return nil, err
    end

    local chunk = fp:read("*all")

    fp:close()

    return chunk
end

function _M.write_file(path, content)
    local fp, err = io_open(path, "w+b")
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

function _M.random()
    ngx.update_time()

    math.randomseed(math.floor(ngx.now() * 1.23456789))

    return math.floor(math.random() * 12345678.9)
end

function _M.get_by_key(obj, key)
    for k, v in pairs(obj) do
        if k == key then
            return v
        end
    end

    return nil
end

return _M
